import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/settings_entity.dart';
import '../../../domain/usecases/get_settings_usecase.dart';
import '../../../domain/usecases/update_language_usecase.dart';

abstract class SettingsEvent {}

class LoadSettingsRequested extends SettingsEvent {}

class ChangeLanguageRequested extends SettingsEvent {
  final String languageCode;
  ChangeLanguageRequested(this.languageCode);
}

class SettingsState {
  final bool isLoading;
  final SettingsEntity? settings;

  SettingsState({this.isLoading = false, this.settings});
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateLanguageUseCase updateLanguageUseCase;

  SettingsBloc({required this.getSettingsUseCase, required this.updateLanguageUseCase}) : super(SettingsState()) {
    on<LoadSettingsRequested>((event, emit) async {
      emit(SettingsState(isLoading: true, settings: state.settings));
      final settings = await getSettingsUseCase.execute();
      emit(SettingsState(isLoading: false, settings: settings));
    });

    on<ChangeLanguageRequested>((event, emit) async {
      await updateLanguageUseCase.execute(event.languageCode);
      add(LoadSettingsRequested());
    });
  }
}
