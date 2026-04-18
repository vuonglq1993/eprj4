package com.languageapp.language_learning_backend.service;

import org.springframework.stereotype.Service;

@Service
public class ScoringService {

    public double similarity(String a, String b) {
        a = normalize(a);
        b = normalize(b);

        if (a.isEmpty() || b.isEmpty()) return 0.0;

        int distance = levenshtein(a, b);
        int maxLen = Math.max(a.length(), b.length());

        return 1.0 - ((double) distance / maxLen);
    }

    public boolean isCorrect(String a, String b, double threshold) {
        return similarity(a, b) >= threshold;
    }

    private String normalize(String s) {
        return s.toLowerCase()
                .replaceAll("[^a-z0-9 ]", "")
                .trim();
    }

    // classic DP
    private int levenshtein(String a, String b) {
        int[][] dp = new int[a.length() + 1][b.length() + 1];

        for (int i = 0; i <= a.length(); i++)
            dp[i][0] = i;

        for (int j = 0; j <= b.length(); j++)
            dp[0][j] = j;

        for (int i = 1; i <= a.length(); i++) {
            for (int j = 1; j <= b.length(); j++) {
                int cost = a.charAt(i - 1) == b.charAt(j - 1) ? 0 : 1;

                dp[i][j] = Math.min(
                        Math.min(dp[i - 1][j] + 1, dp[i][j - 1] + 1),
                        dp[i - 1][j - 1] + cost
                );
            }
        }

        return dp[a.length()][b.length()];
    }
}