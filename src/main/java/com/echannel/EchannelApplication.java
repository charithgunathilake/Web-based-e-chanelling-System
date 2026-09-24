package com.echannel;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Main entry point of the Web-Based E-Channeling System.
 * Extends SpringBootServletInitializer so the app can also be deployed
 * as a WAR file to an external Tomcat server if needed.
 */
@SpringBootApplication
public class EchannelApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(EchannelApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(EchannelApplication.class);
    }
}
