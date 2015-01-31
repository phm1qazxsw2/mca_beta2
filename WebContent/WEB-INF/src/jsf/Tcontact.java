package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Tcontact
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	tcontactStuId;
    private String   	tcontactName;
    private int   	tcontactReleationId;
    private String   	tcontactPhone1;
    private String   	tcontactPhone2;
    private String   	tcontactMobile;
    private String   	tcontactPs;


    public Tcontact() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	tcontactStuId,
        String	tcontactName,
        int	tcontactReleationId,
        String	tcontactPhone1,
        String	tcontactPhone2,
        String	tcontactMobile,
        String	tcontactPs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.tcontactStuId 	 = tcontactStuId;
        this.tcontactName 	 = tcontactName;
        this.tcontactReleationId 	 = tcontactReleationId;
        this.tcontactPhone1 	 = tcontactPhone1;
        this.tcontactPhone2 	 = tcontactPhone2;
        this.tcontactMobile 	 = tcontactMobile;
        this.tcontactPs 	 = tcontactPs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getTcontactStuId   	() { return tcontactStuId; }
    public String   	getTcontactName   	() { return tcontactName; }
    public int   	getTcontactReleationId   	() { return tcontactReleationId; }
    public String   	getTcontactPhone1   	() { return tcontactPhone1; }
    public String   	getTcontactPhone2   	() { return tcontactPhone2; }
    public String   	getTcontactMobile   	() { return tcontactMobile; }
    public String   	getTcontactPs   	() { return tcontactPs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTcontactStuId   	(int tcontactStuId) { this.tcontactStuId = tcontactStuId; }
    public void 	setTcontactName   	(String tcontactName) { this.tcontactName = tcontactName; }
    public void 	setTcontactReleationId   	(int tcontactReleationId) { this.tcontactReleationId = tcontactReleationId; }
    public void 	setTcontactPhone1   	(String tcontactPhone1) { this.tcontactPhone1 = tcontactPhone1; }
    public void 	setTcontactPhone2   	(String tcontactPhone2) { this.tcontactPhone2 = tcontactPhone2; }
    public void 	setTcontactMobile   	(String tcontactMobile) { this.tcontactMobile = tcontactMobile; }
    public void 	setTcontactPs   	(String tcontactPs) { this.tcontactPs = tcontactPs; }
}
