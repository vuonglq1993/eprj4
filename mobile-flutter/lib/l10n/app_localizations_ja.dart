// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'LinguaNext';

  @override
  String get login => 'ログイン';

  @override
  String get logout => 'ログアウト';

  @override
  String get register => '新規登録';

  @override
  String get email => 'メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get confirmPassword => 'パスワード確認';

  @override
  String get forgotPassword => 'パスワードを忘れた方';

  @override
  String get loginWithGoogle => 'Googleで続ける';

  @override
  String get home => 'ホーム';

  @override
  String get profile => 'プロフィール';

  @override
  String get settings => '設定';

  @override
  String get learn => '学習';

  @override
  String get leaderboard => 'ランキング';

  @override
  String get path => 'ルート';

  @override
  String get courses => 'コース';

  @override
  String get allTopics => 'すべて';

  @override
  String get continueLesson => '学習を続ける';

  @override
  String get todayGoal => '今日の目標';

  @override
  String get streak => '連続学習';

  @override
  String get totalXp => '合計XP';

  @override
  String get daysLearned => '学習日数';

  @override
  String get subscription => 'サブスクリプション';

  @override
  String get upgradeToPro => 'Proにアップグレード';

  @override
  String get payNow => '今すぐ支払う';

  @override
  String get paymentSuccess => '支払い完了！';

  @override
  String get paymentFailed => '支払いが失敗またはキャンセルされました';

  @override
  String get paymentTimeout => '支払いに時間がかかっています。履歴で状況を確認してください。';

  @override
  String get checkHistory => '履歴を確認';

  @override
  String get language => '言語';

  @override
  String get interfaceLanguage => '表示言語';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get back => '戻る';

  @override
  String get next => '次へ';

  @override
  String get done => '完了';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラーが発生しました';

  @override
  String get retry => '再試行';

  @override
  String get close => '閉じる';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get search => '検索';

  @override
  String get processing => '処理中...';

  @override
  String get featureInDevelopment => '機能は開発中です';

  @override
  String get splashTagline => 'AIでスマートな語学学習\nパーソナライズドで学ぼう';

  @override
  String get splashGetStarted => '無料で始める';

  @override
  String get welcomeBack => 'おかえりなさい';

  @override
  String get loginToContinue => 'ログインして学習を続ける';

  @override
  String get orEmail => 'またはメール';

  @override
  String get invalidEmail => 'メールアドレスが無効です';

  @override
  String get enterEmail => 'メールを入力';

  @override
  String get enterPassword => 'パスワードを入力';

  @override
  String get wrongCredentials => 'メールまたはパスワードが正しくありません';

  @override
  String get twoFaTitle => '2段階認証を有効にして\nアカウントを保護する';

  @override
  String get twoFaActivated => 'ログイン後に2FAが有効化されます';

  @override
  String get noAccount => 'アカウントをお持ちでない方は ';

  @override
  String get googleIdTokenError => 'idTokenを取得できませんでした。Web Client IDを確認してください。';

  @override
  String get googleBackendRejected => 'バックエンドがGoogleログインを拒否しました';

  @override
  String get googleSha1Error => 'SHA-1エラー (ApiException: 10)';

  @override
  String get googleOAuthError => 'OAuth設定エラー';

  @override
  String get googleNetworkError => 'ネットワークまたはGoogle Playエラー';

  @override
  String googleSignInError(String msg) {
    return 'Googleサインインエラー: $msg';
  }

  @override
  String get continueWithGoogle => 'Googleで続ける';

  @override
  String get createAccount => 'アカウント作成';

  @override
  String get freeNoCard => '無料・クレジットカード不要';

  @override
  String get orUseEmail => 'またはメールを使用';

  @override
  String get lastName => '姓';

  @override
  String get enterLastName => '姓を入力';

  @override
  String get tooShort => '短すぎます';

  @override
  String get firstName => '名';

  @override
  String get enterFirstName => '名を入力';

  @override
  String get phone => '電話番号';

  @override
  String get enterPhone => '電話番号を入力';

  @override
  String get passwordNeedsLetterNumber => '文字と数字を含む必要があります';

  @override
  String get agreeToTerms => '同意する ';

  @override
  String get termsOfService => '利用規約';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get alreadyHaveAccount => 'すでにアカウントをお持ちの方は ';

  @override
  String get agreeToTermsError => '利用規約とプライバシーポリシーに同意してください';

  @override
  String get emailAlreadyRegistered => 'このメールアドレスはすでに登録されています';

  @override
  String get phoneAlreadyRegistered => 'この電話番号はすでに登録されています';

  @override
  String get noNetworkConnection => 'ネットワーク接続がありません。再試行してください。';

  @override
  String get registerFailed => '登録に失敗しました。再試行してください。';

  @override
  String get morningGreeting => 'おはようございます';

  @override
  String get afternoonGreeting => 'こんにちは';

  @override
  String get eveningGreeting => 'こんばんは';

  @override
  String get lessonsCompleted => '完了レッスン';

  @override
  String get minutesLearned => '学習時間(分)';

  @override
  String get avgScore => '平均スコア';

  @override
  String get thisWeek => '今週';

  @override
  String get currentlyLearning => '学習中';

  @override
  String get noCourses => 'コースがありません';

  @override
  String get exploreLearningPath => '学習パスを探索して最初のレッスンを始めましょう';

  @override
  String get explorePath => '学習パスを探索';

  @override
  String get continueLearning => '学習を続ける';

  @override
  String get nextLesson => '次:';

  @override
  String get skill => 'スキル';

  @override
  String get listening => 'リスニング';

  @override
  String get speaking => 'スピーキング';

  @override
  String get reading => 'リーディング';

  @override
  String get writing => 'ライティング';

  @override
  String get vocabulary => '語彙';

  @override
  String get grammar => '文法';

  @override
  String get aiSuggestion => 'AIのおすすめ';

  @override
  String focusImprove(String skill) {
    return '$skillの改善に集中する';
  }

  @override
  String get learningPath => '学習パス';

  @override
  String get myPath => 'マイパス';

  @override
  String get explorePaths => 'パスを探索';

  @override
  String get otherPaths => '他のパス';

  @override
  String get noPathsYet => 'パスがまだありません';

  @override
  String get pathsWillAppear => 'パスがシステムに追加されると表示されます';

  @override
  String get official => '公式';

  @override
  String steps(int count) {
    return '$countステップ';
  }

  @override
  String estimatedHours(String hours) {
    return '$hours時間';
  }

  @override
  String get cannotLoadPath => 'パスを読み込めませんでした';

  @override
  String get pathSteps => 'ステップ';

  @override
  String stepTitle(int order) {
    return 'ステップ$order';
  }

  @override
  String get optional => '任意';

  @override
  String lessons(int count) {
    return '$countレッスン';
  }

  @override
  String get enrollPath => 'パスに登録';

  @override
  String get enrollToUnlock => '登録して解除する';

  @override
  String get enrolledPath => 'パスに登録しました！';

  @override
  String get enrollFailed => '登録できませんでした。再試行してください。';

  @override
  String get levelAndXp => 'レベル & XP';

  @override
  String levelTitle(int level, String title) {
    return 'レベル$level · $title';
  }

  @override
  String totalXpAmount(String xp) {
    return '$xp 合計XP';
  }

  @override
  String xpToNextLevel(int xp, int next) {
    return 'レベル$nextまであと${xp}XP';
  }

  @override
  String get xpThisWeek => '今週のXP';

  @override
  String get totalXpLabel => '合計XP';

  @override
  String get completeLessons => 'レッスン完了';

  @override
  String get correctExercises => '正解した練習';

  @override
  String get streakDays => '連続学習日数';

  @override
  String get perfectScore => '満点';

  @override
  String get howToEarnXp => 'XPの獲得方法';

  @override
  String get xpByDay => '日別XP（今週）';

  @override
  String get streakProgress => '学習進捗';

  @override
  String get daysInARow => '日連続';

  @override
  String get studiedToday => '✓ 今日学習済み';

  @override
  String get longestStreak => '最長';

  @override
  String get totalDays => '合計日数';

  @override
  String get freezeLeft => 'フリーズ残り';

  @override
  String get heatmapThisMonth => '今月のヒートマップ';

  @override
  String get few => '少';

  @override
  String get many => '多';

  @override
  String get today => '今日';

  @override
  String get weeklyReport => '週次レポート';

  @override
  String get thisWeekYouHave => '今週あなたは';

  @override
  String get studyDays => '学習日数';

  @override
  String get bestStreak => '最長ストリーク';

  @override
  String get xpEarned => '獲得XP';

  @override
  String get lessonsDone => '完了レッスン';

  @override
  String get avgPerDay => '1日平均';

  @override
  String get lessonsByDay => '日別レッスン';

  @override
  String get detailEachDay => '日別詳細';

  @override
  String lessonCount(int count) {
    return '$countレッスン';
  }

  @override
  String get noSessionsThisWeek => '今週の学習セッションがありません';

  @override
  String get mon => '月';

  @override
  String get tue => '火';

  @override
  String get wed => '水';

  @override
  String get thu => '木';

  @override
  String get fri => '金';

  @override
  String get sat => '土';

  @override
  String get sun => '日';

  @override
  String get badges => 'バッジ';

  @override
  String get collection => 'コレクション';

  @override
  String get achieved => '達成済み';

  @override
  String get locked => '未解除';

  @override
  String get achievedBadge => '✓ 達成済み';

  @override
  String get lockedBadge => '🔒 未解除';

  @override
  String courseLessons(int completed, int total) {
    return '$completed / $total レッスン完了';
  }

  @override
  String get noLessonsYet => 'レッスンがまだありません';

  @override
  String get lessonsComingSoon => 'レッスンは近日追加予定です';

  @override
  String get lessonRequiresPlan => 'このレッスンにはより高いプランが必要です';

  @override
  String get excellent => '素晴らしい！🎉';

  @override
  String get goodJob => 'よくできました！👍';

  @override
  String get tryHarder => 'もっと頑張って！';

  @override
  String get needMorePractice => 'もっと練習が必要です';

  @override
  String get reviewWrongAnswers => '間違いのレビュー';

  @override
  String questionProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String get noFlashcards => 'フラッシュカードがありません';

  @override
  String get aiTeacher => 'AI Teacher';

  @override
  String get aiTutor => 'スマート言語チューター';

  @override
  String remainingToday(int count) {
    return '残り$count';
  }

  @override
  String get suggestedQuestions => 'おすすめの質問:';

  @override
  String get askAiTeacher => 'AI Teacherに質問...';

  @override
  String get aiConnectionError => '❌ AIに接続できません。ネットワークを確認して再試行してください。';

  @override
  String get aiGrammarCheck => 'AI文法チェック';

  @override
  String get checkAndFixGrammar => '文法エラーをチェック・修正';

  @override
  String get refresh => '更新';

  @override
  String get enterSentenceToCheck => 'チェックする文章を入力';

  @override
  String get paste => '貼り付け';

  @override
  String get check => 'チェック';

  @override
  String get trySampleSentences => 'サンプル文を試す:';

  @override
  String get aiAnalyzing => 'AIが分析中...';

  @override
  String get checkingGrammar => '文法、スペル、語法を確認中';

  @override
  String get sentenceCorrect => '文法は正しいです！✓';

  @override
  String get grammarErrorsFound => '文法エラーが見つかりました';

  @override
  String get sentencePerfect => 'この文章は完全に正確です。';

  @override
  String errorsFound(int count) {
    return '$count件のエラーが見つかりました';
  }

  @override
  String get correctedSentence => '修正後の文章';

  @override
  String get copiedCorrectedSentence => '修正後の文章をコピーしました';

  @override
  String get errorDetails => 'エラーの詳細';

  @override
  String get betterExpressions => 'より良い表現';

  @override
  String get explanation => '解説:';

  @override
  String get grammarType => '文法';

  @override
  String get spellingType => 'スペル';

  @override
  String get punctuationType => '句読点';

  @override
  String wordCount(int count) {
    return '$count語';
  }

  @override
  String get aiRecommendation => 'AIのおすすめ';

  @override
  String get lessonSuggestions => 'あなたに合ったレッスンの提案';

  @override
  String get aiAnalyzingPath => 'AIが分析中...';

  @override
  String get reviewingPath => '学習パスを確認中';

  @override
  String get learningOverview => '学習概要';

  @override
  String get avgScoreLabel => '平均スコア';

  @override
  String get streakDaysLabel => '連続日数';

  @override
  String get completedLessons => '完了レッスン';

  @override
  String get aiAdvice => 'AIからのアドバイス';

  @override
  String get skillsToFocus => '重点スキル';

  @override
  String get suggestedLessons => 'おすすめレッスン';

  @override
  String get lessonSuggestion => 'レッスン提案';

  @override
  String get hot => '注目';

  @override
  String get cannotCreateSuggestion => '提案を作成できません。再試行してください。';

  @override
  String get aiVocabulary => 'AI語彙';

  @override
  String get smartDictionary => 'スマート辞書検索';

  @override
  String get enterEnglishWord => '英単語を入力...';

  @override
  String get lookup => '検索';

  @override
  String get ipaTranscription => 'IPA発音記号';

  @override
  String get memorizationTip => '暗記のコツ';

  @override
  String get synonymsAntonyms => '類義語/反義語';

  @override
  String get realExamples => '実例';

  @override
  String get lookingUpWord => '単語を検索中...';

  @override
  String get aiSynthesizing => 'AIが語彙情報を合成中';

  @override
  String get overview => '概要';

  @override
  String get examples => '例文';

  @override
  String get related => '関連';

  @override
  String get commonPhrases => 'よく使うフレーズ';

  @override
  String get noExamples => '例文がありません';

  @override
  String get noRelatedData => '関連データがありません';

  @override
  String get synonyms => '類義語';

  @override
  String get antonyms => '反義語';

  @override
  String get slow => 'ゆっくり';

  @override
  String wordCountLabel(int count) {
    return '$count語';
  }

  @override
  String get editProfile => 'プロフィール編集';

  @override
  String get lastNameRequired => '姓は必須です';

  @override
  String get profileUpdated => 'プロフィールを更新しました';

  @override
  String get updateFailed => '更新に失敗しました。再試行してください。';

  @override
  String get user => 'ユーザー';

  @override
  String get changePassword => 'パスワード変更';

  @override
  String get setPassword => 'パスワード設定';

  @override
  String get passwordSetSuccess => 'パスワードを設定しました！メールでログインできます。';

  @override
  String get googleSetPasswordInfo =>
      'アカウントはGoogleでログインしています。メールでもログインできるようにパスワードを設定してください。';

  @override
  String get currentPassword => '現在のパスワード';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get confirmNewPassword => '新しいパスワードの確認';

  @override
  String get passwordMinLength => '最低6文字必要です';

  @override
  String get fillAllFields => 'すべての項目を入力してください';

  @override
  String get newPasswordMinLength => '新しいパスワードは6文字以上必要です';

  @override
  String get passwordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get passwordChangedSuccess => 'パスワードを変更しました';

  @override
  String get currentPasswordWrong => '現在のパスワードが正しくありません';

  @override
  String get passwordRecentlyUsed => '新しいパスワードは直近2つのパスワードと異なる必要があります';

  @override
  String get saving => '保存中...';

  @override
  String get logoutConfirm => 'ログアウトしてもよろしいですか？';

  @override
  String get settingsLearning => '学習';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsSecurity => 'セキュリティ';

  @override
  String get cancelAutoRenew => '自動更新をキャンセル';

  @override
  String get cancelAutoRenewDesc => 'Proプランは有効期限まで有効です。その後は自動更新されません。';

  @override
  String get keepPlan => 'プランを維持';

  @override
  String get cancelRenewal => '更新をキャンセル';

  @override
  String get invoiceTitle => '支払い完了！';

  @override
  String get welcomeToPro => 'Proへようこそ';

  @override
  String get choosePlan => 'プランを選択';

  @override
  String get onboardingLanguageTitle => 'どの言語を\n学びたいですか？';

  @override
  String get onboardingLanguageSubtitle => '複数選択できます';

  @override
  String get onboardingGoalTitle => '目標は\n何ですか？';

  @override
  String get onboardingGoalSubtitle => 'AIが最適なパスを作成します';

  @override
  String get goalCommunication => '日常会話';

  @override
  String get goalStudyAbroad => '留学 / 移住';

  @override
  String get goalWork => '仕事 / ビジネス';

  @override
  String get goalTravel => '旅行 / 探索';

  @override
  String get goalOther => 'その他の目標';

  @override
  String get onboardingPersonalizeTitle => 'パスをカスタマイズ';

  @override
  String get dailyMinutes => '1日何分学習しますか？';

  @override
  String get minutes => '分';

  @override
  String get ageRange => '年齢層は？';

  @override
  String get ageUnder18 => '18歳未満';

  @override
  String get age1824 => '18 – 24';

  @override
  String get age2534 => '25 – 34';

  @override
  String get age3544 => '35 – 44';

  @override
  String get age45plus => '45歳以上';

  @override
  String onboardingStep(int step, int total) {
    return 'ステップ$step / $total';
  }

  @override
  String get cannotLoadLanguages => '言語リストを読み込めませんでした';

  @override
  String get checkNetworkAndBackend => 'ネットワーク接続とバックエンドを確認してから再試行してください。';

  @override
  String get yourLevel => 'あなたのレベル';

  @override
  String correctAnswers(int score, int total) {
    return '$score / $total 正解';
  }

  @override
  String get free => '無料';

  @override
  String get enabled => '有効';

  @override
  String get disabled => '無効';

  @override
  String get invalidPhone => '電話番号が無効です';

  @override
  String get minEightChars => '最低8文字';

  @override
  String get takePhoto => '写真を撮る';

  @override
  String get selectFromLibrary => 'ライブラリから選択';

  @override
  String get uploadPhotoFailed => '写真のアップロードに失敗しました';

  @override
  String get basicInfo => '基本情報';

  @override
  String get contactLocation => '連絡先・場所';

  @override
  String get country => '国';

  @override
  String get timezone => 'タイムゾーン';

  @override
  String get selectTimezone => 'タイムゾーンを選択';

  @override
  String get personalInfo => '個人情報';

  @override
  String get gender => '性別';

  @override
  String get selectGender => '性別を選択';

  @override
  String get aboutYourself => '自己紹介';

  @override
  String get bioHint => '自己紹介を書いてください...';

  @override
  String get dateOfBirth => '生年月日';

  @override
  String get selectDateOfBirth => '生年月日を選択';

  @override
  String get phoneHint => '+81 xxx xxx xxx';

  @override
  String get dailyReminder => '毎日の学習リマインダー';

  @override
  String get reminderTime => 'リマインダー時間';

  @override
  String get sendTestNotification => 'テスト通知を送信';

  @override
  String get testNotificationSent => 'テスト通知を送信しました！';

  @override
  String get twoFactorAuth => '2段階認証（2FA）';

  @override
  String get twoFaComingSoon => '2FA機能は次のアップデートで公開予定';

  @override
  String get proMember => 'Proメンバー';

  @override
  String get pathAndLanguage => '学習進捗';

  @override
  String get badgesAchievements => 'バッジ・実績';

  @override
  String get subscriptionBilling => 'サブスクリプション・請求';

  @override
  String get currentPlan => '現在のプラン';

  @override
  String get activeStatus => 'アクティブ';

  @override
  String get startDate => '開始日';

  @override
  String get renewalDate => '次回更新日';

  @override
  String get paymentMethod => '支払い方法';

  @override
  String get upgradeToYearly => '年間プランにアップグレード';

  @override
  String get paymentHistory => '支払い履歴';

  @override
  String get noPaymentHistory => '支払い履歴がありません';

  @override
  String get securePaymentNotice => '安全な決済 • いつでもキャンセル可能';

  @override
  String get waitingPaymentResult => 'お支払い結果を待っています';

  @override
  String get cancelWaiting => '待機をキャンセル';

  @override
  String get orderSummary => '注文概要';

  @override
  String get totalPayment => '合計支払額';

  @override
  String get monthly => '月額';

  @override
  String get yearly => '年額';

  @override
  String get mostPopular => '最も人気';

  @override
  String get perMonth => '/月';

  @override
  String get perYear => '/年';

  @override
  String get cancelAnytime => 'Settingsからいつでもキャンセル可能';

  @override
  String get seeResults => '結果を見る';

  @override
  String get nextQuestion => '次の問題';

  @override
  String get dailyXpGoal => '1日のXP目標';

  @override
  String get learningStyle => '学習スタイル';

  @override
  String get selectXpGoal => 'XP目標を選択';

  @override
  String get selectLearningStyle => '学習スタイルを選択';

  @override
  String get secureLabel => 'セキュリティ';

  @override
  String get paymentLabel => 'お支払い';

  @override
  String get completePaymentInstruction => '開いたウィンドウでお支払いを完了し、アプリに戻ってください。';

  @override
  String autoRenewal(String period) {
    return '$periodごとに自動更新。いつでもキャンセル可能。';
  }

  @override
  String subscribePlan(String plan) {
    return '$planに登録';
  }

  @override
  String get currentPlanCheck => '✓ 現在のプラン';

  @override
  String get loadMore => 'もっと見る';

  @override
  String get skip => 'スキップ';

  @override
  String get onboardingTopicsTitle => '興味のあるトピックは？';

  @override
  String get onboardingTopicsSubtitle => '1〜3つ選んでおすすめ精度を上げましょう';

  @override
  String get onboardingLevelTitle => '現在のレベルは？';

  @override
  String get onboardingLevelSubtitle => 'あなたに合ったパスをおすすめします';

  @override
  String get selfLevelCompleteBeginner => '完全な初心者';

  @override
  String get selfLevelCompleteBeginnerSub => 'この言語を全く知りません';

  @override
  String get selfLevelBeginner => '少し知っている';

  @override
  String get selfLevelBeginnerSub => '基本的な単語を少し知っています';

  @override
  String get selfLevelIntermediate => '基本的なコミュニケーション';

  @override
  String get selfLevelIntermediateSub => '簡単な文が話せます';

  @override
  String get selfLevelAdvanced => 'かなり流暢';

  @override
  String get selfLevelAdvancedSub => 'うまく意思疎通ができます';

  @override
  String get onboardingHeardFromTitle => 'どこで知りましたか？';

  @override
  String get onboardingHeardFromSubtitle => 'サービス向上にご協力ください';

  @override
  String get heardFromGoogle => 'Google検索';

  @override
  String get heardFromSocial => 'SNS';

  @override
  String get heardFromFriend => '友人・家族';

  @override
  String get heardFromAppStore => 'App Store';

  @override
  String get heardFromAd => '広告';

  @override
  String get heardFromOther => 'その他';

  @override
  String get startLearning => '学習を始める';

  @override
  String get recommendedForYou => 'あなたのためのパス！';

  @override
  String get recommendedForYouSub => '目標とレベルをもとにおすすめします：';

  @override
  String get viewLearningPath => 'パスを見る';

  @override
  String get exploreLater => '後で探す';

  @override
  String get filterBeginner => '初級';

  @override
  String get filterElementary => '初歩';

  @override
  String get filterIntermediate => '中級';

  @override
  String get filterUpperIntermediate => '中上級';

  @override
  String get filterAdvanced => '上級';
}
