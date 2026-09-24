<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Operations Dashboard" scope="request"/>
<c:set var="pageSubtitle" value="Room usage, doctor performance and service quality" scope="request"/>
<c:set var="currentPage" value="dashboard" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="grid grid-3" style="margin-bottom:22px;">
    <div class="stat-card"><div class="stat-value">${totalAppointments}</div><div class="stat-label">Total Appointments</div></div>
    <div class="stat-card"><div class="stat-value">${rooms.size()}</div><div class="stat-label">Rooms Configured</div></div>
    <div class="stat-card"><div class="stat-value">${feedbackList.size()}</div><div class="stat-label">Feedback Received</div></div>
</div>

<div class="grid grid-2">
    <div class="card">
        <h2>Room Usage</h2>
        <div class="table-wrap">
        <table>
            <thead><tr><th>Room</th><th>Branch</th><th>Department</th><th>Status</th></tr></thead>
            <tbody>
            <c:forEach var="r" items="${rooms}">
                <tr>
                    <td>${r.roomNumber}</td>
                    <td>${r.branchName}</td>
                    <td>${r.department}</td>
                    <td>
                        <c:choose>
                            <c:when test="${r.status == 'ACTIVE'}"><span class="badge badge-green">Active</span></c:when>
                            <c:otherwise><span class="badge badge-red">Inactive</span></c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        </div>
    </div>

    <div class="card">
        <h2>Doctor Performance (Average Rating)</h2>
        <c:forEach var="entry" items="${doctorRatings}">
            <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:13.5px;">
                <span>${entry.key}</span>
                <span><fmt:formatNumber value="${entry.value}" maxFractionDigits="1"/> <span class="star">&#9733;</span></span>
            </div>
        </c:forEach>
    </div>
</div>

<div class="card" style="margin-top:20px;">
    <h2>Patient Feedback / Reviews</h2>
    <c:choose>
        <c:when test="${empty feedbackList}">
            <div class="empty-state">No feedback submitted yet.</div>
        </c:when>
        <c:otherwise>
            <div class="table-wrap">
            <table>
                <thead><tr><th>Patient</th><th>Doctor</th><th>Rating</th><th>Review</th><th>Status</th><th></th></tr></thead>
                <tbody>
                <c:forEach var="f" items="${feedbackList}">
                    <tr>
                        <td>${f.patientName}</td>
                        <td>${f.doctorName}</td>
                        <td>${f.rating} <span class="star">&#9733;</span></td>
                        <td>${f.review}</td>
                        <td>
                            <c:choose>
                                <c:when test="${f.flagged}"><span class="badge badge-red">Flagged</span></c:when>
                                <c:otherwise><span class="badge badge-green">Visible</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/operations/feedback/flag/${f.feedbackId}">
                                <input type="hidden" name="flagged" value="${!f.flagged}">
                                <button class="btn btn-outline btn-sm" type="submit">${f.flagged ? 'Unflag' : 'Flag'}</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
