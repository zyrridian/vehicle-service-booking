import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_history_usecases.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryBookingsUseCase getHistoryBookingsUseCase;

  HistoryBloc({required this.getHistoryBookingsUseCase}) : super(HistoryState()) {
    on<LoadHistoryEvent>(_onLoadHistoryEvent);
  }

  Future<void> _onLoadHistoryEvent(LoadHistoryEvent event, Emitter<HistoryState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final allBookings = await getHistoryBookingsUseCase.execute();
      final active = allBookings.where((b) => b.isActive).toList();
      final completed = allBookings.where((b) => !b.isActive).toList();
      
      emit(state.copyWith(
        isLoading: false,
        activeBookings: active,
        completedBookings: completed,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
