import 'helper_activation_failure.dart';
import 'helper_usage.dart';

class HelperActivationResult {
  const HelperActivationResult._({
    required this.helperUsage,
    required this.failure,
  });

  final HelperUsage? helperUsage;
  final HelperActivationFailure? failure;

  bool get isSuccess => helperUsage != null;
  bool get isFailure => failure != null;

  factory HelperActivationResult.success(HelperUsage helperUsage) {
    return HelperActivationResult._(
      helperUsage: helperUsage,
      failure: null,
    );
  }

  factory HelperActivationResult.failure(
    HelperActivationFailure failure,
  ) {
    return HelperActivationResult._(
      helperUsage: null,
      failure: failure,
    );
  }
}