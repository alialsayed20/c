import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/application/providers/auth_providers.dart';
import '../../../auth/domain/models/auth_session.dart';
import '../../../auth/presentation/screens/sign_in_screen.dart';
import 'home_placeholder_screen.dart';

class AppStartupScreen extends ConsumerWidget {
  const AppStartupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final AsyncValue<AuthSession> authSessionAsync =
        ref.watch(authSessionProvider);

    return authSessionAsync.when(
      data: (AuthSession session) {
        if (session.isAuthenticated) {
          return const HomePlaceholderScreen();
        }

        return const SignInScreen();
      },
      loading: () => Scaffold(
        body: Center(
          child: Text(l10n.appStartupLoading),
        ),
      ),
      error: (_, __) => Scaffold(
        body: Center(
          child: Text(l10n.appStartupError),
        ),
      ),
    );
  }
}