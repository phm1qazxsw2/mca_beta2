package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Costtrade
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	costtradeName;
    private int   	costtradeActive;
    private String   	costtradeContacter;
    private String   	costtradeUnitnumber;
    private String   	costtradePhone1;
    private String   	costtradePhone2;
    private String   	costtradeMobile;
    private String   	costtradeAddress;
    private String   	costtradePs;
    private int   	bunitId;


    public Costtrade() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	costtradeName,
        int	costtradeActive,
        String	costtradeContacter,
        String	costtradeUnitnumber,
        String	costtradePhone1,
        String	costtradePhone2,
        String	costtradeMobile,
        String	costtradeAddress,
        String	costtradePs,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.costtradeName 	 = costtradeName;
        this.costtradeActive 	 = costtradeActive;
        this.costtradeContacter 	 = costtradeContacter;
        this.costtradeUnitnumber 	 = costtradeUnitnumber;
        this.costtradePhone1 	 = costtradePhone1;
        this.costtradePhone2 	 = costtradePhone2;
        this.costtradeMobile 	 = costtradeMobile;
        this.costtradeAddress 	 = costtradeAddress;
        this.costtradePs 	 = costtradePs;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getCosttradeName   	() { return costtradeName; }
    public int   	getCosttradeActive   	() { return costtradeActive; }
    public String   	getCosttradeContacter   	() { return costtradeContacter; }
    public String   	getCosttradeUnitnumber   	() { return costtradeUnitnumber; }
    public String   	getCosttradePhone1   	() { return costtradePhone1; }
    public String   	getCosttradePhone2   	() { return costtradePhone2; }
    public String   	getCosttradeMobile   	() { return costtradeMobile; }
    public String   	getCosttradeAddress   	() { return costtradeAddress; }
    public String   	getCosttradePs   	() { return costtradePs; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setCosttradeName   	(String costtradeName) { this.costtradeName = costtradeName; }
    public void 	setCosttradeActive   	(int costtradeActive) { this.costtradeActive = costtradeActive; }
    public void 	setCosttradeContacter   	(String costtradeContacter) { this.costtradeContacter = costtradeContacter; }
    public void 	setCosttradeUnitnumber   	(String costtradeUnitnumber) { this.costtradeUnitnumber = costtradeUnitnumber; }
    public void 	setCosttradePhone1   	(String costtradePhone1) { this.costtradePhone1 = costtradePhone1; }
    public void 	setCosttradePhone2   	(String costtradePhone2) { this.costtradePhone2 = costtradePhone2; }
    public void 	setCosttradeMobile   	(String costtradeMobile) { this.costtradeMobile = costtradeMobile; }
    public void 	setCosttradeAddress   	(String costtradeAddress) { this.costtradeAddress = costtradeAddress; }
    public void 	setCosttradePs   	(String costtradePs) { this.costtradePs = costtradePs; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
