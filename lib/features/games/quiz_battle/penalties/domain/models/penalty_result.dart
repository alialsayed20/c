import '../../../session/domain/models/game_session.dart';
import 'penalty_failure.dart';
import 'penalty_record.dart';

class PenaltyResult {
  const PenaltyResult._({
    required this.session,
    required this.record,
    required this.failure,
  });

  final GameSession? session;
  final PenaltyRecord? record;
  final PenaltyFailure? failure;

  bool get isSuccess => session != null && record != null;

  factory PenaltyResult.success({
    required GameSession session,
    required PenaltyRecord record,
  }) {
    return PenaltyResult._(
      session: session,
      record: record,
      failure: null,
    );
  }

  factory PenaltyResult.failure(PenaltyFailure failure) {
    return PenaltyResult._(
      session: null,
      record: null,
      failure: failure,
    );
  }
}