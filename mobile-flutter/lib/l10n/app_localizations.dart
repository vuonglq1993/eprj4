import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_vi.dart';

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
    Locale('en'),
    Locale('ja'),
    Locale('vi'),
  ];

  /// Tên app
  ///
  /// In vi, this message translates to:
  /// **'LinguaNext'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @register.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get register;

  /// No description provided for @email.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPassword;

  /// No description provided for @loginWithGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get loginWithGoogle;

  /// No description provided for @home.
  ///
  /// In vi, this message translates to:
  /// **'Trang chủ'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In vi, this message translates to:
  /// **'Hồ sơ'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settings;

  /// No description provided for @learn.
  ///
  /// In vi, this message translates to:
  /// **'Học'**
  String get learn;

  /// No description provided for @leaderboard.
  ///
  /// In vi, this message translates to:
  /// **'Xếp hạng'**
  String get leaderboard;

  /// No description provided for @path.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình'**
  String get path;

  /// No description provided for @continueLesson.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục học'**
  String get continueLesson;

  /// No description provided for @todayGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu hôm nay'**
  String get todayGoal;

  /// No description provided for @streak.
  ///
  /// In vi, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @totalXp.
  ///
  /// In vi, this message translates to:
  /// **'Tổng XP'**
  String get totalXp;

  /// No description provided for @daysLearned.
  ///
  /// In vi, this message translates to:
  /// **'Ngày học'**
  String get daysLearned;

  /// No description provided for @subscription.
  ///
  /// In vi, this message translates to:
  /// **'Gói đăng ký'**
  String get subscription;

  /// No description provided for @upgradeToPro.
  ///
  /// In vi, this message translates to:
  /// **'Nâng cấp Pro'**
  String get upgradeToPro;

  /// No description provided for @payNow.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán ngay'**
  String get payNow;

  /// No description provided for @paymentSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán thành công!'**
  String get paymentSuccess;

  /// No description provided for @paymentFailed.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán thất bại hoặc bị hủy'**
  String get paymentFailed;

  /// No description provided for @paymentTimeout.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán đang mất nhiều thời gian. Kiểm tra lịch sử để biết kết quả.'**
  String get paymentTimeout;

  /// No description provided for @checkHistory.
  ///
  /// In vi, this message translates to:
  /// **'Xem lịch sử'**
  String get checkHistory;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @interfaceLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ giao diện'**
  String get interfaceLanguage;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In vi, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In vi, this message translates to:
  /// **'Quay lại'**
  String get back;

  /// No description provided for @next.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo'**
  String get next;

  /// No description provided for @done.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành'**
  String get done;

  /// No description provided for @loading.
  ///
  /// In vi, this message translates to:
  /// **'Đang tải...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In vi, this message translates to:
  /// **'Đã có lỗi xảy ra'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'Thử lại'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa'**
  String get edit;

  /// No description provided for @search.
  ///
  /// In vi, this message translates to:
  /// **'Tìm kiếm'**
  String get search;

  /// No description provided for @processing.
  ///
  /// In vi, this message translates to:
  /// **'Đang xử lý...'**
  String get processing;

  /// No description provided for @featureInDevelopment.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng đang phát triển'**
  String get featureInDevelopment;

  /// No description provided for @splashTagline.
  ///
  /// In vi, this message translates to:
  /// **'Học ngoại ngữ thông minh\ncùng AI cá nhân hóa'**
  String get splashTagline;

  /// No description provided for @splashGetStarted.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu miễn phí'**
  String get splashGetStarted;

  /// No description provided for @welcomeBack.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng trở lại'**
  String get welcomeBack;

  /// No description provided for @loginToContinue.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập để tiếp tục học'**
  String get loginToContinue;

  /// No description provided for @orEmail.
  ///
  /// In vi, this message translates to:
  /// **'hoặc email'**
  String get orEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get invalidEmail;

  /// No description provided for @enterEmail.
  ///
  /// In vi, this message translates to:
  /// **'Nhập email'**
  String get enterEmail;

  /// No description provided for @enterPassword.
  ///
  /// In vi, this message translates to:
  /// **'Nhập mật khẩu'**
  String get enterPassword;

  /// No description provided for @wrongCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc mật khẩu không đúng'**
  String get wrongCredentials;

  /// No description provided for @twoFaTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bật xác thực 2 lớp (2FA)\nđể bảo vệ tài khoản'**
  String get twoFaTitle;

  /// No description provided for @twoFaActivated.
  ///
  /// In vi, this message translates to:
  /// **'2FA sẽ được kích hoạt sau khi đăng nhập'**
  String get twoFaActivated;

  /// No description provided for @noAccount.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản? '**
  String get noAccount;

  /// No description provided for @googleIdTokenError.
  ///
  /// In vi, this message translates to:
  /// **'Không lấy được idToken. Kiểm tra Web Client ID.'**
  String get googleIdTokenError;

  /// No description provided for @googleBackendRejected.
  ///
  /// In vi, this message translates to:
  /// **'Backend từ chối đăng nhập Google'**
  String get googleBackendRejected;

  /// No description provided for @googleSha1Error.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi SHA-1 (ApiException: 10)'**
  String get googleSha1Error;

  /// No description provided for @googleOAuthError.
  ///
  /// In vi, this message translates to:
  /// **'OAuth config sai'**
  String get googleOAuthError;

  /// No description provided for @googleNetworkError.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi mạng hoặc Google Play'**
  String get googleNetworkError;

  /// No description provided for @googleSignInError.
  ///
  /// In vi, this message translates to:
  /// **'Google Sign-In lỗi: {msg}'**
  String googleSignInError(String msg);

  /// No description provided for @continueWithGoogle.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục với Google'**
  String get continueWithGoogle;

  /// No description provided for @createAccount.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản'**
  String get createAccount;

  /// No description provided for @freeNoCard.
  ///
  /// In vi, this message translates to:
  /// **'Miễn phí · Không cần thẻ'**
  String get freeNoCard;

  /// No description provided for @orUseEmail.
  ///
  /// In vi, this message translates to:
  /// **'hoặc dùng email'**
  String get orUseEmail;

  /// No description provided for @lastName.
  ///
  /// In vi, this message translates to:
  /// **'Họ'**
  String get lastName;

  /// No description provided for @enterLastName.
  ///
  /// In vi, this message translates to:
  /// **'Nhập họ'**
  String get enterLastName;

  /// No description provided for @tooShort.
  ///
  /// In vi, this message translates to:
  /// **'Quá ngắn'**
  String get tooShort;

  /// No description provided for @firstName.
  ///
  /// In vi, this message translates to:
  /// **'Tên'**
  String get firstName;

  /// No description provided for @enterFirstName.
  ///
  /// In vi, this message translates to:
  /// **'Nhập tên'**
  String get enterFirstName;

  /// No description provided for @phone.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại'**
  String get phone;

  /// No description provided for @enterPhone.
  ///
  /// In vi, this message translates to:
  /// **'Nhập số điện thoại'**
  String get enterPhone;

  /// No description provided for @passwordNeedsLetterNumber.
  ///
  /// In vi, this message translates to:
  /// **'Cần có cả chữ và số'**
  String get passwordNeedsLetterNumber;

  /// No description provided for @agreeToTerms.
  ///
  /// In vi, this message translates to:
  /// **'Tôi đồng ý với '**
  String get agreeToTerms;

  /// No description provided for @termsOfService.
  ///
  /// In vi, this message translates to:
  /// **'Điều khoản'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In vi, this message translates to:
  /// **'Chính sách bảo mật'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản? '**
  String get alreadyHaveAccount;

  /// No description provided for @agreeToTermsError.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng đồng ý với Điều khoản & Chính sách bảo mật'**
  String get agreeToTermsError;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In vi, this message translates to:
  /// **'Email này đã được đăng ký'**
  String get emailAlreadyRegistered;

  /// No description provided for @phoneAlreadyRegistered.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại này đã được đăng ký'**
  String get phoneAlreadyRegistered;

  /// No description provided for @noNetworkConnection.
  ///
  /// In vi, this message translates to:
  /// **'Không có kết nối mạng. Vui lòng thử lại.'**
  String get noNetworkConnection;

  /// No description provided for @registerFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thất bại. Vui lòng thử lại.'**
  String get registerFailed;

  /// No description provided for @morningGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng'**
  String get morningGreeting;

  /// No description provided for @afternoonGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi chiều'**
  String get afternoonGreeting;

  /// No description provided for @eveningGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi tối'**
  String get eveningGreeting;

  /// No description provided for @lessonsCompleted.
  ///
  /// In vi, this message translates to:
  /// **'Bài hoàn thành'**
  String get lessonsCompleted;

  /// No description provided for @minutesLearned.
  ///
  /// In vi, this message translates to:
  /// **'Phút học'**
  String get minutesLearned;

  /// No description provided for @avgScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm TB'**
  String get avgScore;

  /// No description provided for @thisWeek.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này'**
  String get thisWeek;

  /// No description provided for @currentlyLearning.
  ///
  /// In vi, this message translates to:
  /// **'Đang học'**
  String get currentlyLearning;

  /// No description provided for @noCourses.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có khóa học nào'**
  String get noCourses;

  /// No description provided for @exploreLearningPath.
  ///
  /// In vi, this message translates to:
  /// **'Hãy khám phá lộ trình học và bắt đầu bài học đầu tiên'**
  String get exploreLearningPath;

  /// No description provided for @explorePath.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá lộ trình học'**
  String get explorePath;

  /// No description provided for @continueLearning.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục học'**
  String get continueLearning;

  /// No description provided for @nextLesson.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp theo:'**
  String get nextLesson;

  /// No description provided for @skill.
  ///
  /// In vi, this message translates to:
  /// **'Kỹ năng'**
  String get skill;

  /// No description provided for @listening.
  ///
  /// In vi, this message translates to:
  /// **'Nghe'**
  String get listening;

  /// No description provided for @speaking.
  ///
  /// In vi, this message translates to:
  /// **'Nói'**
  String get speaking;

  /// No description provided for @reading.
  ///
  /// In vi, this message translates to:
  /// **'Đọc'**
  String get reading;

  /// No description provided for @writing.
  ///
  /// In vi, this message translates to:
  /// **'Viết'**
  String get writing;

  /// No description provided for @vocabulary.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng'**
  String get vocabulary;

  /// No description provided for @grammar.
  ///
  /// In vi, this message translates to:
  /// **'Ngữ pháp'**
  String get grammar;

  /// No description provided for @aiSuggestion.
  ///
  /// In vi, this message translates to:
  /// **'AI gợi ý'**
  String get aiSuggestion;

  /// No description provided for @focusImprove.
  ///
  /// In vi, this message translates to:
  /// **'Tập trung cải thiện {skill}'**
  String focusImprove(String skill);

  /// No description provided for @learningPath.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình học'**
  String get learningPath;

  /// No description provided for @myPath.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình của tôi'**
  String get myPath;

  /// No description provided for @explorePaths.
  ///
  /// In vi, this message translates to:
  /// **'Khám phá lộ trình'**
  String get explorePaths;

  /// No description provided for @otherPaths.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình khác'**
  String get otherPaths;

  /// No description provided for @noPathsYet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lộ trình nào'**
  String get noPathsYet;

  /// No description provided for @pathsWillAppear.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình sẽ xuất hiện khi được thêm vào hệ thống'**
  String get pathsWillAppear;

  /// No description provided for @official.
  ///
  /// In vi, this message translates to:
  /// **'OFFICIAL'**
  String get official;

  /// No description provided for @steps.
  ///
  /// In vi, this message translates to:
  /// **'{count} bước'**
  String steps(int count);

  /// No description provided for @estimatedHours.
  ///
  /// In vi, this message translates to:
  /// **'{hours}h'**
  String estimatedHours(String hours);

  /// No description provided for @cannotLoadPath.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được lộ trình'**
  String get cannotLoadPath;

  /// No description provided for @pathSteps.
  ///
  /// In vi, this message translates to:
  /// **'Các bước'**
  String get pathSteps;

  /// No description provided for @stepTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bước {order}'**
  String stepTitle(int order);

  /// No description provided for @optional.
  ///
  /// In vi, this message translates to:
  /// **'TÙY CHỌN'**
  String get optional;

  /// No description provided for @lessons.
  ///
  /// In vi, this message translates to:
  /// **'{count} bài'**
  String lessons(int count);

  /// No description provided for @enrollPath.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký lộ trình'**
  String get enrollPath;

  /// No description provided for @enrollToUnlock.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký để mở khóa'**
  String get enrollToUnlock;

  /// No description provided for @enrolledPath.
  ///
  /// In vi, this message translates to:
  /// **'Đã đăng ký lộ trình!'**
  String get enrolledPath;

  /// No description provided for @enrollFailed.
  ///
  /// In vi, this message translates to:
  /// **'Không thể đăng ký. Thử lại.'**
  String get enrollFailed;

  /// No description provided for @levelAndXp.
  ///
  /// In vi, this message translates to:
  /// **'Cấp độ & XP'**
  String get levelAndXp;

  /// No description provided for @levelTitle.
  ///
  /// In vi, this message translates to:
  /// **'Level {level} · {title}'**
  String levelTitle(int level, String title);

  /// No description provided for @totalXpAmount.
  ///
  /// In vi, this message translates to:
  /// **'{xp} tổng XP'**
  String totalXpAmount(String xp);

  /// No description provided for @xpToNextLevel.
  ///
  /// In vi, this message translates to:
  /// **'{xp} XP nữa lên Level {next}'**
  String xpToNextLevel(int xp, int next);

  /// No description provided for @xpThisWeek.
  ///
  /// In vi, this message translates to:
  /// **'XP tuần này'**
  String get xpThisWeek;

  /// No description provided for @totalXpLabel.
  ///
  /// In vi, this message translates to:
  /// **'Tổng XP'**
  String get totalXpLabel;

  /// No description provided for @completeLessons.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn thành bài học'**
  String get completeLessons;

  /// No description provided for @correctExercises.
  ///
  /// In vi, this message translates to:
  /// **'Bài tập đúng'**
  String get correctExercises;

  /// No description provided for @streakDays.
  ///
  /// In vi, this message translates to:
  /// **'Streak ngày học'**
  String get streakDays;

  /// No description provided for @perfectScore.
  ///
  /// In vi, this message translates to:
  /// **'Điểm hoàn hảo'**
  String get perfectScore;

  /// No description provided for @howToEarnXp.
  ///
  /// In vi, this message translates to:
  /// **'CÁCH TÍCH LŨY XP'**
  String get howToEarnXp;

  /// No description provided for @xpByDay.
  ///
  /// In vi, this message translates to:
  /// **'XP THEO NGÀY (TUẦN NÀY)'**
  String get xpByDay;

  /// No description provided for @streakProgress.
  ///
  /// In vi, this message translates to:
  /// **'Tiến trình học'**
  String get streakProgress;

  /// No description provided for @daysInARow.
  ///
  /// In vi, this message translates to:
  /// **'ngày liên tiếp'**
  String get daysInARow;

  /// No description provided for @studiedToday.
  ///
  /// In vi, this message translates to:
  /// **'✓ Đã học hôm nay'**
  String get studiedToday;

  /// No description provided for @longestStreak.
  ///
  /// In vi, this message translates to:
  /// **'Dài nhất'**
  String get longestStreak;

  /// No description provided for @totalDays.
  ///
  /// In vi, this message translates to:
  /// **'Tổng ngày'**
  String get totalDays;

  /// No description provided for @freezeLeft.
  ///
  /// In vi, this message translates to:
  /// **'Freeze còn'**
  String get freezeLeft;

  /// No description provided for @heatmapThisMonth.
  ///
  /// In vi, this message translates to:
  /// **'HEATMAP THÁNG NÀY'**
  String get heatmapThisMonth;

  /// No description provided for @few.
  ///
  /// In vi, this message translates to:
  /// **'Ít'**
  String get few;

  /// No description provided for @many.
  ///
  /// In vi, this message translates to:
  /// **'Nhiều'**
  String get many;

  /// No description provided for @today.
  ///
  /// In vi, this message translates to:
  /// **'Hôm nay'**
  String get today;

  /// No description provided for @weeklyReport.
  ///
  /// In vi, this message translates to:
  /// **'Báo cáo tuần'**
  String get weeklyReport;

  /// No description provided for @thisWeekYouHave.
  ///
  /// In vi, this message translates to:
  /// **'Tuần này bạn đã'**
  String get thisWeekYouHave;

  /// No description provided for @studyDays.
  ///
  /// In vi, this message translates to:
  /// **'Ngày học'**
  String get studyDays;

  /// No description provided for @bestStreak.
  ///
  /// In vi, this message translates to:
  /// **'Streak cao nhất'**
  String get bestStreak;

  /// No description provided for @xpEarned.
  ///
  /// In vi, this message translates to:
  /// **'XP kiếm được'**
  String get xpEarned;

  /// No description provided for @lessonsDone.
  ///
  /// In vi, this message translates to:
  /// **'Bài học xong'**
  String get lessonsDone;

  /// No description provided for @avgPerDay.
  ///
  /// In vi, this message translates to:
  /// **'TB / ngày'**
  String get avgPerDay;

  /// No description provided for @lessonsByDay.
  ///
  /// In vi, this message translates to:
  /// **'BÀI HỌC THEO NGÀY'**
  String get lessonsByDay;

  /// No description provided for @detailEachDay.
  ///
  /// In vi, this message translates to:
  /// **'CHI TIẾT TỪNG NGÀY'**
  String get detailEachDay;

  /// No description provided for @lessonCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} bài'**
  String lessonCount(int count);

  /// No description provided for @noSessionsThisWeek.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có phiên học nào trong tuần này'**
  String get noSessionsThisWeek;

  /// No description provided for @mon.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 2'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 3'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 4'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 5'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 6'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In vi, this message translates to:
  /// **'Thứ 7'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In vi, this message translates to:
  /// **'CN'**
  String get sun;

  /// No description provided for @badges.
  ///
  /// In vi, this message translates to:
  /// **'Huy hiệu'**
  String get badges;

  /// No description provided for @collection.
  ///
  /// In vi, this message translates to:
  /// **'Bộ sưu tập'**
  String get collection;

  /// No description provided for @achieved.
  ///
  /// In vi, this message translates to:
  /// **'ĐÃ ĐẠT ĐƯỢC'**
  String get achieved;

  /// No description provided for @locked.
  ///
  /// In vi, this message translates to:
  /// **'CHƯA MỞ KHÓA'**
  String get locked;

  /// No description provided for @achievedBadge.
  ///
  /// In vi, this message translates to:
  /// **'✓ Đã đạt được'**
  String get achievedBadge;

  /// No description provided for @lockedBadge.
  ///
  /// In vi, this message translates to:
  /// **'🔒 Chưa mở khóa'**
  String get lockedBadge;

  /// No description provided for @courseLessons.
  ///
  /// In vi, this message translates to:
  /// **'{completed} / {total} bài hoàn thành'**
  String courseLessons(int completed, int total);

  /// No description provided for @noLessonsYet.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có bài học nào'**
  String get noLessonsYet;

  /// No description provided for @lessonsComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Bài học sẽ được thêm vào sớm'**
  String get lessonsComingSoon;

  /// No description provided for @lessonRequiresPlan.
  ///
  /// In vi, this message translates to:
  /// **'Bài học này yêu cầu gói cao hơn'**
  String get lessonRequiresPlan;

  /// No description provided for @excellent.
  ///
  /// In vi, this message translates to:
  /// **'Xuất sắc! 🎉'**
  String get excellent;

  /// No description provided for @goodJob.
  ///
  /// In vi, this message translates to:
  /// **'Tốt lắm! 👍'**
  String get goodJob;

  /// No description provided for @tryHarder.
  ///
  /// In vi, this message translates to:
  /// **'Cố gắng hơn!'**
  String get tryHarder;

  /// No description provided for @needMorePractice.
  ///
  /// In vi, this message translates to:
  /// **'Cần ôn tập thêm'**
  String get needMorePractice;

  /// No description provided for @reviewWrongAnswers.
  ///
  /// In vi, this message translates to:
  /// **'Review câu sai'**
  String get reviewWrongAnswers;

  /// No description provided for @questionProgress.
  ///
  /// In vi, this message translates to:
  /// **'{current} / {total}'**
  String questionProgress(int current, int total);

  /// No description provided for @noFlashcards.
  ///
  /// In vi, this message translates to:
  /// **'Không có thẻ từ vựng'**
  String get noFlashcards;

  /// No description provided for @aiTeacher.
  ///
  /// In vi, this message translates to:
  /// **'AI Teacher'**
  String get aiTeacher;

  /// No description provided for @aiTutor.
  ///
  /// In vi, this message translates to:
  /// **'Gia sư ngôn ngữ thông minh'**
  String get aiTutor;

  /// No description provided for @remainingToday.
  ///
  /// In vi, this message translates to:
  /// **'{count} còn lại'**
  String remainingToday(int count);

  /// No description provided for @suggestedQuestions.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý câu hỏi:'**
  String get suggestedQuestions;

  /// No description provided for @askAiTeacher.
  ///
  /// In vi, this message translates to:
  /// **'Hỏi AI Teacher...'**
  String get askAiTeacher;

  /// No description provided for @aiConnectionError.
  ///
  /// In vi, this message translates to:
  /// **'❌ Không thể kết nối đến AI. Vui lòng kiểm tra mạng và thử lại.'**
  String get aiConnectionError;

  /// No description provided for @aiGrammarCheck.
  ///
  /// In vi, this message translates to:
  /// **'AI Grammar Check'**
  String get aiGrammarCheck;

  /// No description provided for @checkAndFixGrammar.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra và sửa lỗi ngữ pháp'**
  String get checkAndFixGrammar;

  /// No description provided for @refresh.
  ///
  /// In vi, this message translates to:
  /// **'Làm mới'**
  String get refresh;

  /// No description provided for @enterSentenceToCheck.
  ///
  /// In vi, this message translates to:
  /// **'Nhập câu cần kiểm tra'**
  String get enterSentenceToCheck;

  /// No description provided for @paste.
  ///
  /// In vi, this message translates to:
  /// **'Dán'**
  String get paste;

  /// No description provided for @check.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra'**
  String get check;

  /// No description provided for @trySampleSentences.
  ///
  /// In vi, this message translates to:
  /// **'Thử với câu mẫu:'**
  String get trySampleSentences;

  /// No description provided for @aiAnalyzing.
  ///
  /// In vi, this message translates to:
  /// **'AI đang phân tích...'**
  String get aiAnalyzing;

  /// No description provided for @checkingGrammar.
  ///
  /// In vi, this message translates to:
  /// **'Đang kiểm tra ngữ pháp, chính tả và cách dùng từ'**
  String get checkingGrammar;

  /// No description provided for @sentenceCorrect.
  ///
  /// In vi, this message translates to:
  /// **'Câu đúng ngữ pháp! ✓'**
  String get sentenceCorrect;

  /// No description provided for @grammarErrorsFound.
  ///
  /// In vi, this message translates to:
  /// **'Phát hiện lỗi ngữ pháp'**
  String get grammarErrorsFound;

  /// No description provided for @sentencePerfect.
  ///
  /// In vi, this message translates to:
  /// **'Câu văn này hoàn toàn chính xác.'**
  String get sentencePerfect;

  /// No description provided for @errorsFound.
  ///
  /// In vi, this message translates to:
  /// **'{count} lỗi được tìm thấy'**
  String errorsFound(int count);

  /// No description provided for @correctedSentence.
  ///
  /// In vi, this message translates to:
  /// **'Câu đã sửa'**
  String get correctedSentence;

  /// No description provided for @copiedCorrectedSentence.
  ///
  /// In vi, this message translates to:
  /// **'Đã sao chép câu đã sửa'**
  String get copiedCorrectedSentence;

  /// No description provided for @errorDetails.
  ///
  /// In vi, this message translates to:
  /// **'Chi tiết lỗi'**
  String get errorDetails;

  /// No description provided for @betterExpressions.
  ///
  /// In vi, this message translates to:
  /// **'Cách diễn đạt tốt hơn'**
  String get betterExpressions;

  /// No description provided for @explanation.
  ///
  /// In vi, this message translates to:
  /// **'Giải thích:'**
  String get explanation;

  /// No description provided for @grammarType.
  ///
  /// In vi, this message translates to:
  /// **'Ngữ pháp'**
  String get grammarType;

  /// No description provided for @spellingType.
  ///
  /// In vi, this message translates to:
  /// **'Chính tả'**
  String get spellingType;

  /// No description provided for @punctuationType.
  ///
  /// In vi, this message translates to:
  /// **'Dấu câu'**
  String get punctuationType;

  /// No description provided for @wordCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} từ'**
  String wordCount(int count);

  /// No description provided for @aiRecommendation.
  ///
  /// In vi, this message translates to:
  /// **'AI Recommendation'**
  String get aiRecommendation;

  /// No description provided for @lessonSuggestions.
  ///
  /// In vi, this message translates to:
  /// **'Gợi ý bài học phù hợp với bạn'**
  String get lessonSuggestions;

  /// No description provided for @aiAnalyzingPath.
  ///
  /// In vi, this message translates to:
  /// **'AI đang phân tích...'**
  String get aiAnalyzingPath;

  /// No description provided for @reviewingPath.
  ///
  /// In vi, this message translates to:
  /// **'Đang xem xét lộ trình học của bạn'**
  String get reviewingPath;

  /// No description provided for @learningOverview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan học tập của bạn'**
  String get learningOverview;

  /// No description provided for @avgScoreLabel.
  ///
  /// In vi, this message translates to:
  /// **'TB điểm'**
  String get avgScoreLabel;

  /// No description provided for @streakDaysLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngày streak'**
  String get streakDaysLabel;

  /// No description provided for @completedLessons.
  ///
  /// In vi, this message translates to:
  /// **'Bài hoàn thành'**
  String get completedLessons;

  /// No description provided for @aiAdvice.
  ///
  /// In vi, this message translates to:
  /// **'Lời khuyên từ AI'**
  String get aiAdvice;

  /// No description provided for @skillsToFocus.
  ///
  /// In vi, this message translates to:
  /// **'Kỹ năng cần tập trung'**
  String get skillsToFocus;

  /// No description provided for @suggestedLessons.
  ///
  /// In vi, this message translates to:
  /// **'Bài học được gợi ý'**
  String get suggestedLessons;

  /// No description provided for @lessonSuggestion.
  ///
  /// In vi, this message translates to:
  /// **'Bài học gợi ý'**
  String get lessonSuggestion;

  /// No description provided for @hot.
  ///
  /// In vi, this message translates to:
  /// **'Hot'**
  String get hot;

  /// No description provided for @cannotCreateSuggestion.
  ///
  /// In vi, this message translates to:
  /// **'Không thể tạo gợi ý. Vui lòng thử lại.'**
  String get cannotCreateSuggestion;

  /// No description provided for @aiVocabulary.
  ///
  /// In vi, this message translates to:
  /// **'AI Vocabulary'**
  String get aiVocabulary;

  /// No description provided for @smartDictionary.
  ///
  /// In vi, this message translates to:
  /// **'Tra từ điển thông minh'**
  String get smartDictionary;

  /// No description provided for @enterEnglishWord.
  ///
  /// In vi, this message translates to:
  /// **'Nhập từ tiếng Anh...'**
  String get enterEnglishWord;

  /// No description provided for @lookup.
  ///
  /// In vi, this message translates to:
  /// **'Tra'**
  String get lookup;

  /// No description provided for @ipaTranscription.
  ///
  /// In vi, this message translates to:
  /// **'Phiên âm IPA'**
  String get ipaTranscription;

  /// No description provided for @memorizationTip.
  ///
  /// In vi, this message translates to:
  /// **'Mẹo ghi nhớ'**
  String get memorizationTip;

  /// No description provided for @synonymsAntonyms.
  ///
  /// In vi, this message translates to:
  /// **'Từ đồng/trái nghĩa'**
  String get synonymsAntonyms;

  /// No description provided for @realExamples.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ thực tế'**
  String get realExamples;

  /// No description provided for @lookingUpWord.
  ///
  /// In vi, this message translates to:
  /// **'Đang tra từ điển...'**
  String get lookingUpWord;

  /// No description provided for @aiSynthesizing.
  ///
  /// In vi, this message translates to:
  /// **'AI đang tổng hợp thông tin từ vựng'**
  String get aiSynthesizing;

  /// No description provided for @overview.
  ///
  /// In vi, this message translates to:
  /// **'Tổng quan'**
  String get overview;

  /// No description provided for @examples.
  ///
  /// In vi, this message translates to:
  /// **'Ví dụ'**
  String get examples;

  /// No description provided for @related.
  ///
  /// In vi, this message translates to:
  /// **'Liên quan'**
  String get related;

  /// No description provided for @commonPhrases.
  ///
  /// In vi, this message translates to:
  /// **'Cụm từ thường gặp'**
  String get commonPhrases;

  /// No description provided for @noExamples.
  ///
  /// In vi, this message translates to:
  /// **'Không có ví dụ'**
  String get noExamples;

  /// No description provided for @noRelatedData.
  ///
  /// In vi, this message translates to:
  /// **'Không có dữ liệu liên quan'**
  String get noRelatedData;

  /// No description provided for @synonyms.
  ///
  /// In vi, this message translates to:
  /// **'Từ đồng nghĩa'**
  String get synonyms;

  /// No description provided for @antonyms.
  ///
  /// In vi, this message translates to:
  /// **'Từ trái nghĩa'**
  String get antonyms;

  /// No description provided for @slow.
  ///
  /// In vi, this message translates to:
  /// **'chậm'**
  String get slow;

  /// No description provided for @wordCountLabel.
  ///
  /// In vi, this message translates to:
  /// **'{count} từ'**
  String wordCountLabel(int count);

  /// No description provided for @editProfile.
  ///
  /// In vi, this message translates to:
  /// **'Chỉnh sửa hồ sơ'**
  String get editProfile;

  /// No description provided for @lastNameRequired.
  ///
  /// In vi, this message translates to:
  /// **'Họ không được để trống'**
  String get lastNameRequired;

  /// No description provided for @profileUpdated.
  ///
  /// In vi, this message translates to:
  /// **'Đã cập nhật hồ sơ'**
  String get profileUpdated;

  /// No description provided for @updateFailed.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật thất bại. Thử lại.'**
  String get updateFailed;

  /// No description provided for @user.
  ///
  /// In vi, this message translates to:
  /// **'Người dùng'**
  String get user;

  /// No description provided for @changePassword.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu'**
  String get changePassword;

  /// No description provided for @setPassword.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mật khẩu'**
  String get setPassword;

  /// No description provided for @passwordSetSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Tạo mật khẩu thành công! Bạn có thể đăng nhập bằng email.'**
  String get passwordSetSuccess;

  /// No description provided for @googleSetPasswordInfo.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản của bạn được đăng nhập qua Google. Tạo mật khẩu để có thể đăng nhập bằng email.'**
  String get googleSetPasswordInfo;

  /// No description provided for @currentPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu hiện tại'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận mật khẩu mới'**
  String get confirmNewPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu tối thiểu 6 ký tự'**
  String get passwordMinLength;

  /// No description provided for @fillAllFields.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng điền đầy đủ thông tin'**
  String get fillAllFields;

  /// No description provided for @newPasswordMinLength.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới phải có ít nhất 6 ký tự'**
  String get newPasswordMinLength;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đổi mật khẩu thành công'**
  String get passwordChangedSuccess;

  /// No description provided for @currentPasswordWrong.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu hiện tại không đúng'**
  String get currentPasswordWrong;

  /// No description provided for @passwordRecentlyUsed.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới không được trùng với 2 mật khẩu gần nhất'**
  String get passwordRecentlyUsed;

  /// No description provided for @saving.
  ///
  /// In vi, this message translates to:
  /// **'Đang lưu...'**
  String get saving;

  /// No description provided for @logoutConfirm.
  ///
  /// In vi, this message translates to:
  /// **'Bạn có chắc muốn đăng xuất?'**
  String get logoutConfirm;

  /// No description provided for @settingsLearning.
  ///
  /// In vi, this message translates to:
  /// **'HỌC TẬP'**
  String get settingsLearning;

  /// No description provided for @settingsNotifications.
  ///
  /// In vi, this message translates to:
  /// **'THÔNG BÁO'**
  String get settingsNotifications;

  /// No description provided for @settingsSecurity.
  ///
  /// In vi, this message translates to:
  /// **'BẢO MẬT'**
  String get settingsSecurity;

  /// No description provided for @cancelAutoRenew.
  ///
  /// In vi, this message translates to:
  /// **'Hủy gia hạn tự động'**
  String get cancelAutoRenew;

  /// No description provided for @cancelAutoRenewDesc.
  ///
  /// In vi, this message translates to:
  /// **'Gói Pro vẫn còn hiệu lực đến ngày hết hạn. Sau đó sẽ không gia hạn tự động.'**
  String get cancelAutoRenewDesc;

  /// No description provided for @keepPlan.
  ///
  /// In vi, this message translates to:
  /// **'Giữ nguyên'**
  String get keepPlan;

  /// No description provided for @cancelRenewal.
  ///
  /// In vi, this message translates to:
  /// **'Hủy gia hạn'**
  String get cancelRenewal;

  /// No description provided for @invoiceTitle.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán thành công!'**
  String get invoiceTitle;

  /// No description provided for @welcomeToPro.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng bạn đến với Pro'**
  String get welcomeToPro;

  /// No description provided for @choosePlan.
  ///
  /// In vi, this message translates to:
  /// **'Chọn gói'**
  String get choosePlan;

  /// No description provided for @onboardingLanguageTitle.
  ///
  /// In vi, this message translates to:
  /// **'Bạn muốn học ngôn ngữ\nnào?'**
  String get onboardingLanguageTitle;

  /// No description provided for @onboardingLanguageSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'Có thể chọn nhiều ngôn ngữ'**
  String get onboardingLanguageSubtitle;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu của bạn là\ngì?'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'AI sẽ tạo lộ trình phù hợp nhất'**
  String get onboardingGoalSubtitle;

  /// No description provided for @goalCommunication.
  ///
  /// In vi, this message translates to:
  /// **'Giao tiếp hàng ngày'**
  String get goalCommunication;

  /// No description provided for @goalStudyAbroad.
  ///
  /// In vi, this message translates to:
  /// **'Du học / định cư'**
  String get goalStudyAbroad;

  /// No description provided for @goalWork.
  ///
  /// In vi, this message translates to:
  /// **'Công việc / kinh doanh'**
  String get goalWork;

  /// No description provided for @goalTravel.
  ///
  /// In vi, this message translates to:
  /// **'Du lịch / khám phá'**
  String get goalTravel;

  /// No description provided for @goalOther.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu khác'**
  String get goalOther;

  /// No description provided for @onboardingPersonalizeTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cá nhân hóa lộ trình'**
  String get onboardingPersonalizeTitle;

  /// No description provided for @dailyMinutes.
  ///
  /// In vi, this message translates to:
  /// **'Học bao nhiêu phút mỗi ngày?'**
  String get dailyMinutes;

  /// No description provided for @minutes.
  ///
  /// In vi, this message translates to:
  /// **'phút'**
  String get minutes;

  /// No description provided for @ageRange.
  ///
  /// In vi, this message translates to:
  /// **'Khoảng tuổi của bạn?'**
  String get ageRange;

  /// No description provided for @ageUnder18.
  ///
  /// In vi, this message translates to:
  /// **'Dưới 18'**
  String get ageUnder18;

  /// No description provided for @age1824.
  ///
  /// In vi, this message translates to:
  /// **'18 – 24'**
  String get age1824;

  /// No description provided for @age2534.
  ///
  /// In vi, this message translates to:
  /// **'25 – 34'**
  String get age2534;

  /// No description provided for @age3544.
  ///
  /// In vi, this message translates to:
  /// **'35 – 44'**
  String get age3544;

  /// No description provided for @age45plus.
  ///
  /// In vi, this message translates to:
  /// **'45+'**
  String get age45plus;

  /// No description provided for @onboardingStep.
  ///
  /// In vi, this message translates to:
  /// **'Bước {step} / {total}'**
  String onboardingStep(int step, int total);

  /// No description provided for @cannotLoadLanguages.
  ///
  /// In vi, this message translates to:
  /// **'Không tải được danh sách ngôn ngữ'**
  String get cannotLoadLanguages;

  /// No description provided for @checkNetworkAndBackend.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra kết nối mạng và backend, sau đó thử lại.'**
  String get checkNetworkAndBackend;

  /// No description provided for @yourLevel.
  ///
  /// In vi, this message translates to:
  /// **'Trình độ của bạn'**
  String get yourLevel;

  /// No description provided for @correctAnswers.
  ///
  /// In vi, this message translates to:
  /// **'{score} / {total} câu đúng'**
  String correctAnswers(int score, int total);

  /// No description provided for @free.
  ///
  /// In vi, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @enabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang bật'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In vi, this message translates to:
  /// **'Đang tắt'**
  String get disabled;

  /// No description provided for @invalidPhone.
  ///
  /// In vi, this message translates to:
  /// **'Số điện thoại không hợp lệ'**
  String get invalidPhone;

  /// No description provided for @minEightChars.
  ///
  /// In vi, this message translates to:
  /// **'Ít nhất 8 ký tự'**
  String get minEightChars;

  /// No description provided for @takePhoto.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh'**
  String get takePhoto;

  /// No description provided for @selectFromLibrary.
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ thư viện'**
  String get selectFromLibrary;

  /// No description provided for @uploadPhotoFailed.
  ///
  /// In vi, this message translates to:
  /// **'Upload ảnh thất bại, thử lại nhé'**
  String get uploadPhotoFailed;

  /// No description provided for @basicInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cơ bản'**
  String get basicInfo;

  /// No description provided for @contactLocation.
  ///
  /// In vi, this message translates to:
  /// **'Liên hệ & Vị trí'**
  String get contactLocation;

  /// No description provided for @country.
  ///
  /// In vi, this message translates to:
  /// **'Quốc gia'**
  String get country;

  /// No description provided for @timezone.
  ///
  /// In vi, this message translates to:
  /// **'Múi giờ'**
  String get timezone;

  /// No description provided for @selectTimezone.
  ///
  /// In vi, this message translates to:
  /// **'Chọn múi giờ'**
  String get selectTimezone;

  /// No description provided for @personalInfo.
  ///
  /// In vi, this message translates to:
  /// **'Thông tin cá nhân'**
  String get personalInfo;

  /// No description provided for @gender.
  ///
  /// In vi, this message translates to:
  /// **'Giới tính'**
  String get gender;

  /// No description provided for @selectGender.
  ///
  /// In vi, this message translates to:
  /// **'Chọn giới tính'**
  String get selectGender;

  /// No description provided for @aboutYourself.
  ///
  /// In vi, this message translates to:
  /// **'Giới thiệu bản thân'**
  String get aboutYourself;

  /// No description provided for @bioHint.
  ///
  /// In vi, this message translates to:
  /// **'Viết vài dòng về bản thân...'**
  String get bioHint;

  /// No description provided for @dateOfBirth.
  ///
  /// In vi, this message translates to:
  /// **'Ngày sinh'**
  String get dateOfBirth;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In vi, this message translates to:
  /// **'Chọn ngày sinh'**
  String get selectDateOfBirth;

  /// No description provided for @phoneHint.
  ///
  /// In vi, this message translates to:
  /// **'+84 xxx xxx xxx'**
  String get phoneHint;

  /// No description provided for @dailyReminder.
  ///
  /// In vi, this message translates to:
  /// **'Nhắc nhở học hàng ngày'**
  String get dailyReminder;

  /// No description provided for @reminderTime.
  ///
  /// In vi, this message translates to:
  /// **'Giờ nhắc nhở'**
  String get reminderTime;

  /// No description provided for @sendTestNotification.
  ///
  /// In vi, this message translates to:
  /// **'Gửi thử notification'**
  String get sendTestNotification;

  /// No description provided for @testNotificationSent.
  ///
  /// In vi, this message translates to:
  /// **'Đã gửi test notification!'**
  String get testNotificationSent;

  /// No description provided for @twoFactorAuth.
  ///
  /// In vi, this message translates to:
  /// **'Xác thực 2 lớp (2FA)'**
  String get twoFactorAuth;

  /// No description provided for @twoFaComingSoon.
  ///
  /// In vi, this message translates to:
  /// **'Tính năng 2FA sẽ ra mắt trong bản cập nhật tới'**
  String get twoFaComingSoon;

  /// No description provided for @proMember.
  ///
  /// In vi, this message translates to:
  /// **'Pro Member'**
  String get proMember;

  /// No description provided for @pathAndLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình & ngôn ngữ'**
  String get pathAndLanguage;

  /// No description provided for @badgesAchievements.
  ///
  /// In vi, this message translates to:
  /// **'Huy hiệu & thành tích'**
  String get badgesAchievements;

  /// No description provided for @subscriptionBilling.
  ///
  /// In vi, this message translates to:
  /// **'Subscription & Billing'**
  String get subscriptionBilling;

  /// No description provided for @currentPlan.
  ///
  /// In vi, this message translates to:
  /// **'Gói hiện tại'**
  String get currentPlan;

  /// No description provided for @activeStatus.
  ///
  /// In vi, this message translates to:
  /// **'Đang hoạt động'**
  String get activeStatus;

  /// No description provided for @startDate.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get startDate;

  /// No description provided for @renewalDate.
  ///
  /// In vi, this message translates to:
  /// **'Gia hạn tiếp'**
  String get renewalDate;

  /// No description provided for @paymentMethod.
  ///
  /// In vi, this message translates to:
  /// **'Phương thức thanh toán'**
  String get paymentMethod;

  /// No description provided for @upgradeToYearly.
  ///
  /// In vi, this message translates to:
  /// **'Nâng lên Yearly'**
  String get upgradeToYearly;

  /// No description provided for @paymentHistory.
  ///
  /// In vi, this message translates to:
  /// **'Lịch sử thanh toán'**
  String get paymentHistory;

  /// No description provided for @noPaymentHistory.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có lịch sử thanh toán'**
  String get noPaymentHistory;

  /// No description provided for @securePaymentNotice.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán an toàn • Hủy bất kỳ lúc nào'**
  String get securePaymentNotice;

  /// No description provided for @waitingPaymentResult.
  ///
  /// In vi, this message translates to:
  /// **'Đang chờ kết quả thanh toán'**
  String get waitingPaymentResult;

  /// No description provided for @cancelWaiting.
  ///
  /// In vi, this message translates to:
  /// **'Hủy chờ'**
  String get cancelWaiting;

  /// No description provided for @orderSummary.
  ///
  /// In vi, this message translates to:
  /// **'Đơn hàng'**
  String get orderSummary;

  /// No description provided for @totalPayment.
  ///
  /// In vi, this message translates to:
  /// **'Tổng thanh toán'**
  String get totalPayment;

  /// No description provided for @monthly.
  ///
  /// In vi, this message translates to:
  /// **'Hàng tháng'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In vi, this message translates to:
  /// **'Hàng năm'**
  String get yearly;

  /// No description provided for @mostPopular.
  ///
  /// In vi, this message translates to:
  /// **'Phổ biến nhất'**
  String get mostPopular;

  /// No description provided for @perMonth.
  ///
  /// In vi, this message translates to:
  /// **'/tháng'**
  String get perMonth;

  /// No description provided for @perYear.
  ///
  /// In vi, this message translates to:
  /// **'/năm'**
  String get perYear;

  /// No description provided for @cancelAnytime.
  ///
  /// In vi, this message translates to:
  /// **'Hủy bất kỳ lúc nào trong Settings'**
  String get cancelAnytime;

  /// No description provided for @seeResults.
  ///
  /// In vi, this message translates to:
  /// **'Xem kết quả'**
  String get seeResults;

  /// No description provided for @nextQuestion.
  ///
  /// In vi, this message translates to:
  /// **'Câu tiếp theo'**
  String get nextQuestion;

  /// No description provided for @dailyXpGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu XP mỗi ngày'**
  String get dailyXpGoal;

  /// No description provided for @learningStyle.
  ///
  /// In vi, this message translates to:
  /// **'Phong cách học'**
  String get learningStyle;

  /// No description provided for @selectXpGoal.
  ///
  /// In vi, this message translates to:
  /// **'Chọn mục tiêu XP'**
  String get selectXpGoal;

  /// No description provided for @selectLearningStyle.
  ///
  /// In vi, this message translates to:
  /// **'Chọn phong cách học'**
  String get selectLearningStyle;

  /// No description provided for @secureLabel.
  ///
  /// In vi, this message translates to:
  /// **'Bảo mật'**
  String get secureLabel;

  /// No description provided for @paymentLabel.
  ///
  /// In vi, this message translates to:
  /// **'Thanh toán'**
  String get paymentLabel;

  /// No description provided for @completePaymentInstruction.
  ///
  /// In vi, this message translates to:
  /// **'Hoàn tất thanh toán trong cửa sổ vừa mở, sau đó quay lại app.'**
  String get completePaymentInstruction;

  /// No description provided for @autoRenewal.
  ///
  /// In vi, this message translates to:
  /// **'Tự động gia hạn mỗi {period}. Hủy bất kỳ lúc nào.'**
  String autoRenewal(String period);

  /// No description provided for @subscribePlan.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký {plan}'**
  String subscribePlan(String plan);

  /// No description provided for @currentPlanCheck.
  ///
  /// In vi, this message translates to:
  /// **'✓ Gói hiện tại'**
  String get currentPlanCheck;
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
      <String>['en', 'ja', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
