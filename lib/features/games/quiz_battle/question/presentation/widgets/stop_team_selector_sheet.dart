import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../session/domain/models/session_team_snapshot.dart';

class StopTeamSelectorSheet extends StatelessWidget {
  const StopTeamSelectorSheet({
    super.key,
    required this.teams,
    required this.currentTeamId,
    required this.onTeamSelected,
  });

  final List<SessionTeamSnapshot> teams;
  final String? currentTeamId;
  final ValueChanged<String> onTeamSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final List<SessionTeamSnapshot> availableTeams = teams
        .where((SessionTeamSnapshot team) =>
            !team.isEliminated &&
            team.id != currentTeamId)
        .toList();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              l10n.quizHelperStopSelectTeam,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (availableTeams.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  l10n.quizHelperNoEligibleTeams,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...availableTeams.map(
                (SessionTeamSnapshot team) => _TeamTile(
                  team: team,
                  onTap: () {
                    Navigator.of(context).pop();
                    onTeamSelected(team.id);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TeamTile extends StatelessWidget {
  const _TeamTile({
    required this.team,
    required this.onTap,
  });

  final SessionTeamSnapshot team;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(team.colorValue);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
      ),
      title: Text(team.name),
      onTap: onTap,
    );
  }
}