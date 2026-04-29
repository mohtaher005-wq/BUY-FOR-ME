import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../l10n/app_localizations.dart';

class CustomerCartScreen extends StatefulWidget {
  const CustomerCartScreen({super.key});

  @override
  State<CustomerCartScreen> createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  bool _isProcessing = false;

  double get _totalPrice => context.watch<StoreProvider>().getCartTotal();

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<StoreProvider>().cart;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('سلة المشتريات', style: TextStyle(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // خلفية ذكية متناسقة مع بقية التطبيق
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark 
                  ? [const Color(0xFF002117), const Color(0xFF000806)]
                  : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
              ),
            ),
          ),
          
          SafeArea(
            child: cartItems.isEmpty
                ? _buildEmptyCart(isDark)
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return _buildCartItemCard(context, item, isDark);
                          },
                        ),
                      ),
                      _buildCheckoutSection(context, isDark, l10n),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.green.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('سلتك فارغة حالياً', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('ابدأ بإضافة بعض المنتجات الرائعة!', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.inventory_2_rounded, color: Colors.green),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${item.product.price} DZD', style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
                _buildQuantityControl(context, item, isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControl(BuildContext context, CartItem item, bool isDark) {
    final provider = context.read<StoreProvider>();
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline, size: 24, color: Colors.redAccent),
          onPressed: () => provider.removeFromCart(item.product),
        ),
        Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, size: 24, color: Colors.green),
          onPressed: () => provider.addToCart(item.product),
        ),
      ],
    );
  }

  Widget _buildCheckoutSection(BuildContext context, bool isDark, AppLocalizations l10n) {
    final cartItems = context.watch<StoreProvider>().cart;
    final storeId = cartItems.isNotEmpty ? cartItems.first.product.storeId : null;
    
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.85),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 40)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('المجموع الكلي', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text(
                    '$_totalPrice DZD',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : () {
                    setState(() => _isProcessing = true);
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) {
                        setState(() => _isProcessing = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('تم تأكيد طلبك بنجاح! تم إرساله للمتجر 🚀'),
                              backgroundColor: Colors.green,
                          ),
                        );
                        
                        context.read<StoreProvider>().placeOrder();
                        _showRatingDialog(context, storeId);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 10,
                    shadowColor: Colors.green.withValues(alpha: 0.5),
                  ),
                  child: _isProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'تأكيد الطلب الآن',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context, String? storeId) {
    double currentRating = 5.0;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1A2220) : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Center(child: Text('تقييم المتجر', style: TextStyle(fontWeight: FontWeight.w900))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'كيف كانت تجربتك مع هذا المتجر؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < currentRating ? Icons.star_rounded : Icons.star_border_rounded,
                          color: Colors.amber,
                          size: 40,
                        ),
                        onPressed: () {
                          setDialogState(() => currentRating = index + 1.0);
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (mounted) Navigator.pop(context);
                },
                child: const Text('تخطي', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<StoreProvider>().submitRating(storeId, currentRating);
                  Navigator.pop(ctx);
                  if (mounted) Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('شكراً لتقييمك! 🌟', style: TextStyle(fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.amber,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('إرسال التقييم', style: TextStyle(fontWeight: FontWeight.w900)),
              ),
            ],
          );
        }
      ),
    );
  }
}
