package com.echannel.config;

import com.echannel.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * Simple session-based access control. Every role-specific area of the site
 * (/patient/**, /doctor/**, ...) is guarded here instead of pulling in the
 * full Spring Security framework, to keep the codebase easy to follow.
 */
@Component
public class RoleInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        User loggedInUser = null;
        if (session != null) {
            loggedInUser = (User) session.getAttribute("currentUser");
            if (loggedInUser == null) {
                loggedInUser = (User) session.getAttribute("loggedInUser");
            }
        }

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String path = request.getRequestURI().substring(request.getContextPath().length());
        String requiredRole = requiredRoleForPath(path);

        if (requiredRole != null && !loggedInUser.getRole().equals(requiredRole)) {
            response.sendRedirect(request.getContextPath() + "/login?error=forbidden");
            return false;
        }
        return true;
    }

    private String requiredRoleForPath(String path) {
        if (path.startsWith("/patient")) return "PATIENT";
        if (path.startsWith("/doctor")) return "DOCTOR";
        if (path.startsWith("/reception")) return "RECEPTION";
        if (path.startsWith("/pharmacist")) return "PHARMACIST";
        if (path.startsWith("/operations")) return "OPERATIONS_MANAGER";
        if (path.startsWith("/admin")) return "ADMIN";
        return null;
    }
}
