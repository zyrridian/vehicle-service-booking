abstract class SettingsLocalDataSource {
  Future<String> getLanguage();
  Future<void> setLanguage(String languageCode);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  String _language = 'en';

  @override
  Future<String> getLanguage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _language;
  }

  @override
  Future<void> setLanguage(String languageCode) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _language = languageCode;
  }
}
