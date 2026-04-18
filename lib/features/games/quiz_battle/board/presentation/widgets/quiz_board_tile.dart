import 'package:flutter/material.dart';

import '../../domain/models/board_cell.dart';
import '../../../shared/presentation/theme/quiz_battle_ui_tokens.dart';

class QuizBoardTile extends StatelessWidget {
  const QuizBoardTile({
    super.key,
    required this.cell,
    required this.onTap,
    this.ownerColor,
  });

  final BoardCell cell;
  final VoidCallback? onTap;
  final Color? ownerColor;

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = cell.isAvailable;
    final bool isInteractive = isAvailable && onTap != null;

    return Opacity(
      opacity: isAvailable ? 1 : 0.82,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isInteractive ? onTap : null,
          borderRadius: QuizBattleUiTokens.tileRadius,
          child: Ink(
            decoration: _tileDecoration(
              isUsed: cell.isUsed,
              ownerColor: ownerColor,
            ),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 88,
              ),
              padding: QuizBattleUiTokens.tilePadding,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${cell.pointValue}',
                      style: QuizBattleUiTokens.boardValue.copyWith(
                        color: cell.isUsed
                            ? QuizBattleUiTokens.textSecondary
                            : QuizBattleUiTokens.textPrimary,
                      ),
                    ),
                  ),
                  if (cell.isUsed)
                    Align(
                      alignment: Alignment.topRight,
                      child: _UsedBadge(
                        ownerColor: ownerColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _tileDecoration({
    required bool isUsed,
    required Color? ownerColor,
  }) {
    if (isUsed) {
      return BoxDecoration(
        gradient: QuizBattleUiTokens.boardTileUsedGradient,
        borderRadius: QuizBattleUiTokens.tileRadius,
        border: Border.all(
          color: ownerColor?.withValues(alpha: 0.65) ??
              QuizBattleUiTokens.borderSoft,
          width: 1.2,
        ),
        boxShadow: QuizBattleUiTokens.softShadow,
      );
    }

    return BoxDecoration(
      gradient: QuizBattleUiTokens.boardTileAvailableGradient,
      borderRadius: QuizBattleUiTokens.tileRadius,
      border: Border.all(
        color: QuizBattleUiTokens.borderPrimary,
        width: 1.2,
      ),
      boxShadow: QuizBattleUiTokens.strongShadow,
    );
  }
}

class _UsedBadge extends StatelessWidget {
  const _UsedBadge({
    required this.ownerColor,
  });

  final Color? ownerColor;

  @override
  Widget build(BuildContext context) {
    final Color resolvedColor =
        ownerColor ?? QuizBattleUiTokens.textMuted;

    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: resolvedColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.90),
          width: 1.2,
        ),
      ),
    );
  }
}