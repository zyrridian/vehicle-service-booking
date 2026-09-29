import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/booking_bloc.dart';
import 'booking_success_page.dart';

class BookingScheduleSummaryPage extends StatefulWidget {
  const BookingScheduleSummaryPage({super.key});

  @override
  State<BookingScheduleSummaryPage> createState() => _BookingScheduleSummaryPageState();
}

class _BookingScheduleSummaryPageState extends State<BookingScheduleSummaryPage> {
  int _selectedBranch = 0;

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(FetchWorkshopsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(7, (i) => today.add(Duration(days: i)));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocConsumer<BookingBloc, BookingState>(
                listener: (context, state) {
                  if (state.confirmedBookingId != null && state.selectedDate != null && state.selectedTimeSlot != null) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => BookingSuccessPage(
                          bookingId: state.confirmedBookingId!,
                          vehicleCount: state.selectedVehicleIds.length,
                          date: state.selectedDate!,
                          time: state.selectedTimeSlot!,
                          totalPrice: state.totalPrice,
                        ),
                      ),
                      (route) => false,
                    );
                  }
                  if (state.errorMessage != null && !state.isSubmitting) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
                  }
                },
                builder: (context, state) {
                  final total = state.totalPrice;
                  
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    children: [
                      const Text('Select Branch', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 44,
                        child: state.workshops == null
                          ? const Center(child: CircularProgressIndicator(color: AppColors.brand))
                          : state.workshops!.isEmpty
                            ? const Center(child: Text('No workshops available', style: TextStyle(color: Colors.grey, fontSize: 13)))
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.workshops!.length,
                                itemBuilder: (context, index) {
                                  final w = state.workshops![index];
                                  final isSelected = state.selectedWorkshopId == w.id;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: _buildBranchBtn(
                                      label: w.name, 
                                      isSelected: isSelected, 
                                      onTap: () {
                                        context.read<BookingBloc>().add(SelectWorkshopEvent(w.id));
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 20),
                      
                      const Text('Select Date', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 64,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: dates.map((d) {
                            final isSelected = state.selectedDate?.day == d.day && state.selectedDate?.month == d.month;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: _buildDateBtn(
                                context,
                                date: d,
                                isSelected: isSelected,
                                onTap: () => context.read<BookingBloc>().add(SelectDateEvent(d)),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      const Text('Select Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                      const SizedBox(height: 10),
                      if (state.selectedDate == null)
                        const Text('Select a date to view available schedules', style: TextStyle(color: Colors.grey))
                      else if (state.availableTimeSlots == null || state.availableTimeSlots!.isEmpty)
                        const Center(child: CircularProgressIndicator(color: AppColors.brand))
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: state.availableTimeSlots!.map((slot) {
                            final isSelected = state.selectedTimeSlot == slot.time;
                            return _buildTimeBtn(
                              time: slot.time,
                              isSelected: isSelected,
                              isAvailable: slot.isAvailable,
                              onTap: slot.isAvailable ? () => context.read<BookingBloc>().add(SelectTimeSlotEvent(slot.time)) : null,
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 24),
                      
                      const Text('Invoice Summary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            ...state.selectedVehicleIds.map((vId) {
                              final vehicle = state.myVehicles?.firstWhere((v) => v.id == vId);
                              final sIds = state.selectedServiceIds[vId] ?? {};
                              final services = state.availableServices[vId] ?? [];
                              final selectedServices = services.where((s) => sIds.contains(s.id)).toList();
                              
                              if (vehicle == null || selectedServices.isEmpty) return const SizedBox.shrink();
                              
                              final desc = selectedServices.map((s) => s.name).join(' · ');
                              final price = selectedServices.fold(0.0, (sum, s) => sum + s.price);
                              
                              return Column(
                                children: [
                                  _buildInvoiceItem(vehicle.name, desc, NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(price)),
                                  Divider(height: 1, color: AppColors.ink.withOpacity(0.1)),
                                ],
                              );
                            }),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Payment', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.ink)),
                                  Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(total), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.brand)),
                                ],
                              ),
                            ),
                          ],
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
          final isReady = state.selectedDate != null && state.selectedTimeSlot != null && state.selectedWorkshopId != null;
          
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                onPressed: isReady && !state.isSubmitting
                    ? () {
                        context.read<BookingBloc>().add(SubmitBookingEvent('Notes...'));
                      }
                    : null,
                child: state.isSubmitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white)) : const Text('Confirm Booking', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
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
              const Text('Schedule & Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
              const Spacer(),
              Text('3/3', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink.withOpacity(0.4))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(3)))),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(3)))),
              const SizedBox(width: 6),
              Expanded(child: Container(height: 6, decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(3)))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBranchBtn({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.brand : Colors.transparent, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.ink : AppColors.ink.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildDateBtn(BuildContext context, {required DateTime date, required bool isSelected, required VoidCallback onTap}) {
    final dayStr = DateFormat('E').format(date);
    final dateStr = DateFormat('dd').format(date);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.brand : Colors.transparent, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(dayStr, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.ink.withOpacity(0.4))),
            Text(dateStr, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.ink)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBtn({required String time, required bool isSelected, required bool isAvailable, required VoidCallback? onTap}) {
    Color bgColor = AppColors.surface;
    Color borderColor = Colors.transparent;
    Color textColor = AppColors.ink.withOpacity(0.6);

    if (isSelected) {
      bgColor = AppColors.brand.withOpacity(0.1);
      borderColor = AppColors.brand;
      textColor = AppColors.ink;
    } else if (!isAvailable) {
      bgColor = Colors.grey[100]!;
      borderColor = Colors.transparent;
      textColor = AppColors.ink.withOpacity(0.3);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          time,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceItem(String title, String desc, String price) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(fontSize: 11.5, color: AppColors.ink.withOpacity(0.5))),
              ],
            ),
          ),
          Text(price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
        ],
      ),
    );
  }
}
