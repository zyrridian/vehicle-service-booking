import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Riwayat Booking', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTab(true, 'Aktif'),
                      const SizedBox(width: 8),
                      _buildTab(false, 'Selesai'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  _buildHistoryCard(
                    id: 'SA-20260925-7765',
                    status: 'Aktif',
                    statusColor: AppColors.info,
                    detail: '1 motor · 25 Sep, 11:00',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(bool isActive, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.brand50 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isActive ? AppColors.brand : AppColors.line, width: 2),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: isActive ? AppColors.ink : AppColors.ink.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildHistoryCard({required String id, required String status, required Color statusColor, required String detail}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.ink)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(detail, style: TextStyle(fontSize: 12, color: AppColors.ink.withOpacity(0.5))),
        ],
      ),
    );
  }
}
