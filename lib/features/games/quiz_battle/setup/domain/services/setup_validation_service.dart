import '../enums/setup_issue_code.dart';
import '../models/player.dart';
import '../models/setup_issue.dart';
import '../models/setup_state.dart';
import '../models/setup_validation_result.dart';
import '../models/team.dart';

class SetupValidationService {
  const SetupValidationService();

  SetupValidationResult validate(SetupState state) {
    final List<SetupIssue> issues = <SetupIssue>[];

    if (state.players.length < 2) {
      issues.add(
        const SetupIssue(code: SetupIssueCode.notEnoughPlayers),
      );
    }

    if (state.teams.length < 2) {
      issues.add(
        const SetupIssue(code: SetupIssueCode.notEnoughTeams),
      );
    }

    final Set<String> normalizedPlayerNames = <String>{};
    for (final Player player in state.players) {
      final String normalizedName = player.name.trim().toLowerCase();

      if (normalizedName.isEmpty) {
        issues.add(
          SetupIssue(
            code: SetupIssueCode.playerNameEmpty,
            referenceId: player.id,
          ),
        );
      } else if (!normalizedPlayerNames.add(normalizedName)) {
        issues.add(
          SetupIssue(
            code: SetupIssueCode.duplicatePlayerNames,
            referenceId: player.id,
          ),
        );
      }

      if (player.teamId == null || player.teamId!.trim().isEmpty) {
        issues.add(
          SetupIssue(
            code: SetupIssueCode.playerWithoutTeam,
            referenceId: player.id,
          ),
        );
      }
    }

    final Set<String> normalizedTeamNames = <String>{};
    for (final Team team in state.teams) {
      final String normalizedName = team.name.trim().toLowerCase();

      if (normalizedName.isEmpty) {
        issues.add(
          SetupIssue(
            code: SetupIssueCode.teamNameEmpty,
            referenceId: team.id,
          ),
        );
      } else if (!normalizedTeamNames.add(normalizedName)) {
        issues.add(
          SetupIssue(
            code: SetupIssueCode.duplicateTeamNames,
            referenceId: team.id,
          ),
        );
      }

      if (team.playerIds.isEmpty) {
        issues.add(
          SetupIssue(
            code: SetupIssueCode.teamWithoutPlayers,
            referenceId: team.id,
          ),
        );
      }
    }

    if (state.hasStartingTeam) {
      final bool startingTeamExists = state.teams.any(
        (Team team) => team.id == state.startingTeamId,
      );

      if (!startingTeamExists) {
        issues.add(
          SetupIssue(
            code: SetupIssueCode.invalidStartingTeam,
            referenceId: state.startingTeamId,
          ),
        );
      }
    }

    return SetupValidationResult(issues: issues);
  }
}