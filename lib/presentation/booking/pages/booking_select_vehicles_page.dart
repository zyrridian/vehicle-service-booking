import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'booking_service_config_page.dart';

class BookingSelectVehiclesPage extends StatefulWidget {
  const BookingSelectVehiclesPage({super.key});

  @override
  State<BookingSelectVehiclesPage> createState() => _BookingSelectVehiclesPageState();
}

class _BookingSelectVehiclesPageState extends State<BookingSelectVehiclesPage> {
  bool _varioSelected = true;
  bool _beatSelected = true;
  bool _pcxSelected = false;

  @override
  Widget build(BuildContext context) {
    int selectedCount = (_varioSelected ? 1 : 0) + (_beatSelected ? 1 : 0) + (_pcxSelected ? 1 : 0);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                children: [
                  _buildSelectableVehicle(
                    name: 'Honda Vario 150',
                    desc: 'B 4567 ABC · Servis terakhir 2 bulan lalu',
                    isSelected: _varioSelected,
                    onTap: () => setState(() => _varioSelected = !_varioSelected),
                  ),
                  const SizedBox(height: 10),
                  _buildSelectableVehicle(
                    name: 'Honda Beat Street',
                    desc: 'B 2210 XYZ · Servis terakhir 5 bulan lalu',
                    isSelected: _beatSelected,
                    onTap: () => setState(() => _beatSelected = !_beatSelected),
                  ),
                  const SizedBox(height: 10),
                  _buildSelectableVehicle(
                    name: 'Honda PCX 160',
                    desc: 'B 8890 DEF · Servis terakhir 1 minggu lalu',
                    isSelected: _pcxSelected,
                    onTap: () => setState(() => _pcxSelected = !_pcxSelected),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.line, width: 2, style: BorderStyle.solid), // Dashboard dash not natively supported easily without custom painter, using solid for now
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.plus, color: AppColors.ink.withOpacity(0.5), size: 15),
                        const SizedBox(width: 8),
                        Text('Tambah Motor Sementara', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink.withOpacity(0.5))),
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
                    const TextSpan(text: ' motor dipilih'),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedCount > 0
                    ? () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BookingServiceConfigPage()));
                      }
                    : null,
                child: const Text('Lanjut: Atur Servis'),
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
              const Text('Pilih Motor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brand50 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.brand : AppColors.line, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.wrench, color: AppColors.brand, size: 20),
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
                color: isSelected ? AppColors.brand : Colors.transparent,
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
}
