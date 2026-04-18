import 'package:flutter/material.dart';

import '../../../shared/presentation/theme/quiz_battle_ui_tokens.dart';

class QuizQuestionShell extends StatelessWidget {
  const QuizQuestionShell({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.topBar,
    this.bottomBar,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? topBar;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: QuizBattleUiTokens.pageGradient,
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  QuizBattleUiTokens.space16,
                  QuizBattleUiTokens.space12,
                  QuizBattleUiTokens.space16,
                  QuizBattleUiTokens.space8,
                ),
                child: _QuestionHeader(
                  title: title,
                  subtitle: subtitle,
                ),
              ),
              if (topBar != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    QuizBattleUiTokens.space16,
                    0,
                    QuizBattleUiTokens.space16,
                    QuizBattleUiTokens.space12,
                  ),
                  child: topBar!,
                ),
              Expanded(
                child: Padding(
                  padding: QuizBattleUiTokens.screenPadding,
                  child: body,
                ),
              ),
              if (bottomBar != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    QuizBattleUiTokens.space16,
                    QuizBattleUiTokens.space8,
                    QuizBattleUiTokens.space16,
                    QuizBattleUiTokens.space16,
                  ),
                  child: bottomBar!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  const _QuestionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: QuizBattleUiTokens.highlightedCardDecoration(),
      padding: const EdgeInsets.all(QuizBattleUiTokens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: QuizBattleUiTokens.titleLarge,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null && subtitle!.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: QuizBattleUiTokens.space8),
            Text(
              subtitle!,
              style: QuizBattleUiTokens.bodyMedium.copyWith(
                color: QuizBattleUiTokens.textPrimary.withValues(alpha: 0.88),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}