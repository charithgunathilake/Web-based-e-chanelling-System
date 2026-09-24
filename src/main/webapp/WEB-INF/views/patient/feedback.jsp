<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Submit Feedback" scope="request"/>
<c:set var="pageSubtitle" value="Rate a completed appointment" scope="request"/>
<c:set var="currentPage" value="feedback" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<c:if test="${param.submitted == '1'}"><div class="alert alert-success">Thank you! Your feedback has been submitted.</div></c:if>
<c:if test="${not empty error}"><div class="alert alert-error">${error}</div></c:if>

<div class="card">
    <h2>Leave Feedback</h2>
    <c:set var="attendedCount" value="0"/>
    <form method="post" action="${pageContext.request.contextPath}/patient/feedback">
        <div class="form-group">
            <label>Completed Appointment</label>
            <select class="form-control" name="appointmentId" required>
                <option value="">-- Select an attended appointment --</option>
                <c:forEach var="a" items="${appointments}">
                    <c:if test="${a.status == 'ATTENDED'}">
                        <option value="${a.appointmentId}">Dr. ${a.doctorName} - <fmt:formatDate value="${a.scheduleDate}" pattern="dd MMM yyyy"/></option>
                    </c:if>
                </c:forEach>
            </select>
        </div>
        <div class="form-group">
            <label>Rating</label>
            <select class="form-control" name="rating" required>
                <option value="5">5 - Excellent</option>
                <option value="4">4 - Good</option>
                <option value="3">3 - Average</option>
                <option value="2">2 - Poor</option>
                <option value="1">1 - Very Poor</option>
            </select>
        </div>
        <div class="form-group">
            <label>Review (optional)</label>
            <textarea class="form-control" name="review" rows="3"></textarea>
        </div>
        <button class="btn btn-primary" type="submit">Submit Feedback</button>
    </form>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
