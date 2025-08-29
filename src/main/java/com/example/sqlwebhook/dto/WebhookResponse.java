package com.example.sqlwebhook.dto;

import lombok.Data;

@Data
public class WebhookResponse {
    private String webhook;
    private String accessToken;
}
