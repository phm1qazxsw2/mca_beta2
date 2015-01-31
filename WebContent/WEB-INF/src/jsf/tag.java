package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class tag
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	name;


    public tag() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	name    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.name 	 = name;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getName   	() { return name; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setName   	(String name) { this.name = name; }
}
