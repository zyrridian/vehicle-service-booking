import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'add_vehicle_page.dart';
import 'vehicle_detail_page.dart';

class GaragePage extends StatelessWidget {
  const GaragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  _buildVehicleTile(
                    context,
                    name: 'Honda Vario 150',
                    plate: 'B 4567 ABC',
                    status: 'Baik',
                    statusColor: AppColors.good,
                  ),
                  const SizedBox(height: 10),
                  _buildVehicleTile(
                    context,
                    name: 'Honda Beat Street',
                    plate: 'B 2210 XYZ',
                    status: 'Cek',
                    statusColor: AppColors.warn,
                  ),
                  const SizedBox(height: 10),
                  _buildVehicleTile(
                    context,
                    name: 'Honda PCX 160',
                    plate: 'B 8890 DEF',
                    status: 'Baik',
                    statusColor: AppColors.good,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Garasi Kamu', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: AppColors.ink)),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddVehiclePage()));
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.brand50,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.plus, color: AppColors.brand, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleTile(
    BuildContext context, {
    required String name,
    required String plate,
    required String status,
    required Color statusColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VehicleDetailPage()));
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line),
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
                  Text(plate, style: TextStyle(fontSize: 12, color: AppColors.ink.withOpacity(0.5))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
