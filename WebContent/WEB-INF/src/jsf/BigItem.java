package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class BigItem
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	acctCode;
    private String   	bigItemName;
    private int   	bigItemActive;


    public BigItem() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	acctCode,
        String	bigItemName,
        int	bigItemActive    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.acctCode 	 = acctCode;
        this.bigItemName 	 = bigItemName;
        this.bigItemActive 	 = bigItemActive;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getAcctCode   	() { return acctCode; }
    public String   	getBigItemName   	() { return bigItemName; }
    public int   	getBigItemActive   	() { return bigItemActive; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setAcctCode   	(String acctCode) { this.acctCode = acctCode; }
    public void 	setBigItemName   	(String bigItemName) { this.bigItemName = bigItemName; }
    public void 	setBigItemActive   	(int bigItemActive) { this.bigItemActive = bigItemActive; }
}
