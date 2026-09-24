<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="user" value="${currentUser != null ? currentUser : loggedInUser}" />
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unified Portal - E-Channeling System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        .portal-layout { display: flex; min-height: 100vh; background: #0f172a; color: #f8fafc; font-family: 'Inter', system-ui, sans-serif; }
        .portal-sidebar { width: 280px; background: rgba(30, 41, 59, 0.85); backdrop-filter: blur(12px); border-right: 1px solid rgba(255,255,255,0.08); padding: 24px; display: flex; flex-direction: column; flex-shrink: 0; }
        .portal-brand { display: flex; align-items: center; gap: 12px; margin-bottom: 32px; text-decoration: none; color: white; }
        .brand-logo { width: 42px; height: 42px; background: linear-gradient(135deg, #3b82f6, #8b5cf6); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 18px; box-shadow: 0 4px 14px rgba(59,130,246,0.4); }
        .brand-title { font-size: 18px; font-weight: 700; line-height: 1.2; }
        .brand-sub { font-size: 11px; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.5px; }
        
        .user-card { background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.06); border-radius: 14px; padding: 14px; margin-bottom: 24px; }
        .user-name { font-weight: 600; font-size: 14px; color: #f1f5f9; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .role-badge { display: inline-block; margin-top: 6px; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; letter-spacing: 0.5px; text-transform: uppercase; }
        .role-PATIENT { background: rgba(59,130,246,0.2); color: #60a5fa; border: 1px solid rgba(59,130,246,0.3); }
        .role-DOCTOR { background: rgba(16,185,129,0.2); color: #34d399; border: 1px solid rgba(16,185,129,0.3); }
        .role-PHARMACIST { background: rgba(245,158,11,0.2); color: #fbbf24; border: 1px solid rgba(245,158,11,0.3); }
        .role-RECEPTION { background: rgba(236,72,153,0.2); color: #f472b6; border: 1px solid rgba(236,72,153,0.3); }
        .role-ADMIN { background: rgba(239,68,68,0.2); color: #f87171; border: 1px solid rgba(239,68,68,0.3); }
        .role-OPERATIONS_MANAGER { background: rgba(139,92,246,0.2); color: #a78bfa; border: 1px solid rgba(139,92,246,0.3); }

        .nav-menu { display: flex; flex-direction: column; gap: 6px; flex-grow: 1; }
        .tab-btn { display: flex; align-items: center; gap: 12px; padding: 12px 16px; border-radius: 10px; background: transparent; border: none; color: #94a3b8; font-size: 14px; font-weight: 500; cursor: pointer; transition: all 0.2s ease; width: 100%; text-align: left; }
        .tab-btn:hover { background: rgba(255,255,255,0.05); color: #f1f5f9; transform: translateX(2px); }
        .tab-btn.active { background: linear-gradient(135deg, rgba(59,130,246,0.2), rgba(139,92,246,0.2)); color: #60a5fa; border-left: 3px solid #3b82f6; font-weight: 600; }
        .tab-btn .icon { font-size: 18px; width: 22px; text-align: center; }

        .logout-btn { display: flex; align-items: center; gap: 10px; padding: 12px 16px; border-radius: 10px; color: #ef4444; text-decoration: none; font-size: 14px; font-weight: 600; background: rgba(239,68,68,0.08); border: 1px solid rgba(239,68,68,0.15); margin-top: auto; transition: all 0.2s; }
        .logout-btn:hover { background: rgba(239,68,68,0.2); transform: translateY(-1px); }

        .portal-main { flex-grow: 1; display: flex; flex-direction: column; min-width: 0; background: #0f172a; }
        .portal-header { background: rgba(30, 41, 59, 0.6); backdrop-filter: blur(12px); border-bottom: 1px solid rgba(255,255,255,0.08); padding: 20px 32px; display: flex; align-items: center; justify-content: space-between; }
        .welcome-title { font-size: 22px; font-weight: 700; color: #f8fafc; margin: 0; }
        .welcome-sub { font-size: 13px; color: #94a3b8; margin-top: 4px; }
        .header-actions { display: flex; align-items: center; gap: 16px; }

        .portal-viewport { padding: 32px; overflow-y: auto; flex-grow: 1; }
        .tab-content { display: none; animation: fadeIn 0.3s ease; }
        .tab-content.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: translateY(0); } }

        .card { background: rgba(30, 41, 59, 0.7); border: 1px solid rgba(255,255,255,0.08); border-radius: 16px; padding: 24px; margin-bottom: 24px; backdrop-filter: blur(8px); }
        .card-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; border-bottom: 1px solid rgba(255,255,255,0.06); padding-bottom: 14px; }
        .card-title { font-size: 18px; font-weight: 700; color: #f1f5f9; margin: 0; }

        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 28px; }
        .stat-card { background: linear-gradient(135deg, rgba(255,255,255,0.04), rgba(255,255,255,0.02)); border: 1px solid rgba(255,255,255,0.08); border-radius: 14px; padding: 20px; display: flex; align-items: center; gap: 16px; }
        .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
        .stat-blue { background: rgba(59,130,246,0.15); color: #60a5fa; }
        .stat-green { background: rgba(16,185,129,0.15); color: #34d399; }
        .stat-purple { background: rgba(139,92,246,0.15); color: #a78bfa; }
        .stat-amber { background: rgba(245,158,11,0.15); color: #fbbf24; }
        .stat-val { font-size: 24px; font-weight: 800; color: #f8fafc; }
        .stat-lbl { font-size: 12px; color: #94a3b8; font-weight: 500; }

        .table-custom { width: 100%; border-collapse: separate; border-spacing: 0; }
        .table-custom th { background: rgba(255,255,255,0.03); color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase; padding: 12px 16px; text-align: left; border-bottom: 1px solid rgba(255,255,255,0.08); }
        .table-custom td { padding: 14px 16px; border-bottom: 1px solid rgba(255,255,255,0.05); color: #e2e8f0; font-size: 14px; }
        .table-custom tr:last-child td { border-bottom: none; }
        .table-custom tr:hover td { background: rgba(255,255,255,0.02); }

        .status-pill { display: inline-block; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
        .status-BOOKED, .status-PENDING { background: rgba(245,158,11,0.2); color: #fbbf24; border: 1px solid rgba(245,158,11,0.3); }
        .status-ATTENDED, .status-FULFILLED, .status-ACTIVE, .status-PAID { background: rgba(16,185,129,0.2); color: #34d399; border: 1px solid rgba(16,185,129,0.3); }
        .status-CANCELLED, .status-INACTIVE { background: rgba(239,68,68,0.2); color: #f87171; border: 1px solid rgba(239,68,68,0.3); }

        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 16px; margin-bottom: 16px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group label { font-size: 12px; font-weight: 600; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.5px; }
        .form-control-dark { background: rgba(15,23,42,0.8); border: 1px solid rgba(255,255,255,0.12); border-radius: 8px; padding: 10px 14px; color: #f8fafc; font-size: 14px; outline: none; transition: border-color 0.2s; }
        .form-control-dark:focus { border-color: #3b82f6; box-shadow: 0 0 0 2px rgba(59,130,246,0.25); }

        .btn-glow { background: linear-gradient(135deg, #3b82f6, #6366f1); border: none; color: white; padding: 10px 20px; border-radius: 8px; font-weight: 600; cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 12px rgba(59,130,246,0.3); }
        .btn-glow:hover { opacity: 0.95; transform: translateY(-1px); box-shadow: 0 6px 16px rgba(59,130,246,0.4); }
        .btn-danger-sm { background: rgba(239,68,68,0.2); border: 1px solid rgba(239,68,68,0.3); color: #f87171; padding: 6px 12px; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600; }
        .btn-danger-sm:hover { background: rgba(239,68,68,0.4); }
        .btn-success-sm { background: rgba(16,185,129,0.2); border: 1px solid rgba(16,185,129,0.3); color: #34d399; padding: 6px 12px; border-radius: 6px; cursor: pointer; font-size: 12px; font-weight: 600; }
        .btn-success-sm:hover { background: rgba(16,185,129,0.4); }
    </style>
</head>
<body>
<div class="portal-layout">
    <!-- Shared Sidebar Navigation -->
    <aside class="portal-sidebar">
        <a href="${pageContext.request.contextPath}/portal" class="portal-brand">
            <div class="brand-logo">EC</div>
            <div>
                <div class="brand-title">E-Channeling</div>
                <div class="brand-sub">Unified System</div>
            </div>
        </a>

        <div class="user-card">
            <div class="user-name">${user.fullName}</div>
            <div style="font-size:11px;color:#94a3b8;margin-top:2px;">@${user.username}</div>
            <span class="role-badge role-${user.role}">${user.role}</span>
        </div>

        <!-- Role-Based Navigation Buttons -->
        <nav class="nav-menu">
            <c:if test="${user.role == 'PATIENT'}">
                <button class="tab-btn" data-tab="prescriptions"><span class="icon">💊</span> View Prescriptions</button>
                <button class="tab-btn" data-tab="book"><span class="icon">📅</span> Book Appointment</button>
                <button class="tab-btn" data-tab="history"><span class="icon">📋</span> Medical History</button>
                <button class="tab-btn" data-tab="profile"><span class="icon">⚙️</span> Profile Settings</button>
            </c:if>

            <c:if test="${user.role == 'DOCTOR'}">
                <button class="tab-btn" data-tab="queue"><span class="icon">👥</span> Patient Queue</button>
                <button class="tab-btn" data-tab="prescribe"><span class="icon">✏️</span> Issue Prescriptions</button>
                <button class="tab-btn" data-tab="schedule"><span class="icon">📆</span> Availability Schedule</button>
            </c:if>

            <c:if test="${user.role == 'PHARMACIST'}">
                <button class="tab-btn" data-tab="pending"><span class="icon">⏳</span> Pending Queue</button>
                <button class="tab-btn" data-tab="dispense"><span class="icon">💊</span> Dispense Medication</button>
                <button class="tab-btn" data-tab="inventory"><span class="icon">📦</span> Inventory</button>
            </c:if>

            <c:if test="${user.role == 'RECEPTION'}">
                <button class="tab-btn" data-tab="checkin"><span class="icon">🚪</span> Patient Check-in</button>
                <button class="tab-btn" data-tab="appointments"><span class="icon">📋</span> Manage Appointments</button>
                <button class="tab-btn" data-tab="billing"><span class="icon">💳</span> Billing</button>
            </c:if>

            <c:if test="${user.role == 'ADMIN'}">
                <button class="tab-btn" data-tab="users"><span class="icon">👤</span> User Management</button>
                <button class="tab-btn" data-tab="reports"><span class="icon">📊</span> System Reports</button>
                <button class="tab-btn" data-tab="audit"><span class="icon">📑</span> Audit Logs</button>
            </c:if>

            <c:if test="${user.role == 'OPERATIONS_MANAGER'}">
                <button class="tab-btn" data-tab="analytics"><span class="icon">📈</span> Operational Analytics</button>
                <button class="tab-btn" data-tab="roster"><span class="icon">🗓️</span> Staff Roster</button>
                <button class="tab-btn" data-tab="resources"><span class="icon">🏢</span> Resource Allocation</button>
            </c:if>
        </nav>

        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            <span>🚪</span> Sign Out
        </a>
    </aside>

    <!-- Main Content Area -->
    <main class="portal-main">
        <header class="portal-header">
            <div>
                <h1 class="welcome-title">Welcome back, ${user.fullName}!</h1>
                <div class="welcome-sub">Logged in as <strong style="color:#60a5fa;">${user.username}</strong> (${user.role})</div>
            </div>
            <div class="header-actions">
                <c:if test="${user.lastLogin != null}">
                    <div style="font-size:12px;color:#94a3b8;text-align:right;">
                        Last Login: <br><strong style="color:#e2e8f0;">${user.lastLogin}</strong>
                    </div>
                </c:if>
            </div>
        </header>

        <div class="portal-viewport">
            <c:if test="${param.updated == '1'}"><div class="card" style="border-color:#34d399;background:rgba(16,185,129,0.1);color:#34d399;padding:12px 20px;">Profile updated successfully!</div></c:if>
            <c:if test="${param.booked == '1'}"><div class="card" style="border-color:#34d399;background:rgba(16,185,129,0.1);color:#34d399;padding:12px 20px;">Appointment booked successfully!</div></c:if>
            <c:if test="${param.dispensed == '1'}"><div class="card" style="border-color:#34d399;background:rgba(16,185,129,0.1);color:#34d399;padding:12px 20px;">Prescription dispensed successfully!</div></c:if>

            <!-- ==================== PATIENT SUB-UIs ==================== -->
            <c:if test="${user.role == 'PATIENT'}">
                <!-- 1. View Prescriptions -->
                <div id="tab-prescriptions" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">My e-Prescriptions</h2></div>
                        <table class="table-custom">
                            <thead><tr><th>ID</th><th>Medicines</th><th>Doctor</th><th>Issued At</th><th>Status</th></tr></thead>
                            <tbody>
                                <c:forEach var="p" items="${prescriptions}">
                                    <tr>
                                        <td>#${p.prescriptionId}</td>
                                        <td><strong>${p.medicines}</strong></td>
                                        <td>${p.doctorName != null ? p.doctorName : 'Dr. Perera'}</td>
                                        <td>${p.issuedAt}</td>
                                        <td><span class="status-pill status-${p.status}">${p.status}</span></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty prescriptions}">
                                    <tr><td colspan="5" style="text-align:center;color:#94a3b8;">No prescriptions found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 2. Book Appointment -->
                <div id="tab-book" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Search Doctors &amp; Book Appointment</h2></div>
                        <form method="get" action="${pageContext.request.contextPath}/portal" style="margin-bottom:20px;display:flex;gap:12px;">
                            <input type="hidden" name="tab" value="book">
                            <input class="form-control-dark" style="flex-grow:1;" name="specialty" value="${specialty}" placeholder="Filter by Specialty (e.g., Cardiology, General)">
                            <button type="submit" class="btn-glow">Search</button>
                        </form>

                        <div style="display:grid;grid-template-columns:repeat(auto-fill, minmax(280px, 1fr));gap:16px;">
                            <c:forEach var="d" items="${doctors}">
                                <div style="background:rgba(255,255,255,0.03);border:1px solid rgba(255,255,255,0.08);border-radius:12px;padding:16px;">
                                    <h3 style="margin:0 0 4px 0;font-size:16px;color:#f1f5f9;">${d.fullName}</h3>
                                    <div style="color:#60a5fa;font-size:13px;margin-bottom:8px;">${d.specialty}</div>
                                    <div style="color:#94a3b8;font-size:12px;margin-bottom:12px;">Branch: ${d.branchName != null ? d.branchName : 'Main Branch'}</div>
                                    <a href="${pageContext.request.contextPath}/patient/book/${d.doctorId}" class="btn-glow" style="display:inline-block;padding:6px 14px;font-size:12px;text-decoration:none;">Select &amp; View Slots</a>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- 3. Medical History -->
                <div id="tab-history" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">My Medical Consultations &amp; Records</h2></div>
                        <table class="table-custom">
                            <thead><tr><th>Record ID</th><th>Doctor</th><th>Diagnosis</th><th>Treatment</th><th>Notes</th><th>Date</th></tr></thead>
                            <tbody>
                                <c:forEach var="r" items="${records}">
                                    <tr>
                                        <td>#${r.recordId}</td>
                                        <td>${r.doctorName}</td>
                                        <td><strong style="color:#f472b6;">${r.diagnosis}</strong></td>
                                        <td>${r.treatment}</td>
                                        <td>${r.notes}</td>
                                        <td>${r.createdAt}</td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty records}">
                                    <tr><td colspan="6" style="text-align:center;color:#94a3b8;">No medical history records found.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 4. Profile Settings -->
                <div id="tab-profile" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Patient Profile &amp; Account Settings</h2></div>
                        <form method="post" action="${pageContext.request.contextPath}/portal/profile/update">
                            <div class="form-grid">
                                <div class="form-group"><label>Full Name</label><input class="form-control-dark" name="fullName" value="${user.fullName}" required></div>
                                <div class="form-group"><label>Username</label><input class="form-control-dark" value="${user.username}" disabled></div>
                                <div class="form-group"><label>Email</label><input class="form-control-dark" type="email" name="email" value="${user.email}" required></div>
                                <div class="form-group"><label>Phone</label><input class="form-control-dark" name="phone" value="${user.phone}" required></div>
                                <div class="form-group"><label>NIC</label><input class="form-control-dark" name="nic" value="${patient != null ? patient.nic : ''}"></div>
                                <div class="form-group"><label>Address</label><input class="form-control-dark" name="address" value="${patient != null ? patient.address : ''}"></div>
                                <div class="form-group"><label>Change Password (optional)</label><input class="form-control-dark" type="password" name="newPassword" placeholder="New Password"></div>
                            </div>
                            <button type="submit" class="btn-glow" style="margin-top:12px;">Save Profile Changes</button>
                        </form>
                    </div>
                </div>
            </c:if>

            <!-- ==================== DOCTOR SUB-UIs ==================== -->
            <c:if test="${user.role == 'DOCTOR'}">
                <!-- 1. Patient Queue -->
                <div id="tab-queue" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Today's Patient Queue</h2></div>
                        <table class="table-custom">
                            <thead><tr><th># No</th><th>Patient Name</th><th>NIC</th><th>Date &amp; Time</th><th>Status</th><th>Actions</th></tr></thead>
                            <tbody>
                                <c:forEach var="a" items="${appointments}">
                                    <tr>
                                        <td><strong>#${a.appointmentNumber}</strong></td>
                                        <td>${a.patientName}</td>
                                        <td>${a.patientNic}</td>
                                        <td>${a.scheduleDate} (${a.startTime} - ${a.endTime})</td>
                                        <td><span class="status-pill status-${a.status}">${a.status}</span></td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/doctor/patient-history/${a.appointmentId}" class="btn-glow" style="padding:4px 10px;font-size:12px;text-decoration:none;">Examine Patient</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 2. Issue Prescriptions -->
                <div id="tab-prescribe" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Issue e-Prescription</h2></div>
                        <p style="color:#94a3b8;font-size:13px;">Select a patient from the Queue tab to enter diagnosis, treatment notes, and issue digital prescriptions directly to the pharmacy.</p>
                    </div>
                </div>

                <!-- 3. Availability Schedule -->
                <div id="tab-schedule" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Manage Availability Schedule</h2></div>
                        <form method="post" action="${pageContext.request.contextPath}/doctor/schedule" style="margin-bottom:24px;">
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Consultation Room</label>
                                    <select class="form-control-dark" name="roomId" required>
                                        <c:forEach var="r" items="${rooms}"><option value="${r.roomId}">${r.roomNumber} - ${r.department}</option></c:forEach>
                                    </select>
                                </div>
                                <div class="form-group"><label>Date</label><input type="date" class="form-control-dark" name="scheduleDate" required></div>
                                <div class="form-group"><label>Start Time</label><input type="time" class="form-control-dark" name="startTime" required></div>
                                <div class="form-group"><label>End Time</label><input type="time" class="form-control-dark" name="endTime" required></div>
                                <div class="form-group"><label>Max Patients</label><input type="number" class="form-control-dark" name="maxPatients" value="20" required></div>
                            </div>
                            <button type="submit" class="btn-glow">Add Schedule Session</button>
                        </form>
                    </div>
                </div>
            </c:if>

            <!-- ==================== PHARMACIST SUB-UIs ==================== -->
            <c:if test="${user.role == 'PHARMACIST'}">
                <div id="tab-pending" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Pending e-Prescriptions Queue</h2></div>
                        <table class="table-custom">
                            <thead><tr><th>ID</th><th>Patient</th><th>Doctor</th><th>Medicines</th><th>Status</th><th>Action</th></tr></thead>
                            <tbody>
                                <c:forEach var="p" items="${pending}">
                                    <tr>
                                        <td>#${p.prescriptionId}</td>
                                        <td><strong>${p.patientName}</strong></td>
                                        <td>${p.doctorName}</td>
                                        <td style="color:#fbbf24;">${p.medicines}</td>
                                        <td><span class="status-pill status-${p.status}">${p.status}</span></td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/pharmacist/dispense/${p.prescriptionId}">
                                                <button type="submit" class="btn-success-sm">Dispense Medication</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty pending}">
                                    <tr><td colspan="6" style="text-align:center;color:#94a3b8;">No pending prescriptions in queue.</td></tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="tab-dispense" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Dispense Medication Console</h2></div>
                        <p style="color:#94a3b8;">Verify prescribed items against patient identity before dispensing.</p>
                    </div>
                </div>

                <div id="tab-inventory" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Pharmacy Medicine Inventory</h2></div>
                        <p style="color:#94a3b8;">Stock tracking &amp; inventory management console.</p>
                    </div>
                </div>
            </c:if>

            <!-- ==================== RECEPTIONIST SUB-UIs ==================== -->
            <c:if test="${user.role == 'RECEPTION'}">
                <div id="tab-checkin" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Register Walk-in Patient &amp; Check-in</h2></div>
                        <form method="post" action="${pageContext.request.contextPath}/reception/walkin">
                            <div class="form-grid">
                                <div class="form-group"><label>Full Name</label><input class="form-control-dark" name="fullName" required></div>
                                <div class="form-group"><label>Phone</label><input class="form-control-dark" name="phone" required></div>
                                <div class="form-group"><label>NIC</label><input class="form-control-dark" name="nic"></div>
                                <div class="form-group"><label>Address</label><input class="form-control-dark" name="address"></div>
                            </div>
                            <button type="submit" class="btn-glow">Register &amp; Issue Token</button>
                        </form>
                    </div>
                </div>

                <div id="tab-appointments" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Manage Daily Appointments</h2></div>
                        <table class="table-custom">
                            <thead><tr><th>Token</th><th>Patient</th><th>Doctor</th><th>Room</th><th>Status</th><th>Update Status</th></tr></thead>
                            <tbody>
                                <c:forEach var="a" items="${today}">
                                    <tr>
                                        <td><strong>#${a.appointmentNumber}</strong></td>
                                        <td>${a.patientName}</td>
                                        <td>${a.doctorName}</td>
                                        <td>${a.roomNumber}</td>
                                        <td><span class="status-pill status-${a.status}">${a.status}</span></td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/reception/update-status/${a.appointmentId}" style="display:flex;gap:6px;">
                                                <select name="status" class="form-control-dark" style="padding:4px 8px;font-size:12px;">
                                                    <option value="BOOKED">BOOKED</option>
                                                    <option value="ATTENDED">ATTENDED</option>
                                                    <option value="CANCELLED">CANCELLED</option>
                                                </select>
                                                <button type="submit" class="btn-glow" style="padding:4px 10px;font-size:12px;">Update</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="tab-billing" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Patient Billing &amp; Receipts</h2></div>
                        <p style="color:#94a3b8;">Process doctor channel fees and hospital service charges.</p>
                    </div>
                </div>
            </c:if>

            <!-- ==================== ADMIN SUB-UIs ==================== -->
            <c:if test="${user.role == 'ADMIN'}">
                <div id="tab-users" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">User Management</h2></div>
                        <table class="table-custom">
                            <thead><tr><th>ID</th><th>Username</th><th>Full Name</th><th>Role</th><th>Status</th><th>Last Login</th></tr></thead>
                            <tbody>
                                <c:forEach var="u" items="${users}">
                                    <tr>
                                        <td>#${u.userId}</td>
                                        <td><strong>${u.username}</strong></td>
                                        <td>${u.fullName}</td>
                                        <td><span class="role-badge role-${u.role}">${u.role}</span></td>
                                        <td><span class="status-pill status-${u.active ? 'ACTIVE' : 'INACTIVE'}">${u.active ? 'ACTIVE' : 'INACTIVE'}</span></td>
                                        <td>${u.lastLogin != null ? u.lastLogin : 'Never'}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id="tab-reports" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">System Reports &amp; Branch Setup</h2></div>
                        <div class="stats-grid">
                            <div class="stat-card stat-blue"><div class="stat-icon">👥</div><div><div class="stat-val">${userCount}</div><div class="stat-lbl">Registered Users</div></div></div>
                            <div class="stat-card stat-purple"><div class="stat-icon">🏢</div><div><div class="stat-val">${branchCount}</div><div class="stat-lbl">Active Branches</div></div></div>
                        </div>
                    </div>
                </div>

                <div id="tab-audit" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">System Audit Logs</h2></div>
                        <p style="color:#94a3b8;">Security and activity logs trace.</p>
                    </div>
                </div>
            </c:if>

            <!-- ==================== OPERATIONS MANAGER SUB-UIs ==================== -->
            <c:if test="${user.role == 'OPERATIONS_MANAGER'}">
                <div id="tab-analytics" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Operational Analytics</h2></div>
                        <div class="stats-grid">
                            <div class="stat-card stat-amber"><div class="stat-icon">📈</div><div><div class="stat-val">${totalAppointments}</div><div class="stat-lbl">Total Appointments</div></div></div>
                        </div>
                    </div>
                </div>

                <div id="tab-roster" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Staff Roster</h2></div>
                        <p style="color:#94a3b8;">Manage clinical staff and doctor shift rosters.</p>
                    </div>
                </div>

                <div id="tab-resources" class="tab-content">
                    <div class="card">
                        <div class="card-header"><h2 class="card-title">Resource Allocation</h2></div>
                        <p style="color:#94a3b8;">Consultation room &amp; facility management.</p>
                    </div>
                </div>
            </c:if>
        </div>
    </main>
</div>

<!-- Client-side SPA Dynamic Tab Switching Script -->
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const tabBtns = document.querySelectorAll('.tab-btn');
        const tabContents = document.querySelectorAll('.tab-content');

        function activateTab(tabId) {
            if (!tabId) return;
            tabBtns.forEach(btn => {
                if (btn.dataset.tab === tabId) {
                    btn.classList.add('active');
                } else {
                    btn.classList.remove('active');
                }
            });
            tabContents.forEach(content => {
                if (content.id === 'tab-' + tabId) {
                    content.classList.add('active');
                } else {
                    content.classList.remove('active');
                }
            });
        }

        tabBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                const tab = btn.dataset.tab;
                activateTab(tab);
                history.pushState(null, '', '?tab=' + tab);
            });
        });

        // Determine initial active tab
        const urlParams = new URLSearchParams(window.location.search);
        const serverActiveTab = '${activeTab}';
        const queryTab = urlParams.get('tab');
        const initialTab = queryTab || serverActiveTab || (tabBtns.length > 0 ? tabBtns[0].dataset.tab : null);
        if (initialTab) {
            activateTab(initialTab);
        }
    });
</script>
</body>
</html>
