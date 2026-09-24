<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Patient Record" scope="request"/>
<c:set var="pageSubtitle" value="${appointment.patientName} - Token #${appointment.tokenNo}" scope="request"/>
<c:set var="currentPage" value="dashboard" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<c:if test="${param.saved == '1'}"><div class="alert alert-success">Consultation notes saved.</div></c:if>
<c:if test="${param.prescribed == '1'}"><div class="alert alert-success">Prescription issued.</div></c:if>

<div class="grid grid-2">
    <div class="card">
        <h2>Previous Health History</h2>
        <c:choose>
            <c:when test="${empty records}">
                <div class="empty-state">No previous records for this patient.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="r" items="${records}">
                    <div style="border-bottom:1px solid var(--border);padding:10px 0;font-size:13.5px;">
                        <fmt:formatDate value="${r.createdAt}" pattern="dd MMM yyyy"/> &middot; <b>${r.diagnosis}</b><br>
                        <span style="color:var(--text-muted);">${r.treatment}</span>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="card">
        <h2>Add Diagnosis / Consultation Notes</h2>
        <form method="post" action="${pageContext.request.contextPath}/doctor/health-record">
            <input type="hidden" name="patientId" value="${appointment.patientId}">
            <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
            <div class="form-group"><label>Diagnosis</label><textarea class="form-control" name="diagnosis" rows="2" required></textarea></div>
            <div class="form-group"><label>Treatment</label><textarea class="form-control" name="treatment" rows="2" required></textarea></div>
            <div class="form-group"><label>Notes (allergies, ongoing conditions, etc.)</label><textarea class="form-control" name="notes" rows="2"></textarea></div>
            <button class="btn btn-primary" type="submit">Save & Mark Attended</button>
        </form>
    </div>
</div>

<div class="card" style="margin-top:20px;">
    <h2>Issue e-Prescription</h2>
    <form method="post" action="${pageContext.request.contextPath}/doctor/prescription">
        <input type="hidden" name="patientId" value="${appointment.patientId}">
        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
        <div class="form-group">
            <label>Medicines &amp; Dosage Instructions</label>
            <textarea class="form-control" name="medicines" rows="3" placeholder="e.g. Amoxicillin 500mg - 1 tablet 3x/day for 5 days" required></textarea>
        </div>
        <button class="btn btn-success" type="submit">Issue Prescription</button>
    </form>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
