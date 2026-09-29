import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';

class TermsPrivacyPage extends StatelessWidget {
  const TermsPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideAccountBloc()..add(LoadSettingsRequested()),
      child: const _TermsPrivacyView(),
    );
  }
}

class _TermsPrivacyView extends StatelessWidget {
  const _TermsPrivacyView();

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
        title: const Text('Terms & Privacy', style: TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state.isLoading || state.settings == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.brand));
          }
          final settings = state.settings!;
          
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Terms of Service', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink)),
                    const SizedBox(height: 16),
                    Text(
                      settings.termsText,
                      style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.ink.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Privacy Policy', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink)),
                    const SizedBox(height: 16),
                    Text(
                      settings.privacyText,
                      style: TextStyle(fontSize: 14, height: 1.6, color: AppColors.ink.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
