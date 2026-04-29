import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import 'customer_cart_screen.dart';

class CustomerStoreScreen extends StatefulWidget {
  final String storeId;
  const CustomerStoreScreen({super.key, required this.storeId});

  @override
  State<CustomerStoreScreen> createState() => _CustomerStoreScreenState();
}

class _CustomerStoreScreenState extends State<CustomerStoreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().fetchStoreProducts(widget.storeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = context.watch<StoreProvider>();
    final store = storeProvider.stores.firstWhere(
      (s) => s.id == widget.storeId,
      orElse: () => Store(name: 'Loading...', category: ''),
    );
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, store.name, isDark),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [const Color(0xFF003822), const Color(0xFF001209)]
                    : [const Color(0xFFF1F8E9), const Color(0xFFDCEDC8)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAnimatedItem(
                  index: 0,
                  child: _buildStoreHeader(store, isDark),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: store.products.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.green),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: store.products.length,
                          itemBuilder: (context, index) {
                            final product = store.products[index];
                            return _buildAnimatedItem(
                              index: index + 1,
                              child: _buildProductCard(context, product, isDark),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 30,
            right: 24,
            child: _buildCartFab(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedItem({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 120)),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    String name,
    bool isDark,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreHeader(Store store, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.6),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      store.rating?.toStringAsFixed(1) ?? "جديد",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'أفضل المنتجات الطازجة تصلك لباب المنزل',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    MerchantProduct product,
    bool isDark,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.7),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 50,
                      color: Colors.green.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.price} DZD',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildAddToCartButton(context, product, isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(
    BuildContext context,
    MerchantProduct product,
    bool isDark,
  ) {
    final storeProvider = context.watch<StoreProvider>();
    final count = storeProvider.getProductCountInCart(product);

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: count > 0 ? Colors.green : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (count > 0) ...[
            IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.remove, size: 18, color: Colors.white),
              onPressed: () => storeProvider.removeFromCart(product),
            ),
            Text(
              '$count',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.add,
              size: 18,
              color: count > 0 ? Colors.white : Colors.green,
            ),
            onPressed: () => storeProvider.addToCart(product),
          ),
        ],
      ),
    );
  }

  Widget _buildCartFab(BuildContext context, bool isDark) {
    final count = context.watch<StoreProvider>().cartItemsCount;
    if (count == 0) return const SizedBox.shrink();

    return FloatingActionButton.extended(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CustomerCartScreen()),
      ),
      backgroundColor: Colors.green,
      label: Text(
        '$count منتجات • اذهب للسلة',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      icon: const Icon(Icons.shopping_cart_rounded),
      elevation: 4,
    );
  }
}
