package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class CoModify
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	coModifyIncomeId;
    private String   	coModifyNotice;
    private int   	coModifyUser;


    public CoModify() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	coModifyIncomeId,
        String	coModifyNotice,
        int	coModifyUser    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.coModifyIncomeId 	 = coModifyIncomeId;
        this.coModifyNotice 	 = coModifyNotice;
        this.coModifyUser 	 = coModifyUser;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getCoModifyIncomeId   	() { return coModifyIncomeId; }
    public String   	getCoModifyNotice   	() { return coModifyNotice; }
    public int   	getCoModifyUser   	() { return coModifyUser; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setCoModifyIncomeId   	(int coModifyIncomeId) { this.coModifyIncomeId = coModifyIncomeId; }
    public void 	setCoModifyNotice   	(String coModifyNotice) { this.coModifyNotice = coModifyNotice; }
    public void 	setCoModifyUser   	(int coModifyUser) { this.coModifyUser = coModifyUser; }
}
