<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'E-Channeling System'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<div class="app-shell">
<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
    <div class="main">
        <div class="topbar">
            <div>
                <h1>${pageTitle != null ? pageTitle : 'E-Channeling Portal'}</h1>
                <c:if test="${pageSubtitle != null}"><p>${pageSubtitle}</p></c:if>
            </div>
            <div class="topbar-user" style="display: flex; align-items: center; gap: 14px;">
                <c:set var="u" value="${currentUser != null ? currentUser : loggedInUser}" />
                <c:if test="${u != null}">
                    <div style="text-align: right;">
                        <div style="font-size: 13.5px; font-weight: 600; color: var(--text);">
                            Welcome, ${u.fullName}
                        </div>
                        <div style="font-size: 11px; color: var(--text-muted); font-weight: 600;">
                            Role: <span class="badge badge-blue">${u.role}</span>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm" style="border-color: var(--border);">
                        <span style="margin-right: 4px;">🚪</span> Logout
                    </a>
                </c:if>
            </div>
        </div>
