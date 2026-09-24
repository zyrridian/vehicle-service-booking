import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'booking_schedule_summary_page.dart';

class BookingServiceConfigPage extends StatefulWidget {
  const BookingServiceConfigPage({super.key});

  @override
  State<BookingServiceConfigPage> createState() => _BookingServiceConfigPageState();
}

class _BookingServiceConfigPageState extends State<BookingServiceConfigPage> {
  int _selectedTabIndex = 0;
  
  // Dummy state for selections
  int _packageSelected = 0; // 0 = Berkala, 1 = Heavy
  int _oilSelected = 1; // 0 = Tanpa, 1 = Shell

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTabs(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                children: [
                  _buildVehicleHeader(),
                  const SizedBox(height: 16),
                  const Text('Pilih Paket Servis', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  const SizedBox(height: 10),
                  _buildPackageOption(0, 'Servis Berkala', 'Ganti oli + cek rutin 17 titik', 'Rp85.000'),
                  const SizedBox(height: 8),
                  _buildPackageOption(1, 'Heavy Service', 'Overhaul + kalibrasi + part utama', 'Rp250.000'),
                  const SizedBox(height: 16),
                  const Text('Oli & Spare Part', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.ink)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildOilOption(0, 'Tanpa Tambahan', '+Rp0')),
                      const SizedBox(width: 8),
                      Expanded(child: _buildOilOption(1, 'Shell Advance 0.8L', '+Rp65.000')),
                    ],
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total 2 motor', style: TextStyle(fontSize: 12.5, color: AppColors.ink.withOpacity(0.5))),
                  const Text('Rp235.000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookingScheduleSummaryPage()));
                },
                child: const Text('Lanjut: Jadwal'),
              ),
            ),
          ],
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
              const Text('Atur Servis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
              const Spacer(),
              Text('2/3', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink.withOpacity(0.4))),
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

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTabBtn(0, 'Honda Vario'),
          const SizedBox(width: 8),
          _buildTabBtn(1, 'Honda Beat'),
        ],
      ),
    );
  }

  Widget _buildTabBtn(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.ink : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.ink : AppColors.line, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.ink.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.wrench, color: AppColors.brand, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Honda Vario 150', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.ink)),
              Text('B 4567 ABC', style: TextStyle(fontSize: 11.5, color: AppColors.ink.withOpacity(0.5))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackageOption(int index, String title, String desc, String price) {
    final isSelected = _packageSelected == index;
    return GestureDetector(
      onTap: () => setState(() => _packageSelected = index),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand50 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.brand : AppColors.line, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? AppColors.brand : AppColors.line, width: 2),
              ),
              alignment: Alignment.center,
              child: isSelected ? Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.brand, shape: BoxShape.circle)) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Text(desc, style: TextStyle(fontSize: 12, color: AppColors.ink.withOpacity(0.5))),
                ],
              ),
            ),
            Text(price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.ink)),
          ],
        ),
      ),
    );
  }

  Widget _buildOilOption(int index, String title, String price) {
    final isSelected = _oilSelected == index;
    return GestureDetector(
      onTap: () => setState(() => _oilSelected = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppColors.brand : AppColors.line, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.ink)),
            Text(price, style: TextStyle(fontSize: 11.5, color: AppColors.ink.withOpacity(0.5))),
          ],
        ),
      ),
    );
  }
}
