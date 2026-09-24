<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Patient Dashboard" scope="request"/>
<c:set var="pageSubtitle" value="Welcome back, ${patient.fullName}" scope="request"/>
<c:set var="currentPage" value="dashboard" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<c:if test="${param.booked == '1'}"><div class="alert alert-success">Appointment booked successfully! Your token has been generated.</div></c:if>
<c:if test="${not empty param.error}"><div class="alert alert-error">${param.error}</div></c:if>

<div class="grid grid-3" style="margin-bottom:22px;">
    <div class="stat-card"><div class="stat-value">${appointments.size()}</div><div class="stat-label">Total Appointments</div></div>
    <div class="stat-card"><div class="stat-value">${patient.nic}</div><div class="stat-label">NIC Number</div></div>
    <div class="stat-card"><div class="stat-value">${notifications.size()}</div><div class="stat-label">Notifications</div></div>
</div>

<div class="grid grid-2">
    <div class="card">
        <h2>My Appointments</h2>
        <c:choose>
            <c:when test="${empty appointments}">
                <div class="empty-state">No appointments yet. <a href="${pageContext.request.contextPath}/patient/search-doctors" style="color:var(--primary);">Search a doctor</a> to book one.</div>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                <table>
                    <thead><tr><th>Doctor</th><th>Date</th><th>Token</th><th>Status</th><th></th></tr></thead>
                    <tbody>
                    <c:forEach var="a" items="${appointments}">
                        <tr>
                            <td>${a.doctorName}<br><small style="color:var(--text-muted);">${a.specialty}</small></td>
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
                            <td>
                                <c:if test="${a.status == 'BOOKED'}">
                                <form method="post" action="${pageContext.request.contextPath}/patient/cancel/${a.appointmentId}" onsubmit="return confirm('Cancel this appointment?');">
                                    <button class="btn btn-danger btn-sm" type="submit">Cancel</button>
                                </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="card">
        <h2>Notifications</h2>
        <c:choose>
            <c:when test="${empty notifications}">
                <div class="empty-state">No notifications yet.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="n" items="${notifications}">
                    <div class="notif-item">${n.message}</div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
