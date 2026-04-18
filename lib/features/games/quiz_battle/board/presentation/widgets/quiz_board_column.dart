import 'package:flutter/material.dart';

import '../../domain/models/board_category_column.dart';
import '../../domain/models/board_cell.dart';
import 'quiz_board_tile.dart';
import '../../../shared/presentation/theme/quiz_battle_ui_tokens.dart';

class QuizBoardColumn extends StatelessWidget {
  const QuizBoardColumn({
    super.key,
    required this.column,
    required this.onCellTap,
    this.teamColorsById = const <String, Color>{},
  });

  final BoardCategoryColumn column;
  final ValueChanged<BoardCell> onCellTap;
  final Map<String, Color> teamColorsById;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: QuizBattleUiTokens.secondaryCardDecoration(),
      padding: const EdgeInsets.all(QuizBattleUiTokens.space12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _CategoryHeader(
            title: column.title,
            isCompleted: column.isCompleted,
          ),
          const SizedBox(height: QuizBattleUiTokens.space12),
          ..._buildCells(),
        ],
      ),
    );
  }

  List<Widget> _buildCells() {
    final List<Widget> widgets = <Widget>[];

    for (int index = 0; index < column.cells.length; index++) {
      final BoardCell cell = column.cells[index];
      final Color? ownerColor = cell.ownerTeamId == null
          ? null
          : teamColorsById[cell.ownerTeamId];

      widgets.add(
        QuizBoardTile(
          cell: cell,
          ownerColor: ownerColor,
          onTap: cell.isAvailable ? () => onCellTap(cell) : null,
        ),
      );

      if (index != column.cells.length - 1) {
        widgets.add(
          const SizedBox(height: QuizBattleUiTokens.space10),
        );
      }
    }

    return widgets;
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.title,
    required this.isCompleted,
  });

  final String title;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: QuizBattleUiTokens.space12,
        vertical: QuizBattleUiTokens.space10,
      ),
      decoration: BoxDecoration(
        gradient: isCompleted
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xFF31434F),
                  Color(0xFF24343E),
                ],
              )
            : QuizBattleUiTokens.headerGradient,
        borderRadius: BorderRadius.circular(
          QuizBattleUiTokens.radiusMd,
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: QuizBattleUiTokens.titleSmall,
      ),
    );
  }
}