package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Sanumber
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	sanumberDate;
    private int   	sanumberTotal;


    public Sanumber() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	sanumberDate,
        int	sanumberTotal    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.sanumberDate 	 = sanumberDate;
        this.sanumberTotal 	 = sanumberTotal;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getSanumberDate   	() { return sanumberDate; }
    public int   	getSanumberTotal   	() { return sanumberTotal; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setSanumberDate   	(Date sanumberDate) { this.sanumberDate = sanumberDate; }
    public void 	setSanumberTotal   	(int sanumberTotal) { this.sanumberTotal = sanumberTotal; }
}
