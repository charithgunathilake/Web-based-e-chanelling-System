package com.echannel.repository;

import com.echannel.exception.DatabaseException;
import java.util.List;

/**
 * ABSTRACTION + GENERICS: a generic contract every repository must follow.
 * T  = the entity type (e.g. User, Doctor, Appointment)
 * ID = the primary key type (usually Integer)
 *
 * Callers (the Service layer) depend only on this interface and never need
 * to know the JDBC / SQL details behind each implementation.
 */
public interface Repository<T, ID> {
    void create(T entity) throws DatabaseException;
    T readById(ID id) throws DatabaseException;
    List<T> readAll() throws DatabaseException;
    void update(T entity) throws DatabaseException;
    void delete(ID id) throws DatabaseException;
}
