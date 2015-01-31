package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Degree
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	degreeName;
    private int   	degreeActive;
    private int   	bunitId;


    public Degree() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	degreeName,
        int	degreeActive,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.degreeName 	 = degreeName;
        this.degreeActive 	 = degreeActive;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getDegreeName   	() { return degreeName; }
    public int   	getDegreeActive   	() { return degreeActive; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setDegreeName   	(String degreeName) { this.degreeName = degreeName; }
    public void 	setDegreeActive   	(int degreeActive) { this.degreeActive = degreeActive; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
