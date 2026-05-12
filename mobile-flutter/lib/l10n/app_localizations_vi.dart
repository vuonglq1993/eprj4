// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'LinguaNext';

  @override
  String get login => 'Đăng nhập';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get register => 'Đăng ký';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get loginWithGoogle => 'Tiếp tục với Google';

  @override
  String get home => 'Trang chủ';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get settings => 'Cài đặt';

  @override
  String get learn => 'Học';

  @override
  String get leaderboard => 'Xếp hạng';

  @override
  String get path => 'Lộ trình';

  @override
  String get continueLesson => 'Tiếp tục học';

  @override
  String get todayGoal => 'Mục tiêu hôm nay';

  @override
  String get streak => 'Streak';

  @override
  String get totalXp => 'Tổng XP';

  @override
  String get daysLearned => 'Ngày học';

  @override
  String get subscription => 'Gói đăng ký';

  @override
  String get upgradeToPro => 'Nâng cấp Pro';

  @override
  String get payNow => 'Thanh toán ngay';

  @override
  String get paymentSuccess => 'Thanh toán thành công!';

  @override
  String get paymentFailed => 'Thanh toán thất bại hoặc bị hủy';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get interfaceLanguage => 'Ngôn ngữ giao diện';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get save => 'Lưu';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get back => 'Quay lại';

  @override
  String get next => 'Tiếp theo';

  @override
  String get done => 'Hoàn thành';

  @override
  String get loading => 'Đang tải...';

  @override
  String get error => 'Đã có lỗi xảy ra';

  @override
  String get retry => 'Thử lại';

  @override
  String get close => 'Đóng';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get processing => 'Đang xử lý...';

  @override
  String get featureInDevelopment => 'Tính năng đang phát triển';

  @override
  String get splashTagline => 'Học ngoại ngữ thông minh\ncùng AI cá nhân hóa';

  @override
  String get splashGetStarted => 'Bắt đầu miễn phí';

  @override
  String get welcomeBack => 'Chào mừng trở lại';

  @override
  String get loginToContinue => 'Đăng nhập để tiếp tục học';

  @override
  String get orEmail => 'hoặc email';

  @override
  String get invalidEmail => 'Email không hợp lệ';

  @override
  String get enterEmail => 'Nhập email';

  @override
  String get enterPassword => 'Nhập mật khẩu';

  @override
  String get wrongCredentials => 'Email hoặc mật khẩu không đúng';

  @override
  String get twoFaTitle => 'Bật xác thực 2 lớp (2FA)\nđể bảo vệ tài khoản';

  @override
  String get twoFaActivated => '2FA sẽ được kích hoạt sau khi đăng nhập';

  @override
  String get noAccount => 'Chưa có tài khoản? ';

  @override
  String get googleIdTokenError =>
      'Không lấy được idToken. Kiểm tra Web Client ID.';

  @override
  String get googleBackendRejected => 'Backend từ chối đăng nhập Google';

  @override
  String get googleSha1Error => 'Lỗi SHA-1 (ApiException: 10)';

  @override
  String get googleOAuthError => 'OAuth config sai';

  @override
  String get googleNetworkError => 'Lỗi mạng hoặc Google Play';

  @override
  String googleSignInError(String msg) {
    return 'Google Sign-In lỗi: $msg';
  }

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get freeNoCard => 'Miễn phí · Không cần thẻ';

  @override
  String get orUseEmail => 'hoặc dùng email';

  @override
  String get lastName => 'Họ';

  @override
  String get enterLastName => 'Nhập họ';

  @override
  String get tooShort => 'Quá ngắn';

  @override
  String get firstName => 'Tên';

  @override
  String get enterFirstName => 'Nhập tên';

  @override
  String get phone => 'Số điện thoại';

  @override
  String get enterPhone => 'Nhập số điện thoại';

  @override
  String get passwordNeedsLetterNumber => 'Cần có cả chữ và số';

  @override
  String get agreeToTerms => 'Tôi đồng ý với ';

  @override
  String get termsOfService => 'Điều khoản';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản? ';

  @override
  String get agreeToTermsError =>
      'Vui lòng đồng ý với Điều khoản & Chính sách bảo mật';

  @override
  String get emailAlreadyRegistered => 'Email này đã được đăng ký';

  @override
  String get phoneAlreadyRegistered => 'Số điện thoại này đã được đăng ký';

  @override
  String get noNetworkConnection => 'Không có kết nối mạng. Vui lòng thử lại.';

  @override
  String get registerFailed => 'Đăng ký thất bại. Vui lòng thử lại.';

  @override
  String get morningGreeting => 'Chào buổi sáng';

  @override
  String get afternoonGreeting => 'Chào buổi chiều';

  @override
  String get eveningGreeting => 'Chào buổi tối';

  @override
  String get lessonsCompleted => 'Bài hoàn thành';

  @override
  String get minutesLearned => 'Phút học';

  @override
  String get avgScore => 'Điểm TB';

  @override
  String get thisWeek => 'Tuần này';

  @override
  String get currentlyLearning => 'Đang học';

  @override
  String get noCourses => 'Chưa có khóa học nào';

  @override
  String get exploreLearningPath =>
      'Hãy khám phá lộ trình học và bắt đầu bài học đầu tiên';

  @override
  String get explorePath => 'Khám phá lộ trình học';

  @override
  String get continueLearning => 'Tiếp tục học';

  @override
  String get nextLesson => 'Tiếp theo:';

  @override
  String get skill => 'Kỹ năng';

  @override
  String get listening => 'Nghe';

  @override
  String get speaking => 'Nói';

  @override
  String get reading => 'Đọc';

  @override
  String get writing => 'Viết';

  @override
  String get vocabulary => 'Từ vựng';

  @override
  String get grammar => 'Ngữ pháp';

  @override
  String get aiSuggestion => 'AI gợi ý';

  @override
  String focusImprove(String skill) {
    return 'Tập trung cải thiện $skill';
  }

  @override
  String get learningPath => 'Lộ trình học';

  @override
  String get myPath => 'Lộ trình của tôi';

  @override
  String get explorePaths => 'Khám phá lộ trình';

  @override
  String get otherPaths => 'Lộ trình khác';

  @override
  String get noPathsYet => 'Chưa có lộ trình nào';

  @override
  String get pathsWillAppear =>
      'Lộ trình sẽ xuất hiện khi được thêm vào hệ thống';

  @override
  String get official => 'OFFICIAL';

  @override
  String steps(int count) {
    return '$count bước';
  }

  @override
  String estimatedHours(String hours) {
    return '${hours}h';
  }

  @override
  String get cannotLoadPath => 'Không tải được lộ trình';

  @override
  String get pathSteps => 'Các bước';

  @override
  String stepTitle(int order) {
    return 'Bước $order';
  }

  @override
  String get optional => 'TÙY CHỌN';

  @override
  String lessons(int count) {
    return '$count bài';
  }

  @override
  String get enrollPath => 'Đăng ký lộ trình';

  @override
  String get enrollToUnlock => 'Đăng ký để mở khóa';

  @override
  String get enrolledPath => 'Đã đăng ký lộ trình!';

  @override
  String get enrollFailed => 'Không thể đăng ký. Thử lại.';

  @override
  String get levelAndXp => 'Cấp độ & XP';

  @override
  String levelTitle(int level, String title) {
    return 'Level $level · $title';
  }

  @override
  String totalXpAmount(String xp) {
    return '$xp tổng XP';
  }

  @override
  String xpToNextLevel(int xp, int next) {
    return '$xp XP nữa lên Level $next';
  }

  @override
  String get xpThisWeek => 'XP tuần này';

  @override
  String get totalXpLabel => 'Tổng XP';

  @override
  String get completeLessons => 'Hoàn thành bài học';

  @override
  String get correctExercises => 'Bài tập đúng';

  @override
  String get streakDays => 'Streak ngày học';

  @override
  String get perfectScore => 'Điểm hoàn hảo';

  @override
  String get howToEarnXp => 'CÁCH TÍCH LŨY XP';

  @override
  String get xpByDay => 'XP THEO NGÀY (TUẦN NÀY)';

  @override
  String get streakProgress => 'Tiến trình học';

  @override
  String get daysInARow => 'ngày liên tiếp';

  @override
  String get studiedToday => '✓ Đã học hôm nay';

  @override
  String get longestStreak => 'Dài nhất';

  @override
  String get totalDays => 'Tổng ngày';

  @override
  String get freezeLeft => 'Freeze còn';

  @override
  String get heatmapThisMonth => 'HEATMAP THÁNG NÀY';

  @override
  String get few => 'Ít';

  @override
  String get many => 'Nhiều';

  @override
  String get today => 'Hôm nay';

  @override
  String get weeklyReport => 'Báo cáo tuần';

  @override
  String get thisWeekYouHave => 'Tuần này bạn đã';

  @override
  String get studyDays => 'Ngày học';

  @override
  String get xpEarned => 'XP kiếm được';

  @override
  String get lessonsDone => 'Bài học xong';

  @override
  String get avgPerDay => 'TB / ngày';

  @override
  String get lessonsByDay => 'BÀI HỌC THEO NGÀY';

  @override
  String get detailEachDay => 'CHI TIẾT TỪNG NGÀY';

  @override
  String lessonCount(int count) {
    return '$count bài';
  }

  @override
  String get noSessionsThisWeek => 'Chưa có phiên học nào trong tuần này';

  @override
  String get mon => 'Thứ 2';

  @override
  String get tue => 'Thứ 3';

  @override
  String get wed => 'Thứ 4';

  @override
  String get thu => 'Thứ 5';

  @override
  String get fri => 'Thứ 6';

  @override
  String get sat => 'Thứ 7';

  @override
  String get sun => 'CN';

  @override
  String get badges => 'Huy hiệu';

  @override
  String get collection => 'Bộ sưu tập';

  @override
  String get achieved => 'ĐÃ ĐẠT ĐƯỢC';

  @override
  String get locked => 'CHƯA MỞ KHÓA';

  @override
  String get achievedBadge => '✓ Đã đạt được';

  @override
  String get lockedBadge => '🔒 Chưa mở khóa';

  @override
  String courseLessons(int completed, int total) {
    return '$completed / $total bài hoàn thành';
  }

  @override
  String get noLessonsYet => 'Chưa có bài học nào';

  @override
  String get lessonsComingSoon => 'Bài học sẽ được thêm vào sớm';

  @override
  String get lessonRequiresPlan => 'Bài học này yêu cầu gói cao hơn';

  @override
  String get excellent => 'Xuất sắc! 🎉';

  @override
  String get goodJob => 'Tốt lắm! 👍';

  @override
  String get tryHarder => 'Cố gắng hơn!';

  @override
  String get needMorePractice => 'Cần ôn tập thêm';

  @override
  String get reviewWrongAnswers => 'Review câu sai';

  @override
  String questionProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get noFlashcards => 'Không có thẻ từ vựng';

  @override
  String get aiTeacher => 'AI Teacher';

  @override
  String get aiTutor => 'Gia sư ngôn ngữ thông minh';

  @override
  String remainingToday(int count) {
    return '$count còn lại';
  }

  @override
  String get suggestedQuestions => 'Gợi ý câu hỏi:';

  @override
  String get askAiTeacher => 'Hỏi AI Teacher...';

  @override
  String get aiConnectionError =>
      '❌ Không thể kết nối đến AI. Vui lòng kiểm tra mạng và thử lại.';

  @override
  String get aiGrammarCheck => 'AI Grammar Check';

  @override
  String get checkAndFixGrammar => 'Kiểm tra và sửa lỗi ngữ pháp';

  @override
  String get refresh => 'Làm mới';

  @override
  String get enterSentenceToCheck => 'Nhập câu cần kiểm tra';

  @override
  String get paste => 'Dán';

  @override
  String get check => 'Kiểm tra';

  @override
  String get trySampleSentences => 'Thử với câu mẫu:';

  @override
  String get aiAnalyzing => 'AI đang phân tích...';

  @override
  String get checkingGrammar =>
      'Đang kiểm tra ngữ pháp, chính tả và cách dùng từ';

  @override
  String get sentenceCorrect => 'Câu đúng ngữ pháp! ✓';

  @override
  String get grammarErrorsFound => 'Phát hiện lỗi ngữ pháp';

  @override
  String get sentencePerfect => 'Câu văn này hoàn toàn chính xác.';

  @override
  String errorsFound(int count) {
    return '$count lỗi được tìm thấy';
  }

  @override
  String get correctedSentence => 'Câu đã sửa';

  @override
  String get copiedCorrectedSentence => 'Đã sao chép câu đã sửa';

  @override
  String get errorDetails => 'Chi tiết lỗi';

  @override
  String get betterExpressions => 'Cách diễn đạt tốt hơn';

  @override
  String get explanation => 'Giải thích:';

  @override
  String get grammarType => 'Ngữ pháp';

  @override
  String get spellingType => 'Chính tả';

  @override
  String get punctuationType => 'Dấu câu';

  @override
  String wordCount(int count) {
    return '$count từ';
  }

  @override
  String get aiRecommendation => 'AI Recommendation';

  @override
  String get lessonSuggestions => 'Gợi ý bài học phù hợp với bạn';

  @override
  String get aiAnalyzingPath => 'AI đang phân tích...';

  @override
  String get reviewingPath => 'Đang xem xét lộ trình học của bạn';

  @override
  String get learningOverview => 'Tổng quan học tập của bạn';

  @override
  String get avgScoreLabel => 'TB điểm';

  @override
  String get streakDaysLabel => 'Ngày streak';

  @override
  String get completedLessons => 'Bài hoàn thành';

  @override
  String get aiAdvice => 'Lời khuyên từ AI';

  @override
  String get skillsToFocus => 'Kỹ năng cần tập trung';

  @override
  String get suggestedLessons => 'Bài học được gợi ý';

  @override
  String get lessonSuggestion => 'Bài học gợi ý';

  @override
  String get hot => 'Hot';

  @override
  String get cannotCreateSuggestion => 'Không thể tạo gợi ý. Vui lòng thử lại.';

  @override
  String get aiVocabulary => 'AI Vocabulary';

  @override
  String get smartDictionary => 'Tra từ điển thông minh';

  @override
  String get enterEnglishWord => 'Nhập từ tiếng Anh...';

  @override
  String get lookup => 'Tra';

  @override
  String get ipaTranscription => 'Phiên âm IPA';

  @override
  String get memorizationTip => 'Mẹo ghi nhớ';

  @override
  String get synonymsAntonyms => 'Từ đồng/trái nghĩa';

  @override
  String get realExamples => 'Ví dụ thực tế';

  @override
  String get lookingUpWord => 'Đang tra từ điển...';

  @override
  String get aiSynthesizing => 'AI đang tổng hợp thông tin từ vựng';

  @override
  String get overview => 'Tổng quan';

  @override
  String get examples => 'Ví dụ';

  @override
  String get related => 'Liên quan';

  @override
  String get commonPhrases => 'Cụm từ thường gặp';

  @override
  String get noExamples => 'Không có ví dụ';

  @override
  String get noRelatedData => 'Không có dữ liệu liên quan';

  @override
  String get synonyms => 'Từ đồng nghĩa';

  @override
  String get antonyms => 'Từ trái nghĩa';

  @override
  String get slow => 'chậm';

  @override
  String wordCountLabel(int count) {
    return '$count từ';
  }

  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get lastNameRequired => 'Họ không được để trống';

  @override
  String get profileUpdated => 'Đã cập nhật hồ sơ';

  @override
  String get updateFailed => 'Cập nhật thất bại. Thử lại.';

  @override
  String get user => 'Người dùng';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get setPassword => 'Tạo mật khẩu';

  @override
  String get passwordSetSuccess =>
      'Tạo mật khẩu thành công! Bạn có thể đăng nhập bằng email.';

  @override
  String get googleSetPasswordInfo =>
      'Tài khoản của bạn được đăng nhập qua Google. Tạo mật khẩu để có thể đăng nhập bằng email.';

  @override
  String get currentPassword => 'Mật khẩu hiện tại';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get confirmNewPassword => 'Xác nhận mật khẩu mới';

  @override
  String get passwordMinLength => 'Mật khẩu tối thiểu 6 ký tự';

  @override
  String get fillAllFields => 'Vui lòng điền đầy đủ thông tin';

  @override
  String get newPasswordMinLength => 'Mật khẩu mới phải có ít nhất 6 ký tự';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu xác nhận không khớp';

  @override
  String get passwordChangedSuccess => 'Đổi mật khẩu thành công';

  @override
  String get currentPasswordWrong => 'Mật khẩu hiện tại không đúng';

  @override
  String get saving => 'Đang lưu...';

  @override
  String get logoutConfirm => 'Bạn có chắc muốn đăng xuất?';

  @override
  String get settingsLearning => 'HỌC TẬP';

  @override
  String get settingsNotifications => 'THÔNG BÁO';

  @override
  String get settingsSecurity => 'BẢO MẬT';

  @override
  String get cancelAutoRenew => 'Hủy gia hạn tự động';

  @override
  String get cancelAutoRenewDesc =>
      'Gói Pro vẫn còn hiệu lực đến ngày hết hạn. Sau đó sẽ không gia hạn tự động.';

  @override
  String get keepPlan => 'Giữ nguyên';

  @override
  String get cancelRenewal => 'Hủy gia hạn';

  @override
  String get invoiceTitle => 'Thanh toán thành công!';

  @override
  String get welcomeToPro => 'Chào mừng bạn đến với Pro';

  @override
  String get choosePlan => 'Chọn gói';

  @override
  String get onboardingLanguageTitle => 'Bạn muốn học ngôn ngữ\nnào?';

  @override
  String get onboardingLanguageSubtitle => 'Có thể chọn nhiều ngôn ngữ';

  @override
  String get onboardingGoalTitle => 'Mục tiêu của bạn là\ngì?';

  @override
  String get onboardingGoalSubtitle => 'AI sẽ tạo lộ trình phù hợp nhất';

  @override
  String get goalToeic => 'Thi TOEIC / IELTS';

  @override
  String get goalCommunication => 'Giao tiếp hàng ngày';

  @override
  String get goalStudyAbroad => 'Du học / định cư';

  @override
  String get goalWork => 'Công việc / kinh doanh';

  @override
  String get goalTravel => 'Du lịch / khám phá';

  @override
  String get goalOther => 'Mục tiêu khác';

  @override
  String get onboardingPersonalizeTitle => 'Cá nhân hóa lộ trình';

  @override
  String get dailyMinutes => 'Học bao nhiêu phút mỗi ngày?';

  @override
  String get minutes => 'phút';

  @override
  String get ageRange => 'Khoảng tuổi của bạn?';

  @override
  String get ageUnder18 => 'Dưới 18';

  @override
  String get age1824 => '18 – 24';

  @override
  String get age2534 => '25 – 34';

  @override
  String get age3544 => '35 – 44';

  @override
  String get age45plus => '45+';

  @override
  String onboardingStep(int step, int total) {
    return 'Bước $step / $total';
  }

  @override
  String get cannotLoadLanguages => 'Không tải được danh sách ngôn ngữ';

  @override
  String get checkNetworkAndBackend =>
      'Kiểm tra kết nối mạng và backend, sau đó thử lại.';

  @override
  String get yourLevel => 'Trình độ của bạn';

  @override
  String correctAnswers(int score, int total) {
    return '$score / $total câu đúng';
  }
}
