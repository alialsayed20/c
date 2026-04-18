import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/fake_auth_repository.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>((Ref ref) {
  return FakeAuthRepository();
});

final FutureProvider<AuthSession> authSessionProvider =
    FutureProvider<AuthSession>((Ref ref) {
  final AuthRepository repository = ref.watch(authRepositoryProvider);
  return repository.getCurrentSession();
});