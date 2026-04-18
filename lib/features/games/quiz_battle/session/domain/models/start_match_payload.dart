import '../../../setup/domain/models/setup_state.dart';

class StartMatchPayload {
  const StartMatchPayload({
    required this.setup,
    required this.sessionId,
    required this.createdAt,
  });

  final SetupState setup;
  final String sessionId;
  final DateTime createdAt;
}