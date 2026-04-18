import '../enums/helper_scope.dart';
import '../enums/helper_type.dart';
import '../enums/helper_usage_status.dart';

class HelperUsage {
  const HelperUsage({
    required this.id,
    required this.teamId,
    required this.type,
    required this.scope,
    required this.status,
    this.targetTeamId,
    this.targetPlayerId,
    this.relatedQuestionId,
  });

  final String id;
  final String teamId;
  final HelperType type;
  final HelperScope scope;
  final HelperUsageStatus status;
  final String? targetTeamId;
  final String? targetPlayerId;
  final String? relatedQuestionId;

  bool get isReady => status == HelperUsageStatus.ready;
  bool get isActivated => status == HelperUsageStatus.activated;
  bool get isConsumed => status == HelperUsageStatus.consumed;

  HelperUsage copyWith({
    String? id,
    String? teamId,
    HelperType? type,
    HelperScope? scope,
    HelperUsageStatus? status,
    String? targetTeamId,
    bool clearTargetTeamId = false,
    String? targetPlayerId,
    bool clearTargetPlayerId = false,
    String? relatedQuestionId,
    bool clearRelatedQuestionId = false,
  }) {
    return HelperUsage(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      type: type ?? this.type,
      scope: scope ?? this.scope,
      status: status ?? this.status,
      targetTeamId:
          clearTargetTeamId ? null : (targetTeamId ?? this.targetTeamId),
      targetPlayerId:
          clearTargetPlayerId ? null : (targetPlayerId ?? this.targetPlayerId),
      relatedQuestionId: clearRelatedQuestionId
          ? null
          : (relatedQuestionId ?? this.relatedQuestionId),
    );
  }
}