import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideAccountBloc()..add(LoadSettingsRequested()),
      child: const _LanguageView(),
    );
  }
}

class _LanguageView extends StatelessWidget {
  const _LanguageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Language', style: TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.brand));
          }
          final currentLang = state.settings?.language ?? 'en';
          
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildLanguageOption(context, 'English', 'en', currentLang),
              const SizedBox(height: 12),
              _buildLanguageOption(context, 'Bahasa Indonesia', 'id', currentLang),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String title, String value, String currentLang) {
    final isSelected = currentLang == value;
    return GestureDetector(
      onTap: () {
        context.read<AccountBloc>().add(ChangeLanguageRequested(value));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand.withValues(alpha: 0.05) : AppColors.surface,
          border: Border.all(color: isSelected ? AppColors.brand : Colors.transparent, width: 2.0),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? AppColors.brand : AppColors.ink)),
            if (isSelected) const Icon(LucideIcons.checkCircle2, color: AppColors.brand, size: 20),
          ],
        ),
      ),
    );
  }
}
