import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/workshop_entity.dart';
import '../../../domain/usecases/workshop_usecases.dart';

abstract class WorkshopEvent extends Equatable {
  const WorkshopEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkshopsEvent extends WorkshopEvent {
  final double? lat;
  final double? lon;
  
  const LoadWorkshopsEvent({this.lat, this.lon});

  @override
  List<Object?> get props => [lat, lon];
}

class LoadWorkshopDetailEvent extends WorkshopEvent {
  final String id;

  const LoadWorkshopDetailEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class WorkshopState extends Equatable {
  final bool isLoading;
  final List<WorkshopEntity> workshops;
  final WorkshopEntity? selectedWorkshop;
  final String? errorMessage;

  const WorkshopState({
    this.isLoading = false,
    this.workshops = const [],
    this.selectedWorkshop,
    this.errorMessage,
  });

  WorkshopState copyWith({
    bool? isLoading,
    List<WorkshopEntity>? workshops,
    WorkshopEntity? selectedWorkshop,
    String? errorMessage,
  }) {
    return WorkshopState(
      isLoading: isLoading ?? this.isLoading,
      workshops: workshops ?? this.workshops,
      selectedWorkshop: selectedWorkshop ?? this.selectedWorkshop,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, workshops, selectedWorkshop, errorMessage];
}

class WorkshopBloc extends Bloc<WorkshopEvent, WorkshopState> {
  final GetWorkshopsUseCase getWorkshopsUseCase;
  final GetWorkshopDetailUseCase getWorkshopDetailUseCase;

  WorkshopBloc({
    required this.getWorkshopsUseCase,
    required this.getWorkshopDetailUseCase,
  }) : super(const WorkshopState()) {
    on<LoadWorkshopsEvent>(_onLoadWorkshops);
    on<LoadWorkshopDetailEvent>(_onLoadWorkshopDetail);
  }

  Future<void> _onLoadWorkshops(
    LoadWorkshopsEvent event,
    Emitter<WorkshopState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final workshops = await getWorkshopsUseCase(lat: event.lat, lon: event.lon);
      emit(state.copyWith(isLoading: false, workshops: workshops));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat daftar bengkel: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadWorkshopDetail(
    LoadWorkshopDetailEvent event,
    Emitter<WorkshopState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final workshop = await getWorkshopDetailUseCase(event.id);
      emit(state.copyWith(isLoading: false, selectedWorkshop: workshop));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Gagal memuat detail bengkel: ${e.toString()}',
      ));
    }
  }
}
