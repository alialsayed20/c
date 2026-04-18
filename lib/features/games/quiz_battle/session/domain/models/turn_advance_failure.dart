import '../enums/turn_advance_failure_code.dart';

class TurnAdvanceFailure {
  const TurnAdvanceFailure({
    required this.code,
  });

  final TurnAdvanceFailureCode code;
}