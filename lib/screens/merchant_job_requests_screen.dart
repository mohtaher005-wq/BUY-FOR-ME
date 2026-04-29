import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/store_provider.dart';

class MerchantJobRequestsScreen extends StatefulWidget {
  const MerchantJobRequestsScreen({super.key});

  @override
  State<MerchantJobRequestsScreen> createState() => _MerchantJobRequestsScreenState();
}

class _MerchantJobRequestsScreenState extends State<MerchantJobRequestsScreen> {
  List<Map<String, dynamic>> _jobRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    final requests = await context.read<StoreProvider>().fetchJobRequests();
    if (mounted) {
      setState(() {
        _jobRequests = requests;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلبات العمل'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRequests,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _jobRequests.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.work_off_rounded, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد طلبات عمل حالياً',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _jobRequests.length,
                  itemBuilder: (context, index) {
                    final req = _jobRequests[index];
                    final date = DateTime.tryParse(req['created_at']?.toString() ?? '');
                    final dateStr = date != null ? DateFormat('yyyy-MM-dd HH:mm').format(date) : '';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.purple.withOpacity(0.2),
                                  child: const Icon(Icons.person, color: Colors.purple),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        req['applicant_name'] ?? 'مجهول',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        dateStr,
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: (req['status'] == 'pending' ? Colors.orange : Colors.green).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    req['status'] == 'pending' ? 'قيد الانتظار' : 'تم الرد',
                                    style: TextStyle(
                                      color: req['status'] == 'pending' ? Colors.orange.shade800 : Colors.green.shade800,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  req['phone'] ?? 'لا يوجد رقم',
                                  style: const TextStyle(fontSize: 16),
                                  textDirection: ui.TextDirection.ltr,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (req['message'] != null && req['message'].toString().trim().isNotEmpty)
                               Container(
                                 width: double.infinity,
                                 padding: const EdgeInsets.all(12),
                                 decoration: BoxDecoration(
                                   color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                                   borderRadius: BorderRadius.circular(12),
                                 ),
                                 child: Text(req['message']),
                               ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (req['status'] == 'pending')
                                  TextButton(
                                    onPressed: () async {
                                      await context.read<StoreProvider>().markJobRequestReplied(req['id']);
                                      _loadRequests();
                                    },
                                    child: const Text('تحديد كـ "تم الرد"'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
