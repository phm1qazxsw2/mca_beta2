package cardreader;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Entry
{

    private int   	id;
    private Date   	created;
    private int   	machineId;
    private String   	cardId;
    private int   	datatype;
    private int   	datauser;
    private int   	number;


    public Entry() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public int   	getMachineId   	() { return machineId; }
    public String   	getCardId   	() { return cardId; }
    public int   	getDatatype   	() { return datatype; }
    public int   	getDatauser   	() { return datauser; }
    public int   	getNumber   	() { return number; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setMachineId   	(int machineId) { this.machineId = machineId; }
    public void 	setCardId   	(String cardId) { this.cardId = cardId; }
    public void 	setDatatype   	(int datatype) { this.datatype = datatype; }
    public void 	setDatauser   	(int datauser) { this.datauser = datauser; }
    public void 	setNumber   	(int number) { this.number = number; }

    public String getDateCard()
    {
	java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy/MM/dd");
	
	return sdf.format(this.created)+cardId;
    }

}
