import '../../domain/models/player.dart';
import '../../domain/models/setup_state.dart';
import '../../domain/models/team.dart';
import '../../../board/domain/enums/board_cell_status.dart';
import '../../../board/domain/models/board_category_column.dart';
import '../../../board/domain/models/board_cell.dart';
import '../../../board/domain/models/board_state.dart';
import '../../../categories/domain/models/category.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../../question/domain/models/question.dart';
import '../../../question/domain/repositories/question_repository.dart';
import '../../../session/domain/enums/game_session_status.dart';
import '../../../session/domain/models/game_session.dart';
import '../../../session/domain/models/session_player_snapshot.dart';
import '../../../session/domain/models/session_team_snapshot.dart';
import '../../../session/domain/models/turn_order.dart';
import '../models/start_match_result.dart';

class StartMatchService {
  const StartMatchService({
    required CategoryRepository categoryRepository,
    required QuestionRepository questionRepository,
  })  : _categoryRepository = categoryRepository,
        _questionRepository = questionRepository;

  final CategoryRepository _categoryRepository;
  final QuestionRepository _questionRepository;

  Future<StartMatchResult> start(
    SetupState setup, {
    required String languageCode,
  }) async {
    final List<Team> validTeams = setup.teams
        .where((Team team) => team.name.trim().isNotEmpty)
        .toList();

    final List<Player> validPlayers = setup.players
        .where((Player player) =>
            player.name.trim().isNotEmpty && player.teamId != null)
        .toList();

    if (validTeams.length < 2) {
      return StartMatchResult.failure(
        'At least 2 valid teams are required.',
      );
    }

    if (validPlayers.length < 2) {
      return StartMatchResult.failure(
        'At least 2 valid players are required.',
      );
    }

    if (setup.selectedCategoryIds.isEmpty) {
      return StartMatchResult.failure(
        'At least 1 selected category is required.',
      );
    }

    final Set<String> validTeamIds =
        validTeams.map((Team team) => team.id).toSet();

    final List<SessionTeamSnapshot> sessionTeams = validTeams
        .map(
          (Team team) => SessionTeamSnapshot(
            id: team.id,
            name: team.name,
            colorValue: team.colorValue,
            playerIds: team.playerIds
                .where((String playerId) {
                  return validPlayers.any(
                    (Player player) =>
                        player.id == playerId && player.teamId == team.id,
                  );
                })
                .toList(),
            score: 0,
            isEliminated: false,
          ),
        )
        .toList();

    final List<SessionPlayerSnapshot> sessionPlayers = validPlayers
        .where((Player player) => validTeamIds.contains(player.teamId))
        .map(
          (Player player) => SessionPlayerSnapshot(
            id: player.id,
            name: player.name,
            teamId: player.teamId!,
          ),
        )
        .toList();

    if (sessionPlayers.length < 2) {
      return StartMatchResult.failure(
        'No valid assigned players were found.',
      );
    }

    final List<String> orderedTeamIds = sessionTeams
        .where((SessionTeamSnapshot team) => team.playerIds.isNotEmpty)
        .map((SessionTeamSnapshot team) => team.id)
        .toList();

    if (orderedTeamIds.length < 2) {
      return StartMatchResult.failure(
        'At least 2 teams with assigned players are required.',
      );
    }

    final int startingIndex = setup.startingTeamId == null
        ? 0
        : orderedTeamIds.indexOf(setup.startingTeamId!);

    final int resolvedStartingIndex =
        startingIndex == -1 ? 0 : startingIndex;

    final TurnOrder turnOrder = TurnOrder(
      teamIds: orderedTeamIds,
      currentIndex: resolvedStartingIndex,
    );

    final GameSession session = GameSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      status: GameSessionStatus.active,
      teams: sessionTeams,
      players: sessionPlayers,
      turnOrder: turnOrder,
      createdAt: DateTime.now(),
    );

    final BoardState board = await _buildInitialBoard(
      selectedCategoryIds: setup.selectedCategoryIds,
      languageCode: languageCode,
    );

    if (board.columns.isEmpty) {
      return StartMatchResult.failure(
        'No playable board could be built from the selected categories.',
      );
    }

    return StartMatchResult.success(
      session: session,
      board: board,
    );
  }

  Future<BoardState> _buildInitialBoard({
    required List<String> selectedCategoryIds,
    required String languageCode,
  }) async {
    final List<Category> categories =
        await _categoryRepository.getCategoriesByIds(selectedCategoryIds);

    final List<BoardCategoryColumn> columns = <BoardCategoryColumn>[];

    for (final Category category in categories) {
      final List<Question> questions =
          await _questionRepository.getQuestionsByCategory(
        categoryId: category.id,
        languageCode: languageCode,
      );

      if (questions.isEmpty) {
        continue;
      }

      columns.add(
        BoardCategoryColumn(
          categoryId: category.id,
          title: category.title,
          cells: questions.map((Question question) {
            return BoardCell(
              id: '${category.id}_${question.pointValue}',
              categoryId: category.id,
              pointValue: question.pointValue,
              questionId: question.id,
              status: BoardCellStatus.available,
            );
          }).toList(),
        ),
      );
    }

    return BoardState(columns: columns);
  }
}