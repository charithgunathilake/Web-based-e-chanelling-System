package com.echannel.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Registers the RoleInterceptor so every request under /patient/**, /doctor/**,
 * /reception/**, /pharmacist/**, /operations/** and /admin/** is checked
 * against the logged-in user's role stored in the HTTP session.
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private RoleInterceptor roleInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(roleInterceptor)
                .addPathPatterns(
                        "/portal", "/portal/**",
                        "/patient/**", "/doctor/**", "/reception/**",
                        "/pharmacist/**", "/operations/**", "/admin/**"
                );
    }
}
