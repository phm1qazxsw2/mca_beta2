package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class IncomeBigItem
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	incomeBigItemName;
    private int   	incomeBigItemActive;


    public IncomeBigItem() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	incomeBigItemName,
        int	incomeBigItemActive    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.incomeBigItemName 	 = incomeBigItemName;
        this.incomeBigItemActive 	 = incomeBigItemActive;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getIncomeBigItemName   	() { return incomeBigItemName; }
    public int   	getIncomeBigItemActive   	() { return incomeBigItemActive; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setIncomeBigItemName   	(String incomeBigItemName) { this.incomeBigItemName = incomeBigItemName; }
    public void 	setIncomeBigItemActive   	(int incomeBigItemActive) { this.incomeBigItemActive = incomeBigItemActive; }
}
