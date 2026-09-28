import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../bloc/garage_bloc.dart';
import 'add_vehicle_page.dart';
import 'vehicle_detail_page.dart';

class GaragePage extends StatelessWidget {
  const GaragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideGarageBloc()..add(LoadGarageVehiclesEvent()),
      child: const _GaragePageView(),
    );
  }
}

class _GaragePageView extends StatelessWidget {
  const _GaragePageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<GarageBloc, GarageState>(
                builder: (context, state) {
                  if (state.isLoading && state.vehicles == null) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.brand));
                  }

                  final vehicles = state.vehicles ?? [];
                  
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<GarageBloc>().add(LoadGarageVehiclesEvent());
                    },
                    color: AppColors.brand,
                    child: vehicles.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: vehicles.length + 1,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              if (index == vehicles.length) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                                  child: Center(
                                    child: Text(
                                      "No more vehicles in your garage",
                                      style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.5)),
                                    ),
                                  ),
                                );
                              }

                              final v = vehicles[index];
                              return _buildVehicleTile(
                                context,
                                id: v.id,
                                name: v.name,
                                type: v.type,
                                plate: v.plate,
                                distance: '${v.mileage} km',
                                nextService: v.nextService,
                                status: v.status,
                                statusColor: v.status == 'Good' ? AppColors.good : AppColors.warn,
                                imageUrl: v.imageUrl,
                              );
                            },
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 60),
        Icon(LucideIcons.bike, size: 80, color: AppColors.ink.withValues(alpha: 0.1)),
        const SizedBox(height: 24),
        const Text(
          'Your garage is empty',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.ink),
        ),
        const SizedBox(height: 8),
        Text(
          'Add a vehicle to easily track its\nservice history and book appointments.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.ink.withValues(alpha: 0.5), height: 1.5),
        ),
        const SizedBox(height: 32),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<GarageBloc>(),
                    child: const AddVehiclePage(),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brand,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 0,
            ),
            icon: const Icon(LucideIcons.plus, size: 18),
            label: const Text('Add Vehicle', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Your Garage', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.ink)),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<GarageBloc>(),
                    child: const AddVehiclePage(),
                  ),
                ),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.brand,
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.plus, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleTile(
    BuildContext context, {
    required String id,
    required String name,
    required String type,
    required String plate,
    required String distance,
    required String nextService,
    required String status,
    required Color statusColor,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        final bloc = context.read<GarageBloc>();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: VehicleDetailPage(vehicleId: id),
          ),
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(LucideIcons.bike, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    type,
                    style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.5)),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(LucideIcons.contact, size: 14, color: AppColors.ink.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        plate,
                        style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.7), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 12),
                      Icon(LucideIcons.gauge, size: 14, color: AppColors.ink.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.7), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Next Service: ',
                        style: TextStyle(fontSize: 13, color: AppColors.ink.withValues(alpha: 0.5)),
                      ),
                      Text(
                        nextService,
                        style: const TextStyle(fontSize: 13, color: AppColors.ink, fontWeight: FontWeight.w600),
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
}
