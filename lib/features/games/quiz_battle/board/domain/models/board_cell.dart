import '../enums/board_cell_status.dart';

class BoardCell {
  const BoardCell({
    required this.id,
    required this.categoryId,
    required this.pointValue,
    required this.questionId,
    required this.status,
    this.ownerTeamId,
  });

  final String id;
  final String categoryId;
  final int pointValue;
  final String questionId;
  final BoardCellStatus status;
  final String? ownerTeamId;

  bool get isAvailable => status == BoardCellStatus.available;
  bool get isUsed => status == BoardCellStatus.used;

  BoardCell copyWith({
    String? id,
    String? categoryId,
    int? pointValue,
    String? questionId,
    BoardCellStatus? status,
    String? ownerTeamId,
    bool clearOwner = false,
  }) {
    return BoardCell(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      pointValue: pointValue ?? this.pointValue,
      questionId: questionId ?? this.questionId,
      status: status ?? this.status,
      ownerTeamId: clearOwner ? null : (ownerTeamId ?? this.ownerTeamId),
    );
  }
}