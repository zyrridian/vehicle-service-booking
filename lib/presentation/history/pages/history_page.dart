import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _activeBookings = [
    {
      'vehicleName': 'Honda Vario 150',
      'bookingId': 'SA-20260925-7765',
      'serviceType': 'Routine Service & Oil Change',
      'dateTime': 'Sep 25, 2026 · 11:00 AM',
      'location': 'Servisin Aja Partner - Bandung',
      'total': 'Rp 185,000',
      'status': 'In Progress',
      'statusColor': AppColors.good,
      'imageUrl':
          'https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=300&q=80',
    },
    {
      'vehicleName': 'Yamaha NMAX 155',
      'bookingId': 'SA-20261001-8892',
      'serviceType': 'CVT Check & Cleaning',
      'dateTime': 'Oct 01, 2026 · 02:00 PM',
      'location': 'Servisin Aja Partner - Jakarta',
      'total': 'Rp 250,000',
      'status': 'Waiting',
      'statusColor': AppColors.warn,
      'imageUrl':
          'https://images.unsplash.com/photo-1558981403-c5f9899a28bc?w=300&q=80',
    }
  ];

  final List<Map<String, dynamic>> _completedBookings = [];

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
        child: Column(
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
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  _buildList(_activeBookings, 'No Active Bookings',
                      'You don\'t have any active service bookings right now.'),
                  _buildList(_completedBookings, 'No Completed Bookings',
                      'You haven\'t completed any service bookings yet.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> bookings, String emptyTitle,
      String emptyMessage) {
    if (bookings.isEmpty) {
      return _buildEmptyState(emptyTitle, emptyMessage);
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final b = bookings[index];
        return _buildHistoryCard(
          vehicleName: b['vehicleName'],
          bookingId: b['bookingId'],
          serviceType: b['serviceType'],
          dateTime: b['dateTime'],
          location: b['location'],
          total: b['total'],
          status: b['status'],
          statusColor: b['statusColor'],
          imageUrl: b['imageUrl'],
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Center(
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
    );
  }

  Widget _buildTab(bool isActive, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.brand : Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : AppColors.ink.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String vehicleName,
    required String bookingId,
    required String serviceType,
    required String dateTime,
    required String location,
    required String total,
    required String status,
    required Color statusColor,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
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
                      child: const Icon(LucideIcons.bike,
                          color: Colors.grey, size: 24),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vehicleName,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink)),
                    const SizedBox(height: 2),
                    Text(bookingId,
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.ink.withValues(alpha: 0.5))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: statusColor),
                ),
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
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: $total',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink)),
              const Text('View Details',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brand)),
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
