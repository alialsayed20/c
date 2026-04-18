// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'BodiPlay';

  @override
  String get appStartupTitle => 'BodiPlay Startup';

  @override
  String get appStartupLoading => 'Checking session...';

  @override
  String get appStartupError => 'An error occurred while starting the app';

  @override
  String get signInTitle => 'Sign In';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get quizBattleTitle => 'Quiz Battle';

  @override
  String get quizBoardNoTeams => 'No teams yet';

  @override
  String get quizBoardExcluded => 'Excluded';

  @override
  String get quizBoardCurrentTurn => 'Current Turn';

  @override
  String get quizBoardWaiting => 'Waiting';

  @override
  String get quizBoardCurrentTurnLabel => 'Current turn:';

  @override
  String get quizBoardAvailableCellsLabel => 'Available cells:';

  @override
  String get quizBoardNoActiveTeam => 'No active team';

  @override
  String get quizQuestionRoundTitle => 'Question Round';

  @override
  String get quizQuestionClosed => 'Question closed';

  @override
  String get quizQuestionWaitingResolution => 'Waiting for round resolution';

  @override
  String quizQuestionNowAnswering(Object teamName) {
    return 'Now answering: $teamName';
  }

  @override
  String get quizQuestionNoAnswerOrder => 'No answer order';

  @override
  String get quizQuestionBanned => 'Banned';

  @override
  String get quizQuestionExcluded => 'Excluded';

  @override
  String get quizQuestionAnswered => 'Answered';

  @override
  String get quizQuestionAnswering => 'Answering';

  @override
  String get quizQuestionWaiting => 'Waiting';

  @override
  String quizQuestionPoints(int value) {
    return '$value pts';
  }

  @override
  String get quizQuestionLive => 'Live Question';

  @override
  String get quizQuestionCorrect => 'Correct';

  @override
  String get quizQuestionWrong => 'Wrong';

  @override
  String get quizQuestionClose => 'Close Question';

  @override
  String get quizQuestionLoading => 'Loading question...';

  @override
  String get quizQuestionUnavailable => 'Question unavailable';

  @override
  String get quizQuestionLoadFailed => 'Failed to load question';

  @override
  String get quizHelperBlockSteal => 'Block Steal';

  @override
  String get quizHelperDoublePoints => 'Double Points';

  @override
  String get quizHelperBanTeam => 'Ban Team';

  @override
  String get quizHelperStealQuestion => 'Steal Question';

  @override
  String get quizHelperStopPlayer => 'Stop Player';

  @override
  String get quizBoardHelpersTitle => 'Board Helpers';

  @override
  String get quizHelperStealSelectTeam => 'Select the team that will steal';

  @override
  String get quizHelperStopSelectTeam => 'Select the team to stop';

  @override
  String get quizHelperNoEligibleTeams => 'No eligible teams to stop';

  @override
  String get quizResultTitle => 'Match Result';

  @override
  String get quizResultNoWinner => 'No winner';

  @override
  String quizResultWinnerSubtitle(Object teamName) {
    return 'Winner: $teamName';
  }

  @override
  String get quizResultClose => 'Close';

  @override
  String get quizResultWinnerLabel => 'Winner';

  @override
  String get quizResultScoreLabel => 'Score';

  @override
  String get quizResultLeaderboardTitle => 'Final Leaderboard';

  @override
  String get quizResultNoTeams => 'No teams';

  @override
  String get quizResultExcluded => 'Excluded';

  @override
  String get quizResultActive => 'Active';
}
