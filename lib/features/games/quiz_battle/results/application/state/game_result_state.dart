import '../../domain/models/match_score_entry.dart';
import '../../../session/domain/models/session_team_snapshot.dart';

class GameResultState {
  const GameResultState({
    required this.isFinished,
    required this.leaderboard,
    this.winner,
    this.lastScoreEntry,
  });

  final bool isFinished;
  final List<SessionTeamSnapshot> leaderboard;
  final SessionTeamSnapshot? winner;
  final MatchScoreEntry? lastScoreEntry;

  bool get hasWinner => winner != null;

  GameResultState copyWith({
    bool? isFinished,
    List<SessionTeamSnapshot>? leaderboard,
    SessionTeamSnapshot? winner,
    bool clearWinner = false,
    MatchScoreEntry? lastScoreEntry,
    bool clearLastScoreEntry = false,
  }) {
    return GameResultState(
      isFinished: isFinished ?? this.isFinished,
      leaderboard: leaderboard ?? this.leaderboard,
      winner: clearWinner ? null : (winner ?? this.winner),
      lastScoreEntry: clearLastScoreEntry
          ? null
          : (lastScoreEntry ?? this.lastScoreEntry),
    );
  }

  static const GameResultState idle = GameResultState(
    isFinished: false,
    leaderboard: <SessionTeamSnapshot>[],
  );
}