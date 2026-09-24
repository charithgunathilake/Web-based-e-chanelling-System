package com.echannel.model;

public class Room {
    private Integer roomId;
    private Integer branchId;
    private String branchName;   // populated by joined queries, not always set
    private String roomNumber;
    private String department;
    private String status;       // ACTIVE, INACTIVE

    public Room() {}

    public Room(Integer roomId, Integer branchId, String roomNumber, String department, String status) {
        this.roomId = roomId;
        this.branchId = branchId;
        this.roomNumber = roomNumber;
        this.department = department;
        this.status = status;
    }

    public Integer getRoomId() { return roomId; }
    public void setRoomId(Integer roomId) { this.roomId = roomId; }

    public Integer getBranchId() { return branchId; }
    public void setBranchId(Integer branchId) { this.branchId = branchId; }

    public String getBranchName() { return branchName; }
    public void setBranchName(String branchName) { this.branchName = branchName; }

    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
