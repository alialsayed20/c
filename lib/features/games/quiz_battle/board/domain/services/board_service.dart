import '../enums/board_action_failure_code.dart';
import '../enums/board_cell_status.dart';
import '../models/board_action_failure.dart';
import '../models/board_action_result.dart';
import '../models/board_category_column.dart';
import '../models/board_cell.dart';
import '../models/board_state.dart';

class BoardService {
  const BoardService();

  BoardActionResult markCellAsUsed({
    required BoardState state,
    required String cellId,
    required String ownerTeamId,
  }) {
    bool found = false;
    bool alreadyUsed = false;

    final List<BoardCategoryColumn> updatedColumns =
        state.columns.map((column) {
      final List<BoardCell> updatedCells = column.cells.map((cell) {
        if (cell.id != cellId) {
          return cell;
        }

        found = true;

        if (cell.isUsed) {
          alreadyUsed = true;
          return cell;
        }

        return cell.copyWith(
          status: BoardCellStatus.used,
          ownerTeamId: ownerTeamId,
        );
      }).toList();

      return column.copyWith(cells: updatedCells);
    }).toList();

    if (!found) {
      return BoardActionResult.failure(
        const BoardActionFailure(
          code: BoardActionFailureCode.cellNotFound,
        ),
      );
    }

    if (alreadyUsed) {
      return BoardActionResult.failure(
        const BoardActionFailure(
          code: BoardActionFailureCode.cellAlreadyUsed,
        ),
      );
    }

    return BoardActionResult.success(
      state.copyWith(columns: updatedColumns),
    );
  }
}