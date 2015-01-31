package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class InModify
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	inModifyIncomeId;
    private String   	inModifyNotice;
    private int   	inModifyUser;


    public InModify() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	inModifyIncomeId,
        String	inModifyNotice,
        int	inModifyUser    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.inModifyIncomeId 	 = inModifyIncomeId;
        this.inModifyNotice 	 = inModifyNotice;
        this.inModifyUser 	 = inModifyUser;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getInModifyIncomeId   	() { return inModifyIncomeId; }
    public String   	getInModifyNotice   	() { return inModifyNotice; }
    public int   	getInModifyUser   	() { return inModifyUser; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setInModifyIncomeId   	(int inModifyIncomeId) { this.inModifyIncomeId = inModifyIncomeId; }
    public void 	setInModifyNotice   	(String inModifyNotice) { this.inModifyNotice = inModifyNotice; }
    public void 	setInModifyUser   	(int inModifyUser) { this.inModifyUser = inModifyUser; }
}
