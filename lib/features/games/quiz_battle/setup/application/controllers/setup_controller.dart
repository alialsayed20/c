import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/player.dart';
import '../../domain/models/setup_state.dart';
import '../../domain/models/team.dart';
import '../../domain/services/setup_review_service.dart';
import '../../domain/services/setup_validation_service.dart';

/// 🔥 NEW
import '../../domain/services/setup_lottery_service.dart';
import '../../domain/services/setup_category_picking_service.dart';

import '../state/setup_editor_state.dart';

class SetupController extends Notifier<SetupEditorState> {
  late final SetupValidationService _validationService;
  late final SetupReviewService _reviewService;

  /// 🔥 NEW SERVICES
  late final SetupLotteryService _lotteryService;
  late final SetupCategoryPickingService _categoryPickingService;

  @override
  SetupEditorState build() {
    _validationService = const SetupValidationService();
    _reviewService = const SetupReviewService();

    _lotteryService = const SetupLotteryService();
    _categoryPickingService = const SetupCategoryPickingService();

    return _evaluate(SetupEditorState.initial());
  }

  SetupEditorState _evaluate(SetupEditorState current) {
    final validation = _validationService.validate(current.setup);
    final review = _reviewService.review(current.setup);

    return current.copyWith(
      validation: validation,
      review: review,
    );
  }

  // ===============================
  // EXISTING LOGIC (بدون تغيير)
  // ===============================

  void addPlayer() {
    final List<Player> updatedPlayers = <Player>[
      ...state.setup.players,
      Player(
        id: 'player_${state.setup.players.length + 1}',
        name: '',
      ),
    ];

    _updateSetup(
      state.setup.copyWith(
        players: updatedPlayers,
        clearStartingTeamId: true,
      ),
    );
  }

  void updatePlayerName({
    required String playerId,
    required String name,
  }) {
    final List<Player> updatedPlayers = state.setup.players
        .map(
          (Player player) => player.id == playerId
              ? player.copyWith(name: name)
              : player,
        )
        .toList();

    _updateSetup(state.setup.copyWith(players: updatedPlayers));
  }

  void removePlayer(String playerId) {
    final List<Player> updatedPlayers = state.setup.players
        .where((Player player) => player.id != playerId)
        .toList();

    final List<Team> updatedTeams = state.setup.teams
        .map(
          (Team team) => team.copyWith(
            playerIds: team.playerIds
                .where((String id) => id != playerId)
                .toList(),
          ),
        )
        .toList();

    _updateSetup(
      state.setup.copyWith(
        players: updatedPlayers,
        teams: updatedTeams,
        clearStartingTeamId: true,
      ),
    );
  }

  void addTeam() {
    final List<Team> updatedTeams = <Team>[
      ...state.setup.teams,
      Team(
        id: 'team_${state.setup.teams.length + 1}',
        name: '',
        colorValue: 0xFF2196F3,
        playerIds: const <String>[],
      ),
    ];

    _updateSetup(
      state.setup.copyWith(
        teams: updatedTeams,
        clearStartingTeamId: true,
      ),
    );
  }

  void updateTeamName({
    required String teamId,
    required String name,
  }) {
    final List<Team> updatedTeams = state.setup.teams
        .map(
          (Team team) => team.id == teamId
              ? team.copyWith(name: name)
              : team,
        )
        .toList();

    _updateSetup(state.setup.copyWith(teams: updatedTeams));
  }

  void updateTeamColor({
    required String teamId,
    required int colorValue,
  }) {
    final List<Team> updatedTeams = state.setup.teams
        .map(
          (Team team) => team.id == teamId
              ? team.copyWith(colorValue: colorValue)
              : team,
        )
        .toList();

    _updateSetup(state.setup.copyWith(teams: updatedTeams));
  }

  void removeTeam(String teamId) {
    final List<Team> updatedTeams = state.setup.teams
        .where((Team team) => team.id != teamId)
        .toList();

    final List<Player> updatedPlayers = state.setup.players
        .map(
          (Player player) => player.teamId == teamId
              ? player.copyWith(teamId: null)
              : player,
        )
        .toList();

    _updateSetup(
      state.setup.copyWith(
        players: updatedPlayers,
        teams: updatedTeams,
        clearStartingTeamId: true,
      ),
    );
  }

  void assignPlayerToTeam({
    required String playerId,
    required String teamId,
  }) {
    final List<Player> updatedPlayers = state.setup.players
        .map(
          (Player player) => player.id == playerId
              ? player.copyWith(teamId: teamId)
              : player,
        )
        .toList();

    final List<Team> updatedTeams = state.setup.teams
        .map(
          (Team team) => team.copyWith(
            playerIds: team.id == teamId
                ? <String>[
                    ...team.playerIds.where((String id) => id != playerId),
                    playerId,
                  ]
                : team.playerIds.where((String id) => id != playerId).toList(),
          ),
        )
        .toList();

    _updateSetup(
      state.setup.copyWith(
        players: updatedPlayers,
        teams: updatedTeams,
        clearStartingTeamId: true,
      ),
    );
  }

  // ===============================
  // 🔥 NEW: LOTTERY
  // ===============================

  void runLottery() {
    final SetupState updated =
        _lotteryService.runLottery(state.setup);

    _updateSetup(updated);
  }

  void resetLottery() {
    final SetupState updated =
        _lotteryService.resetLottery(state.setup);

    _updateSetup(updated);
  }

  // ===============================
  // 🔥 NEW: CATEGORY PICKING
  // ===============================

  void pickCategory({
    required String teamId,
    required String categoryId,
  }) {
    final SetupState updated =
        _categoryPickingService.pickCategory(
      setup: state.setup,
      teamId: teamId,
      categoryId: categoryId,
    );

    _updateSetup(updated);
  }

  void resetCategoryPicking() {
    final SetupState updated =
        _categoryPickingService.resetCategoryPicking(state.setup);

    _updateSetup(updated);
  }

  // ===============================

  void chooseStartingTeam(String? teamId) {
    _updateSetup(
      state.setup.copyWith(
        startingTeamId: teamId,
      ),
    );
  }

  void _updateSetup(SetupState setup) {
    state = _evaluate(
      state.copyWith(
        setup: setup,
      ),
    );
  }
}