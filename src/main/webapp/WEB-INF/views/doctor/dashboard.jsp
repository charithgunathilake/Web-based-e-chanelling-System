<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Doctor Dashboard" scope="request"/>
<c:set var="pageSubtitle" value="Dr. ${doctor.fullName} - ${doctor.specialty}" scope="request"/>
<c:set var="currentPage" value="dashboard" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="grid grid-3" style="margin-bottom:22px;">
    <div class="stat-card"><div class="stat-value">${appointments.size()}</div><div class="stat-label">Total Appointments</div></div>
    <div class="stat-card"><div class="stat-value">${schedule.size()}</div><div class="stat-label">Scheduled Sessions</div></div>
    <div class="stat-card"><div class="stat-value"><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/> <span class="star">&#9733;</span></div><div class="stat-label">Average Rating</div></div>
</div>

<div class="card">
    <h2>Upcoming / Recent Appointments</h2>
    <c:choose>
        <c:when test="${empty appointments}">
            <div class="empty-state">No appointments yet.</div>
        </c:when>
        <c:otherwise>
            <div class="table-wrap">
            <table>
                <thead><tr><th>Patient</th><th>Date</th><th>Token</th><th>Status</th><th></th></tr></thead>
                <tbody>
                <c:forEach var="a" items="${appointments}">
                    <tr>
                        <td>${a.patientName}</td>
                        <td><fmt:formatDate value="${a.scheduleDate}" pattern="dd MMM yyyy"/> ${a.startTime}</td>
                        <td>#${a.tokenNo}</td>
                        <td>
                            <c:choose>
                                <c:when test="${a.status == 'BOOKED'}"><span class="badge badge-blue">Booked</span></c:when>
                                <c:when test="${a.status == 'ATTENDED'}"><span class="badge badge-green">Attended</span></c:when>
                                <c:when test="${a.status == 'CANCELLED'}"><span class="badge badge-red">Cancelled</span></c:when>
                                <c:otherwise><span class="badge badge-gray">${a.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><a class="btn btn-outline btn-sm" href="${pageContext.request.contextPath}/doctor/patient-history/${a.appointmentId}">Open Record</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
