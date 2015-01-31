package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Depart
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	departName;
    private int   	departActive;


    public Depart() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	departName,
        int	departActive    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.departName 	 = departName;
        this.departActive 	 = departActive;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getDepartName   	() { return departName; }
    public int   	getDepartActive   	() { return departActive; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setDepartName   	(String departName) { this.departName = departName; }
    public void 	setDepartActive   	(int departActive) { this.departActive = departActive; }
}
