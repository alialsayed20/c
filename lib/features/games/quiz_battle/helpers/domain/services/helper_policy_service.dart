import '../enums/helper_activation_failure_code.dart';
import '../enums/helper_scope.dart';
import '../enums/helper_type.dart';
import '../enums/helper_usage_status.dart';
import '../models/helper_activation_failure.dart';
import '../models/helper_activation_result.dart';
import '../models/helper_usage.dart';

class HelperPolicyService {
  const HelperPolicyService();

  HelperActivationResult activateBoardHelper({
    required HelperUsage helperUsage,
    required String relatedQuestionId,
  }) {
    if (helperUsage.scope != HelperScope.board) {
      return HelperActivationResult.failure(
        const HelperActivationFailure(
          code: HelperActivationFailureCode.unsupportedHelperScope,
        ),
      );
    }

    if (helperUsage.status == HelperUsageStatus.consumed) {
      return HelperActivationResult.failure(
        const HelperActivationFailure(
          code: HelperActivationFailureCode.alreadyConsumed,
        ),
      );
    }

    if (helperUsage.status == HelperUsageStatus.activated) {
      return HelperActivationResult.failure(
        const HelperActivationFailure(
          code: HelperActivationFailureCode.alreadyActivated,
        ),
      );
    }

    if (relatedQuestionId.trim().isEmpty) {
      return HelperActivationResult.failure(
        const HelperActivationFailure(
          code: HelperActivationFailureCode.invalidState,
        ),
      );
    }

    switch (helperUsage.type) {
      case HelperType.blockSteal:
      case HelperType.doublePoints:
        final HelperUsage updated = helperUsage.copyWith(
          status: HelperUsageStatus.activated,
          relatedQuestionId: relatedQuestionId,
        );

        return HelperActivationResult.success(updated);

      case HelperType.banTeamFromQuestion:
      case HelperType.stealQuestion:
      case HelperType.stopPlayer:
        return HelperActivationResult.failure(
          const HelperActivationFailure(
            code: HelperActivationFailureCode.invalidState,
          ),
        );
    }
  }
}