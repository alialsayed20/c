import '../../../board/domain/models/board_category_column.dart';
import '../../../board/domain/models/board_cell.dart';
import '../../../board/domain/models/board_state.dart';
import '../../../session/domain/models/game_session.dart';
import '../../../session/domain/models/session_team_snapshot.dart';

class GameResultService {
  const GameResultService();

  bool isBoardCompleted(BoardState board) {
    for (final BoardCategoryColumn column in board.columns) {
      for (final BoardCell cell in column.cells) {
        if (cell.isAvailable) {
          return false;
        }
      }
    }

    return true;
  }

  bool shouldFinishMatch({
    required GameSession session,
    required BoardState board,
  }) {
    if (_countActiveTeams(session) <= 1) {
      return true;
    }

    return isBoardCompleted(board);
  }

  SessionTeamSnapshot? resolveWinner(GameSession session) {
    final List<SessionTeamSnapshot> activeTeams = session.teams
        .where((SessionTeamSnapshot team) => !team.isEliminated)
        .toList();

    if (activeTeams.isEmpty) {
      return null;
    }

    activeTeams.sort(
      (SessionTeamSnapshot a, SessionTeamSnapshot b) =>
          b.score.compareTo(a.score),
    );

    return activeTeams.first;
  }

  List<SessionTeamSnapshot> buildLeaderboard(GameSession session) {
    final List<SessionTeamSnapshot> sortedTeams =
        List<SessionTeamSnapshot>.from(session.teams);

    sortedTeams.sort(
      (SessionTeamSnapshot a, SessionTeamSnapshot b) {
        if (a.isEliminated != b.isEliminated) {
          return a.isEliminated ? 1 : -1;
        }

        return b.score.compareTo(a.score);
      },
    );

    return sortedTeams;
  }

  int _countActiveTeams(GameSession session) {
    return session.teams.where((SessionTeamSnapshot team) {
      return !team.isEliminated;
    }).length;
  }
}