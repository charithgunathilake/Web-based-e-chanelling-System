<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Manage User Roles" scope="request"/>
<c:set var="pageSubtitle" value="Activate/deactivate accounts and change roles" scope="request"/>
<c:set var="currentPage" value="users" scope="request"/>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<c:if test="${param.reset == '1'}"><div class="alert alert-success">Password reset successfully.</div></c:if>

<div class="card">
    <h2>All Users</h2>
    <div class="table-wrap">
    <table>
        <thead><tr><th>Username</th><th>Full Name</th><th>Role</th><th>Active</th><th>Change Role / Status</th><th>Reset Password</th></tr></thead>
        <tbody>
        <c:forEach var="u" items="${users}">
            <tr>
                <td>${u.username}</td>
                <td>${u.fullName}</td>
                <td><span class="badge badge-blue">${u.role}</span></td>
                <td>
                    <c:choose>
                        <c:when test="${u.active}"><span class="badge badge-green">Active</span></c:when>
                        <c:otherwise><span class="badge badge-red">Inactive</span></c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <form method="post" action="${pageContext.request.contextPath}/admin/users/update-role" style="display:flex;gap:6px;">
                        <input type="hidden" name="userId" value="${u.userId}">
                        <select name="role" class="form-control" style="padding:6px 8px;font-size:12.5px;">
                            <option value="PATIENT" ${u.role == 'PATIENT' ? 'selected' : ''}>PATIENT</option>
                            <option value="DOCTOR" ${u.role == 'DOCTOR' ? 'selected' : ''}>DOCTOR</option>
                            <option value="RECEPTION" ${u.role == 'RECEPTION' ? 'selected' : ''}>RECEPTION</option>
                            <option value="PHARMACIST" ${u.role == 'PHARMACIST' ? 'selected' : ''}>PHARMACIST</option>
                            <option value="OPERATIONS_MANAGER" ${u.role == 'OPERATIONS_MANAGER' ? 'selected' : ''}>OPERATIONS_MANAGER</option>
                            <option value="ADMIN" ${u.role == 'ADMIN' ? 'selected' : ''}>ADMIN</option>
                        </select>
                        <select name="active" class="form-control" style="padding:6px 8px;font-size:12.5px;">
                            <option value="true" ${u.active ? 'selected' : ''}>Active</option>
                            <option value="false" ${!u.active ? 'selected' : ''}>Inactive</option>
                        </select>
                        <button class="btn btn-primary btn-sm" type="submit">Save</button>
                    </form>
                </td>
                <td>
                    <form method="post" action="${pageContext.request.contextPath}/admin/users/reset-password" style="display:flex;gap:6px;">
                        <input type="hidden" name="userId" value="${u.userId}">
                        <input type="password" name="newPassword" class="form-control" placeholder="New password" style="padding:6px 8px;font-size:12.5px;" required>
                        <button class="btn btn-outline btn-sm" type="submit">Reset</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
