<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Reception Dashboard" scope="request"/>
<c:set var="pageSubtitle" value="Today's front-desk overview" scope="request"/>
<c:set var="currentPage" value="dashboard" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="grid grid-3" style="margin-bottom:22px;">
    <div class="stat-card"><div class="stat-value">${today.size()}</div><div class="stat-label">Appointments Today</div></div>
    <div class="card" style="grid-column: span 2;">
        <h3>Quick Actions</h3>
        <a class="btn btn-primary btn-sm" href="${pageContext.request.contextPath}/reception/walkin">Register Walk-in Patient</a>
        <a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/reception/daily-list">View Daily List</a>
    </div>
</div>

<div class="card">
    <h2>Today's Appointments</h2>
    <c:choose>
        <c:when test="${empty today}">
            <div class="empty-state">No appointments scheduled for today.</div>
        </c:when>
        <c:otherwise>
            <div class="table-wrap">
            <table>
                <thead><tr><th>Token</th><th>Patient</th><th>Doctor</th><th>Time</th><th>Status</th></tr></thead>
                <tbody>
                <c:forEach var="a" items="${today}">
                    <tr>
                        <td>#${a.tokenNo}</td>
                        <td>${a.patientName}</td>
                        <td>${a.doctorName}</td>
                        <td>${a.startTime}</td>
                        <td><span class="badge badge-blue">${a.status}</span></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
