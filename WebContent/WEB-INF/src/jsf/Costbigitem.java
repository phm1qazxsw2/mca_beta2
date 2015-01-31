package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Costbigitem
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	costtradeId;
    private int   	bigitemId;


    public Costbigitem() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	costtradeId,
        int	bigitemId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.costtradeId 	 = costtradeId;
        this.bigitemId 	 = bigitemId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getCosttradeId   	() { return costtradeId; }
    public int   	getBigitemId   	() { return bigitemId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setCosttradeId   	(int costtradeId) { this.costtradeId = costtradeId; }
    public void 	setBigitemId   	(int bigitemId) { this.bigitemId = bigitemId; }
}
