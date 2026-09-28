import '../../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      NotificationModel(
        id: '1',
        title: 'Booking Dikonfirmasi',
        body: 'Servis 2 motor kamu terjadwal besok jam 09:30.',
        time: '10 menit lalu',
        isUnread: true,
      ),
      NotificationModel(
        id: '2',
        title: 'Promo Servis Berkala',
        body: 'Diskon 20% ganti oli untuk booking multi-motor.',
        time: '2 jam lalu',
        isUnread: true,
      ),
    ];
  }
}
