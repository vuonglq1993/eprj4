package com.languageapp.language_learning_backend.ai;

import com.languageapp.language_learning_backend.entity.Subscription;

/**
 * Phân tầng quyền AI theo subscription plan.
 *
 * FREE     → giới hạn thấp
 * MONTHLY  → giới hạn trung bình
 * UNLIMITED → 3_MONTHS + YEARLY → giới hạn cao
 */
public enum AiTier {
    FREE, MONTHLY, UNLIMITED;

    public static AiTier from(Subscription.Plan plan) {
        if (plan == null) return FREE;
        return switch (plan) {
            case THREE_MONTHS, YEARLY -> UNLIMITED;
            case MONTHLY              -> MONTHLY;
            default                   -> FREE;
        };
    }

    /** Chat limit / ngày */
    public int chatLimit()          { return switch (this) { case UNLIMITED -> 200; case MONTHLY -> 100; default -> 20; }; }
    /** Grammar check limit / ngày */
    public int grammarLimit()       { return switch (this) { case UNLIMITED -> 100; case MONTHLY -> 50;  default -> 10; }; }
    /** Pronunciation limit / ngày */
    public int pronunciationLimit() { return switch (this) { case UNLIMITED -> 50;  case MONTHLY -> 20;  default -> 5;  }; }
    /** Vocab generate limit / ngày */
    public int vocabLimit()         { return switch (this) { case UNLIMITED -> 100; case MONTHLY -> 50;  default -> 10; }; }
    /** Recommendation limit / ngày */
    public int recommendLimit()     { return switch (this) { case UNLIMITED -> 20;  case MONTHLY -> 10;  default -> 3;  }; }
}
