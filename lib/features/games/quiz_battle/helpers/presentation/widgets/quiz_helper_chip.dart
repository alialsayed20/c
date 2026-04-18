import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../domain/enums/helper_type.dart';
import '../../domain/enums/helper_usage_status.dart';
import '../../domain/models/helper_usage.dart';
import '../../../shared/presentation/theme/quiz_battle_ui_tokens.dart';

class QuizHelperChip extends StatelessWidget {
  const QuizHelperChip({
    super.key,
    required this.helperUsage,
    required this.onPressed,
    this.isSelected = false,
  });

  final HelperUsage helperUsage;
  final VoidCallback? onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final _HelperVisual visual = _resolveVisual();
    final bool isEnabled = onPressed != null &&
        helperUsage.status == HelperUsageStatus.ready;

    return Opacity(
      opacity: isEnabled ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: QuizBattleUiTokens.chipRadius,
          child: Ink(
            padding: const EdgeInsets.symmetric(
              horizontal: QuizBattleUiTokens.space12,
              vertical: QuizBattleUiTokens.space10,
            ),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        Color(0xFF1BC8B8),
                        Color(0xFF128CA0),
                      ],
                    )
                  : null,
              color: isSelected ? null : QuizBattleUiTokens.surfaceSecondary,
              borderRadius: QuizBattleUiTokens.chipRadius,
              border: Border.all(
                color: isSelected
                    ? visual.color.withValues(alpha: 0.90)
                    : QuizBattleUiTokens.borderPrimary,
                width: isSelected ? 1.4 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  visual.icon,
                  size: 18,
                  color: isSelected
                      ? Colors.white
                      : visual.color,
                ),
                const SizedBox(width: QuizBattleUiTokens.space8),
                Flexible(
                  child: Text(
                    _labelForType(l10n),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: QuizBattleUiTokens.chipLabel.copyWith(
                      color: isSelected
                          ? Colors.white
                          : QuizBattleUiTokens.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: QuizBattleUiTokens.space8),
                _StatusDot(
                  color: _statusColor(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _labelForType(AppLocalizations l10n) {
    switch (helperUsage.type) {
      case HelperType.blockSteal:
        return l10n.quizHelperBlockSteal;
      case HelperType.doublePoints:
        return l10n.quizHelperDoublePoints;
      case HelperType.banTeamFromQuestion:
        return l10n.quizHelperBanTeam;
      case HelperType.stealQuestion:
        return l10n.quizHelperStealQuestion;
      case HelperType.stopPlayer:
        return l10n.quizHelperStopPlayer;
    }
  }

  _HelperVisual _resolveVisual() {
    switch (helperUsage.type) {
      case HelperType.blockSteal:
        return const _HelperVisual(
          icon: Icons.shield_rounded,
          color: QuizBattleUiTokens.info,
        );
      case HelperType.doublePoints:
        return const _HelperVisual(
          icon: Icons.auto_awesome_rounded,
          color: QuizBattleUiTokens.warning,
        );
      case HelperType.banTeamFromQuestion:
        return const _HelperVisual(
          icon: Icons.block_rounded,
          color: QuizBattleUiTokens.danger,
        );
      case HelperType.stealQuestion:
        return const _HelperVisual(
          icon: Icons.flash_on_rounded,
          color: QuizBattleUiTokens.highlightTop,
        );
      case HelperType.stopPlayer:
        return const _HelperVisual(
          icon: Icons.person_off_rounded,
          color: QuizBattleUiTokens.warning,
        );
    }
  }

  Color _statusColor() {
    switch (helperUsage.status) {
      case HelperUsageStatus.ready:
        return QuizBattleUiTokens.success;
      case HelperUsageStatus.activated:
        return QuizBattleUiTokens.info;
      case HelperUsageStatus.consumed:
        return QuizBattleUiTokens.textMuted;
      case HelperUsageStatus.expired:
        return QuizBattleUiTokens.danger;
    }
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
          width: 1,
        ),
      ),
    );
  }
}

class _HelperVisual {
  const _HelperVisual({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;
}