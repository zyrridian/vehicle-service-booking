import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../bloc/account_bloc.dart';
import '../bloc/account_event.dart';
import '../bloc/account_state.dart';
import 'add_edit_address_page.dart';

class SavedAddressesPage extends StatelessWidget {
  const SavedAddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideAccountBloc()..add(FetchAddressesRequested()),
      child: const _SavedAddressesView(),
    );
  }
}

class _SavedAddressesView extends StatelessWidget {
  const _SavedAddressesView();

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
        title: const Text('Saved Addresses', style: TextStyle(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state.isLoading && state.addresses == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.brand));
          }
          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }
          final addresses = state.addresses ?? [];
          if (addresses.isEmpty) {
            return const Center(child: Text('No addresses saved yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final addr = addresses[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: addr.isDefault ? AppColors.brand : AppColors.line, width: addr.isDefault ? 1.5 : 1.0),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(LucideIcons.mapPin, color: addr.isDefault ? AppColors.brand : AppColors.ink.withValues(alpha: 0.5), size: 24),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(addr.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.ink)),
                              if (addr.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: AppColors.brand.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                  child: const Text('Default', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.brand)),
                                ),
                              ]
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(addr.fullAddress, style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.ink.withValues(alpha: 0.7))),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.edit2, size: 18),
                      color: AppColors.ink.withValues(alpha: 0.5),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<AccountBloc>(),
                              child: AddEditAddressPage(addressToEdit: addr),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Builder(
              builder: (innerContext) {
                return ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(innerContext).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: innerContext.read<AccountBloc>(),
                          child: const AddEditAddressPage(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(LucideIcons.plus, size: 20),
                  label: const Text('Add New Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
