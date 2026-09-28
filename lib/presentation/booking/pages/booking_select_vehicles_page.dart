import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../bloc/booking_bloc.dart';
import 'booking_service_config_page.dart';

class BookingSelectVehiclesPage extends StatelessWidget {
  const BookingSelectVehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideBookingBloc()..add(FetchVehiclesEvent()),
      child: const _BookingSelectVehiclesView(),
    );
  }
}

class _BookingSelectVehiclesView extends StatelessWidget {
  const _BookingSelectVehiclesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  if (state.isLoading && state.myVehicles == null) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.brand));
                  }
                  
                  final vehicles = state.myVehicles ?? [];
                  if (vehicles.isEmpty) {
                    return const Center(child: Text('No vehicles found.'));
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    children: [
                      ...vehicles.map((v) {
                        final isSelected = state.selectedVehicleIds.contains(v.id);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildSelectableVehicle(
                            name: v.name,
                            desc: '${v.plate} · Last service ${v.lastService}',
                            isSelected: isSelected,
                            onTap: () => context.read<BookingBloc>().add(ToggleVehicleEvent(v.id)),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          _showAddTemporaryVehicleDialog(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.line, width: 2, style: BorderStyle.solid),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.plus, color: AppColors.ink.withOpacity(0.5), size: 15),
                              const SizedBox(width: 8),
                              Text('Add Temporary Vehicle', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink.withOpacity(0.5))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final selectedCount = state.selectedVehicleIds.length;
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 13, color: AppColors.ink.withOpacity(0.6), fontFamily: 'Plus Jakarta Sans'),
                      children: [
                        TextSpan(text: '$selectedCount', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.ink)),
                        const TextSpan(text: ' vehicles selected'),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedCount > 0
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<BookingBloc>(),
                                  child: const BookingServiceConfigPage(),
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 0,
                    ),
                    child: const Text('Next: Configure Service', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
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
              const Text('Select Vehicle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
              const Spacer(),
              Text('1/3', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink.withOpacity(0.4))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(3)))),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(3)))),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(3)))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableVehicle({required String name, required String desc, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? Border.all(color: AppColors.brand, width: 2) : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : AppColors.brand.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.wrench, color: AppColors.brand, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Text(desc, style: TextStyle(fontSize: 12, color: AppColors.ink.withOpacity(0.5))),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brand : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.brand : AppColors.line, width: 2),
              ),
              child: isSelected ? const Icon(LucideIcons.check, color: Colors.white, size: 14) : null,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTemporaryVehicleDialog(BuildContext context) {
    final nameController = TextEditingController();
    final plateController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Add Temporary Vehicle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  IconButton(icon: const Icon(LucideIcons.x, size: 20), onPressed: () => Navigator.of(ctx).pop()),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Vehicle Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.ink)),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Honda Supra X 125',
                  hintStyle: TextStyle(color: AppColors.ink.withOpacity(0.4)),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              const Text('License Plate', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.ink)),
              const SizedBox(height: 8),
              TextField(
                controller: plateController,
                decoration: InputDecoration(
                  hintText: 'e.g., B 1234 ABC',
                  hintStyle: TextStyle(color: AppColors.ink.withOpacity(0.4)),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (nameController.text.isNotEmpty && plateController.text.isNotEmpty) {
                      context.read<BookingBloc>().add(AddTemporaryVehicleEvent(nameController.text, plateController.text));
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
