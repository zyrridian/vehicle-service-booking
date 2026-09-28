import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<SettingsEntity> getSettings() async {
    final lang = await localDataSource.getLanguage();
    return SettingsEntity(
      language: lang,
      appVersion: 'v1.0.0',
      termsText: '1. Acceptance of Terms\nBy accessing and using Servisin Aja, you accept and agree to be bound by the terms and provision of this agreement.\n\n2. Service Description\nServisin Aja provides a platform connecting vehicle owners with professional repair and maintenance services.\n\n3. User Responsibilities\nYou agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.',
      privacyText: '1. Information Collection\nWe collect information you provide directly to us, such as when you create or modify your account, request services, contact customer support, or otherwise communicate with us.\n\n2. Use of Information\nWe may use the information we collect about you to provide, maintain, and improve our Services, including, for example, to facilitate payments, send receipts, provide products and services you request, develop new features, provide customer support, and send product updates.\n\n3. Sharing of Information\nWe may share the information we collect about you with vendors, consultants, marketing partners, and other service providers who need access to such information to carry out work on our behalf.',
      faqs: [
        FaqEntity('How do I book a service?', 'You can book a service by tapping the "Book Service Now" button on the Home or Garage tab and following the intuitive step-by-step process.'),
        FaqEntity('Can I cancel my booking?', 'Yes, you can cancel your booking up to 2 hours before the scheduled time through the History tab without any penalty.'),
        FaqEntity('How do I track my service?', 'Your service progress will be tracked in real-time in the History tab under "Active" bookings.'),
      ],
    );
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    await localDataSource.setLanguage(languageCode);
  }
}
