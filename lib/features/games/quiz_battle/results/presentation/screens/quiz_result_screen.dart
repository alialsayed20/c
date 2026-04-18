import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../application/state/game_result_state.dart';
import '../../../session/domain/models/session_team_snapshot.dart';
import '../../../shared/presentation/theme/quiz_battle_ui_tokens.dart';
import '../../../shared/presentation/widgets/quiz_battle_shell.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({
    super.key,
    required this.resultState,
    this.onClosePressed,
  });

  final GameResultState resultState;
  final VoidCallback? onClosePressed;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final SessionTeamSnapshot? winner = resultState.winner;

    return QuizBattleShell(
      title: l10n.quizResultTitle,
      subtitle: winner == null
          ? l10n.quizResultNoWinner
          : l10n.quizResultWinnerSubtitle(winner.name),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (winner != null) ...<Widget>[
            _WinnerCard(
              team: winner,
            ),
            const SizedBox(height: QuizBattleUiTokens.space16),
          ],
          Expanded(
            child: _LeaderboardCard(
              leaderboard: resultState.leaderboard,
            ),
          ),
        ],
      ),
      bottomBar: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onClosePressed,
          icon: const Icon(Icons.check_circle_outline_rounded),
          label: Text(l10n.quizResultClose),
        ),
      ),
    );
  }
}

class _WinnerCard extends StatelessWidget {
  const _WinnerCard({
    required this.team,
  });

  final SessionTeamSnapshot team;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color teamColor = Color(team.colorValue);

    return Container(
      decoration: QuizBattleUiTokens.highlightedCardDecoration(),
      padding: QuizBattleUiTokens.cardPadding,
      child: Row(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: teamColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.9),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: QuizBattleUiTokens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.quizResultWinnerLabel,
                  style: QuizBattleUiTokens.bodyMedium.copyWith(
                    color: QuizBattleUiTokens.textPrimary
                        .withValues(alpha: 0.88),
                  ),
                ),
                const SizedBox(height: QuizBattleUiTokens.space4),
                Text(
                  team.name,
                  style: QuizBattleUiTokens.titleLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: QuizBattleUiTokens.space12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                l10n.quizResultScoreLabel,
                style: QuizBattleUiTokens.bodySmall.copyWith(
                  color: QuizBattleUiTokens.textPrimary
                      .withValues(alpha: 0.84),
                ),
              ),
              const SizedBox(height: QuizBattleUiTokens.space4),
              Text(
                '${team.score}',
                style: QuizBattleUiTokens.scoreValue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  const _LeaderboardCard({
    required this.leaderboard,
  });

  final List<SessionTeamSnapshot> leaderboard;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: QuizBattleUiTokens.primaryCardDecoration(),
      padding: QuizBattleUiTokens.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            l10n.quizResultLeaderboardTitle,
            style: QuizBattleUiTokens.titleMedium,
          ),
          const SizedBox(height: QuizBattleUiTokens.space12),
          Expanded(
            child: leaderboard.isEmpty
                ? Center(
                    child: Text(
                      l10n.quizResultNoTeams,
                      style: QuizBattleUiTokens.bodyMedium,
                    ),
                  )
                : ListView.separated(
                    itemCount: leaderboard.length,
                    separatorBuilder: (_, __) => const SizedBox(
                      height: QuizBattleUiTokens.space10,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final SessionTeamSnapshot team = leaderboard[index];

                      return _LeaderboardRow(
                        rank: index + 1,
                        team: team,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({
    required this.rank,
    required this.team,
  });

  final int rank;
  final SessionTeamSnapshot team;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color teamColor = Color(team.colorValue);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: QuizBattleUiTokens.space12,
        vertical: QuizBattleUiTokens.space12,
      ),
      decoration: QuizBattleUiTokens.secondaryCardDecoration(),
      child: Row(
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: teamColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$rank',
              style: QuizBattleUiTokens.titleSmall.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: QuizBattleUiTokens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  team.name,
                  style: QuizBattleUiTokens.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: QuizBattleUiTokens.space4),
                Text(
                  team.isEliminated
                      ? l10n.quizResultExcluded
                      : l10n.quizResultActive,
                  style: QuizBattleUiTokens.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: QuizBattleUiTokens.space12),
          Text(
            '${team.score}',
            style: QuizBattleUiTokens.titleMedium,
          ),
        ],
      ),
    );
  }
}