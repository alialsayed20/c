import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../session/domain/models/session_team_snapshot.dart';
import '../theme/quiz_battle_ui_tokens.dart';

class QuizScoreStrip extends StatelessWidget {
  const QuizScoreStrip({
    super.key,
    required this.teams,
    required this.currentTeamId,
  });

  final List<SessionTeamSnapshot> teams;
  final String? currentTeamId;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    if (teams.isEmpty) {
      return Container(
        decoration: QuizBattleUiTokens.secondaryCardDecoration(),
        padding: QuizBattleUiTokens.cardPadding,
        child: Text(
          l10n.quizBoardNoTeams,
          style: QuizBattleUiTokens.bodyMedium,
        ),
      );
    }

    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: teams.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: QuizBattleUiTokens.space12),
        itemBuilder: (BuildContext context, int index) {
          final SessionTeamSnapshot team = teams[index];
          final bool isCurrent = team.id == currentTeamId;

          return _QuizScoreCard(
            team: team,
            isCurrent: isCurrent,
          );
        },
      ),
    );
  }
}

class _QuizScoreCard extends StatelessWidget {
  const _QuizScoreCard({
    required this.team,
    required this.isCurrent,
  });

  final SessionTeamSnapshot team;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Color teamColor = Color(team.colorValue);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 170,
      padding: QuizBattleUiTokens.cardPadding,
      decoration: BoxDecoration(
        gradient: isCurrent
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFF1BC8B8),
                  Color(0xFF128CA0),
                ],
              )
            : null,
        color: isCurrent ? null : QuizBattleUiTokens.surfacePrimary,
        borderRadius: QuizBattleUiTokens.cardRadius,
        border: Border.all(
          color: isCurrent
              ? teamColor.withValues(alpha: 0.85)
              : QuizBattleUiTokens.borderPrimary,
          width: isCurrent ? 1.6 : 1,
        ),
        boxShadow: isCurrent
            ? QuizBattleUiTokens.strongShadow
            : QuizBattleUiTokens.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: teamColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.9),
                    width: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: QuizBattleUiTokens.space8),
              Expanded(
                child: Text(
                  team.name,
                  style: QuizBattleUiTokens.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${team.score}',
            style: QuizBattleUiTokens.scoreValue,
          ),
          const SizedBox(height: QuizBattleUiTokens.space6),
          Row(
            children: <Widget>[
              if (team.isEliminated)
                _StatusPill(
                  label: l10n.quizBoardExcluded,
                  backgroundColor: QuizBattleUiTokens.danger,
                )
              else if (isCurrent)
                _StatusPill(
                  label: l10n.quizBoardCurrentTurn,
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  borderColor: Colors.white.withValues(alpha: 0.20),
                )
              else
                _StatusPill(
                  label: l10n.quizBoardWaiting,
                  backgroundColor: QuizBattleUiTokens.surfaceTertiary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.backgroundColor,
    this.borderColor,
  });

  final String label;
  final Color backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: QuizBattleUiTokens.chipPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: QuizBattleUiTokens.chipRadius,
        border: borderColor == null
            ? null
            : Border.all(
                color: borderColor!,
                width: 1,
              ),
      ),
      child: Text(
        label,
        style: QuizBattleUiTokens.chipLabel,
      ),
    );
  }
}