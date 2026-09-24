<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Search Doctors" scope="request"/>
<c:set var="pageSubtitle" value="Find a specialist and book a consultation" scope="request"/>
<c:set var="currentPage" value="search" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="card" style="margin-bottom:20px;">
    <form method="get" action="${pageContext.request.contextPath}/patient/search-doctors" class="form-row" style="align-items:flex-end;">
        <div class="form-group" style="flex:2;">
            <label>Search by specialty</label>
            <input class="form-control" type="text" name="specialty" value="${specialty}" placeholder="e.g. Cardiology, General...">
        </div>
        <div class="form-group" style="flex:0 0 auto;">
            <button class="btn btn-primary" type="submit">Search</button>
        </div>
    </form>
</div>

<div class="grid grid-3">
    <c:choose>
        <c:when test="${empty doctors}">
            <div class="empty-state">No doctors found for that specialty.</div>
        </c:when>
        <c:otherwise>
            <c:forEach var="d" items="${doctors}">
                <div class="doctor-card">
                    <div class="doctor-avatar">${d.fullName.charAt(0)}</div>
                    <div><strong>${d.fullName}</strong></div>
                    <div style="color:var(--text-muted);font-size:13px;">${d.specialty}</div>
                    <div style="color:var(--text-muted);font-size:12.5px;">${d.branchName}</div>
                    <a class="btn btn-primary btn-sm" style="margin-top:8px;" href="${pageContext.request.contextPath}/patient/book/${d.doctorId}">View Availability</a>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
