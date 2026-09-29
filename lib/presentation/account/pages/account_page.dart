import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../../auth/pages/login_page.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../notifications/pages/notifications_page.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';
import 'edit_profile_page.dart';
import 'saved_addresses_page.dart';
import 'language_page.dart';
import 'help_center_page.dart';
import 'terms_privacy_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideAccountBloc()
        ..add(FetchProfileRequested())
        ..add(LoadSettingsRequested()),
      child: const _AccountView(),
    );
  }
}

class _AccountView extends StatelessWidget {
  const _AccountView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  _buildProfileSection(context),
                  const SizedBox(height: 32),
                  _buildSectionTitle('ACCOUNT'),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: LucideIcons.mapPin,
                    title: 'Saved Addresses',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const SavedAddressesPage())),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: LucideIcons.bell,
                    title: 'Notifications',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const NotificationsPage())),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: LucideIcons.globe,
                    title: 'Language',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const LanguagePage())),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('SUPPORT & ABOUT'),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: LucideIcons.headphones,
                    title: 'Help Center',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const HelpCenterPage())),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuOption(
                    icon: LucideIcons.shield,
                    title: 'Terms & Privacy Policy',
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const TermsPrivacyPage())),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<AccountBloc, AccountState>(
                    builder: (context, state) {
                      return _buildMenuOption(
                        icon: LucideIcons.info,
                        title: 'App Version',
                        trailing: Text(state.settings?.appVersion ?? 'Loading...',
                            style: TextStyle(
                                color: AppColors.ink.withValues(alpha: 0.4),
                                fontSize: 13)),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  _buildLogoutButton(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Profile',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink),
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(color: AppColors.brand),
            ),
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return const Center(child: Text('Failed to load profile.'));
        }

        return Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.brand,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.phone,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.ink.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<AccountBloc>(),
                      child: const EditProfilePage(),
                    ),
                  ),
                );
              },
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brand,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.ink.withValues(alpha: 0.7),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.ink.withValues(alpha: 0.6), size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 15, color: AppColors.ink),
              ),
            ),
            trailing ??
                Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.ink.withValues(alpha: 0.4),
                  size: 18,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                title: const Text('Logout',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.ink)),
                content: Text('Are you sure you want to log out?',
                    style:
                        TextStyle(color: AppColors.ink.withValues(alpha: 0.7))),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: AppColors.ink, fontWeight: FontWeight.w600)),
                  ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text('Logout',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              );
            },
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
        ),
        child: const Text('Logout',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

