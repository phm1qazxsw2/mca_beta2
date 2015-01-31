package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class PayStore
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	payStoreUpdateDate;
    private Date   	payStorePayDate;
    private int   	payStoreFeeticketId;
    private int   	payStorePayMoney;
    private Date   	payStoreMonth;
    private String   	payStoreId;
    private String   	payStoreAccountId;
    private String   	payStoreSource;
    private int   	payStoreStatus;
    private String   	payStorePs;
    private String   	payStoreException;


    public PayStore() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	payStoreUpdateDate,
        Date	payStorePayDate,
        int	payStoreFeeticketId,
        int	payStorePayMoney,
        Date	payStoreMonth,
        String	payStoreId,
        String	payStoreAccountId,
        String	payStoreSource,
        int	payStoreStatus,
        String	payStorePs,
        String	payStoreException    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.payStoreUpdateDate 	 = payStoreUpdateDate;
        this.payStorePayDate 	 = payStorePayDate;
        this.payStoreFeeticketId 	 = payStoreFeeticketId;
        this.payStorePayMoney 	 = payStorePayMoney;
        this.payStoreMonth 	 = payStoreMonth;
        this.payStoreId 	 = payStoreId;
        this.payStoreAccountId 	 = payStoreAccountId;
        this.payStoreSource 	 = payStoreSource;
        this.payStoreStatus 	 = payStoreStatus;
        this.payStorePs 	 = payStorePs;
        this.payStoreException 	 = payStoreException;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getPayStoreUpdateDate   	() { return payStoreUpdateDate; }
    public Date   	getPayStorePayDate   	() { return payStorePayDate; }
    public int   	getPayStoreFeeticketId   	() { return payStoreFeeticketId; }
    public int   	getPayStorePayMoney   	() { return payStorePayMoney; }
    public Date   	getPayStoreMonth   	() { return payStoreMonth; }
    public String   	getPayStoreId   	() { return payStoreId; }
    public String   	getPayStoreAccountId   	() { return payStoreAccountId; }
    public String   	getPayStoreSource   	() { return payStoreSource; }
    public int   	getPayStoreStatus   	() { return payStoreStatus; }
    public String   	getPayStorePs   	() { return payStorePs; }
    public String   	getPayStoreException   	() { return payStoreException; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setPayStoreUpdateDate   	(Date payStoreUpdateDate) { this.payStoreUpdateDate = payStoreUpdateDate; }
    public void 	setPayStorePayDate   	(Date payStorePayDate) { this.payStorePayDate = payStorePayDate; }
    public void 	setPayStoreFeeticketId   	(int payStoreFeeticketId) { this.payStoreFeeticketId = payStoreFeeticketId; }
    public void 	setPayStorePayMoney   	(int payStorePayMoney) { this.payStorePayMoney = payStorePayMoney; }
    public void 	setPayStoreMonth   	(Date payStoreMonth) { this.payStoreMonth = payStoreMonth; }
    public void 	setPayStoreId   	(String payStoreId) { this.payStoreId = payStoreId; }
    public void 	setPayStoreAccountId   	(String payStoreAccountId) { this.payStoreAccountId = payStoreAccountId; }
    public void 	setPayStoreSource   	(String payStoreSource) { this.payStoreSource = payStoreSource; }
    public void 	setPayStoreStatus   	(int payStoreStatus) { this.payStoreStatus = payStoreStatus; }
    public void 	setPayStorePs   	(String payStorePs) { this.payStorePs = payStorePs; }
    public void 	setPayStoreException   	(String payStoreException) { this.payStoreException = payStoreException; }
}
