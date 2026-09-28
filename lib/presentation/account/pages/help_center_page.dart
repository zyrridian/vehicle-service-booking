import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../../settings/bloc/settings_bloc.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideSettingsBloc()..add(LoadSettingsRequested()),
      child: const _HelpCenterView(),
    );
  }
}

class _HelpCenterView extends StatelessWidget {
  const _HelpCenterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Help Center', style: TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state.isLoading || state.settings == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.brand));
          }
          final faqs = state.settings!.faqs;
          
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('Frequently Asked Questions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
              const SizedBox(height: 16),
              ...faqs.map((faq) => _buildFaqItem(faq.question, faq.answer)),
              const SizedBox(height: 32),
              const Text('Contact Us', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
              const SizedBox(height: 16),
              _buildContactCard(LucideIcons.messageCircle, 'Chat with Support', 'Typically replies in 5 minutes'),
              const SizedBox(height: 12),
              _buildContactCard(LucideIcons.mail, 'Email Support', 'support@servisinaja.com'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(question, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(answer, style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.ink.withValues(alpha: 0.7))),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.brand, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
