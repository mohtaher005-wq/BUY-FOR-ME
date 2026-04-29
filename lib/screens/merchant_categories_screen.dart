import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'merchant_products_screen.dart';
import '../providers/store_provider.dart';

class MerchantCategoriesScreen extends StatefulWidget {
  const MerchantCategoriesScreen({super.key});

  @override
  State<MerchantCategoriesScreen> createState() => _MerchantCategoriesScreenState();
}

class _MerchantCategoriesScreenState extends State<MerchantCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    _loadStore();
  }

  void _loadStore() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StoreProvider>().loadFromSupabase();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final storeProvider = context.watch<StoreProvider>();
    final storeName = storeProvider.currentStore?.name ?? 'أقسام المتجر';

    final List<Map<String, dynamic>> categories = [
      {'name': 'خضر وفواكه', 'icon': Icons.eco_rounded, 'color': Colors.green},
      {'name': 'قصابة ولحوم', 'icon': Icons.restaurant_rounded, 'color': Colors.red},
      {'name': 'مواد تنظيف', 'icon': Icons.cleaning_services_rounded, 'color': Colors.blue},
      {'name': 'معجنات وخبز', 'icon': Icons.bakery_dining_rounded, 'color': Colors.orangeAccent},
      {'name': 'أجبان وألبان', 'icon': Icons.egg_rounded, 'color': Colors.yellow.shade700},
      {'name': 'مشروبات', 'icon': Icons.local_drink_rounded, 'color': Colors.purple},
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0F0D) : Colors.white,
      appBar: AppBar(
        title: Text(storeName, style: const TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: storeProvider.currentStore == null
          ? _buildSetupPrompt(context)
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeaderSection(context)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.95,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final cat = categories[index];
                        return _buildCategoryCard(context, cat);
                      },
                      childCount: categories.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSetupPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.store_rounded, size: 80, color: Colors.orange.shade700),
            ),
            const SizedBox(height: 24),
            const Text(
              'أكمل إعداد متجرك أولاً',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'يجب عليك إدخال بيانات متجرك (الاسم، الموقع، إلخ) لتتمكن من إضافة المنتجات وعرضها للزبائن.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<StoreProvider>().loadFromSupabase();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري تحديث البيانات...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('تحديث البيانات', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('انقر على أيقونة الإعدادات (الترس) في الأسفل')),
                );
              },
              child: const Text('أو اذهب للإعدادات يدوياً', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [Colors.orange.shade900.withValues(alpha: 0.2), Colors.orange.shade800.withValues(alpha: 0.1)]
            : [Colors.orange.shade100, Colors.orange.shade50],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نظّم متجرك بكل سهولة',
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.w900, 
              color: isDark ? Colors.orange.shade400 : Colors.orange.shade900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'اختر القسم المناسب لإضافة منتجاتك والبدء في عرضها للزبائن.',
            style: TextStyle(
              fontSize: 14, 
              color: isDark ? Colors.orange.shade200 : Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> cat) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color color = cat['color'];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: isDark ? const Color(0xFF1A2220) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MerchantProductsScreen(
                categoryName: cat['name'], 
                categoryColor: color
              )
            )
          ),
          borderRadius: BorderRadius.circular(28),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: color.withValues(alpha: isDark ? 0.3 : 0.2), 
                width: 2
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(cat['icon'], size: 36, color: color),
                ),
                const SizedBox(height: 16),
                Text(
                  cat['name'], 
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: isDark ? Colors.white : Colors.black87
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
