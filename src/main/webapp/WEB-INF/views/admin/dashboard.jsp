<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Dashboard" scope="request"/>
<c:set var="pageSubtitle" value="System overview" scope="request"/>
<c:set var="currentPage" value="dashboard" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="grid grid-3">
    <div class="stat-card"><div class="stat-value">${userCount}</div><div class="stat-label">Total User Accounts</div></div>
    <div class="stat-card"><div class="stat-value">${branchCount}</div><div class="stat-label">Branches</div></div>
    <div class="card" style="grid-column: span 1;">
        <h3>Quick Actions</h3>
        <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/admin/users">Manage Users</a>
        <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/admin/branches">Branches &amp; Rooms</a>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
