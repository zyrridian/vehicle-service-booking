import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vehicle_service_booking/domain/usecases/workshop_usecases.dart';
import '../../../domain/entities/booking_entities.dart';
import '../../../domain/entities/workshop_entity.dart';
import '../../../domain/usecases/booking_usecases.dart';

abstract class BookingEvent {}

class FetchVehiclesEvent extends BookingEvent {}

class FetchWorkshopsEvent extends BookingEvent {}

class ToggleVehicleEvent extends BookingEvent {
  final String vehicleId;
  ToggleVehicleEvent(this.vehicleId);
}

class FetchAvailableServicesEvent extends BookingEvent {
  final String vehicleId;
  FetchAvailableServicesEvent(this.vehicleId);
}

class ToggleServiceEvent extends BookingEvent {
  final String vehicleId;
  final String serviceId;
  ToggleServiceEvent(this.vehicleId, this.serviceId);
}

class SelectDateEvent extends BookingEvent {
  final DateTime date;
  SelectDateEvent(this.date);
}

class SelectTimeSlotEvent extends BookingEvent {
  final String time;
  SelectTimeSlotEvent(this.time);
}

class SelectWorkshopEvent extends BookingEvent {
  final String workshopId;
  SelectWorkshopEvent(this.workshopId);
}

class UpdateVehicleNotesEvent extends BookingEvent {
  final String vehicleId;
  final String notes;
  UpdateVehicleNotesEvent(this.vehicleId, this.notes);
}

class AddTemporaryVehicleEvent extends BookingEvent {
  final String name;
  final String plate;
  AddTemporaryVehicleEvent(this.name, this.plate);
}

class SubmitBookingEvent extends BookingEvent {
  final String notes;
  SubmitBookingEvent(this.notes);
}

class BookingState {
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;
  final List<VehicleEntity>? myVehicles;
  final List<WorkshopEntity>? workshops;
  final Set<String> selectedVehicleIds;
  final Map<String, List<ServiceOptionEntity>> availableServices;
  final Map<String, Set<String>> selectedServiceIds;
  final Map<String, String> vehicleNotes;
  final DateTime? selectedDate;
  final List<TimeSlotEntity>? availableTimeSlots;
  final String? selectedTimeSlot;
  final String? selectedWorkshopId;
  final String? confirmedBookingId;

  BookingState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.myVehicles,
    this.workshops,
    this.selectedVehicleIds = const {},
    this.availableServices = const {},
    this.selectedServiceIds = const {},
    this.vehicleNotes = const {},
    this.selectedDate,
    this.availableTimeSlots,
    this.selectedTimeSlot,
    this.selectedWorkshopId,
    this.confirmedBookingId,
  });

  BookingState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    List<VehicleEntity>? myVehicles,
    List<WorkshopEntity>? workshops,
    Set<String>? selectedVehicleIds,
    Map<String, List<ServiceOptionEntity>>? availableServices,
    Map<String, Set<String>>? selectedServiceIds,
    Map<String, String>? vehicleNotes,
    DateTime? selectedDate,
    List<TimeSlotEntity>? availableTimeSlots,
    String? selectedTimeSlot,
    String? selectedWorkshopId,
    String? confirmedBookingId,
  }) {
    return BookingState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      myVehicles: myVehicles ?? this.myVehicles,
      workshops: workshops ?? this.workshops,
      selectedVehicleIds: selectedVehicleIds ?? this.selectedVehicleIds,
      availableServices: availableServices ?? this.availableServices,
      selectedServiceIds: selectedServiceIds ?? this.selectedServiceIds,
      vehicleNotes: vehicleNotes ?? this.vehicleNotes,
      selectedDate: selectedDate ?? this.selectedDate,
      availableTimeSlots: availableTimeSlots ?? this.availableTimeSlots,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
      selectedWorkshopId: selectedWorkshopId ?? this.selectedWorkshopId,
      confirmedBookingId: confirmedBookingId ?? this.confirmedBookingId,
    );
  }

  double get totalPrice {
    double total = 0;
    for (final vId in selectedVehicleIds) {
      final sIds = selectedServiceIds[vId] ?? {};
      final services = availableServices[vId] ?? [];
      for (final sId in sIds) {
        final service = services.firstWhere((s) => s.id == sId);
        total += service.price;
      }
    }
    return total;
  }
}

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetMyVehiclesUseCase getMyVehiclesUseCase;
  final GetAvailableServicesUseCase getAvailableServicesUseCase;
  final GetAvailableTimeSlotsUseCase getAvailableTimeSlotsUseCase;
  final CreateBookingUseCase createBookingUseCase;
  final AddTemporaryVehicleUseCase addTemporaryVehicleUseCase;
  final GetWorkshopsUseCase getWorkshopsUseCase;

  BookingBloc({
    required this.getMyVehiclesUseCase,
    required this.getAvailableServicesUseCase,
    required this.getAvailableTimeSlotsUseCase,
    required this.createBookingUseCase,
    required this.addTemporaryVehicleUseCase,
    required this.getWorkshopsUseCase,
  }) : super(BookingState()) {
    on<FetchVehiclesEvent>(_onFetchVehicles);
    on<FetchWorkshopsEvent>(_onFetchWorkshops);
    on<ToggleVehicleEvent>(_onToggleVehicle);
    on<FetchAvailableServicesEvent>(_onFetchAvailableServices);
    on<ToggleServiceEvent>(_onToggleService);
    on<SelectDateEvent>(_onSelectDate);
    on<SelectTimeSlotEvent>(_onSelectTimeSlot);
    on<SelectWorkshopEvent>(_onSelectWorkshop);
    on<UpdateVehicleNotesEvent>(_onUpdateVehicleNotes);
    on<AddTemporaryVehicleEvent>(_onAddTemporaryVehicle);
    on<SubmitBookingEvent>(_onSubmitBooking);
  }

  Future<void> _onFetchVehicles(
      FetchVehiclesEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final vehicles = await getMyVehiclesUseCase.execute();
      emit(state.copyWith(isLoading: false, myVehicles: vehicles));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchWorkshops(
      FetchWorkshopsEvent event, Emitter<BookingState> emit) async {
    try {
      final workshops = await getWorkshopsUseCase();
      emit(state.copyWith(
          workshops: workshops,
          selectedWorkshopId: state.selectedWorkshopId ??
              (workshops.isNotEmpty ? workshops.first.id : null)));
    } catch (e) {}
  }

  Future<void> _onToggleVehicle(
      ToggleVehicleEvent event, Emitter<BookingState> emit) async {
    final newSelected = Set<String>.from(state.selectedVehicleIds);
    if (newSelected.contains(event.vehicleId)) {
      newSelected.remove(event.vehicleId);
    } else {
      newSelected.add(event.vehicleId);
      if (!state.availableServices.containsKey(event.vehicleId)) {
        add(FetchAvailableServicesEvent(event.vehicleId));
      }
    }
    emit(state.copyWith(selectedVehicleIds: newSelected));
  }

  Future<void> _onFetchAvailableServices(
      FetchAvailableServicesEvent event, Emitter<BookingState> emit) async {
    try {
      final services =
          await getAvailableServicesUseCase.execute(event.vehicleId);
      final newAvailable =
          Map<String, List<ServiceOptionEntity>>.from(state.availableServices);
      newAvailable[event.vehicleId] = services;
      emit(state.copyWith(availableServices: newAvailable));
    } catch (e) {
    }
  }

  Future<void> _onToggleService(
      ToggleServiceEvent event, Emitter<BookingState> emit) async {
    final newSelected = Map<String, Set<String>>.from(state.selectedServiceIds);
    final vehicleServices =
        Set<String>.from(newSelected[event.vehicleId] ?? {});
    if (vehicleServices.contains(event.serviceId)) {
      vehicleServices.remove(event.serviceId);
    } else {
      vehicleServices.add(event.serviceId);
    }
    newSelected[event.vehicleId] = vehicleServices;
    emit(state.copyWith(selectedServiceIds: newSelected));
  }

  Future<void> _onUpdateVehicleNotes(
      UpdateVehicleNotesEvent event, Emitter<BookingState> emit) async {
    final newNotes = Map<String, String>.from(state.vehicleNotes);
    if (event.notes.isEmpty) {
      newNotes.remove(event.vehicleId);
    } else {
      newNotes[event.vehicleId] = event.notes;
    }
    emit(state.copyWith(vehicleNotes: newNotes));
  }

  Future<void> _onAddTemporaryVehicle(
      AddTemporaryVehicleEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final newVehicle =
          await addTemporaryVehicleUseCase.execute(event.name, event.plate);
      final updatedVehicles = List<VehicleEntity>.from(state.myVehicles ?? [])
        ..add(newVehicle);
      emit(state.copyWith(isLoading: false, myVehicles: updatedVehicles));
      add(ToggleVehicleEvent(newVehicle.id));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSelectDate(
      SelectDateEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(
        selectedDate: event.date,
        availableTimeSlots: [],
        selectedTimeSlot: null));
    try {
      final slots = await getAvailableTimeSlotsUseCase.execute(event.date);
      emit(state.copyWith(availableTimeSlots: slots));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onSelectTimeSlot(
      SelectTimeSlotEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(selectedTimeSlot: event.time));
  }

  Future<void> _onSelectWorkshop(
      SelectWorkshopEvent event, Emitter<BookingState> emit) async {
    emit(state.copyWith(selectedWorkshopId: event.workshopId));
  }

  Future<void> _onSubmitBooking(
      SubmitBookingEvent event, Emitter<BookingState> emit) async {
    if (state.selectedDate == null ||
        state.selectedTimeSlot == null ||
        state.selectedWorkshopId == null) return;

    emit(state.copyWith(isSubmitting: true));
    try {
      final request = BookingRequestEntity(
        vehicleIds: state.selectedVehicleIds.toList(),
        selectedServices: {
          for (var vId in state.selectedVehicleIds)
            vId: state.selectedServiceIds[vId]?.toList() ?? []
        },
        date: state.selectedDate!,
        timeSlot: state.selectedTimeSlot!,
        notes: event.notes,
        workshopId: state.selectedWorkshopId!,
      );

      final bookingId = await createBookingUseCase.execute(request);
      emit(state.copyWith(isSubmitting: false, confirmedBookingId: bookingId));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }
}
