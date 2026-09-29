import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../bloc/workshop_bloc.dart';
import 'workshop_detail_page.dart';

class WorkshopListPage extends StatelessWidget {
  const WorkshopListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideWorkshopBloc()
        ..add(const LoadWorkshopsEvent(lat: -6.200000, lon: 106.816666)),
      child: const _WorkshopListView(),
    );
  }
}

class _WorkshopListView extends StatefulWidget {
  const _WorkshopListView();

  @override
  State<_WorkshopListView> createState() => _WorkshopListViewState();
}

class _WorkshopListViewState extends State<_WorkshopListView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: BlocBuilder<WorkshopBloc, WorkshopState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.brand),
                  );
                }
                if (state.errorMessage != null) {
                  return _buildError(context, state.errorMessage!);
                }
                
                final items = state.workshops.where((w) {
                  if (_query.isEmpty) return true;
                  final q = _query.toLowerCase();
                  return w.name.toLowerCase().contains(q) ||
                         w.city.toLowerCase().contains(q);
                }).toList();

                return _buildList(context, items);
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(LucideIcons.chevronLeft, color: AppColors.ink),
      ),
      title: const Text(
        'Nearby Workshops',
        style: TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: 'Search nearby workshops...',
          hintStyle: TextStyle(
            color: AppColors.ink.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          prefixIcon: const Icon(LucideIcons.search,
              color: AppColors.brand, size: 18),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  icon: const Icon(LucideIcons.x,
                      size: 16, color: AppColors.ink),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.brand, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<dynamic> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.searchX,
                size: 48, color: AppColors.ink.withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            Text(
              'No workshops found',
              style: TextStyle(
                color: AppColors.ink.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final w = items[index];
        return _WorkshopCard(
          workshop: w,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => WorkshopDetailPage(workshopId: w.id),
            ),
          ),
        );
      },
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.ink),
            ),
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
                  .add(const LoadWorkshopsEvent(lat: -6.200000, lon: 106.816666)),
              child: const Text('Try Again',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkshopCard extends StatelessWidget {
  final dynamic workshop; 
  final VoidCallback onTap;

  const _WorkshopCard({required this.workshop, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final rating = workshop.rating as double;
    final services = (workshop.services as List).cast<String>();
    final isOpen = workshop.isOpen as bool;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: Container(
                height: 120,
                width: double.infinity,
                color: AppColors.brand.withValues(alpha: 0.1),
                child: workshop.imageUrl != null
                    ? Image.network(
                        workshop.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                            child: Icon(LucideIcons.imageOff,
                                color: AppColors.ink)),
                      )
                    : Center(
                        child: Icon(
                          LucideIcons.warehouse,
                          size: 48,
                          color: AppColors.brand.withValues(alpha: 0.3),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          workshop.name,
                          style: const TextStyle(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isOpen
                              ? AppColors.good.withValues(alpha: 0.12)
                              : Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isOpen ? 'Open' : 'Closed',
                          style: TextStyle(
                            color: isOpen ? AppColors.good : Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin,
                          size: 12, color: AppColors.brand),
                      const SizedBox(width: 4),
                      Text(
                        workshop.city,
                        style: TextStyle(
                          color: AppColors.ink.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(LucideIcons.navigation2,
                          size: 12, color: AppColors.brand),
                      const SizedBox(width: 4),
                      Text(
                        '${workshop.distanceKm} km',
                        style: TextStyle(
                          color: AppColors.ink.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(
                        LucideIcons.star,
                        size: 13,
                        color: i < rating.round()
                            ? Colors.amber
                            : AppColors.line,
                      )),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: services.take(4).map((s) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.brand.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.brand.withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          s,
                          style: const TextStyle(
                            color: AppColors.brand,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
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
