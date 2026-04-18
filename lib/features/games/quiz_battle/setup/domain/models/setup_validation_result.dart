import 'setup_issue.dart';

class SetupValidationResult {
  const SetupValidationResult({
    required this.issues,
  });

  final List<SetupIssue> issues;

  bool get isValid => issues.isEmpty;
}