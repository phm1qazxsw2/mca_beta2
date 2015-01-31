package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Voucher
{

    private int   	id;
    private String   	costbookId;


    public Voucher() {}


    public int   	getId   	() { return id; }
    public String   	getCostbookId   	() { return costbookId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCostbookId   	(String costbookId) { this.costbookId = costbookId; }

}
