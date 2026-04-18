import '../enums/penalty_target_type.dart';
import '../enums/penalty_type.dart';

class PenaltyRecord {
  const PenaltyRecord({
    required this.id,
    required this.type,
    required this.targetType,
    required this.targetId,
    required this.value,
    required this.questionId,
    required this.createdAt,
  });

  final String id;
  final PenaltyType type;
  final PenaltyTargetType targetType;
  final String targetId;
  final int value;
  final String questionId;
  final DateTime createdAt;
}