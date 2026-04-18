import 'turn_advance_failure.dart';
import 'turn_order.dart';

class TurnAdvanceResult {
  const TurnAdvanceResult._({
    required this.turnOrder,
    required this.failure,
  });

  final TurnOrder? turnOrder;
  final TurnAdvanceFailure? failure;

  bool get isSuccess => turnOrder != null;
  bool get isFailure => failure != null;

  factory TurnAdvanceResult.success(TurnOrder turnOrder) {
    return TurnAdvanceResult._(
      turnOrder: turnOrder,
      failure: null,
    );
  }

  factory TurnAdvanceResult.failure(TurnAdvanceFailure failure) {
    return TurnAdvanceResult._(
      turnOrder: null,
      failure: failure,
    );
  }
}