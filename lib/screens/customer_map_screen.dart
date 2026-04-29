import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/store_provider.dart';
import '../providers/locale_provider.dart';
import 'customer_store_screen.dart';
import 'customer_cart_screen.dart';

class CustomerMapScreen extends StatefulWidget {
  const CustomerMapScreen({super.key});

  @override
  State<CustomerMapScreen> createState() => _CustomerMapScreenState();
}

class _CustomerMapScreenState extends State<CustomerMapScreen> {
  final MapController _mapController = MapController();
  LatLng _userPosition = const LatLng(36.7538, 3.0588); // Default to Algiers
  String _searchQuery = '';
  bool _isLocating = true;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _finishLocating();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _finishLocating();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _finishLocating();
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _userPosition = LatLng(position.latitude, position.longitude);
          _isLocating = false;
        });
        _mapController.move(_userPosition, 14);
        context.read<StoreProvider>().fetchRealStores(
          position.latitude,
          position.longitude,
        );
      }
    } catch (e) {
      _finishLocating();
    }
  }

  void _finishLocating() {
    if (mounted) setState(() => _isLocating = false);
  }

  Future<void> _openInMaps(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    const double radius = 6371;
    final dLat = (p2.latitude - p1.latitude) * (pi / 180);
    final dLon = (p2.longitude - p1.longitude) * (pi / 180);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(p1.latitude * (pi / 180)) *
            cos(p2.latitude * (pi / 180)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  String _estimateTime(double distanceKm) {
    final minutes = (distanceKm / 0.08).round();
    if (minutes < 1) return 'دقيقة';
    return minutes < 60
        ? '$minutes د'
        : '${(minutes / 60).toStringAsFixed(1)} س';
  }

  bool _searchThisAreaVisible = false;

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();
    final stores = storeProvider.stores
        .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userPosition,
              initialZoom: 12,
              onPositionChanged: (pos, hasGesture) {
                if (hasGesture && !_searchThisAreaVisible) {
                  setState(() => _searchThisAreaVisible = true);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: isDark
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.buy_for_me',
                retinaMode: RetinaMode.isHighDensity(context),
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _userPosition,
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ...stores.where((s) => s.name.contains(_searchQuery)).map((
                    store,
                  ) {
                    final bool isReal = store.isRealLocation;
                    return Marker(
                      point: LatLng(
                        store.latitude ?? 36.75,
                        store.longitude ?? 3.06,
                      ),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          if (isReal) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('متجر: ${store.name}')),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    CustomerStoreScreen(storeId: store.id!),
                              ),
                            );
                          }
                        },
                        child: Icon(
                          Icons.location_on_rounded,
                          color: isReal ? Colors.blue.shade700 : Colors.green,
                          size: isReal ? 40 : 55,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // Search this area button
          if (_searchThisAreaVisible)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final center = _mapController.camera.center;
                    storeProvider.fetchRealStores(
                      center.latitude,
                      center.longitude,
                    );
                    setState(() => _searchThisAreaVisible = false);
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('ابحث هنا'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),

          // Top Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildAnimatedItem(
                index: 0,
                child: _buildFloatingSearchBar(context, isDark, stores),
              ),
            ),
          ),

          // Bottom Cards
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: stores.length,
              itemBuilder: (context, index) =>
                  _buildAnimatedItem(
                    index: index + 1,
                    child: _buildStoreCard(context, stores[index], isDark),
                  ),
            ),
          ),

          // Side Actions
          Positioned(
            right: 16,
            bottom: 240,
            child: Column(
              children: [
                _buildBlurButton(Icons.language_rounded, () {
                  context.read<LocaleProvider>().cycleLocale();
                }, isDark),
                const SizedBox(height: 12),
                _buildBlurButton(Icons.my_location_rounded, () async {
                  final pos = await Geolocator.getCurrentPosition();
                  setState(
                    () => _userPosition = LatLng(pos.latitude, pos.longitude),
                  );
                  _mapController.move(_userPosition, 14);
                  storeProvider.fetchRealStores(pos.latitude, pos.longitude);
                }, isDark),
                const SizedBox(height: 12),
                _buildCartFab(context, isDark),
              ],
            ),
          ),

          if (_isLocating)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.green),
                    SizedBox(height: 16),
                    Text(
                      'جاري تحديد موقعك...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAnimatedItem({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildFloatingSearchBar(
    BuildContext context,
    bool isDark,
    List<Store> stores,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isDark ? 0.05 : 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن متجر...',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (stores.isNotEmpty)
                GestureDetector(
                  onTap: () => _showAllStores(context, stores, isDark),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.list_rounded,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${stores.length} متاح',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, Store store, bool isDark) {
    final bool isReal = store.isRealLocation;
    final dist = _calculateDistance(
      _userPosition,
      LatLng(store.latitude ?? 36.75, store.longitude ?? 3.06),
    );

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isReal
                  ? Colors.white.withOpacity(isDark ? 0.05 : 0.85)
                  : Colors.green.withOpacity(0.9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildStoreImage(store),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 16,
                              ),
                              Text(
                                ' ${store.rating?.toStringAsFixed(1) ?? "4.5"}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                store.category,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isReal ? Colors.grey : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.directions_walk_rounded,
                      size: 14,
                      color: isReal ? Colors.green : Colors.white,
                    ),
                    Text(
                      ' ${dist.toStringAsFixed(1)} كم',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: isReal ? Colors.orange : Colors.white70,
                    ),
                    Text(
                      ' ${_estimateTime(dist)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isReal ? Colors.green : Colors.white,
                          foregroundColor: isReal ? Colors.white : Colors.green,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CustomerStoreScreen(storeId: store.id!),
                          ),
                        ),
                        child: const Text('المتجر'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _openInMaps(
                        store.latitude ?? 36.75,
                        store.longitude ?? 3.06,
                      ),
                      icon: const Icon(Icons.near_me_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreImage(Store store) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white24,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: store.imageUrl != null
            ? Image.network(
                store.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.store),
              )
            : const Icon(Icons.store, color: Colors.white),
      ),
    );
  }

  Widget _buildBlurButton(IconData icon, VoidCallback onTap, bool isDark) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(isDark ? 0.1 : 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDark ? Colors.greenAccent : Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartFab(BuildContext context, bool isDark) {
    final cartCount = context.watch<StoreProvider>().cartItemsCount;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildBlurButton(
          Icons.shopping_cart_rounded,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CustomerCartScreen()),
          ),
          isDark,
        ),
        if (cartCount > 0)
          Positioned(
            top: -5,
            right: -5,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$cartCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showAllStores(BuildContext context, List<Store> stores, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text(
                      'المتاجر المتاحة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${stores.length} متجر',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: stores.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 70),
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      leading: _buildStoreImage(store),
                      title: Text(
                        store.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 14,
                          ),
                          Text(
                            ' ${store.rating?.toStringAsFixed(1) ?? "4.5"} ',
                            style: const TextStyle(fontSize: 11),
                          ),
                          Text(
                            '• ${store.category}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _mapController.move(
                            LatLng(
                              store.latitude ?? 36.75,
                              store.longitude ?? 3.06,
                            ),
                            15,
                          );
                        },
                      ),
                       onTap: () {
                        if (store.id != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CustomerStoreScreen(storeId: store.id!),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
