package com.languageapp.language_learning_backend.payment;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class PayPalClient {

    private final RestTemplate rest;

    @Value("${paypal.client-id}")     private String clientId;
    @Value("${paypal.client-secret}") private String clientSecret;
    @Value("${paypal.base-url:https://api-m.sandbox.paypal.com}") private String baseUrl;
    @Value("${backend.url}")          private String backendUrl;
    @Value("${android.url:linguanext://app}") private String androidUrl;

    public OrderResponse createOrder(String txId, BigDecimal amount, String desc) {
        String token = getAccessToken();

        // return_url và cancel_url phải là HTTPS — backend xử lý rồi redirect về deep link
        var body = Map.of(
                "intent", "CAPTURE",
                "purchase_units", List.of(Map.of(
                        "custom_id", txId,
                        "amount", Map.of("currency_code", "USD", "value", amount.toString()),
                        "description", desc)),
                "application_context", Map.of(
                        "return_url", backendUrl + "/api/v1/payments/paypal/return",
                        "cancel_url", backendUrl + "/api/v1/payments/paypal/cancel",
                        "brand_name", "LinguaNext",
                        "user_action", "PAY_NOW")
        );

        var resp = rest.exchange(
                baseUrl + "/v2/checkout/orders",
                HttpMethod.POST,
                new HttpEntity<>(body, bearerHeaders(token)),
                OrderResp.class
        );

        var order = resp.getBody();

        String approveUrl = order.links().stream()
                .filter(l -> "approve".equals(l.rel()))
                .map(OrderResp.Link::href)
                .findFirst()
                .orElseThrow(() -> new RuntimeException("No PayPal approval URL"));

        return new OrderResponse(order.id(), approveUrl);
    }

    public CaptureDetailResp captureOrderDetail(String orderId) {
        var resp = rest.exchange(
                baseUrl + "/v2/checkout/orders/" + orderId + "/capture",
                HttpMethod.POST,
                new HttpEntity<>("{}", bearerHeaders(getAccessToken())),
                CaptureDetailResp.class
        );
        return resp.getBody();
    }

    /** Lấy trạng thái PayPal order: CREATED | SAVED | APPROVED | VOIDED | COMPLETED */
    public String getOrderStatus(String orderId) {
        try {
            var resp = rest.exchange(
                    baseUrl + "/v2/checkout/orders/" + orderId,
                    HttpMethod.GET,
                    new HttpEntity<>(bearerHeaders(getAccessToken())),
                    OrderStatusResp.class
            );
            return resp.getBody() != null ? resp.getBody().status() : "UNKNOWN";
        } catch (Exception e) {
            log.warn("PayPal getOrderStatus error: {}", e.getMessage());
            return "UNKNOWN";
        }
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    record OrderStatusResp(String status) {}

    private String cachedToken;
    private long tokenExpiry = 0;

    private synchronized String getAccessToken() {
        long now = System.currentTimeMillis();

        if (cachedToken != null && now < tokenExpiry) {
            return cachedToken;
        }

        var h = new HttpHeaders();
        h.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        h.setBasicAuth(clientId, clientSecret);

        var body = new LinkedMultiValueMap<String, String>();
        body.add("grant_type", "client_credentials");

        var resp = rest.exchange(
                baseUrl + "/v1/oauth2/token",
                HttpMethod.POST,
                new HttpEntity<>(body, h),
                TokenResp.class
        );

        cachedToken = resp.getBody().access_token();

        // set 8 tiếng
        tokenExpiry = now + (8 * 60 * 60 * 1000);

        return cachedToken;
    }
    private HttpHeaders bearerHeaders(String token) {
        var h = new HttpHeaders();
        h.setBearerAuth(token);
        h.setContentType(MediaType.APPLICATION_JSON);
        return h;
    }

    public record OrderResponse(String orderId, String approveUrl) {}

    @JsonIgnoreProperties(ignoreUnknown = true)
    record TokenResp(String access_token) {}

    @JsonIgnoreProperties(ignoreUnknown = true)
    record OrderResp(String id, List<Link> links) {
        @JsonIgnoreProperties(ignoreUnknown = true)
        record Link(String href, String rel) {}
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    public record CaptureDetailResp(
            String id,
            String status,
            List<PurchaseUnit> purchase_units
    ) {
        @JsonIgnoreProperties(ignoreUnknown = true)
        public record PurchaseUnit(String custom_id) {}
    }
}