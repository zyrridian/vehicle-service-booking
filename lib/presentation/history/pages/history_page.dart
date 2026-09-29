import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../../invoice/pages/invoice_detail_page.dart';
import '../../review/pages/review_page.dart';
import '../../tracking/pages/mechanic_tracking_page.dart';
import '../bloc/history_bloc.dart';
import '../bloc/history_event.dart';
import '../bloc/history_state.dart';
import '../../../domain/entities/history_entity.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideHistoryBloc()..add(LoadHistoryEvent()),
      child: const _HistoryPageView(),
    );
  }
}

class _HistoryPageView extends StatefulWidget {
  const _HistoryPageView();

  @override
  State<_HistoryPageView> createState() => _HistoryPageViewState();
}

class _HistoryPageViewState extends State<_HistoryPageView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Booking History',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _onTabTapped(0),
                            child: _buildTab(_currentIndex == 0, 'Active'),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _onTabTapped(1),
                            child: _buildTab(_currentIndex == 1, 'Completed'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.isLoading 
                    ? const Center(child: CircularProgressIndicator(color: AppColors.brand))
                    : PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: [
                      _buildList(state.activeBookings, 'No Active Bookings', 'You don\'t have any active service bookings right now.', isActive: true),
                      _buildList(state.completedBookings, 'No Completed Bookings', 'You haven\'t completed any service bookings yet.'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(List<HistoryBookingEntity> bookings, String emptyTitle, String emptyMessage, {bool isActive = false}) {
    if (bookings.isEmpty) {
      return _buildEmptyState(context, emptyTitle, emptyMessage);
    }
    return RefreshIndicator(
      color: AppColors.brand,
      onRefresh: () async {
        context.read<HistoryBloc>().add(LoadHistoryEvent());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        itemCount: bookings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final b = bookings[index];
          final statusColor = _getStatusColor(b.status);
          return _buildHistoryCard(
            vehicleName: b.vehicleName,
            bookingId: b.bookingId,
            workshopId: b.workshopId,
            serviceType: b.serviceType,
            dateTime: b.dateTime,
            location: b.location,
            total: b.total,
            status: b.status,
            statusColor: statusColor,
            imageUrl: b.imageUrl,
            isActive: isActive,
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
      case 'completed':
        return AppColors.good;
      case 'waiting':
      case 'pending':
      case 'scheduled':
        return AppColors.warn;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.ink;
    }
  }

  Widget _buildEmptyState(BuildContext context, String title, String message) {
    return RefreshIndicator(
      color: AppColors.brand,
      onRefresh: () async {
        context.read<HistoryBloc>().add(LoadHistoryEvent());
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.calendarX,
                        size: 80, color: AppColors.ink.withValues(alpha: 0.1)),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.ink.withValues(alpha: 0.5),
                          height: 1.5),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(bool isActive, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppColors.brand.withValues(alpha: 0.1) : AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isActive ? AppColors.brand : Colors.transparent, width: 2),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          color: isActive ? AppColors.brand : AppColors.ink.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String vehicleName,
    required String bookingId,
    required String workshopId,
    required String serviceType,
    required String dateTime,
    required String location,
    required String total,
    required String status,
    required Color statusColor,
    required String imageUrl,
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey[200],
                      child: const Icon(LucideIcons.bike, color: Colors.grey, size: 24),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vehicleName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
                    const SizedBox(height: 2),
                    Text(bookingId, style: TextStyle(fontSize: 12, color: AppColors.ink.withValues(alpha: 0.5))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(LucideIcons.wrench, serviceType),
          const SizedBox(height: 6),
          _buildInfoRow(LucideIcons.clock, dateTime),
          const SizedBox(height: 6),
          _buildInfoRow(LucideIcons.mapPin, location),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.ink.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: $total', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
              if (isActive)
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MechanicTrackingPage(bookingId: bookingId))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.brand, borderRadius: BorderRadius.circular(20)),
                    child: const Text('Track Mechanic', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                )
              else
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReviewPage(bookingId: bookingId, workshopId: workshopId, workshopName: location, vehicleName: vehicleName))),
                      child: const Text('Rate', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.brand)),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => InvoiceDetailPage(bookingId: bookingId))),
                      child: const Text('Invoice', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.brand)),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.ink.withValues(alpha: 0.5)),
        const SizedBox(width: 8),
        Text(text,
            style: TextStyle(
                fontSize: 13, color: AppColors.ink.withValues(alpha: 0.6))),
      ],
    );
  }
}
