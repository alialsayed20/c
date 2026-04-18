import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../shared/presentation/theme/quiz_battle_ui_tokens.dart';

class QuizQuestionCard extends StatelessWidget {
  const QuizQuestionCard({
    super.key,
    required this.questionText,
    required this.pointValue,
    this.mediaSlot,
  });

  final String questionText;
  final int pointValue;
  final Widget? mediaSlot;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: QuizBattleUiTokens.primaryCardDecoration(),
      padding: const EdgeInsets.all(QuizBattleUiTokens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _QuestionTopBar(
            pointValue: pointValue,
          ),
          const SizedBox(height: QuizBattleUiTokens.space16),
          if (mediaSlot != null) ...<Widget>[
            _QuestionMediaFrame(
              child: mediaSlot!,
            ),
            const SizedBox(height: QuizBattleUiTokens.space16),
          ],
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  questionText,
                  textAlign: TextAlign.center,
                  style: QuizBattleUiTokens.titleMedium.copyWith(
                    height: 1.35,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionTopBar extends StatelessWidget {
  const _QuestionTopBar({
    required this.pointValue,
  });

  final int pointValue;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: QuizBattleUiTokens.space12,
            vertical: QuizBattleUiTokens.space8,
          ),
          decoration: BoxDecoration(
            gradient: QuizBattleUiTokens.actionGradient,
            borderRadius: QuizBattleUiTokens.chipRadius,
            boxShadow: QuizBattleUiTokens.softShadow,
          ),
          child: Text(
            l10n.quizQuestionPoints(pointValue),
            style: QuizBattleUiTokens.chipLabel,
          ),
        ),
        const Spacer(),
        const _QuestionStateHint(),
      ],
    );
  }
}

class _QuestionStateHint extends StatelessWidget {
  const _QuestionStateHint();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: QuizBattleUiTokens.space10,
        vertical: QuizBattleUiTokens.space8,
      ),
      decoration: BoxDecoration(
        color: QuizBattleUiTokens.surfaceTertiary,
        borderRadius: QuizBattleUiTokens.chipRadius,
        border: Border.all(
          color: QuizBattleUiTokens.borderSoft,
          width: 1,
        ),
      ),
      child: Text(
        l10n.quizQuestionLive,
        style: QuizBattleUiTokens.bodySmall.copyWith(
          color: QuizBattleUiTokens.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _QuestionMediaFrame extends StatelessWidget {
  const _QuestionMediaFrame({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 160,
        maxHeight: 240,
      ),
      decoration: BoxDecoration(
        color: QuizBattleUiTokens.surfaceSecondary,
        borderRadius: QuizBattleUiTokens.cardRadius,
        border: Border.all(
          color: QuizBattleUiTokens.borderPrimary,
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}