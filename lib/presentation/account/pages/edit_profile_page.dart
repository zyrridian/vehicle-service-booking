import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Edit Profile', style: TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Edit Profile Content', style: TextStyle(color: AppColors.ink.withValues(alpha: 0.5))),
      ),
    );
  }
}
