package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class IncomeSmallItem
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	incomeSmallItemName;
    private int   	incomeSmallItemActive;
    private int   	incomeSmallItemIncomeBigItemId;


    public IncomeSmallItem() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	incomeSmallItemName,
        int	incomeSmallItemActive,
        int	incomeSmallItemIncomeBigItemId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.incomeSmallItemName 	 = incomeSmallItemName;
        this.incomeSmallItemActive 	 = incomeSmallItemActive;
        this.incomeSmallItemIncomeBigItemId 	 = incomeSmallItemIncomeBigItemId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getIncomeSmallItemName   	() { return incomeSmallItemName; }
    public int   	getIncomeSmallItemActive   	() { return incomeSmallItemActive; }
    public int   	getIncomeSmallItemIncomeBigItemId   	() { return incomeSmallItemIncomeBigItemId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setIncomeSmallItemName   	(String incomeSmallItemName) { this.incomeSmallItemName = incomeSmallItemName; }
    public void 	setIncomeSmallItemActive   	(int incomeSmallItemActive) { this.incomeSmallItemActive = incomeSmallItemActive; }
    public void 	setIncomeSmallItemIncomeBigItemId   	(int incomeSmallItemIncomeBigItemId) { this.incomeSmallItemIncomeBigItemId = incomeSmallItemIncomeBigItemId; }
}
