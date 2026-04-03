package com.languageapp.language_learning_backend.service;

import com.languageapp.language_learning_backend.dto.learningpath.LearningPathResponse;
import com.languageapp.language_learning_backend.dto.onboarding.*;
import com.languageapp.language_learning_backend.entity.*;
import com.languageapp.language_learning_backend.entity.LearningPath.TargetLevel;
import com.languageapp.language_learning_backend.entity.UserLearningPath.PathStatus;
import com.languageapp.language_learning_backend.entity.UserOnboarding.*;
import com.languageapp.language_learning_backend.exception.GlobalExceptionHandler.*;
import com.languageapp.language_learning_backend.repository.*;
import com.languageapp.language_learning_backend.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class OnboardingService {

    private final UserOnboardingRepository   onboardingRepo;
    private final UserRepository             userRepo;
    private final LanguageRepository         languageRepo;
    private final LearningPathRepository     pathRepo;
    private final UserLearningPathRepository userPathRepo;
    private final UserProgressRepository     progressRepo;

    // ── SUBMIT ONBOARDING ────────────────────────────────────
    @Transactional
    public OnboardingResponse submit(OnboardingRequest req, UserPrincipal p) {

        User user = userRepo.findById(p.getUserId())
                .orElseThrow(() -> new NotFoundException("User not found"));

        Language lang = languageRepo.findById(req.getTargetLanguageId())
                .orElseThrow(() -> new NotFoundException("Language not found"));

        // Upsert: nếu đã có onboarding thì update, chưa có thì tạo mới
        UserOnboarding ob = onboardingRepo.findByUserId(p.getUserId())
                .orElse(UserOnboarding.builder().user(user).build());

        ob.setTargetLanguage(lang);
        ob.setNativeLanguageCode(req.getNativeLanguageCode());
        ob.setSelfLevel(req.getSelfLevel());
        ob.setGoal(req.getGoal());
        ob.setDailyTime(req.getDailyTime());
        ob.setAgeGroup(req.getAgeGroup());
        ob.setHeardFrom(req.getHeardFrom());
        ob.setCompleted(true);

        // Recommend Learning Path
        List<LearningPath> suggested = recommend(lang.getId(), req.getSelfLevel(), req.getGoal());
        LearningPath bestPath = suggested.isEmpty() ? null : suggested.get(0);
        ob.setRecommendedPath(bestPath);

        onboardingRepo.save(ob);

        // Auto-enroll vào path được gợi ý tốt nhất (nếu chưa enroll)
        if (bestPath != null
                && !userPathRepo.existsByUserIdAndLearningPathId(p.getUserId(), bestPath.getId())) {
            userPathRepo.save(UserLearningPath.builder()
                    .user(user)
                    .learningPath(bestPath)
                    .currentStep(0)
                    .progressPercent(0)
                    .status(PathStatus.IN_PROGRESS)
                    .build());
            log.info("Auto-enrolled user {} into path {}", p.getUserId(), bestPath.getId());
        }

        // Map suggested paths → response (bỏ path đầu vì đã là recommendedPath)
        List<LearningPathResponse> others = suggested.stream()
                .skip(1).limit(3)
                .map(lp -> toPathSummary(lp, Collections.emptyMap()))
                .collect(Collectors.toList());

        return OnboardingResponse.builder()
                .onboardingId(ob.getId())
                .targetLanguageName(lang.getName())
                .targetLanguageCode(lang.getCode())
                .targetLanguageFlag(lang.getFlag())
                .selfLevel(req.getSelfLevel())
                .goal(req.getGoal())
                .dailyTime(req.getDailyTime())
                .completed(true)
                .recommendedPath(bestPath != null ? toPathSummary(bestPath, Collections.emptyMap()) : null)
                .otherSuggestedPaths(others)
                .motivationMessage(buildMessage(lang.getName(), req.getSelfLevel(), req.getGoal()))
                .build();
    }

    // ── GET MY ONBOARDING ────────────────────────────────────
    @Transactional(readOnly = true)
    public OnboardingResponse getMyOnboarding(UserPrincipal p) {
        UserOnboarding ob = onboardingRepo.findByUserId(p.getUserId())
                .orElseThrow(() -> new NotFoundException("Onboarding not completed yet"));

        Language lang = ob.getTargetLanguage();
        LearningPath rp = ob.getRecommendedPath();

        return OnboardingResponse.builder()
                .onboardingId(ob.getId())
                .targetLanguageName(lang != null ? lang.getName() : null)
                .targetLanguageCode(lang != null ? lang.getCode() : null)
                .targetLanguageFlag(lang != null ? lang.getFlag() : null)
                .selfLevel(ob.getSelfLevel())
                .goal(ob.getGoal())
                .dailyTime(ob.getDailyTime())
                .completed(ob.getCompleted())
                .recommendedPath(rp != null ? toPathSummary(rp, Collections.emptyMap()) : null)
                .build();
    }

    // ── CHECK STATUS (dùng trong splash/login) ───────────────
    @Transactional(readOnly = true)
    public Map<String, Object> getStatus(UserPrincipal p) {
        boolean done = onboardingRepo.findByUserId(p.getUserId())
                .map(UserOnboarding::getCompleted)
                .orElse(false);
        return Map.of(
                "onboardingCompleted", done,
                "userId", p.getUserId()
        );
    }

    // ── RECOMMENDATION ENGINE ─────────────────────────────────
    /**
     * Logic gợi ý Learning Path:
     *  1. Lọc theo ngôn ngữ
     *  2. Map SelfLevel → TargetLevel của path
     *  3. Ưu tiên path isOfficial = true
     *  4. Trả tối đa 4 path
     */
    private List<LearningPath> recommend(UUID languageId, SelfLevel level, LearningGoal goal) {
        TargetLevel targetLevel = mapLevel(level);

        // Lấy tất cả path public của ngôn ngữ này
        List<LearningPath> all = pathRepo.findPublished(
                languageId, null, null, PageRequest.of(0, 20)).getContent();

        if (all.isEmpty()) return Collections.emptyList();

        // Tính điểm ưu tiên cho mỗi path
        return all.stream()
                .sorted(Comparator.comparingInt((LearningPath lp) ->
                        score(lp, targetLevel, goal)).reversed())
                .limit(4)
                .collect(Collectors.toList());
    }

    /**
     * Tính điểm match:
     *  +3  nếu targetLevel khớp chính xác
     *  +1  nếu targetLevel gần (1 bậc)
     *  +2  nếu isOfficial
     *  +1  nếu goal khớp với title/description (keyword matching đơn giản)
     */
    private int score(LearningPath lp, TargetLevel wanted, LearningGoal goal) {
        int s = 0;

        if (lp.getTargetLevel() == wanted) s += 3;
        else if (lp.getTargetLevel() != null && Math.abs(
                lp.getTargetLevel().ordinal() - wanted.ordinal()) == 1) s += 1;

        if (Boolean.TRUE.equals(lp.getIsOfficial())) s += 2;

        // Keyword match với goal
        String combined = ((lp.getTitle() != null ? lp.getTitle() : "")
                + " " + (lp.getDescription() != null ? lp.getDescription() : "")).toLowerCase();
        String goalKw = switch (goal) {
            case TRAVEL           -> "travel";
            case WORK             -> "business work";
            case SCHOOL           -> "academic school";
            case FAMILY_FRIENDS   -> "daily conversation";
            case SKILL_IMPROVEMENT -> "fluency improvement";
            default               -> "";
        };
        for (String kw : goalKw.split(" ")) {
            if (!kw.isBlank() && combined.contains(kw)) s += 1;
        }

        return s;
    }

    private TargetLevel mapLevel(SelfLevel sl) {
        return switch (sl) {
            case COMPLETE_BEGINNER, BEGINNER -> TargetLevel.BEGINNER;
            case INTERMEDIATE                -> TargetLevel.INTERMEDIATE;
            case ADVANCED                    -> TargetLevel.ADVANCED;
        };
    }

    // ── MESSAGE GENERATOR ────────────────────────────────────
    private String buildMessage(String langName, SelfLevel level, LearningGoal goal) {
        String levelStr = switch (level) {
            case COMPLETE_BEGINNER -> "người mới bắt đầu";
            case BEGINNER          -> "người học cơ bản";
            case INTERMEDIATE      -> "người học trung cấp";
            case ADVANCED          -> "người học nâng cao";
        };
        String goalStr = switch (goal) {
            case TRAVEL            -> "du lịch";
            case WORK              -> "công việc";
            case SCHOOL            -> "học tập";
            case FAMILY_FRIENDS    -> "giao tiếp với bạn bè & gia đình";
            case SKILL_IMPROVEMENT -> "nâng cao kỹ năng";
            default                -> "phát triển bản thân";
        };
        return String.format(
                "Chào mừng! Mình đã chọn lộ trình %s phù hợp cho bạn — " +
                        "một %s muốn học %s vì mục tiêu %s. Hành trình bắt đầu từ hôm nay! 🚀",
                langName, levelStr, langName, goalStr
        );
    }

    // ── MAPPER ───────────────────────────────────────────────
    private LearningPathResponse toPathSummary(LearningPath lp, Map<UUID, Integer> cp) {
        return LearningPathResponse.builder()
                .id(lp.getId())
                .title(lp.getTitle())
                .description(lp.getDescription())
                .thumbnailUrl(lp.getThumbnailUrl())
                .languageCode(lp.getLanguage().getCode())
                .languageName(lp.getLanguage().getName())
                .targetLevel(lp.getTargetLevel())
                .goal(lp.getGoal())
                .estimatedHours(lp.getEstimatedHours())
                .isPublished(lp.getIsPublished())
                .isOfficial(lp.getIsOfficial())
                .totalSteps(lp.getSteps().size())
                .createdAt(lp.getCreatedAt())
                .build();
    }
}
