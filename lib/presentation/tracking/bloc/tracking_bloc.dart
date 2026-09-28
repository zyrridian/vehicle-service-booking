import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/tracking_entity.dart';
import '../../../domain/usecases/tracking_usecases.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrackingEvent extends TrackingEvent {
  final String bookingId;

  const LoadTrackingEvent({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class TrackingState extends Equatable {
  final bool isLoading;
  final BookingTrackingEntity? tracking;
  final String? errorMessage;

  const TrackingState({
    this.isLoading = false,
    this.tracking,
    this.errorMessage,
  });

  TrackingState copyWith({
    bool? isLoading,
    BookingTrackingEntity? tracking,
    String? errorMessage,
  }) {
    return TrackingState(
      isLoading: isLoading ?? this.isLoading,
      tracking: tracking ?? this.tracking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, tracking, errorMessage];
}

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final GetBookingTrackingUseCase getBookingTrackingUseCase;

  TrackingBloc({required this.getBookingTrackingUseCase})
      : super(const TrackingState()) {
    on<LoadTrackingEvent>(_onLoadTracking);
  }

  Future<void> _onLoadTracking(
    LoadTrackingEvent event,
    Emitter<TrackingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final tracking = await getBookingTrackingUseCase(event.bookingId);
      emit(state.copyWith(isLoading: false, tracking: tracking));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat data pelacakan: ${e.toString()}',
      ));
    }
  }
}
