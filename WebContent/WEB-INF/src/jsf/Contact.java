package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Contact
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	contactStuId;
    private String   	contactName;
    private int   	contactReleationId;
    private String   	contactPhone1;
    private String   	contactPhone2;
    private String   	contactMobile;
    private String   	contactPs;


    public Contact() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	contactStuId,
        String	contactName,
        int	contactReleationId,
        String	contactPhone1,
        String	contactPhone2,
        String	contactMobile,
        String	contactPs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.contactStuId 	 = contactStuId;
        this.contactName 	 = contactName;
        this.contactReleationId 	 = contactReleationId;
        this.contactPhone1 	 = contactPhone1;
        this.contactPhone2 	 = contactPhone2;
        this.contactMobile 	 = contactMobile;
        this.contactPs 	 = contactPs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getContactStuId   	() { return contactStuId; }
    public String   	getContactName   	() { return contactName; }
    public int   	getContactReleationId   	() { return contactReleationId; }
    public String   	getContactPhone1   	() { return contactPhone1; }
    public String   	getContactPhone2   	() { return contactPhone2; }
    public String   	getContactMobile   	() { return contactMobile; }
    public String   	getContactPs   	() { return contactPs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setContactStuId   	(int contactStuId) { this.contactStuId = contactStuId; }
    public void 	setContactName   	(String contactName) { this.contactName = contactName; }
    public void 	setContactReleationId   	(int contactReleationId) { this.contactReleationId = contactReleationId; }
    public void 	setContactPhone1   	(String contactPhone1) { this.contactPhone1 = contactPhone1; }
    public void 	setContactPhone2   	(String contactPhone2) { this.contactPhone2 = contactPhone2; }
    public void 	setContactMobile   	(String contactMobile) { this.contactMobile = contactMobile; }
    public void 	setContactPs   	(String contactPs) { this.contactPs = contactPs; }
}
