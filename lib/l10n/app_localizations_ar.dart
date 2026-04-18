// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'BodiPlay';

  @override
  String get appStartupTitle => 'بدء تشغيل BodiPlay';

  @override
  String get appStartupLoading => 'جارٍ التحقق من الجلسة...';

  @override
  String get appStartupError => 'حدث خطأ أثناء بدء التطبيق';

  @override
  String get signInTitle => 'تسجيل الدخول';

  @override
  String get continueAsGuest => 'المتابعة كزائر';

  @override
  String get quizBattleTitle => 'كويز باتل';

  @override
  String get quizBoardNoTeams => 'لا توجد فرق بعد';

  @override
  String get quizBoardExcluded => 'مستبعد';

  @override
  String get quizBoardCurrentTurn => 'الدور الحالي';

  @override
  String get quizBoardWaiting => 'بانتظار الدور';

  @override
  String get quizBoardCurrentTurnLabel => 'الدور الحالي:';

  @override
  String get quizBoardAvailableCellsLabel => 'الخلايا المتاحة:';

  @override
  String get quizBoardNoActiveTeam => 'لا يوجد فريق نشط';

  @override
  String get quizQuestionRoundTitle => 'جولة السؤال';

  @override
  String get quizQuestionClosed => 'تم إغلاق السؤال';

  @override
  String get quizQuestionWaitingResolution => 'بانتظار حسم الجولة';

  @override
  String quizQuestionNowAnswering(Object teamName) {
    return 'يجيب الآن: $teamName';
  }

  @override
  String get quizQuestionNoAnswerOrder => 'لا يوجد ترتيب للإجابة';

  @override
  String get quizQuestionBanned => 'ممنوع';

  @override
  String get quizQuestionExcluded => 'مستبعد';

  @override
  String get quizQuestionAnswered => 'أجاب';

  @override
  String get quizQuestionAnswering => 'يجيب الآن';

  @override
  String get quizQuestionWaiting => 'ينتظر';

  @override
  String quizQuestionPoints(int value) {
    return '$value نقطة';
  }

  @override
  String get quizQuestionLive => 'سؤال مباشر';

  @override
  String get quizQuestionCorrect => 'صحيح';

  @override
  String get quizQuestionWrong => 'خطأ';

  @override
  String get quizQuestionClose => 'إغلاق السؤال';

  @override
  String get quizQuestionLoading => 'جارٍ تحميل السؤال...';

  @override
  String get quizQuestionUnavailable => 'السؤال غير متاح';

  @override
  String get quizQuestionLoadFailed => 'فشل تحميل السؤال';

  @override
  String get quizHelperBlockSteal => 'حماية السرقة';

  @override
  String get quizHelperDoublePoints => 'دبل النقاط';

  @override
  String get quizHelperBanTeam => 'منع فريق';

  @override
  String get quizHelperStealQuestion => 'سرقة السؤال';

  @override
  String get quizHelperStopPlayer => 'إيقاف لاعب';

  @override
  String get quizBoardHelpersTitle => 'مساعدات البورد';

  @override
  String get quizHelperStealSelectTeam => 'اختر الفريق الذي سيقوم بالسرقة';

  @override
  String get quizHelperStopSelectTeam => 'اختر الفريق الذي سيتم إيقافه';

  @override
  String get quizHelperNoEligibleTeams => 'لا توجد فرق مؤهلة للإيقاف';

  @override
  String get quizResultTitle => 'نتيجة المباراة';

  @override
  String get quizResultNoWinner => 'لا يوجد فائز';

  @override
  String quizResultWinnerSubtitle(Object teamName) {
    return 'الفائز: $teamName';
  }

  @override
  String get quizResultClose => 'إغلاق';

  @override
  String get quizResultWinnerLabel => 'الفائز';

  @override
  String get quizResultScoreLabel => 'النقاط';

  @override
  String get quizResultLeaderboardTitle => 'الترتيب النهائي';

  @override
  String get quizResultNoTeams => 'لا توجد فرق';

  @override
  String get quizResultExcluded => 'مستبعد';

  @override
  String get quizResultActive => 'نشط';
}
