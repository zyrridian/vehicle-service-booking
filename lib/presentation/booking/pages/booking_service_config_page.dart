import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/booking_bloc.dart';
import 'booking_schedule_summary_page.dart';

class BookingServiceConfigPage extends StatelessWidget {
  const BookingServiceConfigPage({super.key});

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
                  final selectedVehicles = state.myVehicles?.where((v) => state.selectedVehicleIds.contains(v.id)).toList() ?? [];

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    itemCount: selectedVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = selectedVehicles[index];
                      final availableServices = state.availableServices[vehicle.id] ?? [];
                      final selectedServiceIds = state.selectedServiceIds[vehicle.id] ?? {};

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(LucideIcons.wrench, color: AppColors.brand, size: 20),
                                const SizedBox(width: 8),
                                Text(vehicle.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
                                const SizedBox(width: 8),
                                Text(vehicle.plate, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.5))),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (availableServices.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator(color: AppColors.brand)),
                              )
                            else
                              ...availableServices.map((service) {
                                final isSelected = selectedServiceIds.contains(service.id);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _buildServiceOption(
                                    context: context,
                                    vehicleId: vehicle.id,
                                    serviceId: service.id,
                                    title: service.name,
                                    price: NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(service.price),
                                    duration: '${service.durationMinutes} mnt',
                                    isSelected: isSelected,
                                  ),
                                );
                              }),
                            const SizedBox(height: 8),
                            if (state.vehicleNotes[vehicle.id] != null && state.vehicleNotes[vehicle.id]!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Notes / Complaints', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink)),
                                          const SizedBox(height: 4),
                                          Text(state.vehicleNotes[vehicle.id]!, style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.7))),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(LucideIcons.edit2, size: 16, color: AppColors.brand),
                                      onPressed: () => _showNotesDialog(context, vehicle.id, state.vehicleNotes[vehicle.id]),
                                    ),
                                  ],
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: () => _showNotesDialog(context, vehicle.id, null),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text('+ Add Notes / Other Services', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.brand.withValues(alpha: 0.8))),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          final total = state.totalPrice;
          final isReady = state.selectedServiceIds.values.any((s) => s.isNotEmpty);

          return Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Estimated Cost', style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.6))),
                    Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(total), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isReady
                        ? () {
                            context.read<BookingBloc>().add(SelectDateEvent(DateTime.now()));
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<BookingBloc>(),
                                  child: const BookingScheduleSummaryPage(),
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
                    child: const Text('Next: Select Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
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
              const Text('Configure Service', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
              const Spacer(),
              Text('2/3', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink.withValues(alpha: 0.4))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(3)))),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(3)))),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(3)))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceOption({required BuildContext context, required String vehicleId, required String serviceId, required String title, required String price, required String duration, required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        context.read<BookingBloc>().add(ToggleServiceEvent(vehicleId, serviceId));
      },
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
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.brand : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isSelected ? AppColors.brand : AppColors.line, width: 1.5),
              ),
              child: isSelected ? const Icon(LucideIcons.check, color: Colors.white, size: 14) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(price, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.brand.withValues(alpha: 0.8))),
                      const SizedBox(width: 12),
                      Row(
                        children: [
                          Icon(LucideIcons.clock, size: 12, color: AppColors.ink.withValues(alpha: 0.4)),
                          const SizedBox(width: 4),
                          Text(duration, style: TextStyle(fontSize: 12, color: AppColors.ink.withValues(alpha: 0.5))),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotesDialog(BuildContext context, String vehicleId, String? currentNotes) {
    final controller = TextEditingController(text: currentNotes);
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
                  const Text('Add Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  IconButton(icon: const Icon(LucideIcons.x, size: 20), onPressed: () => Navigator.of(ctx).pop()),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g., Front brakes feel loose, or need a tire change too.',
                  hintStyle: TextStyle(color: AppColors.ink.withValues(alpha: 0.4)),
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
                    context.read<BookingBloc>().add(UpdateVehicleNotesEvent(vehicleId, controller.text));
                    Navigator.of(ctx).pop();
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
