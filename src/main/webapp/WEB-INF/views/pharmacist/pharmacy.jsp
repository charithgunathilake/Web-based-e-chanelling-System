<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:if test="${param.dispensed == '1'}">
    <div style="background:rgba(16,185,129,0.15); border:1px solid rgba(16,185,129,0.4); color:#34d399; padding:14px 18px; border-radius:12px; margin-bottom:20px; display:flex; align-items:center; gap:12px; box-shadow:0 4px 14px rgba(16,185,129,0.15);">
        <span style="font-size:22px;">✅</span>
        <div>
            <div style="font-weight:700; font-size:15px;">Prescription Dispensed Successfully!</div>
            <div style="font-size:13px; color:#a7f3d0; margin-top:2px;">
                The prescription status has been updated to <strong>Dispensed</strong> across Doctor, Patient, and Pharmacy systems.
            </div>
        </div>
    </div>
</c:if>

<div class="card">
    <div class="card-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px;">
        <div>
            <h2 class="card-title" style="display:flex; align-items:center; gap:8px;">
                <span>💊</span> Incoming Doctor e-Prescriptions
            </h2>
            <p style="font-size:13px; color:#94a3b8; margin:4px 0 0 0;">
                Review e-prescriptions assigned by patients and dispense medications directly to their designated pharmacy.
            </p>
        </div>
        <span class="status-pill status-BOOKED" style="font-size:12px;">Pharmacist Fulfillment Queue</span>
    </div>

    <div style="overflow-x:auto;">
        <table class="table-custom">
            <thead>
                <tr>
                    <th>Rx ID</th>
                    <th>Patient Name</th>
                    <th>Doctor</th>
                    <th>Diagnosis / Clinical Notes</th>
                    <th>Prescribed Medicines</th>
                    <th>Patient Selected Pharmacy</th>
                    <th>Status</th>
                    <th style="min-width:140px; text-align:center;">Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${pending}">
                    <tr>
                        <td>
                            <strong style="color:#60a5fa;">#Rx-${p.prescriptionId}</strong>
                            <div style="font-size:11px; color:#94a3b8; margin-top:2px;">
                                <c:choose>
                                    <c:when test="${p.issuedAt != null}">${p.issuedAt}</c:when>
                                    <c:otherwise>Recent</c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                        <td>
                            <div style="font-weight:600; color:#f1f5f9;">${p.patientName}</div>
                            <div style="font-size:11px; color:#94a3b8;">Patient ID: #P-${p.patientId}</div>
                        </td>
                        <td>
                            <div style="color:#e2e8f0;">${p.doctorName != null ? p.doctorName : 'Attending Doctor'}</div>
                            <div style="font-size:11px; color:#94a3b8;">Specialist Physician</div>
                        </td>
                        <td>
                            <span style="color:#cbd5e1; font-size:13px;">${p.diagnosis != null ? p.diagnosis : 'Standard Clinical Protocol'}</span>
                        </td>
                        <td>
                            <div style="color:#fbbf24; font-weight:500; font-size:13.5px; line-height:1.4;">${p.medicines}</div>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty p.pharmacyName}">
                                    <div style="display:inline-flex; align-items:center; gap:6px; background:rgba(59,130,246,0.15); border:1px solid rgba(59,130,246,0.35); color:#60a5fa; padding:6px 12px; border-radius:8px; font-size:13px; font-weight:600;">
                                        <span>🏥</span> ${p.pharmacyName}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:#94a3b8; font-size:12px; font-style:italic;">Not specified</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${p.status == 'DISPENSED' || p.status == 'FULFILLED' || p.status == 'COMPLETED'}">
                                    <span class="status-pill status-DISPENSED">Dispensed</span>
                                </c:when>
                                <c:when test="${p.status == 'PENDING_PHARMACY'}">
                                    <span class="status-pill status-PENDING_PHARMACY">Sent to Pharmacy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-pill status-PENDING">Pending Selection</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="text-align:center;">
                            <form method="post" action="${pageContext.request.contextPath}/pharmacist/dispense/${p.prescriptionId}" style="display:inline; margin:0;">
                                <input type="hidden" name="pharmacyName" value="${p.pharmacyName}">
                                <button type="submit" class="btn-success-sm" style="white-space:nowrap; display:inline-flex; align-items:center; gap:6px; padding:7px 16px; font-size:13px; font-weight:600; cursor:pointer;">
                                    <span>💊</span> Dispense
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty pending}">
                    <tr>
                        <td colspan="8" style="text-align:center; padding:36px 16px; color:#94a3b8;">
                            <div style="font-size:28px; margin-bottom:8px;">💊</div>
                            <div style="font-weight:600; font-size:15px; color:#f1f5f9;">No pending e-prescriptions in queue</div>
                            <div style="font-size:13px; margin-top:4px;">All patient-forwarded prescriptions have been successfully dispensed.</div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
