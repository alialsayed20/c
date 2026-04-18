import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../domain/models/answer_order_entry.dart';
import '../../../shared/presentation/theme/quiz_battle_ui_tokens.dart';

class QuizQuestionTurnStrip extends StatelessWidget {
  const QuizQuestionTurnStrip({
    super.key,
    required this.answerOrder,
    required this.currentTeamId,
    this.teamNamesById = const <String, String>{},
    this.teamColorsById = const <String, Color>{},
  });

  final List<AnswerOrderEntry> answerOrder;
  final String? currentTeamId;
  final Map<String, String> teamNamesById;
  final Map<String, Color> teamColorsById;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    if (answerOrder.isEmpty) {
      return Container(
        decoration: QuizBattleUiTokens.secondaryCardDecoration(),
        padding: QuizBattleUiTokens.cardPadding,
        child: Text(
          l10n.quizQuestionNoAnswerOrder,
          style: QuizBattleUiTokens.bodyMedium,
        ),
      );
    }

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: answerOrder.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: QuizBattleUiTokens.space10),
        itemBuilder: (BuildContext context, int index) {
          final AnswerOrderEntry entry = answerOrder[index];
          final String label = teamNamesById[entry.teamId] ?? entry.teamId;
          final Color color =
              teamColorsById[entry.teamId] ?? QuizBattleUiTokens.info;
          final bool isCurrent = entry.teamId == currentTeamId;

          return _TurnEntryCard(
            index: index,
            label: label,
            color: color,
            isCurrent: isCurrent,
            entry: entry,
          );
        },
      ),
    );
  }
}

class _TurnEntryCard extends StatelessWidget {
  const _TurnEntryCard({
    required this.index,
    required this.label,
    required this.color,
    required this.isCurrent,
    required this.entry,
  });

  final int index;
  final String label;
  final Color color;
  final bool isCurrent;
  final AnswerOrderEntry entry;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final _TurnEntryVisualState visualState = _resolveState(l10n);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 164,
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
              ? color.withValues(alpha: 0.90)
              : QuizBattleUiTokens.borderPrimary,
          width: isCurrent ? 1.5 : 1,
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
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.90),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  '${index + 1}',
                  style: QuizBattleUiTokens.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: QuizBattleUiTokens.space8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: QuizBattleUiTokens.titleSmall,
                ),
              ),
            ],
          ),
          const Spacer(),
          _StatePill(
            label: visualState.label,
            backgroundColor: visualState.backgroundColor,
            borderColor: visualState.borderColor,
          ),
        ],
      ),
    );
  }

  _TurnEntryVisualState _resolveState(AppLocalizations l10n) {
    if (entry.isBanned) {
      return _TurnEntryVisualState(
        label: l10n.quizQuestionBanned,
        backgroundColor: QuizBattleUiTokens.danger,
      );
    }

    if (entry.isExcluded) {
      return _TurnEntryVisualState(
        label: l10n.quizQuestionExcluded,
        backgroundColor: QuizBattleUiTokens.warning,
      );
    }

    if (entry.hasAnswered) {
      return _TurnEntryVisualState(
        label: l10n.quizQuestionAnswered,
        backgroundColor: QuizBattleUiTokens.surfaceTertiary,
      );
    }

    if (isCurrent) {
      return _TurnEntryVisualState(
        label: l10n.quizQuestionAnswering,
        backgroundColor: Colors.white.withValues(alpha: 0.18),
        borderColor: Colors.white.withValues(alpha: 0.22),
      );
    }

    return _TurnEntryVisualState(
      label: l10n.quizQuestionWaiting,
      backgroundColor: QuizBattleUiTokens.surfaceTertiary,
    );
  }
}

class _StatePill extends StatelessWidget {
  const _StatePill({
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

class _TurnEntryVisualState {
  const _TurnEntryVisualState({
    required this.label,
    required this.backgroundColor,
    this.borderColor,
  });

  final String label;
  final Color backgroundColor;
  final Color? borderColor;
}