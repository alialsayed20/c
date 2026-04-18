import '../models/player.dart';
import '../models/setup_review_issue.dart';
import '../models/setup_review_result.dart';
import '../models/setup_state.dart';
import '../models/team.dart';
import '../enums/setup_review_issue_code.dart';

class SetupReviewService {
  const SetupReviewService();

  SetupReviewResult review(SetupState state) {
    final List<SetupReviewIssue> issues = <SetupReviewIssue>[];

    final Map<String, Player> playersById = <String, Player>{
      for (final Player player in state.players) player.id: player,
    };

    final Map<String, Team> teamsById = <String, Team>{
      for (final Team team in state.teams) team.id: team,
    };

    final Map<String, int> playerTeamMembershipCount = <String, int>{};

    for (final Team team in state.teams) {
      final Set<String> seenPlayerIds = <String>{};

      for (final String playerId in team.playerIds) {
        if (!playersById.containsKey(playerId)) {
          issues.add(
            SetupReviewIssue(
              code: SetupReviewIssueCode.unknownPlayerReferencedByTeam,
              teamId: team.id,
              playerId: playerId,
            ),
          );
          continue;
        }

        if (!seenPlayerIds.add(playerId)) {
          issues.add(
            SetupReviewIssue(
              code: SetupReviewIssueCode.duplicatedPlayerInSameTeam,
              teamId: team.id,
              playerId: playerId,
            ),
          );
        }

        playerTeamMembershipCount[playerId] =
            (playerTeamMembershipCount[playerId] ?? 0) + 1;

        final Player player = playersById[playerId]!;
        if (player.teamId != team.id) {
          issues.add(
            SetupReviewIssue(
              code: SetupReviewIssueCode.teamReferencesMissingPlayer,
              teamId: team.id,
              playerId: playerId,
            ),
          );
        }
      }
    }

    for (final Player player in state.players) {
      final String? teamId = player.teamId;

      if (teamId == null || teamId.trim().isEmpty) {
        continue;
      }

      final Team? referencedTeam = teamsById[teamId];
      if (referencedTeam == null) {
        issues.add(
          SetupReviewIssue(
            code: SetupReviewIssueCode.playerReferencesMissingTeam,
            teamId: teamId,
            playerId: player.id,
          ),
        );
        continue;
      }

      if (!referencedTeam.playerIds.contains(player.id)) {
        issues.add(
          SetupReviewIssue(
            code: SetupReviewIssueCode.playerReferencesMissingTeam,
            teamId: referencedTeam.id,
            playerId: player.id,
          ),
        );
      }

      final int membershipCount = playerTeamMembershipCount[player.id] ?? 0;
      if (membershipCount > 1) {
        issues.add(
          SetupReviewIssue(
            code: SetupReviewIssueCode.playerAssignedToMultipleTeams,
            playerId: player.id,
          ),
        );
      }
    }

    if (state.startingTeamId != null) {
      final Team? startingTeam = teamsById[state.startingTeamId];
      if (startingTeam != null && startingTeam.playerIds.isEmpty) {
        issues.add(
          SetupReviewIssue(
            code: SetupReviewIssueCode.startingTeamMissingPlayers,
            teamId: startingTeam.id,
          ),
        );
      }
    }

    return SetupReviewResult(issues: issues);
  }
}