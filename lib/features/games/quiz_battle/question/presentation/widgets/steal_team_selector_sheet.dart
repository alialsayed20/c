import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../session/domain/models/session_team_snapshot.dart';

class StealTeamSelectorSheet extends StatelessWidget {
  const StealTeamSelectorSheet({
    super.key,
    required this.teams,
    required this.excludedTeamId,
    required this.onTeamSelected,
  });

  final List<SessionTeamSnapshot> teams;
  final String excludedTeamId;
  final ValueChanged<String> onTeamSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final List<SessionTeamSnapshot> availableTeams = teams
        .where((SessionTeamSnapshot team) => team.id != excludedTeamId)
        .toList();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              l10n.quizHelperStealSelectTeam,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
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