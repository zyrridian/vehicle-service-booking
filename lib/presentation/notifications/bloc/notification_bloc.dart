import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../../domain/usecases/get_notifications_usecase.dart';

abstract class NotificationEvent {}

class FetchNotificationsRequested extends NotificationEvent {}

class NotificationState {
  final bool isLoading;
  final List<NotificationEntity>? notifications;
  final String? errorMessage;

  NotificationState({
    this.isLoading = false,
    this.notifications,
    this.errorMessage,
  });
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationBloc({required this.getNotificationsUseCase}) : super(NotificationState()) {
    on<FetchNotificationsRequested>((event, emit) async {
      emit(NotificationState(isLoading: true));
      try {
        final notifications = await getNotificationsUseCase.execute();
        emit(NotificationState(isLoading: false, notifications: notifications));
      } catch (e) {
        emit(NotificationState(isLoading: false, errorMessage: e.toString()));
      }
    });
  }
}
