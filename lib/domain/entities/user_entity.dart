class UserEntity {
  final String id;
  final String name;
  final String phone;
  final String token;
  final bool isNewUser;

  UserEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.token,
    this.isNewUser = false,
  });
}
