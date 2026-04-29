import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../providers/store_provider.dart';

class MerchantProductsScreen extends StatefulWidget {
  final String categoryName;
  final Color categoryColor;

  const MerchantProductsScreen({
    super.key,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  State<MerchantProductsScreen> createState() => _MerchantProductsScreenState();
}

class _MerchantProductsScreenState extends State<MerchantProductsScreen> {
  File? _selectedProductImage;

  Future<void> _pickProductImage(StateSetter modalSetState) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      modalSetState(() {
        _selectedProductImage = File(pickedFile.path);
      });
    }
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    _selectedProductImage = null;
    bool isProcessing = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              left: 24, right: 24, top: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('إضافة منتج لـ ${widget.categoryName}', 
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900), 
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () => _pickProductImage(setModalState),
                    child: Container(
                      height: 120, width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                        image: _selectedProductImage != null 
                          ? DecorationImage(image: FileImage(_selectedProductImage!), fit: BoxFit.cover) 
                          : null,
                      ),
                      child: _selectedProductImage == null 
                        ? const Icon(Icons.add_a_photo_rounded, size: 40, color: Colors.grey) 
                        : null,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المنتج',
                    prefixIcon: const Icon(Icons.shopping_bag_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'السعر',
                    suffixText: 'دج',
                    prefixIcon: const Icon(Icons.payments_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isProcessing ? null : () async {
                    if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                      setModalState(() => isProcessing = true);
                      final storeProvider = context.read<StoreProvider>();
                      final navigator = Navigator.of(context);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      
                      final success = await storeProvider.addProduct(MerchantProduct(
                        name: nameController.text,
                        price: priceController.text,
                        category: widget.categoryName,
                        imagePath: _selectedProductImage?.path,
                      ));
                      
                      if (success) {
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('تم حفظ المنتج بنجاح!')),
                        );
                        if (navigator.canPop()) navigator.pop();
                      } else {
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('فشل الحفظ. تأكد من إعداد المتجر أولاً')),
                        );
                        setModalState(() => isProcessing = false);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.categoryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 4,
                  ),
                  child: isProcessing 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('حفظ المنتج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final storeProvider = context.watch<StoreProvider>();
    
    final products = (storeProvider.currentStore?.products ?? [])
        .where((p) => p.category == widget.categoryName)
        .toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0F0D) : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(widget.categoryName, style: const TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: widget.categoryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_rounded, size: 100, color: Colors.grey.withValues(alpha: 0.2)),
                  const SizedBox(height: 24),
                  Text('لا توجد منتجات في هذا القسم حالياً', 
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade500, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text('ابدأ بإضافة أول منتج لمتجرك الآن', 
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A2220) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04), 
                        blurRadius: 20, 
                        offset: const Offset(0, 10)
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 64, height: 64,
                      decoration: BoxDecoration(
                        color: widget.categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: product.imagePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16), 
                              child: product.imagePath!.startsWith('http') 
                                ? Image.network(product.imagePath!, fit: BoxFit.cover)
                                : Image.file(File(product.imagePath!), fit: BoxFit.cover)
                            )
                          : Icon(Icons.shopping_basket_rounded, color: widget.categoryColor, size: 32),
                    ),
                    title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text('${product.price} دج', 
                        style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                        onPressed: () {
                          final mainIndex = storeProvider.currentStore!.products.indexOf(product);
                          storeProvider.removeProduct(mainIndex);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductDialog(context),
        backgroundColor: widget.categoryColor,
        elevation: 6,
        label: const Text('إضافة منتج', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.white)),
        icon: const Icon(Icons.add_shopping_cart_rounded, color: Colors.white),
      ),
    );
  }
}
