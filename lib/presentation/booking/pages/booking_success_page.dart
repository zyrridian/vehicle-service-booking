import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../main_layout/pages/main_layout_page.dart';

class BookingSuccessPage extends StatelessWidget {
  final String bookingId;
  final int vehicleCount;
  final DateTime date;
  final String time;
  final double totalPrice;

  const BookingSuccessPage({
    super.key,
    required this.bookingId,
    required this.vehicleCount,
    required this.date,
    required this.time,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('E, dd MMM').format(date);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.good.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(LucideIcons.check, color: AppColors.good, size: 30),
              ),
              const SizedBox(height: 16),
              const Text('Booking Successful!', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.ink)),
              const SizedBox(height: 4),
              Text(
                'Your digital ticket is ready,\nshow it to the staff when you arrive',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.ink.withOpacity(0.5)),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    _buildFakeQr(),
                    const SizedBox(height: 16),
                    Text(bookingId, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: AppColors.ink)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.ink,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('$vehicleCount Vehicle(s)', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: AppColors.ink.withOpacity(0.1), height: 1),
                    const SizedBox(height: 16),
                    _buildDetailRow('Branch', 'Servisin Aja - Kemang'),
                    const SizedBox(height: 6),
                    _buildDetailRow('Schedule', '$dateStr · $time'),
                    const SizedBox(height: 6),
                    _buildDetailRow('Total Cost', NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(totalPrice)),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainLayoutPage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 0,
                  ),
                  child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFakeQr() {
    return SizedBox(
      width: 112,
      height: 112,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: 25,
        itemBuilder: (context, index) {
          bool isBlank = [6, 8, 12, 16, 18].contains(index);
          return Container(
            decoration: BoxDecoration(
              color: isBlank ? Colors.transparent : AppColors.ink,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12.5, color: AppColors.ink.withOpacity(0.6))),
        Text(value, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.ink)),
      ],
    );
  }
}
