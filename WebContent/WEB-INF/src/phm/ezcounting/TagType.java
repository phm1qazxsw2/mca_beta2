package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class TagType
{

    private int   	id;
    private String   	name;
    private int   	num;
    private int   	main;
    private int   	bunitId;


    public TagType() {}


    public int   	getId   	() { return id; }
    public String   	getName   	() { return name; }
    public int   	getNum   	() { return num; }
    public int   	getMain   	() { return main; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setNum   	(int num) { this.num = num; }
    public void 	setMain   	(int main) { this.main = main; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

}
