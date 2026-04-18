import 'package:flutter/material.dart';

import '../../domain/models/board_category_column.dart';
import '../../domain/models/board_cell.dart';
import 'quiz_board_column.dart';

class QuizBoardGrid extends StatelessWidget {
  const QuizBoardGrid({
    super.key,
    required this.columns,
    required this.onCellTap,
    this.teamColorsById = const <String, Color>{},
    this.columnWidth = 170,
    this.columnSpacing = 12,
  });

  final List<BoardCategoryColumn> columns;
  final ValueChanged<BoardCell> onCellTap;
  final Map<String, Color> teamColorsById;
  final double columnWidth;
  final double columnSpacing;

  @override
  Widget build(BuildContext context) {
    if (columns.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List<Widget>.generate(columns.length, (int index) {
          final BoardCategoryColumn column = columns[index];

          return Padding(
            padding: EdgeInsetsDirectional.only(
              end: index == columns.length - 1 ? 0 : columnSpacing,
            ),
            child: SizedBox(
              width: columnWidth,
              child: QuizBoardColumn(
                column: column,
                onCellTap: onCellTap,
                teamColorsById: teamColorsById,
              ),
            ),
          );
        }),
      ),
    );
  }
}