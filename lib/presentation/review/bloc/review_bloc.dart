import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/review_entity.dart';
import '../../../domain/usecases/review_usecases.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class SubmitReviewEvent extends ReviewEvent {
  final String bookingId;
  final String workshopId;
  final int rating;
  final String comment;

  const SubmitReviewEvent({
    required this.bookingId,
    required this.workshopId,
    required this.rating,
    required this.comment,
  });

  @override
  List<Object?> get props => [bookingId, workshopId, rating, comment];
}

class LoadReviewsEvent extends ReviewEvent {
  final String workshopId;

  const LoadReviewsEvent({required this.workshopId});

  @override
  List<Object?> get props => [workshopId];
}

class ReviewState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final List<ReviewEntity> reviews;
  final bool submitSuccess;
  final String? errorMessage;

  const ReviewState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.reviews = const [],
    this.submitSuccess = false,
    this.errorMessage,
  });

  ReviewState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<ReviewEntity>? reviews,
    bool? submitSuccess,
    String? errorMessage,
  }) {
    return ReviewState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      reviews: reviews ?? this.reviews,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isSubmitting, reviews, submitSuccess, errorMessage];
}

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final SubmitReviewUseCase submitReviewUseCase;
  final GetReviewsUseCase getReviewsUseCase;

  ReviewBloc({
    required this.submitReviewUseCase,
    required this.getReviewsUseCase,
  }) : super(const ReviewState()) {
    on<SubmitReviewEvent>(_onSubmitReview);
    on<LoadReviewsEvent>(_onLoadReviews);
  }

  Future<void> _onSubmitReview(
    SubmitReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(
        isSubmitting: true, submitSuccess: false, errorMessage: null));
    try {
      await submitReviewUseCase(
        bookingId: event.bookingId,
        workshopId: event.workshopId,
        workshopName: 'Mock Workshop',
        vehicleName: 'Mock Vehicle',
        mechanicName: 'Mock Mechanic',
        rating: event.rating.toDouble(),
        comment: event.comment,
      );
      emit(state.copyWith(isSubmitting: false, submitSuccess: true));
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Gagal mengirim ulasan: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadReviews(
    LoadReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final reviews = await getReviewsUseCase(event.workshopId);
      emit(state.copyWith(isLoading: false, reviews: reviews));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat ulasan: ${e.toString()}',
      ));
    }
  }
}
