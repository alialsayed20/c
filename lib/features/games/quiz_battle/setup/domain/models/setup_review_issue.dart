import '../enums/setup_review_issue_code.dart';

class SetupReviewIssue {
  const SetupReviewIssue({
    required this.code,
    this.teamId,
    this.playerId,
  });

  final SetupReviewIssueCode code;
  final String? teamId;
  final String? playerId;
}