import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../l10n/app_localizations.dart';
import 'merchant_main_screen.dart';
import '../providers/store_provider.dart';
import '../providers/locale_provider.dart';

class MerchantSetupScreen extends StatefulWidget {
  const MerchantSetupScreen({super.key});

  @override
  State<MerchantSetupScreen> createState() => _MerchantSetupScreenState();
}

class _MerchantSetupScreenState extends State<MerchantSetupScreen> {
  final _storeNameController = TextEditingController();
  final _ripController = TextEditingController();
  String? _selectedCategory;
  File? _image;
  final _picker = ImagePicker();
  bool _isSaving = false;
  LatLng? _selectedLocation;
  final MapController _mapController = MapController();

  // Standard center for Algeria (Algiers)
  static const LatLng _defaultLocation = LatLng(36.7538, 3.0588);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = context.read<StoreProvider>().currentStore;
      if (store != null) {
        setState(() {
          _storeNameController.text = store.name;
          _ripController.text = store.rip ?? '';
          _selectedCategory = store.category;
          if (store.latitude != null && store.longitude != null) {
            _selectedLocation = LatLng(store.latitude!, store.longitude!);
          }
        });
      }
    });
  }

  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2220) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 24),
              _imageOption(Icons.camera_alt_rounded, l10n.pickFromCamera, Colors.blue, () async {
                Navigator.pop(context);
                await _getImage(ImageSource.camera);
              }),
              const SizedBox(height: 12),
              _imageOption(Icons.photo_library_rounded, l10n.pickFromGallery, Colors.purple, () async {
                Navigator.pop(context);
                await _getImage(ImageSource.gallery);
              }),
              if (_image != null) ...[
                const SizedBox(height: 12),
                _imageOption(Icons.delete_rounded, l10n.deletePhoto, Colors.red, () {
                  setState(() => _image = null);
                  Navigator.pop(context);
                }),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _imageOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() => _image = File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
      }
    }
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _ripController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0F0D) : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(l10n.merchantSetupTitle, style: const TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.language_rounded),
            onPressed: () => context.read<LocaleProvider>().cycleLocale(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAnimatedSection(
              index: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Store Image Upload
                  _buildSectionLabel(l10n.storeImage, Icons.photo_camera_rounded, Colors.orange),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1A2220) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
                        image: _image != null ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover) : null,
                      ),
                      child: _image == null 
                        ? Icon(Icons.add_a_photo_rounded, size: 40, color: Colors.orange.shade400)
                        : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildAnimatedSection(
              index: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   // Store Name
                  _buildSectionLabel(l10n.storeName, Icons.store_rounded, Colors.blue),
                  const SizedBox(height: 12),
                  _buildPremiumField(controller: _storeNameController, hint: l10n.storeNameHint, icon: Icons.edit, isDark: isDark),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildAnimatedSection(
              index: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // RIP
                  _buildSectionLabel(l10n.ripLabel, Icons.account_balance_rounded, Colors.green),
                  const SizedBox(height: 12),
                  _buildPremiumField(controller: _ripController, hint: l10n.ripHint, icon: Icons.credit_card, isDark: isDark, keyboardType: TextInputType.number),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildAnimatedSection(
              index: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   // Category Selection
                  _buildSectionLabel(l10n.categoryLabel, Icons.category_rounded, Colors.purple),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1A2220) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        hint: Text(l10n.categoryHint),
                        isExpanded: true,
                        items: [
                          DropdownMenuItem(value: 'بقالة عامة', child: _catItem(Icons.store_rounded, 'بقالة عامة', Colors.green)),
                          DropdownMenuItem(value: 'فواكه وخضر', child: _catItem(Icons.eco, 'فواكه وخضر', Colors.green)),
                          DropdownMenuItem(value: 'لحوم ودواجن', child: _catItem(Icons.restaurant, 'لحوم ودواجن', Colors.red)),
                          DropdownMenuItem(value: 'حلويات ومعجنات', child: _catItem(Icons.bakery_dining, 'حلويات ومعجنات', Colors.orange)),
                          DropdownMenuItem(value: 'مواد تنظيف', child: _catItem(Icons.cleaning_services, 'مواد تنظيف', Colors.blue)),
                          DropdownMenuItem(value: 'ألبان وأجبان', child: _catItem(Icons.egg, 'ألبان وأجبان', Colors.yellow.shade700)),
                          DropdownMenuItem(value: 'مشروبات وعصائر', child: _catItem(Icons.local_drink, 'مشروبات وعصائر', Colors.purple)),
                        ],
                        onChanged: (val) => setState(() => _selectedCategory = val),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildAnimatedSection(
              index: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    // MUST: Location Picker (Yassir Style)
                  _buildSectionLabel(isDark ? 'Store location' : 'موقع المتجر على الخريطة', Icons.location_on_rounded, Colors.redAccent),
                  const SizedBox(height: 12),
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _selectedLocation ?? _defaultLocation,
                          initialZoom: 13,
                          onTap: (tapPosition, latlng) {
                            setState(() => _selectedLocation = latlng);
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.buyforme.app',
                          ),
                          if (_selectedLocation != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _selectedLocation!,
                                  width: 60, height: 60,
                                  child: const Icon(Icons.location_on_rounded, color: Colors.red, size: 45),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              height: 64,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                  elevation: 6,
                ),
                child: _isSaving 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('حفظ والانتقال للمتجر', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 150)),
      curve: Curves.easeOutCubic,
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

  Widget _catItem(IconData icon, String label, Color color) {
    return Row(children: [
      Icon(icon, color: color, size: 20),
      const SizedBox(width: 12),
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    ]);
  }

  Widget _buildSectionLabel(String label, IconData icon, Color color) {
    return Row(children: [
      Icon(icon, size: 20, color: color),
      const SizedBox(width: 8),
      Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
    ]);
  }

  Widget _buildPremiumField({required TextEditingController controller, required String hint, required IconData icon, required bool isDark, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2220) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(hintText: hint, icon: Icon(icon, color: Colors.orange), border: InputBorder.none),
      ),
    );
  }

  Future<void> _save() async {
    if (_storeNameController.text.isEmpty || _selectedCategory == null || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى ملء جميع الحقول وتحديد الموقع على الخريطة')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      await context.read<StoreProvider>().updateStore(
        name: _storeNameController.text.trim(),
        category: _selectedCategory!,
        rip: _ripController.text.trim(),
        image: _image,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
      );
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MerchantMainScreen()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('حدث خطأ: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
