package com.echannel.service;

import com.echannel.exception.DatabaseException;
import com.echannel.model.Branch;
import com.echannel.model.Room;
import com.echannel.repository.BranchRepository;
import com.echannel.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/** Handles Use Case 4: Manage Hospital Branch & Room Allocation. */
@Service
public class BranchService {

    @Autowired
    private BranchRepository branchRepository;

    @Autowired
    private RoomRepository roomRepository;

    public List<Branch> allBranches() throws DatabaseException {
        return branchRepository.readAll();
    }

    public void addBranch(Branch b) throws DatabaseException {
        branchRepository.create(b);
    }

    public void updateBranch(Branch b) throws DatabaseException {
        branchRepository.update(b);
    }

    public List<Room> allRooms() throws DatabaseException {
        return roomRepository.readAll();
    }

    public void addRoom(Room r) throws DatabaseException {
        roomRepository.create(r);
    }

    public void updateRoom(Room r) throws DatabaseException {
        roomRepository.update(r);
    }

    /** Extension 3a in Use Case 4 - deactivate rather than hard-delete. */
    public void deactivateRoom(Integer roomId) throws DatabaseException {
        roomRepository.delete(roomId);
    }
}
