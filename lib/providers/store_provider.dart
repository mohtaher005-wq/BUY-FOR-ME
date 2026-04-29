import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../services/google_places_service.dart';

class Store {
  final String? id;
  final String name;
  final String category;
  final String? description;
  final String? imageUrl;
  final String? rip;
  final double? latitude;
  final double? longitude;
  final List<MerchantProduct> products;
  final double? rating;
  final bool isRealLocation;

  Store({
    this.id,
    required this.name,
    required this.category,
    this.description,
    this.imageUrl,
    this.rip,
    this.latitude,
    this.longitude,
    this.products = const [],
    this.isRealLocation = false,
    this.rating,
  });

  // Alias for backward compatibility
  String? get imagePath => imageUrl;

  factory Store.fromMap(
    Map<String, dynamic> map, {
    List<MerchantProduct> products = const [],
  }) {
    return Store(
      id: map['id'],
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      description: map['description'],
      imageUrl: map['image_url'],
      rip: map['rip'],
      latitude: map['latitude'] != null
          ? (map['latitude'] as num).toDouble()
          : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : null,
      products: products,
      rating: map['rating'] != null
          ? (map['rating'] as num).toDouble()
          : (4.0 + (map['id']?.hashCode ?? 0) % 10 / 10), // Default mock rating
    );
  }
}

class MerchantProduct {
  final String? id;
  final String name;
  final String price;
  final String category;
  final String? imagePath;
  final String? storeId;

  MerchantProduct({
    this.id,
    required this.name,
    required this.price,
    required this.category,
    this.imagePath,
    this.storeId,
  });

  factory MerchantProduct.fromMap(Map<String, dynamic> map) {
    return MerchantProduct(
      id: map['id'],
      name: map['name'] ?? '',
      price: map['price']?.toString() ?? '0',
      category: map['category'] ?? '',
      imagePath: map['image_url'],
      storeId: map['store_id'],
    );
  }
}

class CartItem {
  final MerchantProduct product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class Order {
  final String id;
  final String customerName;
  final List<CartItem> items;
  final double total;
  String status;
  final DateTime date;
  final String? receiptImagePath;
  final double? rating;

  Order({
    required this.id,
    required this.customerName,
    required this.items,
    required this.total,
    this.status = 'قيد الانتظار',
    required this.date,
    this.receiptImagePath,
    this.rating,
  });

  double get totalPrice => total;
}

class StoreProvider with ChangeNotifier {
  final client = Supabase.instance.client;
  Store? _currentStore;
  List<Store> _allStores = [];
  List<Store> _realStores = [];
  final List<Order> _orders = [];
  final List<CartItem> _cart = [];
  bool _isLoading = false;

  Store? get currentStore => _currentStore;
  List<Store> get stores => [..._allStores, ..._realStores]; // Combine both
  List<Order> get orders => _orders;
  List<CartItem> get cart => _cart;
  bool get isLoading => _isLoading;
  int get cartItemsCount => _cart.fold(0, (sum, item) => sum + item.quantity);

  Future<void> fetchRealStores(double lat, double lon) async {
    _isLoading = true;
    notifyListeners();
    try {
      _realStores = await GooglePlacesService.fetchNearbyRealStores(lat, lon);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  StoreProvider() {
    loadFromSupabase();
  }

  Future<void> loadFromSupabase() async {
    final user = client.auth.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Load Merchant Store
      final storeRes = await client
          .from('stores')
          .select()
          .eq('owner_id', user.id)
          .maybeSingle();

      if (storeRes != null) {
        final productsRes = await client
            .from('products')
            .select()
            .eq('store_id', storeRes['id']);

        final List<MerchantProduct> products = (productsRes as List)
            .map((p) => MerchantProduct.fromMap(p))
            .toList();

        _currentStore = Store.fromMap(storeRes, products: products);
      }

      // Load All Stores for Customer
      final allStoresRes = await client.from('stores').select();
      _allStores = (allStoresRes as List).map((s) => Store.fromMap(s)).toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading from Supabase: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchStoreProducts(String storeId) async {
    try {
      final res = await client
          .from('products')
          .select()
          .eq('store_id', storeId);
      final products = (res as List)
          .map((p) => MerchantProduct.fromMap(p))
          .toList();

      final index = _allStores.indexWhere((s) => s.id == storeId);
      if (index != -1) {
        final oldStore = _allStores[index];
        _allStores[index] = Store(
          id: oldStore.id,
          name: oldStore.name,
          category: oldStore.category,
          imageUrl: oldStore.imageUrl,
          latitude: oldStore.latitude,
          longitude: oldStore.longitude,
          products: products,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  Future<bool> addProduct(MerchantProduct product) async {
    if (_currentStore?.id == null) return false;

    try {
      String? imageUrl = product.imagePath;
      if (product.imagePath != null && !product.imagePath!.startsWith('http')) {
        final file = File(product.imagePath!);
        final path = 'products/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await client.storage.from('products').upload(path, file);
        imageUrl = client.storage.from('products').getPublicUrl(path);
      }

      final parsedPrice =
          double.tryParse(product.price.replaceAll(',', '.')) ?? 0.0;

      await client.from('products').insert({
        'store_id': _currentStore!.id,
        'name': product.name,
        'price': parsedPrice,
        'category': product.category,
        'image_url': imageUrl,
      });

      await loadFromSupabase();
      return true;
    } catch (e) {
      debugPrint('Error adding product: $e');
      return false;
    }
  }

  void removeProduct(int index) async {
    if (_currentStore == null) return;
    final product = _currentStore!.products[index];
    if (product.id == null) return;

    try {
      await client.from('products').delete().eq('id', product.id!);
      await loadFromSupabase();
    } catch (e) {
      debugPrint('Error removing product: $e');
    }
  }

  Future<void> updateStore({
    required String name,
    required String category,
    String? rip,
    File? image,
    double? latitude,
    double? longitude,
  }) async {
    final user = client.auth.currentUser;
    if (user == null) return;

    try {
      String? imageUrl = _currentStore?.imageUrl;
      if (image != null) {
        final path =
            'stores/${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        await client.storage.from('stores').upload(path, image);
        imageUrl = client.storage.from('stores').getPublicUrl(path);
      }

      final data = {
        'owner_id': user.id,
        'name': name,
        'category': category,
        'rip': rip,
        'image_url': imageUrl,
        'latitude': latitude,
        'longitude': longitude,
      };

      await client.from('stores').upsert(data, onConflict: 'owner_id');
      await loadFromSupabase();
    } catch (e) {
      debugPrint('Error updating store: $e');
      rethrow;
    }
  }

  // Cart Management
  void addToCart(MerchantProduct product) {
    final index = _cart.indexWhere((item) => item.product.name == product.name);
    if (index != -1) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(MerchantProduct product) {
    final index = _cart.indexWhere((item) => item.product.name == product.name);
    if (index != -1) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double getCartTotal() {
    return _cart.fold(
      0,
      (sum, item) =>
          sum + (double.tryParse(item.product.price) ?? 0) * item.quantity,
    );
  }

  int getProductCountInCart(MerchantProduct product) {
    final index = _cart.indexWhere((item) => item.product.name == product.name);
    return index != -1 ? _cart[index].quantity : 0;
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      notifyListeners();
      // In a real app, update Supabase orders table here
    }
  }

  Future<void> placeOrder() async {
    if (_cart.isEmpty) return;
    
    final user = client.auth.currentUser;
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    
    try {
      // 1. Save to Supabase
      await client.from('orders').insert({
        'id': orderId,
        'customer_id': user?.id,
        'customer_name': 'زبون ${DateTime.now().second}',
        'total': getCartTotal(),
        'status': 'pending',
        'store_id': _cart.first.product.storeId,
        'items': _cart.map((item) => {
          'name': item.product.name,
          'price': item.product.price,
          'quantity': item.quantity,
        }).toList(),
      });

      // 2. Local Update
      final newOrder = Order(
        id: orderId,
        customerName: 'زبون ${DateTime.now().second}',
        items: List.from(_cart),
        total: getCartTotal(),
        date: DateTime.now(),
        status: 'قيد الانتظار',
      );
      
      _orders.insert(0, newOrder);
      _cart.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error placing order: $e');
    }
  }

  Future<void> submitRating(String? storeId, double rating) async {
    if (storeId == null) return;
    
    try {
      // 1. Update Supabase (Calculated average on client for simplicity in this MVP)
      final index = _allStores.indexWhere((s) => s.id == storeId);
      if (index != -1) {
        final store = _allStores[index];
        final newRating = store.rating == null ? rating : (store.rating! + rating) / 2.0;
        
        await client.from('stores').update({'rating': newRating}).eq('id', storeId);
        
        // 2. Local Update
        _allStores[index] = Store(
          id: store.id,
          name: store.name,
          category: store.category,
          description: store.description,
          imageUrl: store.imageUrl,
          rip: store.rip,
          latitude: store.latitude,
          longitude: store.longitude,
          products: store.products,
          isRealLocation: store.isRealLocation,
          rating: newRating,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating rating: $e');
    }
  }

  Future<String?> sendJobRequest(String storeId, String name, String phone, String message) async {
    try {
      await client.from('job_requests').insert({
        'store_id': storeId,
        'applicant_name': name,
        'phone': phone,
        'message': message,
        'created_at': DateTime.now().toIso8601String(),
        'status': 'pending', 
      });
      return null; // Success
    } on PostgrestException catch (e) {
      debugPrint('Database error: ${e.message}');
      return e.message;
    } catch (e) {
      debugPrint('Error sending job request: $e');
      return e.toString();
    }
  }

  Future<List<Map<String, dynamic>>> fetchJobRequests() async {
    if (_currentStore?.id == null) return [];
    try {
      final res = await client
          .from('job_requests')
          .select()
          .eq('store_id', _currentStore!.id!)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(res as List);
    } catch (e) {
      debugPrint('Error fetching job requests: $e');
      return [];
    }
  }

  Future<void> markJobRequestReplied(String requestId) async {
    try {
      await client
          .from('job_requests')
          .update({'status': 'replied'})
          .eq('id', requestId);
    } catch (e) {
      debugPrint('Error updating job request status: $e');
    }
  }
}
