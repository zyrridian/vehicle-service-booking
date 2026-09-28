import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/garage_vehicle_entity.dart';
import '../../../domain/usecases/garage_usecases.dart';

abstract class GarageEvent {}

class LoadGarageVehiclesEvent extends GarageEvent {}

class LoadVehicleDetailEvent extends GarageEvent {
  final String id;
  LoadVehicleDetailEvent(this.id);
}

class AddVehicleEvent extends GarageEvent {
  final GarageVehicleEntity vehicle;
  AddVehicleEvent(this.vehicle);
}

class EditVehicleEvent extends GarageEvent {
  final GarageVehicleEntity vehicle;
  EditVehicleEvent(this.vehicle);
}

class DeleteVehicleEvent extends GarageEvent {
  final String id;
  DeleteVehicleEvent(this.id);
}

class GarageState {
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final List<GarageVehicleEntity>? vehicles;
  final GarageVehicleEntity? currentVehicle;
  final bool addSuccess;
  final bool editSuccess;
  final bool deleteSuccess;

  GarageState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.vehicles,
    this.currentVehicle,
    this.addSuccess = false,
    this.editSuccess = false,
    this.deleteSuccess = false,
  });

  GarageState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    List<GarageVehicleEntity>? vehicles,
    GarageVehicleEntity? currentVehicle,
    bool? addSuccess,
    bool? editSuccess,
    bool? deleteSuccess,
  }) {
    return GarageState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      vehicles: vehicles ?? this.vehicles,
      currentVehicle: currentVehicle ?? this.currentVehicle,
      addSuccess: addSuccess ?? false,
      editSuccess: editSuccess ?? false,
      deleteSuccess: deleteSuccess ?? false,
    );
  }
}

class GarageBloc extends Bloc<GarageEvent, GarageState> {
  final GetGarageVehiclesUseCase getGarageVehiclesUseCase;
  final GetVehicleDetailUseCase getVehicleDetailUseCase;
  final AddVehicleUseCase addVehicleUseCase;
  final EditVehicleUseCase editVehicleUseCase;
  final DeleteVehicleUseCase deleteVehicleUseCase;

  GarageBloc({
    required this.getGarageVehiclesUseCase,
    required this.getVehicleDetailUseCase,
    required this.addVehicleUseCase,
    required this.editVehicleUseCase,
    required this.deleteVehicleUseCase,
  }) : super(GarageState()) {
    on<LoadGarageVehiclesEvent>(_onLoadGarageVehicles);
    on<LoadVehicleDetailEvent>(_onLoadVehicleDetail);
    on<AddVehicleEvent>(_onAddVehicle);
    on<EditVehicleEvent>(_onEditVehicle);
    on<DeleteVehicleEvent>(_onDeleteVehicle);
  }

  Future<void> _onLoadGarageVehicles(
      LoadGarageVehiclesEvent event, Emitter<GarageState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final vehicles = await getGarageVehiclesUseCase.execute();
      emit(state.copyWith(isLoading: false, vehicles: vehicles));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadVehicleDetail(
      LoadVehicleDetailEvent event, Emitter<GarageState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final vehicle = await getVehicleDetailUseCase.execute(event.id);
      emit(state.copyWith(isLoading: false, currentVehicle: vehicle));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddVehicle(
      AddVehicleEvent event, Emitter<GarageState> emit) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      await addVehicleUseCase.execute(event.vehicle);
      emit(state.copyWith(isSubmitting: false, addSuccess: true));
      add(LoadGarageVehiclesEvent());
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onEditVehicle(
      EditVehicleEvent event, Emitter<GarageState> emit) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      await editVehicleUseCase.execute(event.vehicle);
      emit(state.copyWith(isSubmitting: false, editSuccess: true));
      add(LoadGarageVehiclesEvent());
      add(LoadVehicleDetailEvent(event.vehicle.id));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteVehicle(
      DeleteVehicleEvent event, Emitter<GarageState> emit) async {
    emit(state.copyWith(isSubmitting: true));
    try {
      await deleteVehicleUseCase.execute(event.id);
      emit(state.copyWith(isSubmitting: false, deleteSuccess: true));
      add(LoadGarageVehiclesEvent());
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}
