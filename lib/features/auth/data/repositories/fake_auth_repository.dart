import '../../domain/models/auth_session.dart';
import '../../domain/models/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  AuthUser? _currentUser;

  @override
  Future<AuthSession> getCurrentSession() async {
    if (_currentUser == null) {
      return AuthSession.unauthenticated;
    }

    return AuthSession.authenticated(_currentUser!);
  }

  @override
  Future<AuthUser> signInAsGuest() async {
    const AuthUser guestUser = AuthUser(
      id: 'guest_user',
      displayName: 'Guest',
      isGuest: true,
    );

    _currentUser = guestUser;
    return guestUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}