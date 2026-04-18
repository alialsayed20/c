import '../enums/session_mutation_failure_code.dart';

class SessionMutationFailure {
  const SessionMutationFailure({
    required this.code,
  });

  final SessionMutationFailureCode code;
}