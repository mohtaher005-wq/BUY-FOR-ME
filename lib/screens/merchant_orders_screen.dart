import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/store_provider.dart';

class MerchantOrdersScreen extends StatefulWidget {
  const MerchantOrdersScreen({super.key});

  @override
  State<MerchantOrdersScreen> createState() => _MerchantOrdersScreenState();
}

class _MerchantOrdersScreenState extends State<MerchantOrdersScreen> {
  final List<String> _drivers = [
    'سفيان (سيارة)',
    'كريم (دراجة نارية)',
    'أمين (شاحنة صغيرة)',
  ];

  void _assignDriver(BuildContext context, String orderId, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2220) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'اختر موزع التوصيل',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 24),
            ..._drivers.map((driver) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.orange.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    context.read<StoreProvider>().updateOrderStatus(orderId, 'في الطريق ($driver)');
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('تم تعيين $driver بنجاح!'),
                      backgroundColor: Colors.green,
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.delivery_dining_rounded, color: Colors.orange.shade600),
                        ),
                        const SizedBox(width: 16),
                        Text(driver, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Spacer(),
                        const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            )),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final storeProvider = context.watch<StoreProvider>();
    final orders = storeProvider.orders;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0F0D) : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('طلبات الزبائن', style: TextStyle(fontWeight: FontWeight.w900)),
        centerTitle: true,
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.receipt_long_rounded, size: 72, color: Colors.orange.shade200),
                  ),
                  const SizedBox(height: 24),
                  const Text('لا توجد طلبات حالياً', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text('ستظهر طلبات الزبائن هنا فور ورودها', style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final bool isPending = order.status == 'قيد الانتظار';
                final statusColor = isPending ? Colors.blue : Colors.green;

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A2220) : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20, offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'طلب #${order.id.substring(0, 8)}',
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                order.status,
                                style: TextStyle(color: statusColor, fontWeight: FontWeight.w900, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        if (order.rating != null) ...[
                          const SizedBox(height: 10),
                          Row(children: [
                            ...List.generate(order.rating!.toInt(), (_) =>
                              const Icon(Icons.star_rounded, color: Colors.orange, size: 18)),
                            const SizedBox(width: 6),
                            Text('${order.rating}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                          ]),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(height: 1),
                        ),
                        _buildInfoRow(Icons.person_rounded, 'الزبون', order.customerName, Colors.blue),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          Icons.shopping_bag_rounded, 'المنتجات',
                          order.items.map((i) => '${i.quantity}x ${i.product.name}').join(' • '),
                          Colors.purple,
                        ),
                        const SizedBox(height: 16),
                        if (order.receiptImagePath != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: OutlinedButton.icon(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: Image.file(File(order.receiptImagePath!), fit: BoxFit.contain),
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.receipt_rounded, color: Colors.green),
                              label: const Text('عرض وصل الدفع', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.green),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                minimumSize: const Size(double.infinity, 48),
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${order.items.length} منتجات', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                            Text('${order.totalPrice} دج', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.orange.shade600)),
                          ],
                        ),
                        if (isPending) ...[
                          const SizedBox(height: 16),
                          Row(children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _assignDriver(context, order.id, isDark),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                icon: const Icon(Icons.delivery_dining_rounded, size: 20),
                                label: const Text('تعيين موزع', style: TextStyle(fontWeight: FontWeight.w900)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => storeProvider.updateOrderStatus(order.id, 'تم التجهيز'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                icon: const Icon(Icons.inventory_2_rounded, size: 20),
                                label: const Text('تجهيز الطلب', style: TextStyle(fontWeight: FontWeight.w900)),
                              ),
                            ),
                          ]),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis, maxLines: 2),
            ],
          ),
        ),
      ],
    );
  }
}
