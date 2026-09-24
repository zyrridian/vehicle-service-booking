import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  _buildNotificationItem(
                    title: 'Booking Dikonfirmasi',
                    body: 'Servis 2 motor kamu terjadwal besok jam 09:30.',
                    time: '10 menit lalu',
                    isUnread: true,
                  ),
                  const SizedBox(height: 10),
                  _buildNotificationItem(
                    title: 'Promo Servis Berkala',
                    body: 'Diskon 20% ganti oli untuk booking multi-motor.',
                    time: '2 jam lalu',
                    isUnread: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 36,
              height: 36,
              transform: Matrix4.translationValues(-6.0, 0.0, 0.0),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Icon(LucideIcons.chevronLeft, color: AppColors.ink, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          const Text('Notifikasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({required String title, required String body, required String time, required bool isUnread}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.brand50,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.bell, color: AppColors.brand, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(body, style: TextStyle(fontSize: 12, color: AppColors.ink.withOpacity(0.5))),
                const SizedBox(height: 4),
                Text(time, style: TextStyle(fontSize: 11, color: AppColors.ink.withOpacity(0.35))),
              ],
            ),
          ),
          if (isUnread)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 4),
              decoration: const BoxDecoration(
                color: AppColors.brand,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
