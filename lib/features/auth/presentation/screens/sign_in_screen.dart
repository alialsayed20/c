import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../application/providers/auth_providers.dart';
import '../../domain/repositories/auth_repository.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.signInTitle),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final AuthRepository repository =
                ref.read(authRepositoryProvider);

            await repository.signInAsGuest();
            ref.invalidate(authSessionProvider);
          },
          child: Text(l10n.continueAsGuest),
        ),
      ),
    );
  }
}