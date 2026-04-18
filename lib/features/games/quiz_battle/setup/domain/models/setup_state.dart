import 'player.dart';
import 'team.dart';

enum SetupStep {
  setup,
  lottery,
  categoryPicking,
  ready,
}

class SetupState {
  const SetupState({
    required this.players,
    required this.teams,

    /// existing
    this.startingTeamId,

    /// NEW
    required this.step,
    required this.pickOrderTeamIds,
    required this.selectedCategoryIds,
    required this.categorySelectionsByTeamId,
    this.currentPickingTeamId,
  });

  final List<Player> players;
  final List<Team> teams;

  /// الفريق الذي يبدأ بعد القرعة
  final String? startingTeamId;

  /// المرحلة الحالية
  final SetupStep step;

  /// ترتيب اختيار الأقسام (ناتج القرعة)
  final List<String> pickOrderTeamIds;

  /// الفريق الذي يختار الآن
  final String? currentPickingTeamId;

  /// جميع الأقسام المختارة (البورد العام)
  final List<String> selectedCategoryIds;

  /// اختيارات كل فريق (3 أقسام لكل فريق)
  final Map<String, List<String>> categorySelectionsByTeamId;

  // ===== helpers =====

  bool get hasStartingTeam =>
      startingTeamId != null && startingTeamId!.isNotEmpty;

  bool get isSetupStep => step == SetupStep.setup;
  bool get isLotteryStep => step == SetupStep.lottery;
  bool get isCategoryPickingStep => step == SetupStep.categoryPicking;
  bool get isReady => step == SetupStep.ready;

  bool get isCategoryPickingComplete {
    for (final team in teams) {
      final selections = categorySelectionsByTeamId[team.id] ?? [];
      if (selections.length < 3) return false;
    }
    return true;
  }

  SetupState copyWith({
    List<Player>? players,
    List<Team>? teams,
    String? startingTeamId,
    bool clearStartingTeamId = false,

    SetupStep? step,
    List<String>? pickOrderTeamIds,
    String? currentPickingTeamId,
    bool clearCurrentPickingTeamId = false,
    List<String>? selectedCategoryIds,
    Map<String, List<String>>? categorySelectionsByTeamId,
  }) {
    return SetupState(
      players: players ?? this.players,
      teams: teams ?? this.teams,
      startingTeamId: clearStartingTeamId
          ? null
          : (startingTeamId ?? this.startingTeamId),

      step: step ?? this.step,
      pickOrderTeamIds: pickOrderTeamIds ?? this.pickOrderTeamIds,
      currentPickingTeamId: clearCurrentPickingTeamId
          ? null
          : (currentPickingTeamId ?? this.currentPickingTeamId),
      selectedCategoryIds:
          selectedCategoryIds ?? this.selectedCategoryIds,
      categorySelectionsByTeamId:
          categorySelectionsByTeamId ??
              this.categorySelectionsByTeamId,
    );
  }

  static const SetupState empty = SetupState(
    players: <Player>[],
    teams: <Team>[],
    step: SetupStep.setup,
    pickOrderTeamIds: <String>[],
    selectedCategoryIds: <String>[],
    categorySelectionsByTeamId: <String, List<String>>{},
  );
}