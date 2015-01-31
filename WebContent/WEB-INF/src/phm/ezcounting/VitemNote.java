package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class VitemNote
{

    private int   	vitemId;
    private String   	note;


    public VitemNote() {}


    public int   	getVitemId   	() { return vitemId; }
    public String   	getNote   	() { return note; }


    public void 	setVitemId   	(int vitemId) { this.vitemId = vitemId; }
    public void 	setNote   	(String note) { this.note = note; }

}
