import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/setup_controller.dart';
import '../state/setup_editor_state.dart';

final NotifierProvider<SetupController, SetupEditorState>
    setupControllerProvider =
    NotifierProvider<SetupController, SetupEditorState>(
  SetupController.new,
);