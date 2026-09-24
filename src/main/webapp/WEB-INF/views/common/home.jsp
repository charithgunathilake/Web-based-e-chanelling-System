<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="u" value="${currentUser != null ? currentUser : loggedInUser}" />

<jsp:include page="/WEB-INF/views/common/header.jsp" />

<style>
    /* Styling enhancements for Common Landing Hub UI */
    .hero-banner {
        background: linear-gradient(135deg, #1e4ed8 0%, #0ea5a4 100%);
        border-radius: var(--radius);
        padding: 32px 36px;
        color: #ffffff;
        margin-bottom: 28px;
        box-shadow: 0 10px 25px -5px rgba(37, 99, 235, 0.3);
        position: relative;
        overflow: hidden;
    }
    .hero-banner::after {
        content: '';
        position: absolute;
        right: -30px;
        bottom: -30px;
        width: 220px;
        height: 220px;
        background: rgba(255, 255, 255, 0.08);
        border-radius: 50%;
        pointer-events: none;
    }
    .hero-title {
        font-size: 26px;
        font-weight: 800;
        margin: 0 0 8px 0;
        letter-spacing: -0.02em;
    }
    .hero-subtitle {
        font-size: 15px;
        color: rgba(255, 255, 255, 0.9);
        margin: 0 0 24px 0;
        max-width: 680px;
        line-height: 1.5;
    }

    .capabilities-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
        gap: 16px;
    }
    .cap-card {
        background: rgba(255, 255, 255, 0.12);
        backdrop-filter: blur(8px);
        border: 1px solid rgba(255, 255, 255, 0.2);
        border-radius: 12px;
        padding: 16px;
        color: #fff;
        transition: transform 0.2s ease, background 0.2s ease;
    }
    .cap-card:hover {
        transform: translateY(-3px);
        background: rgba(255, 255, 255, 0.18);
    }
    .cap-icon {
        font-size: 24px;
        margin-bottom: 8px;
        display: inline-block;
    }
    .cap-title {
        font-size: 14px;
        font-weight: 700;
        margin-bottom: 4px;
    }
    .cap-desc {
        font-size: 12px;
        color: rgba(255, 255, 255, 0.85);
        line-height: 1.4;
    }

    /* Workspace Launcher Card */
    .launcher-card {
        background: var(--surface);
        border: 2px solid var(--primary-light);
        border-radius: var(--radius);
        padding: 24px;
        margin-bottom: 28px;
        box-shadow: var(--shadow);
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 20px;
        flex-wrap: wrap;
    }
    .launcher-info {
        display: flex;
        align-items: center;
        gap: 16px;
    }
    .launcher-avatar {
        width: 52px;
        height: 52px;
        border-radius: 14px;
        background: linear-gradient(135deg, var(--primary), var(--accent));
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 22px;
        font-weight: 700;
    }
    .launcher-title {
        font-size: 17px;
        font-weight: 700;
        margin: 0 0 4px 0;
        color: var(--text);
    }
    .launcher-desc {
        font-size: 13px;
        color: var(--text-muted);
        margin: 0;
    }

    /* Feature Grid Sections */
    .section-title {
        font-size: 18px;
        font-weight: 700;
        margin: 0 0 16px 0;
        color: var(--text);
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .feature-card {
        background: var(--surface);
        border-radius: var(--radius);
        box-shadow: var(--shadow);
        padding: 22px;
        height: 100%;
        display: flex;
        flex-direction: column;
    }
    .feature-card h3 {
        margin: 0 0 12px 0;
        font-size: 16px;
        font-weight: 700;
        color: var(--text);
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .specialty-tag {
        display: inline-block;
        background: var(--primary-light);
        color: var(--primary-dark);
        font-size: 12px;
        font-weight: 600;
        padding: 4px 10px;
        border-radius: 999px;
        margin: 3px 2px;
    }

    .notice-item {
        padding: 10px 12px;
        background: #f8fafc;
        border-left: 4px solid var(--primary);
        border-radius: 6px;
        margin-bottom: 10px;
        font-size: 13px;
    }
    .notice-item strong {
        color: var(--text);
        display: block;
        margin-bottom: 2px;
    }

    .contact-badge {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 10px 14px;
        background: #f8fafc;
        border-radius: 10px;
        margin-bottom: 8px;
        font-size: 13px;
    }
    .contact-icon {
        width: 34px;
        height: 34px;
        border-radius: 8px;
        background: #e0f2fe;
        color: #0284c7;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 16px;
        flex-shrink: 0;
    }
</style>

<!-- Hero Section: System Overview & 4 Core Capabilities -->
<div class="hero-banner">
    <div class="hero-title">Central e-Channelling Platform</div>
    <div class="hero-subtitle">
        Welcome to the unified digital healthcare portal. Access doctor scheduling, prescription tracking, appointment channeling, and pharmacy fulfillment in real-time.
    </div>

    <div class="capabilities-grid">
        <div class="cap-card">
            <span class="cap-icon">💊</span>
            <div class="cap-title">E-Prescription Tracking</div>
            <div class="cap-desc">Live prescription status, digital dosages, and pharmacy order dispatch tracking.</div>
        </div>
        <div class="cap-card">
            <span class="cap-icon">📅</span>
            <div class="cap-title">Doctor Scheduling</div>
            <div class="cap-desc">Real-time doctor availability, roster updates, room allocations &amp; slot management.</div>
        </div>
        <div class="cap-card">
            <span class="cap-icon">🩺</span>
            <div class="cap-title">Appointment Booking</div>
            <div class="cap-desc">Seamless online doctor channeling, slot selection, and walk-in token issuance.</div>
        </div>
        <div class="cap-card">
            <span class="cap-icon">📦</span>
            <div class="cap-title">Pharmacy Fulfilment</div>
            <div class="cap-desc">Automated medicine queueing, inventory management &amp; prescription dispensing.</div>
        </div>
    </div>
</div>

<!-- Role-Specific Quick Action Dashboard Launcher -->
<div class="launcher-card">
    <div class="launcher-info">
        <div class="launcher-avatar">
            <c:choose>
                <c:when test="${u.role == 'PATIENT'}">🩺</c:when>
                <c:when test="${u.role == 'DOCTOR'}">👨‍⚕️</c:when>
                <c:when test="${u.role == 'RECEPTION'}">🏥</c:when>
                <c:when test="${u.role == 'PHARMACIST'}">💊</c:when>
                <c:when test="${u.role == 'OPERATIONS_MANAGER'}">📊</c:when>
                <c:otherwise>⚙️</c:otherwise>
            </c:choose>
        </div>
        <div>
            <h2 class="launcher-title">Logged in as ${u.fullName}</h2>
            <p class="launcher-desc">
                Session Role: <span class="badge badge-blue">${u.role}</span> &bull; 
                <c:choose>
                    <c:when test="${u.role == 'PATIENT'}">Access doctor search, appointment bookings, &amp; personal medical records.</c:when>
                    <c:when test="${u.role == 'DOCTOR'}">Manage availability schedules, examine patient queues, &amp; issue e-prescriptions.</c:when>
                    <c:when test="${u.role == 'RECEPTION'}">Register walk-in patients, manage daily channeling lists, &amp; check-in tokens.</c:when>
                    <c:when test="${u.role == 'PHARMACIST'}">Manage pending e-prescription queue, dispense medicines, &amp; inspect stock.</c:when>
                    <c:when test="${u.role == 'OPERATIONS_MANAGER'}">Monitor room utilization, staff rosters, &amp; system operational analytics.</c:when>
                    <c:otherwise>Manage system user roles, password resets, &amp; branch parameters.</c:otherwise>
                </c:choose>
            </p>
        </div>
    </div>

    <!-- Role-Specific Launcher Route -->
    <div>
        <c:choose>
            <c:when test="${u.role == 'PATIENT'}">
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="btn btn-primary" style="padding: 12px 24px;">
                    Go to Patient Workspace &rarr;
                </a>
            </c:when>
            <c:when test="${u.role == 'DOCTOR'}">
                <a href="${pageContext.request.contextPath}/doctor/dashboard" class="btn btn-primary" style="padding: 12px 24px;">
                    Open Doctor Dashboard &rarr;
                </a>
            </c:when>
            <c:when test="${u.role == 'RECEPTION'}">
                <a href="${pageContext.request.contextPath}/reception/dashboard" class="btn btn-primary" style="padding: 12px 24px;">
                    Open Reception Workspace &rarr;
                </a>
            </c:when>
            <c:when test="${u.role == 'PHARMACIST'}">
                <a href="${pageContext.request.contextPath}/pharmacist/dashboard" class="btn btn-primary" style="padding: 12px 24px;">
                    Open Pharmacy Queue &rarr;
                </a>
            </c:when>
            <c:when test="${u.role == 'OPERATIONS_MANAGER'}">
                <a href="${pageContext.request.contextPath}/operations/dashboard" class="btn btn-primary" style="padding: 12px 24px;">
                    Open Operations Dashboard &rarr;
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary" style="padding: 12px 24px;">
                    Open Admin Control Panel &rarr;
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Common Feature Grid (System Capabilities) -->
<h2 class="section-title"><span>🌐</span> System Features &amp; General Hub</h2>

<div class="grid grid-2" style="margin-bottom: 24px;">

    <!-- Card 1: Doctor & Channeling Search Preview -->
    <div class="feature-card">
        <h3><span>🔎</span> Doctor &amp; Channeling Search</h3>
        <p style="font-size: 13.5px; color: var(--text-muted); margin-bottom: 14px;">
            Search through accredited medical specialists, check available consultation slots, and book channeling appointments.
        </p>
        <form method="get" action="${pageContext.request.contextPath}/patient/search-doctors" style="display: flex; gap: 8px; margin-bottom: 14px;">
            <input type="text" name="specialty" class="form-control" placeholder="Search by Specialty (e.g. Cardiology)" style="padding: 8px 12px; font-size: 13px;">
            <button type="submit" class="btn btn-primary btn-sm">Search</button>
        </form>
        <div style="margin-top: auto;">
            <div style="font-size: 12px; font-weight: 600; color: var(--text-muted); margin-bottom: 6px;">Popular Specialties:</div>
            <div>
                <span class="specialty-tag">Cardiology</span>
                <span class="specialty-tag">Pediatrics</span>
                <span class="specialty-tag">Neurology</span>
                <span class="specialty-tag">Dermatology</span>
                <span class="specialty-tag">General Medicine</span>
            </div>
        </div>
    </div>

    <!-- Card 2: Hospital & Clinic Branches -->
    <div class="feature-card">
        <h3><span>🏢</span> Hospital &amp; Clinic Branches</h3>
        <p style="font-size: 13.5px; color: var(--text-muted); margin-bottom: 14px;">
            Supported healthcare medical centers, consultation wings, and room allocation network.
        </p>
        <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 14px;">
            <div style="padding: 8px 12px; background: #f8fafc; border-radius: 8px; font-size: 13px; display: flex; justify-content: space-between; align-items: center;">
                <span><strong>Colombo Central Hospital</strong><br><small style="color:var(--text-muted);">No 12, Main Street, Colombo 03</small></span>
                <span class="badge badge-green">Operating</span>
            </div>
            <div style="padding: 8px 12px; background: #f8fafc; border-radius: 8px; font-size: 13px; display: flex; justify-content: space-between; align-items: center;">
                <span><strong>Kandy Medical Wing</strong><br><small style="color:var(--text-muted);">No 45, Peradeniya Road, Kandy</small></span>
                <span class="badge badge-green">Operating</span>
            </div>
            <div style="padding: 8px 12px; background: #f8fafc; border-radius: 8px; font-size: 13px; display: flex; justify-content: space-between; align-items: center;">
                <span><strong>Galle Health Clinic</strong><br><small style="color:var(--text-muted);">No 88, Station Road, Galle</small></span>
                <span class="badge badge-blue">OPD Active</span>
            </div>
        </div>
        <c:if test="${u.role == 'ADMIN'}">
            <a href="${pageContext.request.contextPath}/admin/branches" class="btn btn-outline btn-sm" style="margin-top: auto; align-self: flex-start;">Manage Branches &rarr;</a>
        </c:if>
    </div>

    <!-- Card 3: Emergency Contacts & Helpline -->
    <div class="feature-card">
        <h3><span>🚨</span> Emergency Contacts &amp; Helpline</h3>
        <p style="font-size: 13.5px; color: var(--text-muted); margin-bottom: 14px;">
            Important 24/7 emergency dispatch and hospital helpline desk numbers.
        </p>
        <div class="contact-badge">
            <div class="contact-icon">🚑</div>
            <div>
                <strong>Suwa Seriya Ambulance: 1990</strong>
                <div style="font-size: 11.5px; color: var(--text-muted);">National Pre-Hospital Care Service</div>
            </div>
        </div>
        <div class="contact-badge">
            <div class="contact-icon">📞</div>
            <div>
                <strong>Channeling Hotline: +94 11 234 5678</strong>
                <div style="font-size: 11.5px; color: var(--text-muted);">24/7 Telephone Booking &amp; Support Desk</div>
            </div>
        </div>
        <div class="contact-badge">
            <div class="contact-icon">🏥</div>
            <div>
                <strong>Hospital Emergency Unit: Ext. 101 / 102</strong>
                <div style="font-size: 11.5px; color: var(--text-muted);">Main Reception &amp; Casualty Ward</div>
            </div>
        </div>
    </div>

    <!-- Card 4: System Announcements / Hospital Notices -->
    <div class="feature-card">
        <h3><span>📢</span> System Announcements &amp; Notices</h3>
        <p style="font-size: 13.5px; color: var(--text-muted); margin-bottom: 14px;">
            Broadcast updates, clinical notices, and general hospital announcements.
        </p>
        <div class="notice-item">
            <strong>📌 24/7 Digital e-Prescriptions Active</strong>
            Patients can now view digital prescriptions issued by doctors immediately after consultation.
        </div>
        <div class="notice-item">
            <strong>📌 Annual Vaccination Drive</strong>
            Seasonal flu &amp; general health screening drive available at all branch clinics this month.
        </div>
        <div class="notice-item">
            <strong>📌 Specialist Doctor Roster Published</strong>
            Consultation session slots for next week are now open for online channeling.
        </div>
    </div>

</div>

<jsp:include page="/WEB-INF/views/common/footer.jsp" />
