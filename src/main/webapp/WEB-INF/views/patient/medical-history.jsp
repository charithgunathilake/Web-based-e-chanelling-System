<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Medical History" scope="request"/>
<c:set var="pageSubtitle" value="Your consultation records and prescriptions" scope="request"/>
<c:set var="currentPage" value="history" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="grid grid-2">
    <div class="card">
        <h2>Consultation Records</h2>
        <c:choose>
            <c:when test="${empty records}">
                <div class="empty-state">No health records yet.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="r" items="${records}">
                    <div style="border-bottom:1px solid var(--border);padding:12px 0;">
                        <strong>Dr. ${r.doctorName}</strong>
                        <span style="color:var(--text-muted);font-size:12.5px;">&middot; <fmt:formatDate value="${r.createdAt}" pattern="dd MMM yyyy"/></span>
                        <div style="font-size:13.5px;margin-top:6px;"><b>Diagnosis:</b> ${r.diagnosis}</div>
                        <div style="font-size:13.5px;"><b>Treatment:</b> ${r.treatment}</div>
                        <c:if test="${not empty r.notes}"><div style="font-size:13.5px;"><b>Notes:</b> ${r.notes}</div></c:if>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="card">
        <h2>Prescriptions</h2>
        <c:choose>
            <c:when test="${empty prescriptions}">
                <div class="empty-state">No prescriptions yet.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="p" items="${prescriptions}">
                    <div style="border-bottom:1px solid var(--border);padding:12px 0;">
                        <strong>Dr. ${p.doctorName}</strong>
                        <c:choose>
                            <c:when test="${p.status == 'FULFILLED'}"><span class="badge badge-green">Dispensed</span></c:when>
                            <c:otherwise><span class="badge badge-amber">Pending</span></c:otherwise>
                        </c:choose>
                        <div style="font-size:13.5px;margin-top:6px;white-space:pre-wrap;">${p.medicines}</div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
