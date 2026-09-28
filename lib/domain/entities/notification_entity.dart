class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final String time;
  final bool isUnread;

  NotificationEntity({required this.id, required this.title, required this.body, required this.time, required this.isUnread});
}
