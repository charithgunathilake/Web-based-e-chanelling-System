<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - E-Channeling System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card" style="max-width:480px;">
        <div class="brand">
            <div class="logo-badge">EC</div>
            <div class="brand-text">Web-Based E-Channeling System<small>Patient Registration</small></div>
        </div>
        <h1>Create your account</h1>
        <p class="subtitle">Register once, then search doctors and book appointments online.</p>

        <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>

        <form method="post" action="${pageContext.request.contextPath}/register">
            <div class="form-row">
                <div class="form-group"><label>Full Name</label><input class="form-control" name="fullName" required></div>
                <div class="form-group"><label>Username</label><input class="form-control" name="username" required></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Email</label><input class="form-control" type="email" name="email" required></div>
                <div class="form-group"><label>Phone</label><input class="form-control" name="phone" required></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>NIC</label><input class="form-control" name="nic"></div>
                <div class="form-group"><label>Address</label><input class="form-control" name="address"></div>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input class="form-control" type="password" name="password" required>
            </div>
            <button class="btn btn-primary btn-block" type="submit">Create Account</button>
        </form>

        <div class="auth-footer">
            Already have an account? <a href="${pageContext.request.contextPath}/login" style="color:var(--primary);font-weight:600;">Sign in</a>
        </div>
    </div>
</div>
</body>
</html>
