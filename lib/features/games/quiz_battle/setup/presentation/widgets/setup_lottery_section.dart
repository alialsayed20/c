import 'package:flutter/material.dart';

import '../../domain/models/setup_state.dart';
import '../../domain/models/team.dart';

class SetupLotterySection extends StatelessWidget {
  const SetupLotterySection({
    super.key,
    required this.setup,
    required this.onRunLottery,
    required this.onResetLottery,
  });

  final SetupState setup;
  final VoidCallback onRunLottery;
  final VoidCallback onResetLottery;

  @override
  Widget build(BuildContext context) {
    final List<Team> orderedTeams = _resolveOrderedTeams();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Lottery',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Run a lottery to decide which team starts choosing categories.',
            ),
            const SizedBox(height: 16),
            if (orderedTeams.isEmpty)
              const Text('No eligible teams yet.')
            else
              Column(
                children: orderedTeams.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final Team team = entry.value;

                  return _LotteryTeamTile(
                    rank: index + 1,
                    team: team,
                    isStartingTeam: team.id == setup.startingTeamId,
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canRunLottery() ? onRunLottery : null,
                    child: const Text('Run Lottery'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: setup.pickOrderTeamIds.isNotEmpty
                        ? onResetLottery
                        : null,
                    child: const Text('Reset Lottery'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Team> _resolveOrderedTeams() {
    final Map<String, Team> teamsById = <String, Team>{
      for (final Team team in setup.teams) team.id: team,
    };

    if (setup.pickOrderTeamIds.isEmpty) {
      return setup.teams
          .where((Team team) => team.name.trim().isNotEmpty)
          .toList();
    }

    return setup.pickOrderTeamIds
        .map((String teamId) => teamsById[teamId])
        .whereType<Team>()
        .toList();
  }

  bool _canRunLottery() {
    final int eligibleTeams = setup.teams
        .where((Team team) => team.name.trim().isNotEmpty)
        .length;

    return eligibleTeams >= 2;
  }
}

class _LotteryTeamTile extends StatelessWidget {
  const _LotteryTeamTile({
    required this.rank,
    required this.team,
    required this.isStartingTeam,
  });

  final int rank;
  final Team team;
  final bool isStartingTeam;

  @override
  Widget build(BuildContext context) {
    final Color teamColor = Color(team.colorValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: isStartingTeam
            ? teamColor.withValues(alpha: 0.14)
            : null,
        border: Border.all(
          color: isStartingTeam ? teamColor : Colors.grey.shade300,
          width: isStartingTeam ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: teamColor,
            child: Text(
              '$rank',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              team.name.isEmpty ? team.id : team.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isStartingTeam)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: teamColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Starts',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}