<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - E-Channeling System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <div class="brand">
            <div class="logo-badge">EC</div>
            <div class="brand-text">Web-Based E-Channeling System<small>SLIIT | SE2030 Group Project</small></div>
        </div>
        <h1>Welcome back</h1>
        <p class="subtitle">Sign in to continue to your dashboard.</p>

        <c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>
        <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>
        <c:if test="${param.error == 'forbidden'}"><div class="alert alert-error">You don't have access to that page.</div></c:if>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-group">
                <label>Username</label>
                <input class="form-control" type="text" name="username" required autofocus>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input class="form-control" type="password" name="password" required>
            </div>
            <button class="btn btn-primary btn-block" type="submit">Sign In</button>
        </form>

        <div class="auth-footer">
            New patient? <a href="${pageContext.request.contextPath}/register" style="color:var(--primary);font-weight:600;">Register an account</a>
        </div>
        <div class="auth-footer" style="margin-top:6px;font-size:12px;">
            Demo logins (password: <b>Passw0rd!</b>): admin / drperera / reception1 / pharmacy1 / opsmgr1 / patient1
        </div>
    </div>
</div>
</body>
</html>
