import '../enums/setup_issue_code.dart';

class SetupIssue {
  const SetupIssue({
    required this.code,
    this.referenceId,
  });

  final SetupIssueCode code;
  final String? referenceId;
}