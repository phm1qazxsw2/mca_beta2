package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Feenumber
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	feenumberDate;
    private int   	feenumberTotal;


    public Feenumber() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	feenumberDate,
        int	feenumberTotal    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.feenumberDate 	 = feenumberDate;
        this.feenumberTotal 	 = feenumberTotal;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getFeenumberDate   	() { return feenumberDate; }
    public int   	getFeenumberTotal   	() { return feenumberTotal; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setFeenumberDate   	(Date feenumberDate) { this.feenumberDate = feenumberDate; }
    public void 	setFeenumberTotal   	(int feenumberTotal) { this.feenumberTotal = feenumberTotal; }
}
