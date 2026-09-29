import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/garage_vehicle_entity.dart';
import '../../booking/pages/booking_select_vehicles_page.dart';
import '../bloc/garage_bloc.dart';
import 'add_vehicle_page.dart';

class VehicleDetailPage extends StatefulWidget {
  final String vehicleId;
  const VehicleDetailPage({super.key, required this.vehicleId});

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<GarageBloc>().add(LoadVehicleDetailEvent(widget.vehicleId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GarageBloc, GarageState>(
      listener: (context, state) {
        if (state.deleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Vehicle deleted successfully')),
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state.isLoading && state.currentVehicle == null) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: CircularProgressIndicator(color: AppColors.brand)),
          );
        }

        final vehicle = state.currentVehicle;
        if (vehicle == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(),
            body: const Center(child: Text("Vehicle not found")),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildImageHeader(vehicle),
                  _buildBody(vehicle),
                ],
              ),
              _buildFloatingAppBar(context, vehicle),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(),
        );
      },
    );
  }

  Widget _buildFloatingAppBar(
      BuildContext context, GarageVehicleEntity vehicle) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon:
                      const Icon(LucideIcons.chevronLeft, color: AppColors.ink),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: BlocBuilder<GarageBloc, GarageState>(
                      builder: (context, state) {
                        return IconButton(
                          icon: state.isSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.redAccent))
                              : const Icon(LucideIcons.trash2,
                                  color: Colors.redAccent, size: 20),
                          onPressed: state.isSubmitting
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        title: const Text('Delete Vehicle',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.ink)),
                                        content: Text(
                                            'Are you sure you want to delete this vehicle from your garage?',
                                            style: TextStyle(
                                                color: AppColors.ink
                                                    .withValues(alpha: 0.7))),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(dialogContext)
                                                    .pop(),
                                            child: const Text('Cancel',
                                                style: TextStyle(
                                                    color: AppColors.ink,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                              context.read<GarageBloc>().add(
                                                  DeleteVehicleEvent(
                                                      vehicle.id));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              foregroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                            ),
                                            child: const Text('Delete',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(LucideIcons.edit2,
                          color: AppColors.ink, size: 20),
                      onPressed: () {
                        final bloc = context.read<GarageBloc>();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: bloc,
                            child: AddVehiclePage(vehicleToEdit: vehicle),
                          ),
                        ));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader(GarageVehicleEntity vehicle) {
    final images = vehicle.imageUrls.isNotEmpty 
        ? vehicle.imageUrls 
        : ['https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=300&q=80'];
        
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 280,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imgUrl = images[index];
              if (imgUrl.startsWith('http')) {
                return Image.network(imgUrl, fit: BoxFit.cover);
              } else {
                return Image.file(File(imgUrl), fit: BoxFit.cover);
              }
            },
          ),
        ),
        if (images.length > 1)
          Positioned(
            left: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${_currentImageIndex + 1} / ${images.length}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        Positioned(
          bottom: -24,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.ink, width: 2),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(vehicle.plate,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.ink)),
                const SizedBox(height: 2),
                Text(vehicle.expiry,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.ink)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(GarageVehicleEntity vehicle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(vehicle.name,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink)),
          const SizedBox(height: 4),
          Text('${vehicle.type} · ${vehicle.capacity}cc · ${vehicle.year}',
              style: TextStyle(
                  fontSize: 14, color: AppColors.ink.withValues(alpha: 0.5))),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                  child: _buildInfoCard(PhosphorIcons.gauge(),
                      '${vehicle.mileage} km', 'Mileage')),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildInfoCard(PhosphorIcons.shieldCheck(),
                      vehicle.status, 'Condition')),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildInfoCard(
                      PhosphorIcons.calendarBlank(),
                      vehicle.nextService.contains(' ')
                          ? vehicle.nextService.split(' ').take(2).join(' ')
                          : vehicle.nextService,
                      'Next Service')),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Service History',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink)),
          const SizedBox(height: 16),
          _buildTimelineItem(
              icon: PhosphorIcons.drop(),
              title: 'Oil Change & Tune Up',
              subtitle: '12 Aug 2026 · AHASS Bintang Motor Bandung',
              isLast: false),
          _buildTimelineItem(
              icon: PhosphorIcons.gear(),
              title: 'CVT Cleaning & Roller Replacement',
              subtitle: '20 May 2026 · Servisin Aja Mitra Baleendah',
              isLast: false),
          _buildTimelineItem(
              icon: PhosphorIcons.shieldCheck(),
              title: 'Front & Rear Brake Pad Replacement',
              subtitle: '15 Feb 2026 · Bengkel SiTepat Buah Batu',
              isLast: false),
          _buildTimelineItem(
              icon: PhosphorIcons.fileText(),
              title: 'Complete Periodic Service (10,000 km)',
              subtitle: '10 Nov 2025 · AHASS Daya Motor Moh. Toha',
              isLast: true),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildFeatureCard(
                      PhosphorIcons.sealCheck(), 'Official', 'Parts')),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildFeatureCard(
                      PhosphorIcons.shieldStar(), 'Warranty', '14d')),
              const SizedBox(width: 8),
              Expanded(
                  child: _buildFeatureCard(
                      PhosphorIcons.motorcycle(), 'Pickup', 'Ready')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
          color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: AppColors.ink),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                const SizedBox(height: 2),
                Text(label,
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.ink.withValues(alpha: 0.5)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.ink),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.ink.withValues(alpha: 0.5)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
      {required IconData icon,
      required String title,
      required String subtitle,
      required bool isLast}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                  color: AppColors.brand, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            if (!isLast) Container(width: 2, height: 40, color: AppColors.line),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink)),
              const SizedBox(height: 4),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.ink.withValues(alpha: 0.5),
                      height: 1.4)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const BookingSelectVehiclesPage()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brand,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 0,
          ),
          child: const Text('Book Service Now',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
