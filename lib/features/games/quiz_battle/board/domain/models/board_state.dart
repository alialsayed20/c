import 'board_category_column.dart';

class BoardState {
  const BoardState({
    required this.columns,
  });

  final List<BoardCategoryColumn> columns;

  bool get isEmpty => columns.isEmpty;

  bool get isCompleted =>
      columns.every((column) => column.isCompleted);

  BoardState copyWith({
    List<BoardCategoryColumn>? columns,
  }) {
    return BoardState(
      columns: columns ?? this.columns,
    );
  }
}