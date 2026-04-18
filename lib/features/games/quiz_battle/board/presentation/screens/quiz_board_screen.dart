import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../domain/models/board_cell.dart';
import '../../domain/models/board_state.dart';
import '../../../helpers/domain/enums/helper_scope.dart';
import '../../../helpers/domain/enums/helper_type.dart';
import '../../../helpers/domain/enums/helper_usage_status.dart';
import '../../../helpers/domain/models/helper_usage.dart';
import '../../../helpers/presentation/widgets/quiz_helpers_panel.dart';
import '../../../session/domain/models/game_session.dart';
import '../../../session/domain/models/session_team_snapshot.dart';
import '../../../shared/presentation/widgets/quiz_battle_shell.dart';
import '../../../shared/presentation/widgets/quiz_score_strip.dart';
import '../widgets/quiz_board_grid.dart';

class QuizBoardScreen extends StatelessWidget {
  const QuizBoardScreen({
    super.key,
    required this.session,
    required this.board,
    required this.onCellTap,
    this.onMorePressed,
    this.helperUsages,
    this.onBoardHelperPressed,
    this.selectedHelperId,
  });

  final GameSession session;
  final BoardState board;
  final ValueChanged<BoardCell> onCellTap;
  final VoidCallback? onMorePressed;
  final List<HelperUsage>? helperUsages;
  final ValueChanged<HelperUsage>? onBoardHelperPressed;
  final String? selectedHelperId;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final Map<String, Color> teamColorsById = <String, Color>{
      for (final SessionTeamSnapshot team in session.teams)
        team.id: Color(team.colorValue),
    };

    final List<HelperUsage> resolvedHelpers = helperUsages == null
        ? _buildBoardHelpers()
        : _filterHelpersForCurrentTeam(helperUsages!);

    return QuizBattleShell(
      title: l10n.quizBattleTitle,
      subtitle: _buildSubtitle(l10n),
      headerTrailing: _BoardHeaderAction(
        onPressed: onMorePressed,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          QuizScoreStrip(
            teams: session.teams,
            currentTeamId: session.currentTeamId,
          ),
          const SizedBox(height: 16),
          QuizHelpersPanel(
            title: l10n.quizBoardHelpersTitle,
            helperUsages: resolvedHelpers,
            selectedHelperId: selectedHelperId,
            onHelperPressed: (HelperUsage helperUsage) {
              onBoardHelperPressed?.call(helperUsage);
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: QuizBoardGrid(
              columns: board.columns,
              onCellTap: onCellTap,
              teamColorsById: teamColorsById,
            ),
          ),
        ],
      ),
    );
  }

  String _buildSubtitle(AppLocalizations l10n) {
    final String turnLabel =
        _currentTeamName() ?? l10n.quizBoardNoActiveTeam;
    final int availableCount = _availableCellsCount();

    return '${l10n.quizBoardCurrentTurnLabel} $turnLabel • '
        '${l10n.quizBoardAvailableCellsLabel} $availableCount';
  }

  String? _currentTeamName() {
    final String? currentTeamId = session.currentTeamId;
    if (currentTeamId == null) {
      return null;
    }

    for (final SessionTeamSnapshot team in session.teams) {
      if (team.id == currentTeamId) {
        return team.name;
      }
    }

    return null;
  }

  int _availableCellsCount() {
    int count = 0;

    for (final column in board.columns) {
      for (final cell in column.cells) {
        if (cell.isAvailable) {
          count++;
        }
      }
    }

    return count;
  }

  List<HelperUsage> _filterHelpersForCurrentTeam(
    List<HelperUsage> helpers,
  ) {
    final String? currentTeamId = session.currentTeamId;

    if (currentTeamId == null) {
      return const <HelperUsage>[];
    }

    return helpers.where((HelperUsage helper) {
      return helper.teamId == currentTeamId &&
          helper.scope == HelperScope.board;
    }).toList();
  }

  List<HelperUsage> _buildBoardHelpers() {
    final String ownerTeamId = session.currentTeamId ?? 'current_team';

    return <HelperUsage>[
      HelperUsage(
        id: 'block_steal',
        teamId: ownerTeamId,
        type: HelperType.blockSteal,
        scope: HelperScope.board,
        status: HelperUsageStatus.ready,
      ),
      HelperUsage(
        id: 'double_points',
        teamId: ownerTeamId,
        type: HelperType.doublePoints,
        scope: HelperScope.board,
        status: HelperUsageStatus.ready,
      ),
    ];
  }
}

class _BoardHeaderAction extends StatelessWidget {
  const _BoardHeaderAction({
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: onPressed,
      icon: const Icon(Icons.more_horiz_rounded),
    );
  }
}