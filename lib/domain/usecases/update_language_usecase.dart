import '../repositories/settings_repository.dart';

class UpdateLanguageUseCase {
  final SettingsRepository repository;
  UpdateLanguageUseCase(this.repository);

  Future<void> execute(String languageCode) {
    return repository.updateLanguage(languageCode);
  }
}
