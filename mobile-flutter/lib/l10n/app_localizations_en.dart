// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LinguaNext';

  @override
  String get login => 'Log In';

  @override
  String get logout => 'Log Out';

  @override
  String get register => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get learn => 'Learn';

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get path => 'Path';

  @override
  String get continueLesson => 'Continue Learning';

  @override
  String get todayGoal => 'Today\'s Goal';

  @override
  String get streak => 'Streak';

  @override
  String get totalXp => 'Total XP';

  @override
  String get daysLearned => 'Days Learned';

  @override
  String get subscription => 'Subscription';

  @override
  String get upgradeToPro => 'Upgrade to Pro';

  @override
  String get payNow => 'Pay Now';

  @override
  String get paymentSuccess => 'Payment Successful!';

  @override
  String get paymentFailed => 'Payment failed or cancelled';

  @override
  String get language => 'Language';

  @override
  String get interfaceLanguage => 'Interface Language';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get close => 'Close';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Search';

  @override
  String get processing => 'Processing...';

  @override
  String get featureInDevelopment => 'Feature in development';

  @override
  String get splashTagline => 'Smart language learning\nwith personalized AI';

  @override
  String get splashGetStarted => 'Get started for free';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginToContinue => 'Log in to continue learning';

  @override
  String get orEmail => 'or email';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get wrongCredentials => 'Incorrect email or password';

  @override
  String get twoFaTitle =>
      'Enable 2-Factor Authentication\nto protect your account';

  @override
  String get twoFaActivated => '2FA will be activated after login';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get googleIdTokenError =>
      'Could not get idToken. Check Web Client ID.';

  @override
  String get googleBackendRejected => 'Backend rejected Google login';

  @override
  String get googleSha1Error => 'SHA-1 Error (ApiException: 10)';

  @override
  String get googleOAuthError => 'OAuth config error';

  @override
  String get googleNetworkError => 'Network or Google Play error';

  @override
  String googleSignInError(String msg) {
    return 'Google Sign-In error: $msg';
  }

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get createAccount => 'Create Account';

  @override
  String get freeNoCard => 'Free · No credit card required';

  @override
  String get orUseEmail => 'or use email';

  @override
  String get lastName => 'Last Name';

  @override
  String get enterLastName => 'Enter last name';

  @override
  String get tooShort => 'Too short';

  @override
  String get firstName => 'First Name';

  @override
  String get enterFirstName => 'Enter first name';

  @override
  String get phone => 'Phone Number';

  @override
  String get enterPhone => 'Enter phone number';

  @override
  String get passwordNeedsLetterNumber => 'Must contain letters and numbers';

  @override
  String get agreeToTerms => 'I agree to the ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get agreeToTermsError => 'Please agree to the Terms & Privacy Policy';

  @override
  String get emailAlreadyRegistered => 'This email is already registered';

  @override
  String get phoneAlreadyRegistered =>
      'This phone number is already registered';

  @override
  String get noNetworkConnection => 'No network connection. Please try again.';

  @override
  String get registerFailed => 'Registration failed. Please try again.';

  @override
  String get morningGreeting => 'Good morning';

  @override
  String get afternoonGreeting => 'Good afternoon';

  @override
  String get eveningGreeting => 'Good evening';

  @override
  String get lessonsCompleted => 'Lessons done';

  @override
  String get minutesLearned => 'Minutes learned';

  @override
  String get avgScore => 'Avg score';

  @override
  String get thisWeek => 'This week';

  @override
  String get currentlyLearning => 'Currently learning';

  @override
  String get noCourses => 'No courses yet';

  @override
  String get exploreLearningPath =>
      'Explore learning paths and start your first lesson';

  @override
  String get explorePath => 'Explore learning paths';

  @override
  String get continueLearning => 'Continue learning';

  @override
  String get nextLesson => 'Next:';

  @override
  String get skill => 'Skills';

  @override
  String get listening => 'Listening';

  @override
  String get speaking => 'Speaking';

  @override
  String get reading => 'Reading';

  @override
  String get writing => 'Writing';

  @override
  String get vocabulary => 'Vocabulary';

  @override
  String get grammar => 'Grammar';

  @override
  String get aiSuggestion => 'AI Suggestion';

  @override
  String focusImprove(String skill) {
    return 'Focus on improving $skill';
  }

  @override
  String get learningPath => 'Learning Path';

  @override
  String get myPath => 'My Paths';

  @override
  String get explorePaths => 'Explore Paths';

  @override
  String get otherPaths => 'Other Paths';

  @override
  String get noPathsYet => 'No paths yet';

  @override
  String get pathsWillAppear => 'Paths will appear when added to the system';

  @override
  String get official => 'OFFICIAL';

  @override
  String steps(int count) {
    return '$count steps';
  }

  @override
  String estimatedHours(String hours) {
    return '${hours}h';
  }

  @override
  String get cannotLoadPath => 'Could not load path';

  @override
  String get pathSteps => 'Steps';

  @override
  String stepTitle(int order) {
    return 'Step $order';
  }

  @override
  String get optional => 'OPTIONAL';

  @override
  String lessons(int count) {
    return '$count lessons';
  }

  @override
  String get enrollPath => 'Enroll in Path';

  @override
  String get enrollToUnlock => 'Enroll to unlock';

  @override
  String get enrolledPath => 'Enrolled in path!';

  @override
  String get enrollFailed => 'Could not enroll. Try again.';

  @override
  String get levelAndXp => 'Level & XP';

  @override
  String levelTitle(int level, String title) {
    return 'Level $level · $title';
  }

  @override
  String totalXpAmount(String xp) {
    return '$xp total XP';
  }

  @override
  String xpToNextLevel(int xp, int next) {
    return '$xp XP to Level $next';
  }

  @override
  String get xpThisWeek => 'XP this week';

  @override
  String get totalXpLabel => 'Total XP';

  @override
  String get completeLessons => 'Complete lessons';

  @override
  String get correctExercises => 'Correct exercises';

  @override
  String get streakDays => 'Streak days';

  @override
  String get perfectScore => 'Perfect score';

  @override
  String get howToEarnXp => 'HOW TO EARN XP';

  @override
  String get xpByDay => 'XP BY DAY (THIS WEEK)';

  @override
  String get streakProgress => 'Learning Progress';

  @override
  String get daysInARow => 'days in a row';

  @override
  String get studiedToday => '✓ Studied today';

  @override
  String get longestStreak => 'Longest';

  @override
  String get totalDays => 'Total days';

  @override
  String get freezeLeft => 'Freeze left';

  @override
  String get heatmapThisMonth => 'HEATMAP THIS MONTH';

  @override
  String get few => 'Few';

  @override
  String get many => 'Many';

  @override
  String get today => 'Today';

  @override
  String get weeklyReport => 'Weekly Report';

  @override
  String get thisWeekYouHave => 'This week you have';

  @override
  String get studyDays => 'Study days';

  @override
  String get bestStreak => 'Best streak';

  @override
  String get xpEarned => 'XP earned';

  @override
  String get lessonsDone => 'Lessons done';

  @override
  String get avgPerDay => 'Avg / day';

  @override
  String get lessonsByDay => 'LESSONS BY DAY';

  @override
  String get detailEachDay => 'DAILY DETAILS';

  @override
  String lessonCount(int count) {
    return '$count lessons';
  }

  @override
  String get noSessionsThisWeek => 'No study sessions this week';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get badges => 'Badges';

  @override
  String get collection => 'Collection';

  @override
  String get achieved => 'ACHIEVED';

  @override
  String get locked => 'LOCKED';

  @override
  String get achievedBadge => '✓ Achieved';

  @override
  String get lockedBadge => '🔒 Locked';

  @override
  String courseLessons(int completed, int total) {
    return '$completed / $total lessons done';
  }

  @override
  String get noLessonsYet => 'No lessons yet';

  @override
  String get lessonsComingSoon => 'Lessons will be added soon';

  @override
  String get lessonRequiresPlan => 'This lesson requires a higher plan';

  @override
  String get excellent => 'Excellent! 🎉';

  @override
  String get goodJob => 'Good job! 👍';

  @override
  String get tryHarder => 'Keep trying!';

  @override
  String get needMorePractice => 'Needs more practice';

  @override
  String get reviewWrongAnswers => 'Review wrong answers';

  @override
  String questionProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get noFlashcards => 'No flashcards';

  @override
  String get aiTeacher => 'AI Teacher';

  @override
  String get aiTutor => 'Smart language tutor';

  @override
  String remainingToday(int count) {
    return '$count remaining';
  }

  @override
  String get suggestedQuestions => 'Suggested questions:';

  @override
  String get askAiTeacher => 'Ask AI Teacher...';

  @override
  String get aiConnectionError =>
      '❌ Cannot connect to AI. Please check your network and try again.';

  @override
  String get aiGrammarCheck => 'AI Grammar Check';

  @override
  String get checkAndFixGrammar => 'Check and fix grammar errors';

  @override
  String get refresh => 'Refresh';

  @override
  String get enterSentenceToCheck => 'Enter sentence to check';

  @override
  String get paste => 'Paste';

  @override
  String get check => 'Check';

  @override
  String get trySampleSentences => 'Try sample sentences:';

  @override
  String get aiAnalyzing => 'AI is analyzing...';

  @override
  String get checkingGrammar => 'Checking grammar, spelling and word usage';

  @override
  String get sentenceCorrect => 'Grammar is correct! ✓';

  @override
  String get grammarErrorsFound => 'Grammar errors found';

  @override
  String get sentencePerfect => 'This sentence is perfectly correct.';

  @override
  String errorsFound(int count) {
    return '$count errors found';
  }

  @override
  String get correctedSentence => 'Corrected sentence';

  @override
  String get copiedCorrectedSentence => 'Copied corrected sentence';

  @override
  String get errorDetails => 'Error details';

  @override
  String get betterExpressions => 'Better expressions';

  @override
  String get explanation => 'Explanation:';

  @override
  String get grammarType => 'Grammar';

  @override
  String get spellingType => 'Spelling';

  @override
  String get punctuationType => 'Punctuation';

  @override
  String wordCount(int count) {
    return '$count words';
  }

  @override
  String get aiRecommendation => 'AI Recommendation';

  @override
  String get lessonSuggestions => 'Lesson suggestions tailored for you';

  @override
  String get aiAnalyzingPath => 'AI is analyzing...';

  @override
  String get reviewingPath => 'Reviewing your learning path';

  @override
  String get learningOverview => 'Your learning overview';

  @override
  String get avgScoreLabel => 'Avg score';

  @override
  String get streakDaysLabel => 'Streak days';

  @override
  String get completedLessons => 'Completed lessons';

  @override
  String get aiAdvice => 'AI advice';

  @override
  String get skillsToFocus => 'Skills to focus on';

  @override
  String get suggestedLessons => 'Suggested lessons';

  @override
  String get lessonSuggestion => 'Lesson suggestion';

  @override
  String get hot => 'Hot';

  @override
  String get cannotCreateSuggestion =>
      'Cannot create suggestions. Please try again.';

  @override
  String get aiVocabulary => 'AI Vocabulary';

  @override
  String get smartDictionary => 'Smart dictionary lookup';

  @override
  String get enterEnglishWord => 'Enter English word...';

  @override
  String get lookup => 'Look up';

  @override
  String get ipaTranscription => 'IPA Transcription';

  @override
  String get memorizationTip => 'Memory tip';

  @override
  String get synonymsAntonyms => 'Synonyms/Antonyms';

  @override
  String get realExamples => 'Real examples';

  @override
  String get lookingUpWord => 'Looking up word...';

  @override
  String get aiSynthesizing => 'AI is synthesizing vocabulary info';

  @override
  String get overview => 'Overview';

  @override
  String get examples => 'Examples';

  @override
  String get related => 'Related';

  @override
  String get commonPhrases => 'Common phrases';

  @override
  String get noExamples => 'No examples';

  @override
  String get noRelatedData => 'No related data';

  @override
  String get synonyms => 'Synonyms';

  @override
  String get antonyms => 'Antonyms';

  @override
  String get slow => 'slow';

  @override
  String wordCountLabel(int count) {
    return '$count words';
  }

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get lastNameRequired => 'Last name is required';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get updateFailed => 'Update failed. Try again.';

  @override
  String get user => 'User';

  @override
  String get changePassword => 'Change Password';

  @override
  String get setPassword => 'Set Password';

  @override
  String get passwordSetSuccess =>
      'Password set! You can now log in with your email.';

  @override
  String get googleSetPasswordInfo =>
      'Your account uses Google login. Set a password to also log in with email.';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordMinLength => 'Minimum 6 characters';

  @override
  String get fillAllFields => 'Please fill in all fields';

  @override
  String get newPasswordMinLength =>
      'New password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordChangedSuccess => 'Password changed successfully';

  @override
  String get currentPasswordWrong => 'Current password is incorrect';
  @override
  String get passwordRecentlyUsed => 'New password must not match the last 2 passwords';

  @override
  String get saving => 'Saving...';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get settingsLearning => 'LEARNING';

  @override
  String get settingsNotifications => 'NOTIFICATIONS';

  @override
  String get settingsSecurity => 'SECURITY';

  @override
  String get cancelAutoRenew => 'Cancel Auto-Renewal';

  @override
  String get cancelAutoRenewDesc =>
      'Your Pro plan remains active until expiry. After that, it won\'t auto-renew.';

  @override
  String get keepPlan => 'Keep Plan';

  @override
  String get cancelRenewal => 'Cancel Renewal';

  @override
  String get invoiceTitle => 'Payment Successful!';

  @override
  String get welcomeToPro => 'Welcome to Pro';

  @override
  String get choosePlan => 'Choose Plan';

  @override
  String get onboardingLanguageTitle => 'Which language do you\nwant to learn?';

  @override
  String get onboardingLanguageSubtitle => 'You can select multiple languages';

  @override
  String get onboardingGoalTitle => 'What is your\ngoal?';

  @override
  String get onboardingGoalSubtitle => 'AI will create the best path for you';

  @override
  String get goalToeic => 'TOEIC / IELTS Exam';

  @override
  String get goalCommunication => 'Daily conversation';

  @override
  String get goalStudyAbroad => 'Study abroad / immigration';

  @override
  String get goalWork => 'Work / business';

  @override
  String get goalTravel => 'Travel / explore';

  @override
  String get goalOther => 'Other goal';

  @override
  String get onboardingPersonalizeTitle => 'Personalize your path';

  @override
  String get dailyMinutes => 'How many minutes per day?';

  @override
  String get minutes => 'min';

  @override
  String get ageRange => 'Your age range?';

  @override
  String get ageUnder18 => 'Under 18';

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
    return 'Step $step / $total';
  }

  @override
  String get cannotLoadLanguages => 'Could not load language list';

  @override
  String get checkNetworkAndBackend =>
      'Check your network connection and backend, then try again.';

  @override
  String get yourLevel => 'Your Level';

  @override
  String correctAnswers(int score, int total) {
    return '$score / $total correct';
  }

  @override
  String get free => 'Free';
  @override
  String get enabled => 'Enabled';
  @override
  String get disabled => 'Disabled';
  @override
  String get invalidPhone => 'Invalid phone number';
  @override
  String get minEightChars => 'Minimum 8 characters';
  @override
  String get takePhoto => 'Take Photo';
  @override
  String get selectFromLibrary => 'Select from Library';
  @override
  String get uploadPhotoFailed => 'Photo upload failed, please try again';
  @override
  String get basicInfo => 'Basic Information';
  @override
  String get contactLocation => 'Contact & Location';
  @override
  String get country => 'Country';
  @override
  String get timezone => 'Timezone';
  @override
  String get selectTimezone => 'Select timezone';
  @override
  String get personalInfo => 'Personal Information';
  @override
  String get gender => 'Gender';
  @override
  String get selectGender => 'Select gender';
  @override
  String get aboutYourself => 'About Yourself';
  @override
  String get bioHint => 'Write a few lines about yourself...';
  @override
  String get dateOfBirth => 'Date of Birth';
  @override
  String get selectDateOfBirth => 'Select date of birth';
  @override
  String get phoneHint => '+1 xxx xxx xxx';
  @override
  String get dailyReminder => 'Daily Study Reminder';
  @override
  String get reminderTime => 'Reminder Time';
  @override
  String get sendTestNotification => 'Send Test Notification';
  @override
  String get testNotificationSent => 'Test notification sent!';
  @override
  String get twoFactorAuth => 'Two-Factor Authentication (2FA)';
  @override
  String get twoFaComingSoon => '2FA feature coming in next update';
  @override
  String get proMember => 'Pro Member';
  @override
  String get pathAndLanguage => 'Learning Path & Language';
  @override
  String get badgesAchievements => 'Badges & Achievements';
  @override
  String get subscriptionBilling => 'Subscription & Billing';
  @override
  String get currentPlan => 'Current Plan';
  @override
  String get activeStatus => 'Active';
  @override
  String get startDate => 'Start Date';
  @override
  String get renewalDate => 'Renewal Date';
  @override
  String get paymentMethod => 'Payment Method';
  @override
  String get upgradeToYearly => 'Upgrade to Yearly';
  @override
  String get paymentHistory => 'Payment History';
  @override
  String get securePaymentNotice => 'Secure payment • Cancel anytime';
  @override
  String get waitingPaymentResult => 'Waiting for payment result';
  @override
  String get cancelWaiting => 'Cancel Wait';
  @override
  String get orderSummary => 'Order Summary';
  @override
  String get totalPayment => 'Total Payment';
  @override
  String get monthly => 'Monthly';
  @override
  String get yearly => 'Yearly';
  @override
  String get mostPopular => 'Most Popular';
  @override
  String get perMonth => '/mo';
  @override
  String get perYear => '/yr';
  @override
  String get cancelAnytime => 'Cancel anytime in Settings';
  @override
  String get seeResults => 'See Results';
  @override
  String get nextQuestion => 'Next Question';
  @override
  String get dailyXpGoal => 'Daily XP Goal';
  @override
  String get learningStyle => 'Learning Style';
  @override
  String get selectXpGoal => 'Select XP Goal';
  @override
  String get selectLearningStyle => 'Select Learning Style';
  @override
  String get secureLabel => 'Secure';
  @override
  String get paymentLabel => 'Payment';
  @override
  String get completePaymentInstruction => 'Complete the payment in the window that opened, then return to the app.';
  @override
  String autoRenewal(String period) => 'Auto-renews every $period. Cancel anytime.';
  @override
  String subscribePlan(String plan) => 'Subscribe to $plan';
  @override
  String get currentPlanCheck => '✓ Current Plan';
}
