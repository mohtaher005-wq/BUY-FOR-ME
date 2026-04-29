import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/store_provider.dart';

class JobSearchMapScreen extends StatefulWidget {
  const JobSearchMapScreen({super.key});

  @override
  State<JobSearchMapScreen> createState() => _JobSearchMapScreenState();
}

class _JobSearchMapScreenState extends State<JobSearchMapScreen> {
  final MapController _mapController = MapController();
  LatLng _userPosition = const LatLng(36.7538, 3.0588); // Default to Algiers
  String _searchQuery = '';
  bool _isLocating = true;
  bool _searchThisAreaVisible = false;

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

  void _showJobRequestDialog(BuildContext context, Store store) {
    if (store.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('عذراً، هذا المتجر غير متوفر لطلبات العمل')),
      );
      return;
    }

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('طلب عمل: ${store.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم الكامل',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'رسالة قصيرة أو خبراتك',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('الرجاء إدخال الاسم ورقم الهاتف')),
                );
                return;
              }

              final errorMessage = await context.read<StoreProvider>().sendJobRequest(
                store.id!,
                nameController.text.trim(),
                phoneController.text.trim(),
                messageController.text.trim(),
              );

              if (!mounted) return;
              Navigator.pop(ctx);
              
              if (errorMessage == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إرسال طلب العمل بنجاح!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('فشل الإرسال: $errorMessage'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            },
            child: const Text('إرسال الطلب'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();
    // Get all stores which are registered in the app (exclude Google Places results if needed, or allow all. Real stores from DB don't have isRealLocation=true but wait, in the customer map: isRealLocation = true for google places).
    // Let's only list stores from DB so we can message them:
    final stores = storeProvider.stores
        .where((s) => !s.isRealLocation && s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
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
                  ...stores.map((store) {
                    return Marker(
                      point: LatLng(
                        store.latitude ?? 36.75,
                        store.longitude ?? 3.06,
                      ),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          _showJobRequestDialog(context, store);
                        },
                        child: const Icon(
                          Icons.work_rounded,
                          color: Colors.purple,
                          size: 45,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // Top Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildFloatingSearchBar(context, isDark, stores),
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
                  _buildStoreCard(context, stores[index], isDark),
            ),
          ),

          // Side Actions
          Positioned(
            right: 16,
            bottom: 240,
            child: Column(
              children: [
                _buildBlurButton(Icons.my_location_rounded, () async {
                  final pos = await Geolocator.getCurrentPosition();
                  setState(
                    () => _userPosition = LatLng(pos.latitude, pos.longitude),
                  );
                  _mapController.move(_userPosition, 14);
                }, isDark),
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

  Widget _buildFloatingSearchBar(BuildContext context, bool isDark, List<Store> stores) {
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
                    hintText: 'ابحث عن عمل في المتاجر...',
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              if (stores.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.work_rounded, size: 14, color: Colors.purple),
                      const SizedBox(width: 4),
                      Text(
                        '${stores.length}',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, Store store, bool isDark) {
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
              color: Colors.purple.withOpacity(isDark ? 0.2 : 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                          ),
                          Text(
                            store.category,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, size: 14, color: Colors.purple),
                    Text(
                      ' يبعد ${dist.toStringAsFixed(1)} كم',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => _showJobRequestDialog(context, store),
                        icon: const Icon(Icons.send_rounded, size: 16),
                        label: const Text('أرسل طلب عمل'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blueAccent.withOpacity(0.1),
                        foregroundColor: Colors.blue,
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
        color: Colors.grey.withOpacity(0.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: store.imageUrl != null
            ? Image.network(
                store.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.store),
              )
            : const Icon(Icons.store),
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
              color: isDark ? Colors.purpleAccent : Colors.purple,
            ),
          ),
        ),
      ),
    );
  }
}
