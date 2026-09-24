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
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />g
    <div class="main">
        <div class="topbar">
            <div>
                <h1>${pageTitle}</h1>
                <c:if test="${pageSubtitle != null}"><p>${pageSubtitle}</p></c:if>
            </div>
        </div>
