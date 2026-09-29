class ProfileEntity {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? profilePictureUrl;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.profilePictureUrl,
  });
}
