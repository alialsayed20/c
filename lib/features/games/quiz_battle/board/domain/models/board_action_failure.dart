import '../enums/board_action_failure_code.dart';

class BoardActionFailure {
  const BoardActionFailure({
    required this.code,
  });

  final BoardActionFailureCode code;
}