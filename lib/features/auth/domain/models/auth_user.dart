class AuthUser {
  const AuthUser({
    required this.id,
    required this.displayName,
    required this.isGuest,
    this.email,
    this.photoUrl,
  });

  final String id;
  final String displayName;
  final bool isGuest;
  final String? email;
  final String? photoUrl;
}