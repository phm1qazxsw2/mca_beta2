package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Exl
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	exlFileName;
    private String   	exlTitle;
    private int   	exlType;
    private String   	exlPs;


    public Exl() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	exlFileName,
        String	exlTitle,
        int	exlType,
        String	exlPs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.exlFileName 	 = exlFileName;
        this.exlTitle 	 = exlTitle;
        this.exlType 	 = exlType;
        this.exlPs 	 = exlPs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getExlFileName   	() { return exlFileName; }
    public String   	getExlTitle   	() { return exlTitle; }
    public int   	getExlType   	() { return exlType; }
    public String   	getExlPs   	() { return exlPs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setExlFileName   	(String exlFileName) { this.exlFileName = exlFileName; }
    public void 	setExlTitle   	(String exlTitle) { this.exlTitle = exlTitle; }
    public void 	setExlType   	(int exlType) { this.exlType = exlType; }
    public void 	setExlPs   	(String exlPs) { this.exlPs = exlPs; }
}
