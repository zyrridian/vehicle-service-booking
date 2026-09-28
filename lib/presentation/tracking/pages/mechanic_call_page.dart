import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class MechanicCallPage extends StatelessWidget {
  final String mechanicName;
  final String? mechanicPhotoUrl;

  const MechanicCallPage({
    super.key,
    required this.mechanicName,
    this.mechanicPhotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white12,
              backgroundImage: mechanicPhotoUrl != null
                  ? NetworkImage(mechanicPhotoUrl!)
                  : null,
              child: mechanicPhotoUrl == null
                  ? const Icon(LucideIcons.user, size: 60, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 24),
            Text(
              mechanicName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '02:15',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCallButton(LucideIcons.micOff, Colors.white12, Colors.white, () {}),
                _buildCallButton(LucideIcons.phoneOff, Colors.red, Colors.white, () {
                  Navigator.of(context).pop();
                }, size: 72, iconSize: 32),
                _buildCallButton(LucideIcons.volume2, Colors.white12, Colors.white, () {}),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildCallButton(
      IconData icon, Color bgColor, Color iconColor, VoidCallback onTap,
      {double size = 56, double iconSize = 24}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(icon, color: iconColor, size: iconSize),
        ),
      ),
    );
  }
}
