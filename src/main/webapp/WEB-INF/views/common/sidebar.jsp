<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="loggedInUser" value="${sessionScope.loggedInUser}"/>
<div class="sidebar">
    <div class="brand">
        <div class="logo-badge">EC</div>
        <div class="brand-text">E-Channeling<small>SLIIT SE2030</small></div>
    </div>
    <span class="role-pill">${loggedInUser.role}</span>

    <c:if test="${loggedInUser.role == 'PATIENT'}">
        <a class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/patient/dashboard"><span class="icon">&#127968;</span> Dashboard</a>
        <a class="nav-link ${currentPage == 'search' ? 'active' : ''}" href="${pageContext.request.contextPath}/patient/search-doctors"><span class="icon">&#128270;</span> Search Doctors</a>
        <a class="nav-link ${currentPage == 'history' ? 'active' : ''}" href="${pageContext.request.contextPath}/patient/medical-history"><span class="icon">&#128193;</span> Medical History</a>
        <a class="nav-link ${currentPage == 'feedback' ? 'active' : ''}" href="${pageContext.request.contextPath}/patient/feedback"><span class="icon">&#11088;</span> Feedback</a>
    </c:if>

    <c:if test="${loggedInUser.role == 'DOCTOR'}">
        <a class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/doctor/dashboard"><span class="icon">&#127968;</span> Dashboard</a>
        <a class="nav-link ${currentPage == 'schedule' ? 'active' : ''}" href="${pageContext.request.contextPath}/doctor/schedule"><span class="icon">&#128197;</span> Manage Schedule</a>
    </c:if>

    <c:if test="${loggedInUser.role == 'RECEPTION'}">
        <a class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/reception/dashboard"><span class="icon">&#127968;</span> Dashboard</a>
        <a class="nav-link ${currentPage == 'walkin' ? 'active' : ''}" href="${pageContext.request.contextPath}/reception/walkin"><span class="icon">&#128100;</span> Register Walk-in</a>
        <a class="nav-link ${currentPage == 'daily' ? 'active' : ''}" href="${pageContext.request.contextPath}/reception/daily-list"><span class="icon">&#128203;</span> Daily Appointments</a>
    </c:if>

    <c:if test="${loggedInUser.role == 'PHARMACIST'}">
        <a class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/pharmacist/dashboard"><span class="icon">&#128138;</span> Prescription Queue</a>
    </c:if>

    <c:if test="${loggedInUser.role == 'OPERATIONS_MANAGER'}">
        <a class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/operations/dashboard"><span class="icon">&#128202;</span> Operations Dashboard</a>
    </c:if>

    <c:if test="${loggedInUser.role == 'ADMIN'}">
        <a class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard"><span class="icon">&#127968;</span> Dashboard</a>
        <a class="nav-link ${currentPage == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users"><span class="icon">&#128100;</span> Manage Users</a>
        <a class="nav-link ${currentPage == 'branches' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/branches"><span class="icon">&#127976;</span> Branches &amp; Rooms</a>
    </c:if>

    <div class="sidebar-footer">
        <div class="user-name">${loggedInUser.fullName}</div>
        <div class="user-role">${loggedInUser.username}</div>
        <a class="nav-link" href="${pageContext.request.contextPath}/logout"><span class="icon">&#8592;</span> Logout</a>
    </div>
</div>
