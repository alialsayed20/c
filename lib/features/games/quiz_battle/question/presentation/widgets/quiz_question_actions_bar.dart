import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../shared/presentation/theme/quiz_battle_ui_tokens.dart';

class QuizQuestionActionsBar extends StatelessWidget {
  const QuizQuestionActionsBar({
    super.key,
    required this.onCorrectPressed,
    required this.onWrongPressed,
    required this.onClosePressed,
    this.onStealPressed,
    this.onStopPressed,
    this.canMarkCorrect = true,
    this.canMarkWrong = true,
    this.canClose = true,
    this.canSteal = false,
    this.canStop = false,
  });

  final VoidCallback? onCorrectPressed;
  final VoidCallback? onWrongPressed;
  final VoidCallback? onClosePressed;
  final VoidCallback? onStealPressed;
  final VoidCallback? onStopPressed;
  final bool canMarkCorrect;
  final bool canMarkWrong;
  final bool canClose;
  final bool canSteal;
  final bool canStop;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: QuizBattleUiTokens.primaryCardDecoration(),
      padding: const EdgeInsets.all(QuizBattleUiTokens.space12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (onStealPressed != null || onStopPressed != null) ...<Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: _TopActionButton(
                    label: l10n.quizHelperStealQuestion,
                    icon: Icons.flash_on_rounded,
                    onPressed: canSteal ? onStealPressed : null,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xFFFFC14D),
                        Color(0xFFF08A24),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: QuizBattleUiTokens.space12),
                Expanded(
                  child: _TopActionButton(
                    label: l10n.quizHelperStopPlayer,
                    icon: Icons.person_off_rounded,
                    onPressed: canStop ? onStopPressed : null,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xFF7D7BFF),
                        Color(0xFF5A54D6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: QuizBattleUiTokens.space12),
          ],
          Row(
            children: <Widget>[
              Expanded(
                child: _PrimaryActionButton(
                  label: l10n.quizQuestionCorrect,
                  icon: Icons.check_circle_rounded,
                  onPressed: canMarkCorrect ? onCorrectPressed : null,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color(0xFF29D17D),
                      Color(0xFF169E5B),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: QuizBattleUiTokens.space12),
              Expanded(
                child: _PrimaryActionButton(
                  label: l10n.quizQuestionWrong,
                  icon: Icons.close_rounded,
                  onPressed: canMarkWrong ? onWrongPressed : null,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      Color(0xFFFF7B7B),
                      Color(0xFFD64F4F),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: QuizBattleUiTokens.space12),
          _SecondaryActionButton(
            label: l10n.quizQuestionClose,
            icon: Icons.stop_circle_outlined,
            onPressed: canClose ? onClosePressed : null,
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.gradient,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return Opacity(
      opacity: isEnabled ? 1 : 0.45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: QuizBattleUiTokens.cardRadius,
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: QuizBattleUiTokens.space12,
              vertical: QuizBattleUiTokens.space16,
            ),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: QuizBattleUiTokens.cardRadius,
              boxShadow: QuizBattleUiTokens.softShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: QuizBattleUiTokens.space8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: QuizBattleUiTokens.titleSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.gradient,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return Opacity(
      opacity: isEnabled ? 1 : 0.45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: QuizBattleUiTokens.cardRadius,
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: QuizBattleUiTokens.space12,
              vertical: QuizBattleUiTokens.space16,
            ),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: QuizBattleUiTokens.cardRadius,
              boxShadow: QuizBattleUiTokens.softShadow,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: QuizBattleUiTokens.space8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: QuizBattleUiTokens.titleSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null;

    return Opacity(
      opacity: isEnabled ? 1 : 0.45,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: QuizBattleUiTokens.cardRadius,
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: QuizBattleUiTokens.space12,
              vertical: QuizBattleUiTokens.space16,
            ),
            decoration: BoxDecoration(
              color: QuizBattleUiTokens.surfaceSecondary,
              borderRadius: QuizBattleUiTokens.cardRadius,
              border: Border.all(
                color: QuizBattleUiTokens.borderPrimary,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                  color: QuizBattleUiTokens.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: QuizBattleUiTokens.space8),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: QuizBattleUiTokens.titleSmall.copyWith(
                      color: QuizBattleUiTokens.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}