<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Prescription Queue" scope="request"/>
<c:set var="pageSubtitle" value="View e-prescriptions and confirm order fulfilment" scope="request"/>
<c:set var="currentPage" value="dashboard" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<c:if test="${param.dispensed == '1'}"><div class="alert alert-success">Prescription dispensed and patient notified.</div></c:if>

<div class="card">
    <h2>Pending Prescriptions</h2>
    <c:choose>
        <c:when test="${empty pending}">
            <div class="empty-state">No pending prescriptions. All caught up!</div>
        </c:when>
        <c:otherwise>
            <div class="table-wrap">
            <table>
                <thead><tr><th>Patient</th><th>Doctor</th><th>Medicines</th><th>Issued</th><th></th></tr></thead>
                <tbody>
                <c:forEach var="p" items="${pending}">
                    <tr>
                        <td>${p.patientName}</td>
                        <td>${p.doctorName}</td>
                        <td style="white-space:pre-wrap;max-width:320px;">${p.medicines}</td>
                        <td><fmt:formatDate value="${p.issuedAt}" pattern="dd MMM yyyy HH:mm"/></td>
                        <td>
                            <form method="post" action="${pageContext.request.contextPath}/pharmacist/dispense/${p.prescriptionId}">
                                <button class="btn btn-success btn-sm" type="submit">Confirm Fulfilment</button>
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
