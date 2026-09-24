import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'booking_success_page.dart';

class BookingScheduleSummaryPage extends StatefulWidget {
  const BookingScheduleSummaryPage({super.key});

  @override
  State<BookingScheduleSummaryPage> createState() => _BookingScheduleSummaryPageState();
}

class _BookingScheduleSummaryPageState extends State<BookingScheduleSummaryPage> {
  int _selectedBranch = 0;
  int _selectedDate = 1;
  int _selectedTime = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                children: [
                  const Text('Pilih Cabang', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildBranchBtn(0, 'Servisin Aja - Kemang'),
                        const SizedBox(width: 8),
                        _buildBranchBtn(1, 'BSD'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  const Text('Pilih Tanggal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 64,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildDateBtn(0, 'Rab', '23'),
                        const SizedBox(width: 8),
                        _buildDateBtn(1, 'Kam', '24'),
                        const SizedBox(width: 8),
                        _buildDateBtn(2, 'Jum', '25'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  const Text('Pilih Jam', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildTimeBtn(0, '08:00')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTimeBtn(1, '09:30')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTimeBtn(2, '11:00')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  const Text('Ringkasan Invoice', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Column(
                      children: [
                        _buildInvoiceItem('Honda Vario 150', 'Servis Berkala · Shell Advance 0.8L', 'Rp150.000'),
                        const Divider(height: 1, color: AppColors.line),
                        _buildInvoiceItem('Honda Beat Street', 'Servis Berkala · Tanpa Tambahan', 'Rp85.000'),
                        const Divider(height: 1, color: AppColors.line),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Pembayaran', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.ink)),
                              Text('Rp235.000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.brand)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookingSuccessPage()));
            },
            child: const Text('Konfirmasi Booking'),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.line)),
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
              const Text('Jadwal & Ringkasan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
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

  Widget _buildBranchBtn(int index, String label) {
    final isSelected = _selectedBranch == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedBranch = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand50 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.brand : AppColors.line, width: 2),
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

  Widget _buildDateBtn(int index, String day, String date) {
    final isSelected = _selectedDate == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedDate = index),
      child: Container(
        width: 56,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.brand : AppColors.line, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.ink.withOpacity(0.4))),
            Text(date, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.ink)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBtn(int index, String time) {
    final isSelected = _selectedTime == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTime = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand50 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.brand : AppColors.line, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          time,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.ink : AppColors.ink.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceItem(String title, String desc, String price) {
    return Container(
      padding: const EdgeInsets.all(14),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
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
