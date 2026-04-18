import '../models/auth_session.dart';
import '../models/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthSession> getCurrentSession();

  Future<AuthUser> signInAsGuest();

  Future<void> signOut();
}