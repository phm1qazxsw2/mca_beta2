package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class DiscountType
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	discountTypeName;
    private int   	discountTypeActive;
    private String   	discountTypePs;
    private String   	acctcode;
    private int   	bunitId;


    public DiscountType() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	discountTypeName,
        int	discountTypeActive,
        String	discountTypePs,
        String	acctcode,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.discountTypeName 	 = discountTypeName;
        this.discountTypeActive 	 = discountTypeActive;
        this.discountTypePs 	 = discountTypePs;
        this.acctcode 	 = acctcode;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getDiscountTypeName   	() { return discountTypeName; }
    public int   	getDiscountTypeActive   	() { return discountTypeActive; }
    public String   	getDiscountTypePs   	() { return discountTypePs; }
    public String   	getAcctcode   	() { return acctcode; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setDiscountTypeName   	(String discountTypeName) { this.discountTypeName = discountTypeName; }
    public void 	setDiscountTypeActive   	(int discountTypeActive) { this.discountTypeActive = discountTypeActive; }
    public void 	setDiscountTypePs   	(String discountTypePs) { this.discountTypePs = discountTypePs; }
    public void 	setAcctcode   	(String acctcode) { this.acctcode = acctcode; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
