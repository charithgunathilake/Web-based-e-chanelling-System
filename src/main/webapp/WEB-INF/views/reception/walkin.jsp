<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Register Walk-in Patient" scope="request"/>
<c:set var="pageSubtitle" value="Create a patient record for a walk-in visitor" scope="request"/>
<c:set var="currentPage" value="walkin" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>

<div class="card" style="max-width:560px;">
    <h2>Patient Details</h2>
    <form method="post" action="${pageContext.request.contextPath}/reception/walkin">
        <div class="form-group"><label>Full Name</label><input class="form-control" name="fullName" required></div>
        <div class="form-row">
            <div class="form-group"><label>Phone</label><input class="form-control" name="phone" required></div>
            <div class="form-group"><label>NIC</label><input class="form-control" name="nic"></div>
        </div>
        <div class="form-group"><label>Address</label><input class="form-control" name="address"></div>
        <button class="btn btn-primary" type="submit">Register Patient</button>
    </form>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
