import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'BodiPlay'**
  String get appName;

  /// No description provided for @appStartupTitle.
  ///
  /// In en, this message translates to:
  /// **'BodiPlay Startup'**
  String get appStartupTitle;

  /// No description provided for @appStartupLoading.
  ///
  /// In en, this message translates to:
  /// **'Checking session...'**
  String get appStartupLoading;

  /// No description provided for @appStartupError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while starting the app'**
  String get appStartupError;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInTitle;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @quizBattleTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz Battle'**
  String get quizBattleTitle;

  /// No description provided for @quizBoardNoTeams.
  ///
  /// In en, this message translates to:
  /// **'No teams yet'**
  String get quizBoardNoTeams;

  /// No description provided for @quizBoardExcluded.
  ///
  /// In en, this message translates to:
  /// **'Excluded'**
  String get quizBoardExcluded;

  /// No description provided for @quizBoardCurrentTurn.
  ///
  /// In en, this message translates to:
  /// **'Current Turn'**
  String get quizBoardCurrentTurn;

  /// No description provided for @quizBoardWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get quizBoardWaiting;

  /// No description provided for @quizBoardCurrentTurnLabel.
  ///
  /// In en, this message translates to:
  /// **'Current turn:'**
  String get quizBoardCurrentTurnLabel;

  /// No description provided for @quizBoardAvailableCellsLabel.
  ///
  /// In en, this message translates to:
  /// **'Available cells:'**
  String get quizBoardAvailableCellsLabel;

  /// No description provided for @quizBoardNoActiveTeam.
  ///
  /// In en, this message translates to:
  /// **'No active team'**
  String get quizBoardNoActiveTeam;

  /// No description provided for @quizQuestionRoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Question Round'**
  String get quizQuestionRoundTitle;

  /// No description provided for @quizQuestionClosed.
  ///
  /// In en, this message translates to:
  /// **'Question closed'**
  String get quizQuestionClosed;

  /// No description provided for @quizQuestionWaitingResolution.
  ///
  /// In en, this message translates to:
  /// **'Waiting for round resolution'**
  String get quizQuestionWaitingResolution;

  /// No description provided for @quizQuestionNowAnswering.
  ///
  /// In en, this message translates to:
  /// **'Now answering: {teamName}'**
  String quizQuestionNowAnswering(Object teamName);

  /// No description provided for @quizQuestionNoAnswerOrder.
  ///
  /// In en, this message translates to:
  /// **'No answer order'**
  String get quizQuestionNoAnswerOrder;

  /// No description provided for @quizQuestionBanned.
  ///
  /// In en, this message translates to:
  /// **'Banned'**
  String get quizQuestionBanned;

  /// No description provided for @quizQuestionExcluded.
  ///
  /// In en, this message translates to:
  /// **'Excluded'**
  String get quizQuestionExcluded;

  /// No description provided for @quizQuestionAnswered.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get quizQuestionAnswered;

  /// No description provided for @quizQuestionAnswering.
  ///
  /// In en, this message translates to:
  /// **'Answering'**
  String get quizQuestionAnswering;

  /// No description provided for @quizQuestionWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get quizQuestionWaiting;

  /// No description provided for @quizQuestionPoints.
  ///
  /// In en, this message translates to:
  /// **'{value} pts'**
  String quizQuestionPoints(int value);

  /// No description provided for @quizQuestionLive.
  ///
  /// In en, this message translates to:
  /// **'Live Question'**
  String get quizQuestionLive;

  /// No description provided for @quizQuestionCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get quizQuestionCorrect;

  /// No description provided for @quizQuestionWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get quizQuestionWrong;

  /// No description provided for @quizQuestionClose.
  ///
  /// In en, this message translates to:
  /// **'Close Question'**
  String get quizQuestionClose;

  /// No description provided for @quizQuestionLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading question...'**
  String get quizQuestionLoading;

  /// No description provided for @quizQuestionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Question unavailable'**
  String get quizQuestionUnavailable;

  /// No description provided for @quizQuestionLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load question'**
  String get quizQuestionLoadFailed;

  /// No description provided for @quizHelperBlockSteal.
  ///
  /// In en, this message translates to:
  /// **'Block Steal'**
  String get quizHelperBlockSteal;

  /// No description provided for @quizHelperDoublePoints.
  ///
  /// In en, this message translates to:
  /// **'Double Points'**
  String get quizHelperDoublePoints;

  /// No description provided for @quizHelperBanTeam.
  ///
  /// In en, this message translates to:
  /// **'Ban Team'**
  String get quizHelperBanTeam;

  /// No description provided for @quizHelperStealQuestion.
  ///
  /// In en, this message translates to:
  /// **'Steal Question'**
  String get quizHelperStealQuestion;

  /// No description provided for @quizHelperStopPlayer.
  ///
  /// In en, this message translates to:
  /// **'Stop Player'**
  String get quizHelperStopPlayer;

  /// No description provided for @quizBoardHelpersTitle.
  ///
  /// In en, this message translates to:
  /// **'Board Helpers'**
  String get quizBoardHelpersTitle;

  /// No description provided for @quizHelperStealSelectTeam.
  ///
  /// In en, this message translates to:
  /// **'Select the team that will steal'**
  String get quizHelperStealSelectTeam;

  /// No description provided for @quizHelperStopSelectTeam.
  ///
  /// In en, this message translates to:
  /// **'Select the team to stop'**
  String get quizHelperStopSelectTeam;

  /// No description provided for @quizHelperNoEligibleTeams.
  ///
  /// In en, this message translates to:
  /// **'No eligible teams to stop'**
  String get quizHelperNoEligibleTeams;

  /// No description provided for @quizResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Match Result'**
  String get quizResultTitle;

  /// No description provided for @quizResultNoWinner.
  ///
  /// In en, this message translates to:
  /// **'No winner'**
  String get quizResultNoWinner;

  /// No description provided for @quizResultWinnerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Winner: {teamName}'**
  String quizResultWinnerSubtitle(Object teamName);

  /// No description provided for @quizResultClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get quizResultClose;

  /// No description provided for @quizResultWinnerLabel.
  ///
  /// In en, this message translates to:
  /// **'Winner'**
  String get quizResultWinnerLabel;

  /// No description provided for @quizResultScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get quizResultScoreLabel;

  /// No description provided for @quizResultLeaderboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Final Leaderboard'**
  String get quizResultLeaderboardTitle;

  /// No description provided for @quizResultNoTeams.
  ///
  /// In en, this message translates to:
  /// **'No teams'**
  String get quizResultNoTeams;

  /// No description provided for @quizResultExcluded.
  ///
  /// In en, this message translates to:
  /// **'Excluded'**
  String get quizResultExcluded;

  /// No description provided for @quizResultActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get quizResultActive;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
