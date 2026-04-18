import 'package:flutter/material.dart';

import '../theme/quiz_battle_ui_tokens.dart';

class QuizBattleShell extends StatelessWidget {
  const QuizBattleShell({
    super.key,
    required this.title,
    required this.body,
    this.subtitle,
    this.headerTrailing,
    this.bottomBar,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget body;
  final Widget? headerTrailing;
  final Widget? bottomBar;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets resolvedPadding =
        padding ?? QuizBattleUiTokens.screenPadding;

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
                child: _QuizBattleHeader(
                  title: title,
                  subtitle: subtitle,
                  trailing: headerTrailing,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: resolvedPadding,
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

class _QuizBattleHeader extends StatelessWidget {
  const _QuizBattleHeader({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: QuizBattleUiTokens.highlightedCardDecoration(),
      padding: const EdgeInsets.all(QuizBattleUiTokens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: _HeaderTextBlock(
              title: title,
              subtitle: subtitle,
            ),
          ),
          if (trailing != null) ...<Widget>[
            const SizedBox(width: QuizBattleUiTokens.space12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _HeaderTextBlock extends StatelessWidget {
  const _HeaderTextBlock({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}