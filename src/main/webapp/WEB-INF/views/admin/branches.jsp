<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Branches & Rooms" scope="request"/>
<c:set var="pageSubtitle" value="Configure branch parameters and consultation rooms" scope="request"/>
<c:set var="currentPage" value="branches" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="grid grid-2">
    <div class="card">
        <h2>Branches</h2>
        <div class="table-wrap">
        <table>
            <thead><tr><th>Name</th><th>Address</th><th>Phone</th></tr></thead>
            <tbody>
            <c:forEach var="b" items="${branches}">
                <tr><td>${b.branchName}</td><td>${b.address}</td><td>${b.phone}</td></tr>
            </c:forEach>
            </tbody>
        </table>
        </div>
        <h3 style="margin-top:18px;">Add Branch</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/branches/add">
            <div class="form-group"><label>Branch Name</label><input class="form-control" name="branchName" required></div>
            <div class="form-group"><label>Address</label><input class="form-control" name="address" required></div>
            <div class="form-group"><label>Phone</label><input class="form-control" name="phone" required></div>
            <button class="btn btn-primary" type="submit">Add Branch</button>
        </form>
    </div>

    <div class="card">
        <h2>Rooms</h2>
        <div class="table-wrap">
        <table>
            <thead><tr><th>Room</th><th>Branch</th><th>Department</th><th>Status</th><th></th></tr></thead>
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
                    <td>
                        <c:if test="${r.status == 'ACTIVE'}">
                        <form method="post" action="${pageContext.request.contextPath}/admin/rooms/deactivate/${r.roomId}" onsubmit="return confirm('Deactivate this room? Existing appointment history is preserved.');">
                            <button class="btn btn-danger btn-sm" type="submit">Deactivate</button>
                        </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        </div>
        <h3 style="margin-top:18px;">Add Room</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/rooms/add">
            <div class="form-group">
                <label>Branch</label>
                <select class="form-control" name="branchId" required>
                    <c:forEach var="b" items="${branches}">
                        <option value="${b.branchId}">${b.branchName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Room Number</label><input class="form-control" name="roomNumber" required></div>
                <div class="form-group"><label>Department</label><input class="form-control" name="department" required></div>
            </div>
            <button class="btn btn-primary" type="submit">Add Room</button>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
