import '../../../setup/application/state/setup_editor_state.dart';
import '../enums/start_match_failure_code.dart';
import '../models/start_match_failure.dart';
import '../models/start_match_payload.dart';
import '../models/start_match_result.dart';
import 'setup_to_session_mapper.dart';

class StartMatchService {
  const StartMatchService({
    required SetupToSessionMapper mapper,
  }) : _mapper = mapper;

  final SetupToSessionMapper _mapper;

  StartMatchResult start({
    required SetupEditorState setupEditorState,
    required String sessionId,
    required DateTime createdAt,
  }) {
    if (!setupEditorState.canStartMatch) {
      return StartMatchResult.failure(
        const StartMatchFailure(
          code: StartMatchFailureCode.invalidSetup,
        ),
      );
    }

    final session = _mapper.map(
      StartMatchPayload(
        setup: setupEditorState.setup,
        sessionId: sessionId,
        createdAt: createdAt,
      ),
    );

    return StartMatchResult.success(session);
  }
}