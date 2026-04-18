import '../../domain/models/setup_issue.dart';
import '../../domain/models/setup_review_issue.dart';
import '../../domain/models/setup_review_result.dart';
import '../../domain/models/setup_state.dart';
import '../../domain/models/setup_validation_result.dart';

class SetupEditorState {
  const SetupEditorState({
    required this.setup,
    required this.validation,
    required this.review,
  });

  final SetupState setup;
  final SetupValidationResult validation;
  final SetupReviewResult review;

  bool get canStartMatch => validation.isValid && review.isReady;

  SetupEditorState copyWith({
    SetupState? setup,
    SetupValidationResult? validation,
    SetupReviewResult? review,
  }) {
    return SetupEditorState(
      setup: setup ?? this.setup,
      validation: validation ?? this.validation,
      review: review ?? this.review,
    );
  }

  factory SetupEditorState.initial() {
    return const SetupEditorState(
      setup: SetupState.empty,
      validation: SetupValidationResult(
        issues: <SetupIssue>[],
      ),
      review: SetupReviewResult(
        issues: <SetupReviewIssue>[],
      ),
    );
  }
}