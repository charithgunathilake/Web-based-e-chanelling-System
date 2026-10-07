<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:if test="${param.prescribed == '1'}">
    <div style="background:rgba(16,185,129,0.15); border:1px solid rgba(16,185,129,0.4); color:#34d399; padding:14px 18px; border-radius:10px; margin-bottom:20px; display:flex; align-items:center; gap:10px;">
        <span style="font-size:20px;">✅</span>
        <span style="font-weight:600;">Prescription issued and consultation record saved successfully. Sent to Pharmacy queue.</span>
    </div>
</c:if>
<c:if test="${param.updated == '1'}">
    <div style="background:rgba(59,130,246,0.15); border:1px solid rgba(59,130,246,0.4); color:#60a5fa; padding:14px 18px; border-radius:10px; margin-bottom:20px; display:flex; align-items:center; gap:10px;">
        <span style="font-size:20px;">ℹ️</span>
        <span style="font-weight:600;">Prescription successfully updated.</span>
    </div>
</c:if>
<c:if test="${param.deleted == '1'}">
    <div style="background:rgba(239,68,68,0.15); border:1px solid rgba(239,68,68,0.4); color:#f87171; padding:14px 18px; border-radius:10px; margin-bottom:20px; display:flex; align-items:center; gap:10px;">
        <span style="font-size:20px;">🗑️</span>
        <span style="font-weight:600;">Prescription successfully deleted.</span>
    </div>
</c:if>

<div class="card" id="prescriptionCard">
    <div class="card-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
        <div>
            <h2 class="card-title" id="prescriptionFormTitle" style="display:flex; align-items:center; gap:8px;">
                <span>✏️</span> Issue e-Prescription &amp; Consultation Record
            </h2>
            <div style="font-size:13px; color:#94a3b8; margin-top:4px;">
                Select an active patient from the shared queue to load clinical consultation &amp; medication details.
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/portal?tab=queue" class="btn-glow" style="padding:8px 16px; font-size:13px; text-decoration:none; display:inline-flex; align-items:center; gap:6px; background: rgba(59,130,246,0.15); border: 1px solid rgba(59,130,246,0.3); color: #60a5fa;">
            <span>👥</span> View Queue (${queuedPatients != null ? queuedPatients.size() : 0})
        </a>
    </div>
    
    <form method="post" action="${pageContext.request.contextPath}/doctor/prescription" id="prescriptionForm">
        <input type="hidden" name="prescriptionId" id="editPrescriptionId" value="">
        <input type="hidden" name="appointmentId" id="prescriptionAppointmentId" value="">

        <!-- Patient Selection from Queue -->
        <div class="form-grid" style="margin-bottom: 20px;">
            <div class="form-group" style="grid-column: span 2;">
                <label style="color:#60a5fa; font-weight:700; display:flex; align-items:center; gap:6px;">
                    <span>👤</span> Select Patient from Active Queue (Synchronized Data)
                </label>
                <select class="form-control-dark" id="patientSelector" name="patientId" required onchange="onPrescribePatientChange(this.value)">
                    <option value="">-- Select Active Patient (${queuedPatients != null ? queuedPatients.size() : 0} in Queue) --</option>
                    <c:forEach var="p" items="${queuedPatients}">
                        <option value="${p.patientId}" 
                                data-appointment="${p.appointmentId}" 
                                data-name="${p.patientName}" 
                                data-nic="${p.patientNic}" 
                                data-agegender="${p.ageGender}" 
                                data-phone="${p.patientPhone}"
                                data-time="${p.startTime}"
                                data-token="${p.tokenNo}"
                                data-status="${p.status == 'BOOKED' ? 'Waiting' : p.status}" 
                                <c:if test="${selectedPatientId == p.patientId}">selected</c:if>>
                            #P-${p.patientId} &bull; ${p.patientName} (${p.ageGender}) [Token #${p.tokenNo} - ${p.startTime}] &bull; ${p.status == 'BOOKED' ? 'Waiting' : p.status}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <!-- Dynamic Patient Summary Card -->
        <div id="patientSummaryCard" style="background: rgba(15,23,42,0.85); border: 1px solid rgba(59,130,246,0.35); border-radius: 12px; padding: 18px; margin-bottom: 22px; display: none; box-shadow: 0 4px 16px rgba(0,0,0,0.2);">
            <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
                <div>
                    <div style="display:flex; align-items:center; gap:8px;">
                        <span style="font-size:20px;">🧑‍⚕️</span>
                        <h3 id="summaryPatientName" style="margin:0; font-size:17px; font-weight:700; color:#f8fafc;">-</h3>
                    </div>
                    <div style="font-size:13px; color:#94a3b8; margin-top:6px; display:flex; flex-wrap:wrap; gap:12px;">
                        <span>Patient ID: <strong id="summaryPatientId" style="color:#60a5fa;">-</strong></span>
                        <span>&bull;</span>
                        <span>Age / Gender: <strong id="summaryAgeGender" style="color:#e2e8f0;">-</strong></span>
                        <span>&bull;</span>
                        <span>NIC: <strong id="summaryNic" style="color:#e2e8f0;">-</strong></span>
                        <span>&bull;</span>
                        <span>Phone: <strong id="summaryPhone" style="color:#e2e8f0;">-</strong></span>
                    </div>
                </div>
                <div>
                    <span id="summaryStatus" class="status-pill status-BOOKED">Waiting</span>
                </div>
            </div>
        </div>

        <!-- Prescription Form Fields -->
        <div class="form-grid">
            <div class="form-group" style="grid-column: span 2;">
                <label>Clinical Diagnosis <span style="color:#ef4444;">*</span></label>
                <input class="form-control-dark" name="diagnosis" id="prescribeDiagnosis" placeholder="e.g., Acute Bronchitis / Hypertension / Diabetes Type 2" required>
            </div>
            <div class="form-group" style="grid-column: span 2;">
                <label>Prescribed Medicines <span style="color:#ef4444;">*</span></label>
                <textarea class="form-control-dark" name="medicines" id="prescribeMedicines" rows="3" placeholder="e.g., Amoxicillin 500mg, Paracetamol 500mg, Cetirizine 10mg" required></textarea>
            </div>
            <div class="form-group">
                <label>Dosage &amp; Duration</label>
                <input class="form-control-dark" name="dosage" id="prescribeDosage" placeholder="e.g., 1 Tablet TDS after meals for 5 Days">
            </div>
            <div class="form-group">
                <label>Special Instructions / Notes</label>
                <input class="form-control-dark" name="instructions" id="prescribeInstructions" placeholder="e.g., Drink warm water, avoid cold drinks, review in 1 week">
            </div>
        </div>

        <div style="margin-top: 20px; display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
            <button type="submit" id="prescribeSubmitBtn" class="btn-glow" style="padding: 12px 28px; font-size:14px; display:inline-flex; align-items:center; gap:6px;">
                <span>💾</span> Save &amp; Dispense
            </button>
            <button type="button" id="prescribeCancelEditBtn" onclick="cancelPrescriptionEdit()" class="btn-danger-sm" style="display:none; padding: 11px 20px; font-size:13px; background: rgba(148,163,184,0.2); border-color: rgba(148,163,184,0.4); color: #cbd5e1;">
                Cancel Edit
            </button>
        </div>
    </form>

    <!-- Previously Issued Prescriptions Table / History View -->
    <div style="margin-top: 36px; border-top: 1px solid rgba(255,255,255,0.08); padding-top: 24px;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; flex-wrap:wrap; gap:10px;">
            <div>
                <h3 class="card-title" style="font-size:16px; margin:0;">Previously Issued Prescriptions</h3>
                <div style="font-size:12px; color:#94a3b8; margin-top:4px;">Manage, edit, or delete previously prescribed consultation records</div>
            </div>
            <span class="status-pill status-BOOKED" style="font-size:12px;">Issued Records</span>
        </div>

        <div style="overflow-x:auto;">
            <table class="table-custom">
                <thead>
                    <tr>
                        <th>Rx ID</th>
                        <th>Patient Name</th>
                        <th>Clinical Diagnosis</th>
                        <th>Prescribed Medicines</th>
                        <th>Status</th>
                        <th style="min-width:180px; text-align:center;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="pr" items="${doctorPrescriptions}">
                        <tr>
                            <td><strong style="color:#60a5fa;">#${pr.prescriptionId}</strong></td>
                            <td>
                                <div style="font-weight:600; color:#f1f5f9;">${pr.patientName}</div>
                                <div style="font-size:11px; color:#94a3b8;">Patient ID: #P-${pr.patientId}</div>
                            </td>
                            <td>
                                <span style="color:#cbd5e1; font-size:13px;">${pr.diagnosis != null ? pr.diagnosis : 'Standard Clinical Protocol'}</span>
                            </td>
                            <td>
                                <span style="color:#fbbf24; font-size:13px;">${pr.medicines}</span>
                            </td>
                            <td>
                                <span class="status-pill status-${pr.status}">${pr.status}</span>
                            </td>
                            <td style="text-align:center;">
                                <div style="display:inline-flex; gap:8px; align-items:center; justify-content:center;">
                                    <!-- Yellow Edit Button -->
                                    <button type="button" class="btn-warning-sm" 
                                            onclick="editPrescription('${pr.prescriptionId}', '${pr.patientId}', '${pr.patientName}', '${pr.diagnosis}', '${pr.medicines}')"
                                            title="Edit Prescription">
                                        <span>✏️</span> Edit
                                    </button>

                                    <!-- Red Delete Button -->
                                    <form method="post" action="${pageContext.request.contextPath}/doctor/prescription/delete/${pr.prescriptionId}" style="display:inline; margin:0;">
                                        <button type="submit" class="btn-danger-sm" 
                                                onclick="return confirm('Are you sure you want to delete this prescription?');"
                                                title="Delete Prescription">
                                            <span>🗑️</span> Delete
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty doctorPrescriptions}">
                        <tr>
                            <td colspan="6" style="text-align:center; padding:24px; color:#94a3b8;">
                                No prescriptions recorded yet.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
