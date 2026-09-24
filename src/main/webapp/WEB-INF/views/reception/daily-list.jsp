<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Daily Appointment List" scope="request"/>
<c:set var="pageSubtitle" value="Verify payment status and update bookings" scope="request"/>
<c:set var="currentPage" value="daily" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="card" style="margin-bottom:18px;">
    <form method="get" action="${pageContext.request.contextPath}/reception/daily-list" class="form-row" style="align-items:flex-end;">
        <div class="form-group" style="max-width:220px;">
            <label>Date</label>
            <input class="form-control" type="date" name="date" value="${selectedDate}">
        </div>
        <div class="form-group" style="flex:0 0 auto;"><button class="btn btn-primary" type="submit">View</button></div>
    </form>
</div>

<div class="card">
    <h2>Appointments on ${selectedDate}</h2>
    <c:choose>
        <c:when test="${empty appointments}">
            <div class="empty-state">No appointments on this date.</div>
        </c:when>
        <c:otherwise>
            <div class="table-wrap">
            <table>
                <thead><tr><th>Token</th><th>Patient</th><th>Doctor</th><th>Time</th><th>Status</th><th>Update</th></tr></thead>
                <tbody>
                <c:forEach var="a" items="${appointments}">
                    <tr>
                        <td>#${a.tokenNo}</td>
                        <td>${a.patientName}</td>
                        <td>${a.doctorName}</td>
                        <td>${a.startTime}</td>
                        <td>
                            <c:choose>
                                <c:when test="${a.status == 'BOOKED'}"><span class="badge badge-blue">Booked</span></c:when>
                                <c:when test="${a.status == 'ATTENDED'}"><span class="badge badge-green">Attended</span></c:when>
                                <c:when test="${a.status == 'CANCELLED'}"><span class="badge badge-red">Cancelled</span></c:when>
                                <c:when test="${a.status == 'NO_SHOW'}"><span class="badge badge-gray">No Show</span></c:when>
                                <c:otherwise><span class="badge badge-gray">${a.status}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td style="white-space:nowrap;">
                            <form method="post" style="display:inline;" action="${pageContext.request.contextPath}/reception/update-status/${a.appointmentId}">
                                <input type="hidden" name="date" value="${selectedDate}">
                                <input type="hidden" name="status" value="ATTENDED">
                                <button class="btn btn-success btn-sm" type="submit">Attended</button>
                            </form>
                            <form method="post" style="display:inline;" action="${pageContext.request.contextPath}/reception/update-status/${a.appointmentId}">
                                <input type="hidden" name="date" value="${selectedDate}">
                                <input type="hidden" name="status" value="NO_SHOW">
                                <button class="btn btn-outline btn-sm" type="submit">No-show</button>
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
