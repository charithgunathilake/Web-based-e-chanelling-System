<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Book Appointment" scope="request"/>
<c:set var="pageSubtitle" value="Dr. ${doctor.fullName} - ${doctor.specialty}" scope="request"/>
<c:set var="currentPage" value="search" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="card">
    <h2>Available Sessions</h2>
    <c:choose>
        <c:when test="${empty slots}">
            <div class="empty-state">No available sessions for this doctor right now. Please check back later.</div>
        </c:when>
        <c:otherwise>
            <form method="post" action="${pageContext.request.contextPath}/patient/book">
                <div class="grid grid-3">
                    <c:forEach var="s" items="${slots}">
                        <label class="slot-pill">
                            <input type="radio" name="scheduleId" value="${s.scheduleId}" required>
                            <fmt:formatDate value="${s.scheduleDate}" pattern="dd MMM yyyy"/> &middot; ${s.startTime}-${s.endTime} &middot; Room ${s.roomNumber}
                        </label>
                    </c:forEach>
                </div>
                <button class="btn btn-primary" style="margin-top:18px;" type="submit">Confirm Booking</button>
            </form>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
