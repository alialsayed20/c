import '../enums/auth_session_status.dart';
import 'auth_user.dart';

class AuthSession {
  const AuthSession({
    required this.status,
    this.user,
  });

  final AuthSessionStatus status;
  final AuthUser? user;

  bool get isAuthenticated => status == AuthSessionStatus.authenticated;
  bool get isUnauthenticated => status == AuthSessionStatus.unauthenticated;
  bool get isUnknown => status == AuthSessionStatus.unknown;

  static const AuthSession unknown = AuthSession(
    status: AuthSessionStatus.unknown,
  );

  static const AuthSession unauthenticated = AuthSession(
    status: AuthSessionStatus.unauthenticated,
  );

  static AuthSession authenticated(AuthUser user) {
    return AuthSession(
      status: AuthSessionStatus.authenticated,
      user: user,
    );
  }
}