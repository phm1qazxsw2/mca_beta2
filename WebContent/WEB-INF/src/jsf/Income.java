package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Income
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	incomeName;
    private int   	incomeMoney;
    private int   	incomePayWay;
    private Date   	incomeDate;
    private String   	incomeFrom;
    private int   	incomeLog;
    private int   	incomeVerify;
    private int   	incomeVerifyNameId;
    private Date   	incomeVerifyDate;
    private int   	incomeBigItem;
    private int   	incomeSmallItem;
    private int   	incomeFeenumber;


    public Income() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	incomeName,
        int	incomeMoney,
        int	incomePayWay,
        Date	incomeDate,
        String	incomeFrom,
        int	incomeLog,
        int	incomeVerify,
        int	incomeVerifyNameId,
        Date	incomeVerifyDate,
        int	incomeBigItem,
        int	incomeSmallItem,
        int	incomeFeenumber    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.incomeName 	 = incomeName;
        this.incomeMoney 	 = incomeMoney;
        this.incomePayWay 	 = incomePayWay;
        this.incomeDate 	 = incomeDate;
        this.incomeFrom 	 = incomeFrom;
        this.incomeLog 	 = incomeLog;
        this.incomeVerify 	 = incomeVerify;
        this.incomeVerifyNameId 	 = incomeVerifyNameId;
        this.incomeVerifyDate 	 = incomeVerifyDate;
        this.incomeBigItem 	 = incomeBigItem;
        this.incomeSmallItem 	 = incomeSmallItem;
        this.incomeFeenumber 	 = incomeFeenumber;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getIncomeName   	() { return incomeName; }
    public int   	getIncomeMoney   	() { return incomeMoney; }
    public int   	getIncomePayWay   	() { return incomePayWay; }
    public Date   	getIncomeDate   	() { return incomeDate; }
    public String   	getIncomeFrom   	() { return incomeFrom; }
    public int   	getIncomeLog   	() { return incomeLog; }
    public int   	getIncomeVerify   	() { return incomeVerify; }
    public int   	getIncomeVerifyNameId   	() { return incomeVerifyNameId; }
    public Date   	getIncomeVerifyDate   	() { return incomeVerifyDate; }
    public int   	getIncomeBigItem   	() { return incomeBigItem; }
    public int   	getIncomeSmallItem   	() { return incomeSmallItem; }
    public int   	getIncomeFeenumber   	() { return incomeFeenumber; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setIncomeName   	(String incomeName) { this.incomeName = incomeName; }
    public void 	setIncomeMoney   	(int incomeMoney) { this.incomeMoney = incomeMoney; }
    public void 	setIncomePayWay   	(int incomePayWay) { this.incomePayWay = incomePayWay; }
    public void 	setIncomeDate   	(Date incomeDate) { this.incomeDate = incomeDate; }
    public void 	setIncomeFrom   	(String incomeFrom) { this.incomeFrom = incomeFrom; }
    public void 	setIncomeLog   	(int incomeLog) { this.incomeLog = incomeLog; }
    public void 	setIncomeVerify   	(int incomeVerify) { this.incomeVerify = incomeVerify; }
    public void 	setIncomeVerifyNameId   	(int incomeVerifyNameId) { this.incomeVerifyNameId = incomeVerifyNameId; }
    public void 	setIncomeVerifyDate   	(Date incomeVerifyDate) { this.incomeVerifyDate = incomeVerifyDate; }
    public void 	setIncomeBigItem   	(int incomeBigItem) { this.incomeBigItem = incomeBigItem; }
    public void 	setIncomeSmallItem   	(int incomeSmallItem) { this.incomeSmallItem = incomeSmallItem; }
    public void 	setIncomeFeenumber   	(int incomeFeenumber) { this.incomeFeenumber = incomeFeenumber; }
}
