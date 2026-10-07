<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    .clinical-input-error {
        border-color: #ef4444 !important;
        background: rgba(239, 68, 68, 0.06) !important;
        box-shadow: 0 0 0 2px rgba(239, 68, 68, 0.25) !important;
    }
    .clinical-error-text {
        color: #f87171;
        font-size: 12px;
        margin-top: 4px;
        display: none;
        font-weight: 500;
    }
</style>

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
<c:if test="${param.error == 'invalid_clinical'}">
    <div id="serverClinicalAlert" style="background:rgba(239,68,68,0.15); border:1px solid rgba(239,68,68,0.4); color:#f87171; padding:14px 18px; border-radius:10px; margin-bottom:20px; display:flex; align-items:center; gap:10px;">
        <span style="font-size:20px;">🚫</span>
        <span><strong>Prescription rejected due to invalid clinical entries.</strong> Please correct the fields before issuing to the pharmacy.</span>
    </div>
</c:if>

<!-- Dynamic Client-Side Clinical Validation Error Banner -->
<div id="clinicalValidationAlert" style="display: none; background:rgba(239,68,68,0.15); border:1px solid rgba(239,68,68,0.4); color:#f87171; padding:14px 18px; border-radius:10px; margin-bottom:20px; align-items:center; gap:10px;">
    <span style="font-size:20px;">⚠️</span>
    <span id="clinicalValidationAlertMsg"><strong>Invalid clinical entry detected.</strong> Please correct the highlighted fields before issuing the prescription to the pharmacy.</span>
</div>

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
    
    <form method="post" action="${pageContext.request.contextPath}/doctor/prescription" id="prescriptionForm" onsubmit="return validatePrescriptionPayload(event)">
        <input type="hidden" name="prescriptionId" id="editPrescriptionId" value="">
        <input type="hidden" name="appointmentId" id="prescriptionAppointmentId" value="">

        <!-- Patient Selection from Queue -->
        <div class="form-grid" style="margin-bottom: 20px;">
            <div class="form-group" style="grid-column: span 2;">
                <label style="color:#60a5fa; font-weight:700; display:flex; align-items:center; gap:6px;">
                    <span>👤</span> Select Patient from Active Queue (Synchronized Data)
                </label>
                <select class="form-control-dark" id="patientSelector" name="patientId" required onchange="onPrescribePatientChange(this.value); clearFieldError('patientSelector');">
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
                <div id="error-patientSelector" class="clinical-error-text">Please select a patient from the active queue.</div>
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
                <input class="form-control-dark" name="diagnosis" id="prescribeDiagnosis" placeholder="e.g., Acute Bronchitis / Hypertension / Diabetes Type 2" required oninput="clearFieldError('prescribeDiagnosis')">
                <div id="error-prescribeDiagnosis" class="clinical-error-text">Please enter a valid clinical diagnosis (e.g., Acute Bronchitis, Hypertension). Gibberish and random characters are not permitted.</div>
            </div>
            <div class="form-group" style="grid-column: span 2;">
                <label>Prescribed Medicines <span style="color:#ef4444;">*</span></label>
                <textarea class="form-control-dark" name="medicines" id="prescribeMedicines" rows="3" placeholder="e.g., Amoxicillin 500mg, Paracetamol 500mg, Cetirizine 10mg" required oninput="clearFieldError('prescribeMedicines')"></textarea>
                <div id="error-prescribeMedicines" class="clinical-error-text">Please enter valid medication and dosage forms (e.g., Paracetamol 500mg, Amoxicillin, Syrup, Tablet).</div>
            </div>
            <div class="form-group">
                <label>Dosage &amp; Duration</label>
                <input class="form-control-dark" name="dosage" id="prescribeDosage" placeholder="e.g., 1 Tablet TDS after meals for 5 Days" oninput="clearFieldError('prescribeDosage')">
                <div id="error-prescribeDosage" class="clinical-error-text">Please specify a valid dosage format (e.g., 1 Tablet TDS after meals for 5 Days, 5ml BD).</div>
            </div>
            <div class="form-group">
                <label>Special Instructions / Notes</label>
                <input class="form-control-dark" name="instructions" id="prescribeInstructions" placeholder="e.g., Drink warm water, avoid cold drinks, review in 1 week" oninput="clearFieldError('prescribeInstructions')">
                <div id="error-prescribeInstructions" class="clinical-error-text">Special instructions contain invalid or gibberish text. Please enter clear clinical guidance or leave blank.</div>
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
                                <c:choose>
                                    <c:when test="${pr.status == 'DISPENSED' || pr.status == 'FULFILLED' || pr.status == 'COMPLETED'}">
                                        <span class="status-pill status-DISPENSED">Dispensed</span>
                                    </c:when>
                                    <c:when test="${pr.status == 'PENDING_PHARMACY'}">
                                        <span class="status-pill status-PENDING_PHARMACY">Sent to Pharmacy</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill status-PENDING">${pr.status}</span>
                                    </c:otherwise>
                                </c:choose>
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

<script>
    // Medical keywords and forms for client-side sanity check
    const CLIENT_MEDICAL_TERMS = [
        'acute', 'chronic', 'fever', 'cough', 'cold', 'flu', 'infection', 'headache', 'migraine',
        'hypertension', 'diabetes', 'bronchitis', 'asthma', 'gastritis', 'gerd', 'allergy', 'allergic',
        'dermatitis', 'sinusitis', 'pneumonia', 'tonsillitis', 'otitis', 'rhinitis', 'anemia', 'arthritis',
        'ulcer', 'rash', 'covid', 'uti', 'urinary', 'cardiac', 'renal', 'sprain', 'fracture', 'wound',
        'conjunctivitis', 'eczema', 'dyspepsia', 'colitis', 'gastric', 'diarrhea', 'vomiting', 'nausea',
        'pain', 'chest', 'back', 'abdominal', 'throat', 'hyperlipidemia', 'insomnia', 'anxiety', 'depression',
        'hypothyroidism', 'hyperthyroidism', 'gout', 'sciatica', 'cellulitis', 'measles', 'dengue', 'malaria',
        'typhoid', 'vertigo', 'fatigue', 'acne', 'psoriasis', 'glaucoma', 'cataract', 'stroke', 'epilepsy',
        'syndrome', 'disease', 'disorder', 'viral', 'bacterial', 'fungal', 'deficiency', 'inflammation',
        'tablet', 'tablets', 'tab', 'tabs', 'capsule', 'capsules', 'cap', 'caps', 'syrup', 'syr',
        'suspension', 'susp', 'injection', 'inj', 'ointment', 'cream', 'gel', 'drops', 'drop',
        'inhaler', 'spray', 'lotion', 'solution', 'suppository', 'patch', 'mg', 'g', 'mcg', 'ml', 'iu',
        'puff', 'puffs', 'tsp', 'tbsp', 'spoonful', 'od', 'bd', 'tds', 'qds', 'qid', 'tid', 'bid',
        'prn', 'stat', 'daily', 'once', 'twice', 'thrice', 'morning', 'night', 'evening', 'afternoon',
        'meals', 'food', 'water', 'hours', 'days', 'weeks', 'months', 'paracetamol', 'panadol', 'amoxicillin',
        'augmentin', 'ibuprofen', 'brufen', 'omeprazole', 'pantoprazole', 'esomeprazole', 'rabeprazole',
        'metformin', 'atorvastatin', 'rosuvastatin', 'losartan', 'candesartan', 'telmisartan', 'valsartan',
        'azithromycin', 'ciprofloxacin', 'levofloxacin', 'cefixime', 'ceftriaxone', 'cefuroxime', 'amoxil',
        'doxycycline', 'clarithromycin', 'cetirizine', 'fexofenadine', 'loratadine', 'chlorpheniramine',
        'piriton', 'salbutamol', 'ventolin', 'budesonide', 'fluticasone', 'montelukast', 'prednisolone',
        'dexamethasone', 'hydrocortisone', 'aspirin', 'clopidogrel', 'amlodipine', 'nifedipine', 'diltiazem',
        'verapamil', 'atenolol', 'bisoprolol', 'metoprolol', 'carvedilol', 'nebivolol', 'enalapril',
        'lisinopril', 'ramipril', 'perindopril', 'hydrochlorothiazide', 'furosemide', 'lasix', 'spironolactone',
        'glimepiride', 'gliclazide', 'vildagliptin', 'sitagliptin', 'empagliflozin', 'dapagliflozin', 'insulin',
        'insulatard', 'actrapid', 'novorapid', 'lantus', 'diclofenac', 'cataflam', 'voltaren', 'aceclofenac',
        'mefenamic', 'ponstan', 'tramadol', 'codeine', 'morphine', 'gabapentin', 'pregabalin', 'domperidone',
        'motilium', 'metoclopramide', 'plasil', 'ondansetron', 'gravol', 'hyoscine', 'buscopan', 'mebeverine',
        'lactulose', 'bisacodyl', 'dulcolax', 'senna', 'loperamide', 'imodium', 'ors', 'zinc', 'calcium',
        'vitamin', 'neurobion', 'folic', 'iron', 'ferrous', 'antacid', 'gaviscon', 'eno', 'chlorhexidine',
        'betadine', 'mupirocin', 'fusidic', 'clotrimazole', 'fluconazole', 'acyclovir', 'miconazole', 'timolol',
        'systane', 'otrivin', 'xylometazoline', 'strepsils', 'difflam', 'betamethasone', 'allopurinol',
        'colchicine', 'thyroxine', 'diazepam', 'lorazepam', 'alprazolam', 'clonazepam', 'fluoxetine', 'sertraline',
        'escitalopram', 'quetiapine', 'olanzapine', 'risperidone', 'valproate', 'carbamazepine', 'levetiracetam',
        'baclofen', 'levodopa', 'donepezil', 'betahistine', 'cinnarizine', 'tranexamic', 'heparin', 'enoxaparin',
        'warfarin', 'rivaroxaban', 'apixaban', 'digoxin', 'amiodarone', 'glyceryl', 'nitroglycerin', 'isosorbide',
        'tamsulosin', 'sildenafil', 'tadalafil'
    ];

    const MASH_STRINGS = [
        'asdf', 'sdfg', 'dfgh', 'fghj', 'ghjk', 'hjkl',
        'qwer', 'wert', 'erty', 'rtyu', 'tyui', 'yuio', 'uiop',
        'zxcv', 'xcvb', 'cvbn', 'vbnm',
        'lkjh', 'kjhg', 'jhgf', 'hgfd', 'gfds', 'fdsa',
        'poiu', 'oiuy', 'iuyt', 'uytr', 'ytre', 'trew', 'rewq',
        'mnbv', 'nbvc', 'bvcx', 'vcxz',
        '1234', '2345', '3456', '4567', '5678', '6789', '7890'
    ];

    function checkIsGibberish(text) {
        if (!text) return true;
        const clean = text.trim().toLowerCase();
        if (clean.length < 2) return true;

        // Must contain at least one letter
        if (!/[a-z]/.test(clean)) return true;

        // 4+ repeated letters
        if (/([a-z])\1{3,}/i.test(clean)) return true;

        // Keyboard mash patterns
        for (let pattern of MASH_STRINGS) {
            if (clean.includes(pattern)) return true;
        }

        // Long consonant clusters (5+ consonants)
        const match = clean.match(/[bcdfghjklmnpqrstvwxz]{5,}/i);
        if (match) {
            let isAcronym = false;
            for (let term of CLIENT_MEDICAL_TERMS) {
                if (clean.includes(term)) { isAcronym = true; break; }
            }
            if (!isAcronym) return true;
        }

        // Words with 5+ alpha chars having 0 vowels
        const words = clean.split(/[\s,;:.|/\-+()]+/);
        for (let word of words) {
            const alphaOnly = word.replace(/[^a-z]/g, '');
            if (alphaOnly.length >= 5 && !/[aeiouy]/.test(alphaOnly)) {
                if (!CLIENT_MEDICAL_TERMS.includes(alphaOnly)) {
                    return true;
                }
            }
        }

        return false;
    }

    function setFieldError(fieldId, errorMsg) {
        const el = document.getElementById(fieldId);
        if (el) {
            el.classList.add('clinical-input-error');
        }
        const errEl = document.getElementById('error-' + fieldId);
        if (errEl) {
            if (errorMsg) errEl.innerText = errorMsg;
            errEl.style.display = 'block';
        }
    }

    function clearFieldError(fieldId) {
        const el = document.getElementById(fieldId);
        if (el) {
            el.classList.remove('clinical-input-error');
        }
        const errEl = document.getElementById('error-' + fieldId);
        if (errEl) {
            errEl.style.display = 'none';
        }
        // If all errors are cleared, hide top alert
        const activeErrors = document.querySelectorAll('.clinical-input-error');
        if (activeErrors.length === 0) {
            const alertEl = document.getElementById('clinicalValidationAlert');
            if (alertEl) alertEl.style.display = 'none';
        }
    }

    function validatePrescriptionPayload(e) {
        let isValid = true;
        let firstInvalidEl = null;

        // 1. Patient Selector
        const patientSel = document.getElementById('patientSelector');
        if (!patientSel || !patientSel.value) {
            setFieldError('patientSelector', 'Please select an active patient from the queue.');
            isValid = false;
            if (!firstInvalidEl) firstInvalidEl = patientSel;
        } else {
            clearFieldError('patientSelector');
        }

        // 2. Clinical Diagnosis
        const diagEl = document.getElementById('prescribeDiagnosis');
        const diagVal = diagEl ? diagEl.value.trim() : '';
        if (!diagVal || diagVal.length < 3 || checkIsGibberish(diagVal)) {
            setFieldError('prescribeDiagnosis', 'Clinical diagnosis must be a valid medical condition (e.g., Acute Bronchitis, Hypertension). Gibberish is rejected.');
            isValid = false;
            if (!firstInvalidEl) firstInvalidEl = diagEl;
        } else {
            clearFieldError('prescribeDiagnosis');
        }

        // 3. Prescribed Medicines
        const medEl = document.getElementById('prescribeMedicines');
        const medVal = medEl ? medEl.value.trim() : '';
        if (!medVal || medVal.length < 3 || checkIsGibberish(medVal)) {
            setFieldError('prescribeMedicines', 'Prescribed medicines must include recognizable drug names or dosage forms (e.g., Paracetamol, Amoxicillin 500mg, Syrup, Tablet).');
            isValid = false;
            if (!firstInvalidEl) firstInvalidEl = medEl;
        } else {
            const lowerMed = medVal.toLowerCase();
            let hasMedRef = false;
            for (let term of CLIENT_MEDICAL_TERMS) {
                if (lowerMed.includes(term)) {
                    hasMedRef = true;
                    break;
                }
            }
            if (!hasMedRef && !/\d+\s*(mg|g|mcg|ml|tab|caps|puff|drop|iu)/i.test(lowerMed) && lowerMed.length < 4) {
                setFieldError('prescribeMedicines', 'Medicines entry could not be clinically recognized. Please specify valid drug name and strength (e.g., Amoxicillin 500mg).');
                isValid = false;
                if (!firstInvalidEl) firstInvalidEl = medEl;
            } else {
                clearFieldError('prescribeMedicines');
            }
        }

        // 4. Dosage & Duration (Optional, but if filled must be valid)
        const dosEl = document.getElementById('prescribeDosage');
        const dosVal = dosEl ? dosEl.value.trim() : '';
        if (dosVal && (dosVal.length < 2 || checkIsGibberish(dosVal))) {
            setFieldError('prescribeDosage', 'Dosage & Duration must follow standard clinical frequency (e.g., 1 Tablet TDS after meals for 5 Days).');
            isValid = false;
            if (!firstInvalidEl) firstInvalidEl = dosEl;
        } else if (dosEl) {
            clearFieldError('prescribeDosage');
        }

        // 5. Special Instructions (Optional, but if filled must be valid)
        const instEl = document.getElementById('prescribeInstructions');
        const instVal = instEl ? instEl.value.trim() : '';
        if (instVal && (instVal.length < 3 || checkIsGibberish(instVal))) {
            setFieldError('prescribeInstructions', 'Special instructions contain invalid or gibberish text. Please enter clear guidance or leave empty.');
            isValid = false;
            if (!firstInvalidEl) firstInvalidEl = instEl;
        } else if (instEl) {
            clearFieldError('prescribeInstructions');
        }

        if (!isValid) {
            if (e) {
                e.preventDefault();
                e.stopPropagation();
            }
            const alertEl = document.getElementById('clinicalValidationAlert');
            if (alertEl) {
                alertEl.style.display = 'flex';
                alertEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
            } else if (firstInvalidEl) {
                firstInvalidEl.scrollIntoView({ behavior: 'smooth', block: 'center' });
                firstInvalidEl.focus();
            }
            return false;
        }

        const alertEl = document.getElementById('clinicalValidationAlert');
        if (alertEl) alertEl.style.display = 'none';
        return true;
    }
</script>
