import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../../booking/pages/booking_select_vehicles_page.dart';
import '../bloc/workshop_bloc.dart';

class WorkshopDetailPage extends StatelessWidget {
  final String workshopId;

  const WorkshopDetailPage({super.key, required this.workshopId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideWorkshopBloc()
        ..add(LoadWorkshopDetailEvent(id: workshopId)),
      child: _WorkshopDetailView(workshopId: workshopId),
    );
  }
}

class _WorkshopDetailView extends StatelessWidget {
  final String workshopId;

  const _WorkshopDetailView({required this.workshopId});

  static final Map<String, dynamic> _mockDetail = {
    'id': 'ws001',
    'name': 'Bengkel Maju Jaya',
    'city': 'Jakarta Selatan',
    'address': 'Jl. Fatmawati No. 12, Cilandak, Jakarta Selatan 12430',
    'phone': '+62 21-7654-3210',
    'rating': 4.8,
    'reviewCount': 234,
    'hours': 'Senin – Sabtu: 08.00 – 18.00 WIB',
    'services': ['Ganti Oli', 'Tune Up', 'Rem & Kampas', 'Ban & Velg',
        'AC Mobil', 'Kelistrikan', 'Suspensi', 'Transmisi'],
    'reviews': [
      {
        'name': 'Andi Prasetyo',
        'rating': 5,
        'comment': 'Pelayanannya sangat memuaskan! Montir profesional dan tepat waktu.',
        'date': '2 hari lalu',
      },
      {
        'name': 'Siti Rahayu',
        'rating': 4,
        'comment': 'Harga wajar, bengkel bersih dan nyaman. Recommended!',
        'date': '1 minggu lalu',
      },
      {
        'name': 'Rudi Hartono',
        'rating': 5,
        'comment': 'Servis AC mobilku selesai cepat. Puas dengan hasilnya.',
        'date': '2 minggu lalu',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<WorkshopBloc, WorkshopState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brand),
            );
          }
          if (state.errorMessage != null) {
            return _buildError(context, state.errorMessage!);
          }
          if (state.selectedWorkshop == null) {
            return const Center(child: Text('Loading...'));
          }
          return _buildContent(context, state.selectedWorkshop!);
        },
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }


  Widget _buildContent(BuildContext context, dynamic workshop) {
    final reviews =
        (_mockDetail['reviews'] as List).cast<Map<String, dynamic>>();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 200,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.chevronLeft,
                  color: AppColors.ink, size: 20),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppColors.surface,
              child: workshop.imageUrl != null
                  ? Image.network(
                      workshop.imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Icon(
                        LucideIcons.warehouse,
                        size: 72,
                        color: AppColors.ink.withValues(alpha: 0.12),
                      ),
                    ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeaderSection(workshop),
              const SizedBox(height: 16),

              _buildInfoSection(workshop),
              const SizedBox(height: 16),

              _buildServicesSection(workshop),
              const SizedBox(height: 16),

              _buildReviewsSection(reviews),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(dynamic workshop) {
    final rating = workshop.rating as double;
    final reviewCount = workshop.reviewCount as int;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            workshop.name,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(LucideIcons.mapPin, size: 13, color: AppColors.brand),
              const SizedBox(width: 4),
              Text(
                workshop.city,
                style: TextStyle(
                  color: AppColors.ink.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ...List.generate(
                5,
                (i) => Icon(
                  LucideIcons.star,
                  size: 16,
                  color: i < rating.round() ? Colors.amber : AppColors.line,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '($reviewCount reviews)',
                style: TextStyle(
                  color: AppColors.ink.withValues(alpha: 0.4),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(dynamic workshop) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Workshop Information',
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          _infoRow(LucideIcons.phone, workshop.phone),
          const SizedBox(height: 10),
          _infoRow(LucideIcons.mapPin, workshop.address),
          const SizedBox(height: 10),
          _infoRow(LucideIcons.clock, workshop.openHours),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.brand),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.ink, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection(dynamic workshop) {
    final services = (workshop.services as List).cast<String>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Services',
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: services.map((s) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.brand.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.brand.withValues(alpha: 0.25)),
                ),
                child: Text(
                  s,
                  style: const TextStyle(
                    color: AppColors.brand,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(List<Map<String, dynamic>> reviews) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Reviews',
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          ...reviews.map((r) => _ReviewTile(review: r)),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brand,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            elevation: 0,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const BookingSelectVehiclesPage(),
              ),
            );
          },
          child: const Text(
            'Book at this Workshop',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.alertCircle, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brand,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                elevation: 0,
              ),
              onPressed: () => context
                  .read<WorkshopBloc>()
                  .add(LoadWorkshopDetailEvent(id: workshopId)),
              child: const Text('Try Again',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final Map<String, dynamic> review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    final rating = review['rating'] as int;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.brand.withValues(alpha: 0.15),
                  child: Text(
                    (review['name'] as String)[0],
                    style: const TextStyle(
                      color: AppColors.brand,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['name'] as String,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        review['date'] as String,
                        style: TextStyle(
                          color: AppColors.ink.withValues(alpha: 0.4),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      LucideIcons.star,
                      size: 12,
                      color: i < rating ? Colors.amber : AppColors.line,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review['comment'] as String,
              style: TextStyle(
                color: AppColors.ink.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
