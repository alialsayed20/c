import 'package:flutter/material.dart';

import '../../domain/models/helper_usage.dart';
import 'quiz_helper_chip.dart';
import '../../../shared/presentation/theme/quiz_battle_ui_tokens.dart';

class QuizHelpersPanel extends StatelessWidget {
  const QuizHelpersPanel({
    super.key,
    required this.title,
    required this.helperUsages,
    required this.onHelperPressed,
    this.selectedHelperId,
  });

  final String title;
  final List<HelperUsage> helperUsages;
  final ValueChanged<HelperUsage> onHelperPressed;
  final String? selectedHelperId;

  @override
  Widget build(BuildContext context) {
    if (helperUsages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: QuizBattleUiTokens.secondaryCardDecoration(),
      padding: QuizBattleUiTokens.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: QuizBattleUiTokens.titleSmall,
          ),
          const SizedBox(height: QuizBattleUiTokens.space12),
          Wrap(
            spacing: QuizBattleUiTokens.space10,
            runSpacing: QuizBattleUiTokens.space10,
            children: helperUsages.map((HelperUsage helperUsage) {
              return QuizHelperChip(
                helperUsage: helperUsage,
                isSelected: helperUsage.id == selectedHelperId,
                onPressed: () => onHelperPressed(helperUsage),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}