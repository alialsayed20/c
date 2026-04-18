import 'setup_review_issue.dart';

class SetupReviewResult {
  const SetupReviewResult({
    required this.issues,
  });

  final List<SetupReviewIssue> issues;

  bool get isReady => issues.isEmpty;
}