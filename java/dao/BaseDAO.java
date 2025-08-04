package dao;

import java.sql.SQLException;
import java.util.List;


public interface BaseDAO<T> {

   
    boolean insert(T obj) throws SQLException;

    boolean update(T obj) throws SQLException;

    boolean delete(int id) throws SQLException;

    T getById(int id) throws SQLException;

    List<T> getAll() throws SQLException;

   
    List<T> search(String keyword) throws SQLException;
}
