<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Manage Schedule" scope="request"/>
<c:set var="pageSubtitle" value="Create and manage your consultation sessions" scope="request"/>
<c:set var="currentPage" value="schedule" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<c:if test="${param.created == '1'}"><div class="alert alert-success">Session created successfully.</div></c:if>
<c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>

<div class="grid grid-2">
    <div class="card">
        <h2>Create New Session</h2>
        <form method="post" action="${pageContext.request.contextPath}/doctor/schedule">
            <div class="form-group">
                <label>Room</label>
                <select class="form-control" name="roomId" required>
                    <c:forEach var="r" items="${rooms}">
                        <c:if test="${r.status == 'ACTIVE'}">
                            <option value="${r.roomId}">${r.roomNumber} - ${r.department} (${r.branchName})</option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Date</label><input class="form-control" type="date" name="scheduleDate" required></div>
                <div class="form-group"><label>Max Patients</label><input class="form-control" type="number" name="maxPatients" value="20" min="1" required></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Start Time</label><input class="form-control" type="time" name="startTime" required></div>
                <div class="form-group"><label>End Time</label><input class="form-control" type="time" name="endTime" required></div>
            </div>
            <button class="btn btn-primary" type="submit">Create Session</button>
        </form>
    </div>

    <div class="card">
        <h2>My Sessions</h2>
        <c:choose>
            <c:when test="${empty schedule}">
                <div class="empty-state">No sessions created yet.</div>
            </c:when>
            <c:otherwise>
                <div class="table-wrap">
                <table>
                    <thead><tr><th>Date</th><th>Time</th><th>Room</th><th>Status</th><th></th></tr></thead>
                    <tbody>
                    <c:forEach var="s" items="${schedule}">
                        <tr>
                            <td><fmt:formatDate value="${s.scheduleDate}" pattern="dd MMM yyyy"/></td>
                            <td>${s.startTime}-${s.endTime}</td>
                            <td>${s.roomNumber}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${s.status == 'AVAILABLE'}"><span class="badge badge-green">Available</span></c:when>
                                    <c:when test="${s.status == 'CANCELLED'}"><span class="badge badge-red">Cancelled</span></c:when>
                                    <c:otherwise><span class="badge badge-gray">${s.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${s.status == 'AVAILABLE'}">
                                <form method="post" action="${pageContext.request.contextPath}/doctor/schedule/cancel/${s.scheduleId}" onsubmit="return confirm('Cancel/block this session?');">
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
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
