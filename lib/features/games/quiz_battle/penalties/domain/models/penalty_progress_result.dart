import '../../../session/domain/models/game_session.dart';
import 'penalty_progress_state.dart';

class PenaltyProgressResult {
  const PenaltyProgressResult({
    required this.session,
    required this.progressState,
    required this.matchEnded,
  });

  final GameSession session;
  final PenaltyProgressState progressState;
  final bool matchEnded;
}