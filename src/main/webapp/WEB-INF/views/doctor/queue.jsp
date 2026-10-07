<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="card">
    <div class="card-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
        <div>
            <h2 class="card-title" style="display:flex; align-items:center; gap:8px;">
                <span>👥</span> Doctor's Active Patient Queue
            </h2>
            <div style="font-size:13px; color:#94a3b8; margin-top:4px;">
                Real-time synchronized waiting queue for active clinical consultation sessions.
            </div>
        </div>
        <div style="display:flex; gap:10px; align-items:center;">
            <span class="status-pill status-BOOKED" style="font-size:12px;">
                <c:choose>
                    <c:when test="${not empty queuedPatients}">${queuedPatients.size()} Active Patients</c:when>
                    <c:otherwise>0 Patients</c:otherwise>
                </c:choose>
            </span>
            <a href="${pageContext.request.contextPath}/portal?tab=prescribe" class="btn-glow" style="padding:8px 16px; font-size:13px; text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
                <span>✏️</span> Issue Prescriptions
            </a>
        </div>
    </div>

    <!-- Active Queue Table -->
    <div style="overflow-x:auto;">
        <table class="table-custom">
            <thead>
                <tr>
                    <th>Patient ID</th>
                    <th>Full Name</th>
                    <th>Age / Gender</th>
                    <th>Appointment Time</th>
                    <th>Status</th>
                    <th style="min-width:180px; text-align:center;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="a" items="${queuedPatients}">
                    <tr>
                        <td>
                            <strong style="color:#60a5fa; font-size:14px;">#P-${a.patientId}</strong>
                            <div style="font-size:11px; color:#94a3b8;">Token #${a.tokenNo}</div>
                        </td>
                        <td>
                            <div style="font-weight:600; color:#f1f5f9; font-size:14.5px;">${a.patientName}</div>
                            <div style="font-size:11px; color:#94a3b8;">NIC: ${a.patientNic != null ? a.patientNic : 'N/A'} &bull; Tel: ${a.patientPhone != null ? a.patientPhone : 'N/A'}</div>
                        </td>
                        <td>
                            <span style="color:#e2e8f0;">${a.ageGender != null ? a.ageGender : 'N/A'}</span>
                        </td>
                        <td>
                            <div style="color:#fbbf24; font-weight:700; display:inline-flex; align-items:center; gap:4px;">
                                <span>⏰</span> ${a.startTime != null ? a.startTime : '09:00'}
                            </div>
                        </td>
                        <td>
                            <span class="status-pill status-BOOKED">
                                <c:choose>
                                    <c:when test="${a.status == 'BOOKED'}">Waiting</c:when>
                                    <c:otherwise>${a.status}</c:otherwise>
                                </c:choose>
                            </span>
                        </td>
                        <td style="text-align:center;">
                            <a href="${pageContext.request.contextPath}/portal?tab=prescribe&patientId=${a.patientId}" 
                               class="btn-glow" 
                               style="padding:6px 14px; font-size:12px; text-decoration:none; display:inline-flex; align-items:center; gap:6px;">
                                <span>✏️</span> Issue Prescription &rarr;
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty queuedPatients}">
                    <tr>
                        <td colspan="6" style="text-align:center; padding:32px 16px; color:#94a3b8;">
                            <div style="font-size:24px; margin-bottom:8px;">👥</div>
                            <div>No active patients waiting in the queue.</div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
