import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;

  const CustomSearchBar({
    super.key,
    this.hintText = 'Cari bengkel, layanan...',
    this.onTap,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.search,
              size: 20,
              color: AppColors.ink.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hintText,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.ink.withValues(alpha: 0.5),
                ),
              ),
            ),
            GestureDetector(
              onTap: onFilterTap,
              child: const Icon(
                LucideIcons.slidersHorizontal,
                size: 20,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
