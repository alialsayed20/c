import 'package:flutter/material.dart';

import '../../../board/domain/models/board_state.dart';
import '../../../board/presentation/screens/quiz_board_container.dart';
import '../../../session/domain/models/game_session.dart';
import '../../application/models/quiz_match_bootstrap_data.dart';

class QuizBattleEntryScope extends StatelessWidget {
  const QuizBattleEntryScope({
    super.key,
    required this.session,
    required this.board,
  });

  final GameSession session;
  final BoardState board;

  @override
  Widget build(BuildContext context) {
    final QuizMatchBootstrapData bootstrap = QuizMatchBootstrapData(
      session: session,
      board: board,
    );

    return QuizBoardContainer(
      bootstrap: bootstrap,
    );
  }
}