import '../models/setup_state.dart';

class SetupCategoryPickingService {
  const SetupCategoryPickingService();

  static const int categoriesPerTeam = 3;

  SetupState pickCategory({
    required SetupState setup,
    required String teamId,
    required String categoryId,
  }) {
    if (setup.step != SetupStep.categoryPicking) {
      return setup;
    }

    if (setup.currentPickingTeamId != teamId) {
      return setup;
    }

    if (setup.selectedCategoryIds.contains(categoryId)) {
      return setup;
    }

    final List<String> currentTeamSelections =
        List<String>.from(setup.categorySelectionsByTeamId[teamId] ?? const <String>[]);

    if (currentTeamSelections.length >= categoriesPerTeam) {
      return setup;
    }

    currentTeamSelections.add(categoryId);

    final Map<String, List<String>> updatedSelections =
        Map<String, List<String>>.from(setup.categorySelectionsByTeamId);
    updatedSelections[teamId] = currentTeamSelections;

    final List<String> updatedSelectedCategoryIds =
        List<String>.from(setup.selectedCategoryIds)..add(categoryId);

    final String? nextPickingTeamId = _resolveNextPickingTeamId(
      pickOrderTeamIds: setup.pickOrderTeamIds,
      selectionsByTeamId: updatedSelections,
    );

    final bool isComplete = _isCategoryPickingComplete(
      pickOrderTeamIds: setup.pickOrderTeamIds,
      selectionsByTeamId: updatedSelections,
    );

    return setup.copyWith(
      selectedCategoryIds: updatedSelectedCategoryIds,
      categorySelectionsByTeamId: updatedSelections,
      currentPickingTeamId: isComplete ? null : nextPickingTeamId,
      clearCurrentPickingTeamId: isComplete,
      step: isComplete ? SetupStep.ready : SetupStep.categoryPicking,
    );
  }

  SetupState resetCategoryPicking(SetupState setup) {
    if (setup.pickOrderTeamIds.isEmpty) {
      return setup.copyWith(
        selectedCategoryIds: const <String>[],
        categorySelectionsByTeamId: const <String, List<String>>{},
        clearCurrentPickingTeamId: true,
      );
    }

    return setup.copyWith(
      step: SetupStep.categoryPicking,
      selectedCategoryIds: const <String>[],
      categorySelectionsByTeamId: <String, List<String>>{
        for (final String teamId in setup.pickOrderTeamIds) teamId: <String>[],
      },
      currentPickingTeamId: setup.pickOrderTeamIds.first,
    );
  }

  bool _isCategoryPickingComplete({
    required List<String> pickOrderTeamIds,
    required Map<String, List<String>> selectionsByTeamId,
  }) {
    for (final String teamId in pickOrderTeamIds) {
      final List<String> selections = selectionsByTeamId[teamId] ?? const <String>[];
      if (selections.length < categoriesPerTeam) {
        return false;
      }
    }
    return true;
  }

  String? _resolveNextPickingTeamId({
    required List<String> pickOrderTeamIds,
    required Map<String, List<String>> selectionsByTeamId,
  }) {
    for (final String teamId in pickOrderTeamIds) {
      final List<String> selections = selectionsByTeamId[teamId] ?? const <String>[];
      if (selections.length < categoriesPerTeam) {
        return teamId;
      }
    }
    return null;
  }
}