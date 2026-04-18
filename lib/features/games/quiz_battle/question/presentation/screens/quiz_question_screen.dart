import 'dart:async';

import 'package:flutter/material.dart';

import '../../../session/domain/models/game_session.dart';
import '../../../session/domain/models/session_team_snapshot.dart';
import '../../domain/models/answer_order_entry.dart';
import '../../domain/models/question_round.dart';

class QuizQuestionScreen extends StatefulWidget {
  const QuizQuestionScreen({
    super.key,
    required this.session,
    required this.round,
    required this.questionText,
    required this.answerText,
    required this.onTeamSelected,
    required this.onClosePressed,
    this.onRevealAnswerPressed,
    this.onStealPressed,
    this.onStopPressed,
  });

  final GameSession session;
  final QuestionRound round;
  final String questionText;
  final String answerText;
  final ValueChanged<String> onTeamSelected;
  final VoidCallback onClosePressed;
  final VoidCallback? onRevealAnswerPressed;
  final VoidCallback? onStealPressed;
  final VoidCallback? onStopPressed;

  @override
  State<QuizQuestionScreen> createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  static const int _initialSeconds = 60;

  Timer? _timer;
  int _seconds = _initialSeconds;
  bool _showAnswer = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant QuizQuestionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.round.questionId != widget.round.questionId) {
      _timer?.cancel();
      _seconds = _initialSeconds;
      _showAnswer = false;
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<SessionTeamSnapshot> teams = widget.session.teams;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isArabic(context) ? 'السؤال' : 'Question'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    _QuestionCard(
                      title: _isArabic(context) ? 'نص السؤال' : 'Question',
                      valueText: widget.questionText,
                      pointValue: widget.round.pointValue,
                      pointLabel: _isArabic(context) ? 'النقاط' : 'Points',
                    ),
                    const SizedBox(height: 16),
                    _AnswerOrderCard(
                      title:
                          _isArabic(context) ? 'ترتيب الإجابة' : 'Answer order',
                      entries: widget.round.answerOrder,
                      teams: teams,
                      currentTeamId: widget.round.currentAnsweringTeamId,
                    ),
                    const SizedBox(height: 16),
                    _CountdownCard(
                      title: _isArabic(context)
                          ? 'الوقت المتبقي'
                          : 'Time remaining',
                      seconds: _seconds,
                    ),
                    const SizedBox(height: 16),
                    if (_showAnswer)
                      _AnswerCard(
                        title: _isArabic(context)
                            ? 'الجواب الصحيح'
                            : 'Correct answer',
                        answerText: widget.answerText.trim().isEmpty
                            ? (_isArabic(context)
                                ? 'الجواب غير متوفر'
                                : 'Answer unavailable')
                            : widget.answerText,
                      ),
                    if (_showAnswer) const SizedBox(height: 16),
                    if (_showAnswer)
                      _WinnerSelectionCard(
                        title: _isArabic(context)
                            ? 'من الفريق الذي أجاب صح؟'
                            : 'Which team answered correctly?',
                        teams: teams,
                        onTeamSelected: widget.onTeamSelected,
                      ),
                  ],
                ),
              ),
            ),
            _BottomActions(
              isArabic: _isArabic(context),
              showAnswer: _showAnswer,
              canUseSteal: _canUseSteal(),
              canUseStop: _canUseStop(),
              onRevealPressed: _showAnswer ? null : _handleRevealAnswer,
              onStealPressed: widget.onStealPressed,
              onStopPressed: widget.onStopPressed,
              onNoOneAnsweredPressed: widget.onClosePressed,
              onClosePressed: widget.onClosePressed,
            ),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    if (_showAnswer) {
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_showAnswer) {
        timer.cancel();
        return;
      }

      if (_seconds <= 1) {
        timer.cancel();
        _handleRevealAnswer();
        return;
      }

      setState(() {
        _seconds -= 1;
      });
    });
  }

  void _handleRevealAnswer() {
    if (_showAnswer) {
      return;
    }

    _timer?.cancel();

    setState(() {
      _showAnswer = true;
      _seconds = 0;
    });

    widget.onRevealAnswerPressed?.call();
  }

  bool _canUseSteal() {
    if (_showAnswer) {
      return false;
    }

    if (widget.onStealPressed == null) {
      return false;
    }

    if (widget.round.isClosed) {
      return false;
    }

    if (widget.round.isStealBlocked) {
      return false;
    }

    if (widget.round.answerOrder.length < 2) {
      return false;
    }

    final String firstTeamId = widget.round.answerOrder.first.teamId;

    final bool hasEligibleStealingTeam = widget.round.answerOrder.any(
      (AnswerOrderEntry entry) {
        if (entry.teamId == firstTeamId) {
          return false;
        }

        return entry.canAnswer;
      },
    );

    return hasEligibleStealingTeam;
  }

  bool _canUseStop() {
    if (_showAnswer) {
      return false;
    }

    if (widget.onStopPressed == null) {
      return false;
    }

    if (widget.round.isClosed) {
      return false;
    }

    final String? currentTeamId = widget.round.currentAnsweringTeamId;
    if (currentTeamId == null || currentTeamId.trim().isEmpty) {
      return false;
    }

    final bool hasEligibleOtherTeam = widget.round.answerOrder.any(
      (AnswerOrderEntry entry) =>
          entry.teamId != currentTeamId && entry.canAnswer,
    );

    return hasEligibleOtherTeam;
  }

  bool _isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.title,
    required this.valueText,
    required this.pointValue,
    required this.pointLabel,
  });

  final String title;
  final String valueText;
  final int pointValue;
  final String pointLabel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            valueText,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            '$pointLabel: $pointValue',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerOrderCard extends StatelessWidget {
  const _AnswerOrderCard({
    required this.title,
    required this.entries,
    required this.teams,
    required this.currentTeamId,
  });

  final String title;
  final List<AnswerOrderEntry> entries;
  final List<SessionTeamSnapshot> teams;
  final String? currentTeamId;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...entries.asMap().entries.map((entry) {
            final int index = entry.key;
            final AnswerOrderEntry orderEntry = entry.value;
            final SessionTeamSnapshot? team = _findTeamById(orderEntry.teamId);
            final String teamName = team?.name ?? orderEntry.teamId;
            final bool isCurrent = orderEntry.teamId == currentTeamId;

            String? trailingText;
            if (orderEntry.isBanned) {
              trailingText = _isArabic(context) ? 'محظور' : 'Banned';
            } else if (orderEntry.isExcluded) {
              trailingText = _isArabic(context) ? 'موقوف' : 'Stopped';
            } else if (orderEntry.hasAnswered) {
              trailingText = _isArabic(context) ? 'أجاب' : 'Answered';
            }

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isCurrent
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCurrent
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    '${index + 1}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      teamName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isCurrent ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (trailingText != null)
                    Text(
                      trailingText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (isCurrent) ...<Widget>[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.play_arrow_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  SessionTeamSnapshot? _findTeamById(String teamId) {
    for (final SessionTeamSnapshot team in teams) {
      if (team.id == teamId) {
        return team;
      }
    }
    return null;
  }

  bool _isArabic(BuildContext context) {
    return Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';
  }
}

class _CountdownCard extends StatelessWidget {
  const _CountdownCard({
    required this.title,
    required this.seconds,
  });

  final String title;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$seconds',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({
    required this.title,
    required this.answerText,
  });

  final String title;
  final String answerText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            answerText,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _WinnerSelectionCard extends StatelessWidget {
  const _WinnerSelectionCard({
    required this.title,
    required this.teams,
    required this.onTeamSelected,
  });

  final String title;
  final List<SessionTeamSnapshot> teams;
  final ValueChanged<String> onTeamSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...teams.map((SessionTeamSnapshot team) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => onTeamSelected(team.id),
                  child: Text(team.name),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.isArabic,
    required this.showAnswer,
    required this.canUseSteal,
    required this.canUseStop,
    required this.onRevealPressed,
    required this.onStealPressed,
    required this.onStopPressed,
    required this.onNoOneAnsweredPressed,
    required this.onClosePressed,
  });

  final bool isArabic;
  final bool showAnswer;
  final bool canUseSteal;
  final bool canUseStop;
  final VoidCallback? onRevealPressed;
  final VoidCallback? onStealPressed;
  final VoidCallback? onStopPressed;
  final VoidCallback onNoOneAnsweredPressed;
  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (!showAnswer) ...<Widget>[
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onRevealPressed,
                  child: Text(
                    isArabic ? 'إظهار الجواب' : 'Show answer',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: canUseSteal ? onStealPressed : null,
                      child: Text(
                        isArabic ? 'سرقة السؤال' : 'Steal question',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: canUseStop ? onStopPressed : null,
                      child: Text(
                        isArabic ? 'إيقاف فريق' : 'Stop team',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onNoOneAnsweredPressed,
                  child: Text(
                    isArabic ? 'لم يجب أحد' : 'No one answered',
                  ),
                ),
              ),
            ] else ...<Widget>[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onNoOneAnsweredPressed,
                  child: Text(
                    isArabic ? 'لم يجب أحد' : 'No one answered',
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onClosePressed,
                child: Text(
                  isArabic ? 'إغلاق السؤال' : 'Close question',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}