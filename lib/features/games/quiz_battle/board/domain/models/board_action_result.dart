import 'board_action_failure.dart';
import 'board_state.dart';

class BoardActionResult {
  const BoardActionResult._({
    required this.state,
    required this.failure,
  });

  final BoardState? state;
  final BoardActionFailure? failure;

  bool get isSuccess => state != null;
  bool get isFailure => failure != null;

  factory BoardActionResult.success(BoardState state) {
    return BoardActionResult._(
      state: state,
      failure: null,
    );
  }

  factory BoardActionResult.failure(BoardActionFailure failure) {
    return BoardActionResult._(
      state: null,
      failure: failure,
    );
  }
}