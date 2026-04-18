import 'board_cell.dart';

class BoardCategoryColumn {
  const BoardCategoryColumn({
    required this.categoryId,
    required this.title,
    required this.cells,
  });

  final String categoryId;
  final String title;
  final List<BoardCell> cells;

  bool get isCompleted =>
      cells.every((cell) => cell.isUsed);

  BoardCategoryColumn copyWith({
    String? categoryId,
    String? title,
    List<BoardCell>? cells,
  }) {
    return BoardCategoryColumn(
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      cells: cells ?? this.cells,
    );
  }
}