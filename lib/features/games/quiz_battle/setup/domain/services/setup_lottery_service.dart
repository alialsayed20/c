import 'dart:math';

import '../models/setup_state.dart';
import '../models/team.dart';

class SetupLotteryService {
  const SetupLotteryService();

  SetupState runLottery(
    SetupState setup, {
    Random? random,
  }) {
    final List<Team> eligibleTeams = setup.teams
        .where((Team team) => team.name.trim().isNotEmpty)
        .toList();

    if (eligibleTeams.length < 2) {
      return setup;
    }

    final Random resolvedRandom = random ?? Random();

    final List<String> shuffledTeamIds = eligibleTeams
        .map((Team team) => team.id)
        .toList()
      ..shuffle(resolvedRandom);

    final String startingTeamId = shuffledTeamIds.first;

    return setup.copyWith(
      startingTeamId: startingTeamId,
      step: SetupStep.categoryPicking,
      pickOrderTeamIds: shuffledTeamIds,
      currentPickingTeamId: startingTeamId,
      selectedCategoryIds: const <String>[],
      categorySelectionsByTeamId: <String, List<String>>{
        for (final Team team in eligibleTeams) team.id: <String>[],
      },
    );
  }

  SetupState resetLottery(SetupState setup) {
    return setup.copyWith(
      clearStartingTeamId: true,
      step: SetupStep.lottery,
      pickOrderTeamIds: const <String>[],
      clearCurrentPickingTeamId: true,
      selectedCategoryIds: const <String>[],
      categorySelectionsByTeamId: const <String, List<String>>{},
    );
  }
}