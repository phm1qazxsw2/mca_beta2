package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class SmallItem
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	acctCode;
    private String   	smallItemName;
    private int   	smallItemActive;
    private int   	smallItemBigItemId;


    public SmallItem() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	acctCode,
        String	smallItemName,
        int	smallItemActive,
        int	smallItemBigItemId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.acctCode 	 = acctCode;
        this.smallItemName 	 = smallItemName;
        this.smallItemActive 	 = smallItemActive;
        this.smallItemBigItemId 	 = smallItemBigItemId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getAcctCode   	() { return acctCode; }
    public String   	getSmallItemName   	() { return smallItemName; }
    public int   	getSmallItemActive   	() { return smallItemActive; }
    public int   	getSmallItemBigItemId   	() { return smallItemBigItemId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setAcctCode   	(String acctCode) { this.acctCode = acctCode; }
    public void 	setSmallItemName   	(String smallItemName) { this.smallItemName = smallItemName; }
    public void 	setSmallItemActive   	(int smallItemActive) { this.smallItemActive = smallItemActive; }
    public void 	setSmallItemBigItemId   	(int smallItemBigItemId) { this.smallItemBigItemId = smallItemBigItemId; }
}
