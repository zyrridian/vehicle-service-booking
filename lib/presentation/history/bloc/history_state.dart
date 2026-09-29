import '../../../domain/entities/history_entity.dart';

class HistoryState {
  final bool isLoading;
  final List<HistoryBookingEntity> activeBookings;
  final List<HistoryBookingEntity> completedBookings;
  final String? errorMessage;

  HistoryState({
    this.isLoading = false,
    this.activeBookings = const [],
    this.completedBookings = const [],
    this.errorMessage,
  });

  HistoryState copyWith({
    bool? isLoading,
    List<HistoryBookingEntity>? activeBookings,
    List<HistoryBookingEntity>? completedBookings,
    String? errorMessage,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      activeBookings: activeBookings ?? this.activeBookings,
      completedBookings: completedBookings ?? this.completedBookings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
