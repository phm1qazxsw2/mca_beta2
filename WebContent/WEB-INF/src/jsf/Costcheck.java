package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Costcheck
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	CostcheckDate;
    private int   	CostcheckTotal;


    public Costcheck() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	CostcheckDate,
        int	CostcheckTotal    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.CostcheckDate 	 = CostcheckDate;
        this.CostcheckTotal 	 = CostcheckTotal;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getCostcheckDate   	() { return CostcheckDate; }
    public int   	getCostcheckTotal   	() { return CostcheckTotal; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setCostcheckDate   	(Date CostcheckDate) { this.CostcheckDate = CostcheckDate; }
    public void 	setCostcheckTotal   	(int CostcheckTotal) { this.CostcheckTotal = CostcheckTotal; }
}
