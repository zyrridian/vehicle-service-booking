class FaqEntity {
  final String question;
  final String answer;
  FaqEntity(this.question, this.answer);
}

class SettingsEntity {
  final String language;
  final String appVersion;
  final String termsText;
  final String privacyText;
  final List<FaqEntity> faqs;

  SettingsEntity({
    required this.language,
    required this.appVersion,
    required this.termsText,
    required this.privacyText,
    required this.faqs,
  });
}
