package cardreader;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class SchNotifier
{

    private int   	id;
    private int   	lastId;


    public SchNotifier() {}


    public int   	getId   	() { return id; }
    public int   	getLastId   	() { return lastId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setLastId   	(int lastId) { this.lastId = lastId; }

}
