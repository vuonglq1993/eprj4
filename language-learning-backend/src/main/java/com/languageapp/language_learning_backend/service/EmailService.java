package com.languageapp.language_learning_backend.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService {

    private final JavaMailSender mailSender;

    @Value("${spring.mail.username}")
    private String fromEmail;

    // ══════════════════════════════════════════════
    // SEND VERIFICATION OTP
    // ══════════════════════════════════════════════
    @Async
    public void sendVerificationOtp(String toEmail, String otp) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("LinguaNext - Mã xác thực tài khoản");
            message.setText(
                    "Xin chào,\n\n" +
                            "Mã OTP của bạn là: " + otp + "\n\n" +
                            "Mã này sẽ hết hạn sau 5 phút.\n\n" +
                            "Nếu bạn không yêu cầu mã này, vui lòng bỏ qua email.\n\n" +
                            "Trân trọng,\n" +
                            "LinguaNext Team"
            );

            mailSender.send(message);
            log.info("✅ Verification OTP sent to {}", toEmail);

        } catch (Exception e) {
            log.error("❌ Failed to send verification OTP: {}", e.getMessage());
        }
    }

    // ══════════════════════════════════════════════
    // SEND PASSWORD RESET OTP
    // ══════════════════════════════════════════════
    @Async
    public void sendPasswordResetOtp(String toEmail, String otp) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("LinguaNext - Mã đặt lại mật khẩu");
            message.setText(
                    "Xin chào,\n\n" +
                            "Mã OTP để đặt lại mật khẩu của bạn là: " + otp + "\n\n" +
                            "Mã này sẽ hết hạn sau 5 phút.\n\n" +
                            "Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này.\n\n" +
                            "Trân trọng,\n" +
                            "LinguaNext Team"
            );

            mailSender.send(message);
            log.info("✅ Password reset OTP sent to {}", toEmail);

        } catch (Exception e) {
            log.error("❌ Failed to send reset OTP: {}", e.getMessage());
        }
    }

    // ══════════════════════════════════════════════
    // SEND STUDY REMINDER (Daily notification)
    // ══════════════════════════════════════════════
    @Async
    public void sendStudyReminder(String toEmail, String userName, int streak) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("🔥 Đừng để streak " + streak + " ngày của bạn bị gián đoạn!");
            message.setText(
                    "Xin chào " + userName + ",\n\n" +
                            "Bạn đang có streak " + streak + " ngày liên tiếp! 🎉\n\n" +
                            "Hôm nay bạn chưa hoàn thành bài học nào. " +
                            "Hãy dành 5 phút để duy trì chuỗi ngày học của bạn nhé!\n\n" +
                            "Học ngay: https://linguanext.com/learn\n\n" +
                            "Trân trọng,\n" +
                            "LinguaNext Team"
            );

            mailSender.send(message);
            log.info("✅ Study reminder sent to {}", toEmail);

        } catch (Exception e) {
            log.error("❌ Failed to send study reminder: {}", e.getMessage());
        }
    }
}