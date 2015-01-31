package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Cost
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	costAccountDate;
    private int   	costOutIn;
    private String   	costName;
    private int   	costMoney;
    private int   	costLogId;
    private int   	costBigItem;
    private int   	costSmallItem;
    private int   	costCostbookId;
    private int   	costCostCheckId;
    private String   	costPs;


    public Cost() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	costAccountDate,
        int	costOutIn,
        String	costName,
        int	costMoney,
        int	costLogId,
        int	costBigItem,
        int	costSmallItem,
        int	costCostbookId,
        int	costCostCheckId,
        String	costPs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.costAccountDate 	 = costAccountDate;
        this.costOutIn 	 = costOutIn;
        this.costName 	 = costName;
        this.costMoney 	 = costMoney;
        this.costLogId 	 = costLogId;
        this.costBigItem 	 = costBigItem;
        this.costSmallItem 	 = costSmallItem;
        this.costCostbookId 	 = costCostbookId;
        this.costCostCheckId 	 = costCostCheckId;
        this.costPs 	 = costPs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getCostAccountDate   	() { return costAccountDate; }
    public int   	getCostOutIn   	() { return costOutIn; }
    public String   	getCostName   	() { return costName; }
    public int   	getCostMoney   	() { return costMoney; }
    public int   	getCostLogId   	() { return costLogId; }
    public int   	getCostBigItem   	() { return costBigItem; }
    public int   	getCostSmallItem   	() { return costSmallItem; }
    public int   	getCostCostbookId   	() { return costCostbookId; }
    public int   	getCostCostCheckId   	() { return costCostCheckId; }
    public String   	getCostPs   	() { return costPs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setCostAccountDate   	(Date costAccountDate) { this.costAccountDate = costAccountDate; }
    public void 	setCostOutIn   	(int costOutIn) { this.costOutIn = costOutIn; }
    public void 	setCostName   	(String costName) { this.costName = costName; }
    public void 	setCostMoney   	(int costMoney) { this.costMoney = costMoney; }
    public void 	setCostLogId   	(int costLogId) { this.costLogId = costLogId; }
    public void 	setCostBigItem   	(int costBigItem) { this.costBigItem = costBigItem; }
    public void 	setCostSmallItem   	(int costSmallItem) { this.costSmallItem = costSmallItem; }
    public void 	setCostCostbookId   	(int costCostbookId) { this.costCostbookId = costCostbookId; }
    public void 	setCostCostCheckId   	(int costCostCheckId) { this.costCostCheckId = costCostCheckId; }
    public void 	setCostPs   	(String costPs) { this.costPs = costPs; }
}
