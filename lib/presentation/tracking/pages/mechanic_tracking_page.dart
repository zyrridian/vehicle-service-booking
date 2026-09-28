import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../bloc/tracking_bloc.dart';
import 'mechanic_chat_page.dart';
import 'mechanic_call_page.dart';

class MechanicTrackingPage extends StatelessWidget {
  final String bookingId;

  const MechanicTrackingPage({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Injection.provideTrackingBloc()
        ..add(LoadTrackingEvent(bookingId: bookingId)),
      child: _MechanicTrackingView(bookingId: bookingId),
    );
  }
}

class _MechanicTrackingView extends StatefulWidget {
  final String bookingId;

  const _MechanicTrackingView({required this.bookingId});

  @override
  State<_MechanicTrackingView> createState() => _MechanicTrackingViewState();
}

class _MechanicTrackingViewState extends State<_MechanicTrackingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const int _activeStep = 2;

  static const List<String> _steps = [
    'Booking Confirmed',
    'Mechanic Assigned',
    'Mechanic on the Way',
    'Service in Progress',
    'Completed',
  ];

  static const List<IconData> _stepIcons = [
    LucideIcons.checkCircle,
    LucideIcons.user,
    LucideIcons.navigation,
    LucideIcons.wrench,
    LucideIcons.flag,
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 0.7, end: 1.0).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.brand),
            );
          }
          if (state.errorMessage != null) {
            return _buildError(state.errorMessage!);
          }
          return _buildBody(state);
        },
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
        'Track Order',
        style: TextStyle(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget _buildError(String message) {
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
                  .read<TrackingBloc>()
                  .add(LoadTrackingEvent(bookingId: widget.bookingId)),
              child: const Text('Try Again',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(TrackingState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _BookingInfoCard(
            bookingId: widget.bookingId,
            vehicleName: state.tracking?.vehicleName ?? 'Honda Vario 150',
            serviceType: state.tracking?.serviceType ?? 'Oil Change & Tune Up',
          ),
          const SizedBox(height: 12),
          _MechanicInfoCard(tracking: state.tracking),
          const SizedBox(height: 12),
          _StepTimeline(
            steps: _steps,
            icons: _stepIcons,
            activeStep: _activeStep,
            pulseAnimation: _pulseAnimation,
          ),
          const SizedBox(height: 12),
          _EstimatedTimeCard(tracking: state.tracking),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _BookingInfoCard extends StatelessWidget {
  final String bookingId;
  final String vehicleName;
  final String serviceType;

  const _BookingInfoCard({
    required this.bookingId,
    required this.vehicleName,
    required this.serviceType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.car, color: AppColors.ink, size: 20),
              const SizedBox(width: 8),
              Text(
                vehicleName,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Text(
                'ID: $bookingId',
                style: const TextStyle(
                  color: AppColors.brand,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(LucideIcons.wrench, color: AppColors.ink, size: 20),
              const SizedBox(width: 8),
              Text(
                serviceType,
                style: TextStyle(
                  color: AppColors.ink.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MechanicInfoCard extends StatelessWidget {
  final dynamic tracking;

  const _MechanicInfoCard({this.tracking});

  static const String _mockName = 'Budi Santoso';
  static const double _mockRating = 4.8;
  static const String _mockPhone = '+62 812-3456-7890';

  @override
  Widget build(BuildContext context) {
    final name = tracking?.mechanicName ?? _mockName;
    final rating = tracking?.mechanicRating ?? _mockRating;
    final phone = tracking?.mechanicPhone ?? _mockPhone;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Mechanic',
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.surface,
                backgroundImage: tracking?.mechanicPhotoUrl != null
                    ? NetworkImage(tracking!.mechanicPhotoUrl as String)
                    : null,
                child: tracking?.mechanicPhotoUrl == null
                    ? const Icon(LucideIcons.user,
                        color: AppColors.brand, size: 28)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(5, (i) {
                          return Icon(
                            LucideIcons.star,
                            size: 13,
                            color: i < rating.round()
                                ? Colors.amber
                                : AppColors.line,
                          );
                        }),
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
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MechanicChatPage(mechanicName: name),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.line),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.messageSquare, color: AppColors.ink, size: 20),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => MechanicCallPage(
                      mechanicName: name, 
                      mechanicPhotoUrl: tracking?.mechanicPhotoUrl as String?
                    ),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.line),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.phone, color: AppColors.ink, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(LucideIcons.phone, size: 13,
                  color: AppColors.ink),
              const SizedBox(width: 6),
              Text(
                phone,
                style: TextStyle(
                  color: AppColors.ink.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepTimeline extends StatelessWidget {
  final List<String> steps;
  final List<IconData> icons;
  final int activeStep;
  final Animation<double> pulseAnimation;

  const _StepTimeline({
    required this.steps,
    required this.icons,
    required this.activeStep,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(steps.length, (index) {
            final isDone = index < activeStep;
            final isActive = index == activeStep;
            final isFuture = index > activeStep;
            final isLast = index == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    isActive
                        ? AnimatedBuilder(
                            animation: pulseAnimation,
                            builder: (_, __) => Opacity(
                              opacity: pulseAnimation.value,
                              child: _stepCircle(
                                  icons[index], AppColors.brand, true),
                            ),
                          )
                        : _stepCircle(
                            icons[index],
                            isDone ? AppColors.brand : AppColors.line,
                            false,
                          ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 36,
                        color: isDone ? AppColors.brand : AppColors.line,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 8),
                    child: Text(
                      steps[index],
                      style: TextStyle(
                        color: isFuture
                            ? AppColors.ink.withValues(alpha: 0.35)
                            : AppColors.ink,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                if (isDone)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(LucideIcons.check,
                        size: 14, color: AppColors.brand),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _stepCircle(IconData icon, Color color, bool isActive) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isActive ? color : color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(icon,
          size: 16, color: isActive ? Colors.white : color),
    );
  }
}

class _EstimatedTimeCard extends StatelessWidget {
  final dynamic tracking;

  const _EstimatedTimeCard({this.tracking});

  @override
  Widget build(BuildContext context) {
    final eta = tracking?.estimatedMinutes != null ? '~${tracking!.estimatedMinutes} mins' : '~15 mins';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brand,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.clock, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estimated Time',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  eta,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.navigation,
              color: Colors.white70, size: 20),
        ],
      ),
    );
  }
}
