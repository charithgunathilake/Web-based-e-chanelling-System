<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- Success Confirmation Toast / Banner -->
<c:if test="${param.pharmacySelected == '1'}">
    <div style="background: rgba(16,185,129,0.15); border: 1px solid rgba(16,185,129,0.4); color: #34d399; padding: 14px 18px; border-radius: 12px; margin-bottom: 22px; display: flex; align-items: center; gap: 12px; box-shadow: 0 4px 14px rgba(16,185,129,0.15);">
        <span style="font-size: 22px;">✅</span>
        <div>
            <div style="font-weight: 700; font-size: 15px;">Prescription Forwarded Successfully!</div>
            <div style="font-size: 13.5px; color: #a7f3d0; margin-top: 2px;">
                Prescription successfully forwarded to <strong>${param.pharmacyName != null ? param.pharmacyName : 'the selected pharmacy'}</strong>!
            </div>
        </div>
    </div>
</c:if>

<div class="card">
    <div class="card-header" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
        <div>
            <h2 class="card-title" style="display: flex; align-items: center; gap: 8px;">
                <span>💊</span> My Doctor e-Prescriptions
            </h2>
            <div style="font-size: 13px; color: #94a3b8; margin-top: 4px;">
                View digital prescriptions issued by your attending physicians and choose your preferred pharmacy for fulfillment.
            </div>
        </div>
        <div style="display: flex; gap: 10px; align-items: center;">
            <span class="status-pill status-BOOKED" style="font-size: 12px;">
                <c:choose>
                    <c:when test="${not empty prescriptions}">${prescriptions.size()} Prescriptions</c:when>
                    <c:otherwise>0 Records</c:otherwise>
                </c:choose>
            </span>
        </div>
    </div>

    <!-- Prescriptions List / Table -->
    <div style="overflow-x: auto;">
        <table class="table-custom">
            <thead>
                <tr>
                    <th>Rx ID</th>
                    <th>Attending Doctor</th>
                    <th>Clinical Diagnosis</th>
                    <th>Prescribed Medicines &amp; Dosage</th>
                    <th>Status</th>
                    <th style="min-width: 320px;">Pharmacy Selection &amp; Forwarding</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${prescriptions}">
                    <tr>
                        <td>
                            <strong style="color: #60a5fa; font-size: 14px;">#Rx-${p.prescriptionId}</strong>
                            <div style="font-size: 11px; color: #94a3b8; margin-top: 2px;">
                                <c:choose>
                                    <c:when test="${p.issuedAt != null}">
                                        ${p.issuedAt}
                                    </c:when>
                                    <c:otherwise>Recent</c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                        <td>
                            <div style="font-weight: 600; color: #f1f5f9; font-size: 14px;">
                                ${p.doctorName != null ? p.doctorName : 'Dr. Nimal Perera'}
                            </div>
                            <div style="font-size: 11px; color: #94a3b8;">Attending Specialist</div>
                        </td>
                        <td>
                            <span style="color: #cbd5e1; font-size: 13px;">
                                ${p.diagnosis != null ? p.diagnosis : 'Standard Clinical Consultation'}
                            </span>
                        </td>
                        <td>
                            <div style="color: #fbbf24; font-weight: 500; font-size: 13.5px; line-height: 1.4;">
                                ${p.medicines}
                            </div>
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
                        <td>
                            <c:choose>
                                <c:when test="${p.status == 'DISPENSED' || p.status == 'FULFILLED' || p.status == 'COMPLETED'}">
                                    <div style="display: inline-flex; align-items: center; gap: 8px; background: rgba(16,185,129,0.12); border: 1px solid rgba(16,185,129,0.3); color: #34d399; padding: 8px 14px; border-radius: 8px; font-size: 13.5px; font-weight: 600;">
                                        <span>✅</span>
                                        <span>Medication dispensed by <strong>${p.pharmacyName != null && !empty p.pharmacyName ? p.pharmacyName : 'Selected Pharmacy'}</strong></span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Pharmacy Selection Form -->
                                    <form method="post" action="${pageContext.request.contextPath}/patient/prescription/select-pharmacy" style="display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                                        <input type="hidden" name="prescriptionId" value="${p.prescriptionId}">
                                        <select name="pharmacyName" class="form-control-dark" style="min-width: 175px; padding: 7px 10px; font-size: 13px;" required>
                                            <option value="">-- Select Preferred Pharmacy --</option>
                                            <option value="Asiri Pharmacy" <c:if test="${p.pharmacyName == 'Asiri Pharmacy'}">selected</c:if>>Asiri Pharmacy</option>
                                            <option value="Union Pharmacy" <c:if test="${p.pharmacyName == 'Union Pharmacy'}">selected</c:if>>Union Pharmacy</option>
                                            <option value="Laksiri Pharmacy" <c:if test="${p.pharmacyName == 'Laksiri Pharmacy'}">selected</c:if>>Laksiri Pharmacy</option>
                                            <option value="Durdans Pharmacy" <c:if test="${p.pharmacyName == 'Durdans Pharmacy'}">selected</c:if>>Durdans Pharmacy</option>
                                            <option value="Sujeewa Pharmacy" <c:if test="${p.pharmacyName == 'Sujeewa Pharmacy'}">selected</c:if>>Sujeewa Pharmacy</option>
                                            <option value="New Town Pharmacy" <c:if test="${p.pharmacyName == 'New Town Pharmacy'}">selected</c:if>>New Town Pharmacy</option>
                                        </select>
                                        <button type="submit" class="btn-glow" style="padding: 7px 14px; font-size: 13px; display: inline-flex; align-items: center; gap: 6px; white-space: nowrap;">
                                            <span>🏥</span> Send to Pharmacy
                                        </button>
                                    </form>
                                    <c:if test="${p.pharmacyName != null && !empty p.pharmacyName}">
                                        <div style="font-size: 11.5px; color: #a78bfa; margin-top: 4px; display: flex; align-items: center; gap: 4px;">
                                            <span>📍</span> Currently assigned to: <strong>${p.pharmacyName}</strong>
                                        </div>
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty prescriptions}">
                    <tr>
                        <td colspan="6" style="text-align: center; padding: 36px 16px; color: #94a3b8;">
                            <div style="font-size: 28px; margin-bottom: 8px;">💊</div>
                            <div style="font-weight: 600; font-size: 15px; color: #f1f5f9;">No e-prescriptions found</div>
                            <div style="font-size: 13px; margin-top: 4px;">Once your doctor issues an e-prescription during consultation, it will appear here for pharmacy forwarding.</div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
