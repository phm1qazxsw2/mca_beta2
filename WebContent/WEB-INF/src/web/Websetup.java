package web;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Websetup
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	websetupShareIp;
    private String   	websetupWebaddress;
    private String   	websetupAuthodCode;
    private String   	websetupCompanyname;


    public Websetup() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	websetupShareIp,
        String	websetupWebaddress,
        String	websetupAuthodCode,
        String	websetupCompanyname    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.websetupShareIp 	 = websetupShareIp;
        this.websetupWebaddress 	 = websetupWebaddress;
        this.websetupAuthodCode 	 = websetupAuthodCode;
        this.websetupCompanyname 	 = websetupCompanyname;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getWebsetupShareIp   	() { return websetupShareIp; }
    public String   	getWebsetupWebaddress   	() { return websetupWebaddress; }
    public String   	getWebsetupAuthodCode   	() { return websetupAuthodCode; }
    public String   	getWebsetupCompanyname   	() { return websetupCompanyname; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setWebsetupShareIp   	(String websetupShareIp) { this.websetupShareIp = websetupShareIp; }
    public void 	setWebsetupWebaddress   	(String websetupWebaddress) { this.websetupWebaddress = websetupWebaddress; }
    public void 	setWebsetupAuthodCode   	(String websetupAuthodCode) { this.websetupAuthodCode = websetupAuthodCode; }
    public void 	setWebsetupCompanyname   	(String websetupCompanyname) { this.websetupCompanyname = websetupCompanyname; }
}
