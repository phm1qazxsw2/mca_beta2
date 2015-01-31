package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Banknumber
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	banknumberDate;
    private int   	banknumberTotal;


    public Banknumber() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	banknumberDate,
        int	banknumberTotal    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.banknumberDate 	 = banknumberDate;
        this.banknumberTotal 	 = banknumberTotal;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getBanknumberDate   	() { return banknumberDate; }
    public int   	getBanknumberTotal   	() { return banknumberTotal; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setBanknumberDate   	(Date banknumberDate) { this.banknumberDate = banknumberDate; }
    public void 	setBanknumberTotal   	(int banknumberTotal) { this.banknumberTotal = banknumberTotal; }
}
