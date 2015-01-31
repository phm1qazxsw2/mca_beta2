package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillItem
{

    private int   	id;
    private int   	billId;
    private String   	name;
    private int   	aliasId;
    private int   	smallItemId;
    private int   	pitemId;
    private int   	status;
    private String   	description;
    private int   	defaultAmount;
    private int   	copyStatus;
    private int   	mainBillItemId;
    private int   	pos;
    private String   	color;
    private int   	templateVchrId;


    public BillItem() {}


    public int   	getId   	() { return id; }
    public int   	getBillId   	() { return billId; }
    public String   	getName   	() { return name; }
    public int   	getAliasId   	() { return aliasId; }
    public int   	getSmallItemId   	() { return smallItemId; }
    public int   	getPitemId   	() { return pitemId; }
    public int   	getStatus   	() { return status; }
    public String   	getDescription   	() { return description; }
    public int   	getDefaultAmount   	() { return defaultAmount; }
    public int   	getCopyStatus   	() { return copyStatus; }
    public int   	getMainBillItemId   	() { return mainBillItemId; }
    public int   	getPos   	() { return pos; }
    public String   	getColor   	() { return color; }
    public int   	getTemplateVchrId   	() { return templateVchrId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setBillId   	(int billId) { this.billId = billId; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setAliasId   	(int aliasId) { this.aliasId = aliasId; }
    public void 	setSmallItemId   	(int smallItemId) { this.smallItemId = smallItemId; }
    public void 	setPitemId   	(int pitemId) { this.pitemId = pitemId; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setDescription   	(String description) { this.description = description; }
    public void 	setDefaultAmount   	(int defaultAmount) { this.defaultAmount = defaultAmount; }
    public void 	setCopyStatus   	(int copyStatus) { this.copyStatus = copyStatus; }
    public void 	setMainBillItemId   	(int mainBillItemId) { this.mainBillItemId = mainBillItemId; }
    public void 	setPos   	(int pos) { this.pos = pos; }
    public void 	setColor   	(String color) { this.color = color; }
    public void 	setTemplateVchrId   	(int templateVchrId) { this.templateVchrId = templateVchrId; }

    public static final int STATUS_ACTIVE = 1;
    public static final int STATUS_NOTACTIVE = 0;

    public static final int SALARY_PAY = 1;
    public static final int SALARY_DEDUCT1 = 2;
    public static final int SALARY_DEDUCT2 = 3;

    public static final int COPY_YES = 0;
    public static final int COPY_NO = 1;

    // 2, 3 are negative, 1 is positive
    public static int calc_salary_diff(int org_abs_amount, int new_abs_amount, int org_stype, int new_stype)
    {
        int org_amount = org_abs_amount;
        int new_amount = new_abs_amount;
        if (org_stype==2 || org_stype==3) {
            org_amount = 0 - org_abs_amount;
	    new_amount = 0 - new_abs_amount;
	}
        if (new_stype==2 || new_stype==3)
            new_amount = 0 - new_abs_amount;
        return new_amount - org_amount;
    }

    //### alias ####
    public static Map<Integer, Vector<Alias>> __aliasmap = null;
    public String getItemName()
        throws Exception
    {
        return getItemName(this);
    }

    public static String getItemName(BillItem bi)
        throws Exception
    {
	return getItemName(bi.getAliasId(), bi.getName(), 0);
    }

    public synchronized static String getItemName(int aliasId, String name, int pitemNum)
        throws Exception
    {
        if (__aliasmap==null) {
            __aliasmap = new SortingMap(AliasMgr.getInstance().retrieveList("","")).doSort("getId");
        }
	
	String ret = name;
        if (aliasId>0) {
            Vector<Alias> va = __aliasmap.get(new Integer(aliasId));
            if (va!=null) {
                ret = "[" + va.get(0).getName() + "] " + ret ;
            }
        }
	else if (pitemNum>0) {
	    ret += "(" + pitemNum + "個)";
	}
        return ret;
    }

    public synchronized static void invalidateAlias()
    {
        __aliasmap = null;
    }

    public synchronized static String getAliasName(int aid)
    {
        if (__aliasmap==null || aid==0) {
	    return null;
	}
	String ret = "##";
        Vector<Alias> va = __aliasmap.get(new Integer(aid));
        if (va!=null) {
	    ret = va.get(0).getName();
        }
	return ret;
    }


    /*
        格式一(級距)
        11:130
        21:110
        ==================
        格式二(鐘點)
        10:1000:80
        =================
        格式三(累進:該級距的人數用該級距的費率)
        11:130+
        21:110+
    */
    public final static int CHARGE_TYPE_COUNT = 0;
    public final static int CHARGE_TYPE_STEPS = 1;
    public final static int CHARGE_TYPE_HOURS = 2;
    public final static int CHARGE_TYPE_ACCUM = 3;
    private int chargeType = 0;
    private LinkedHashMap<Integer, Integer> steps = null;
    private int threshold = 0, normal = 0, beyond = 0;
    public int getChargeType() {
        return chargeType;
    }  
    public void parseCharge()
        throws Exception
    {
        steps = new LinkedHashMap<Integer, Integer>();
        String str = this.getDescription();
        String[] lines = str.split("\n");
        for (int i=0; i<lines.length; i++)
        {
            if (lines[i].trim().length()==0)
                continue;
            String[] tokens = lines[i].trim().split(":");
            if (tokens.length==2) { // 級距
                
                int left = Integer.parseInt(tokens[0]);
                String rightstr = null;
                if (tokens[1].indexOf("+")>0) {
                    chargeType = CHARGE_TYPE_ACCUM;
                    rightstr = tokens[1].substring(0, tokens[1].length()-1);
                }
                else {
                    chargeType = CHARGE_TYPE_STEPS;
                    rightstr = tokens[1];
                }
                int right = Integer.parseInt(rightstr);
                steps.put(new Integer(left), new Integer(right));
            }
            else if (tokens.length==3) { // 鐘點            
                chargeType = CHARGE_TYPE_HOURS;
                threshold = Integer.parseInt(tokens[0]);
                normal = Integer.parseInt(tokens[1]);
                beyond = Integer.parseInt(tokens[2]);
            }
            else
                throw new Exception();
        }
    }

    public int getChargeUnitPrice(int num, StringBuffer sb)
    {
        int ret = this.getDefaultAmount();
        if (this.chargeType == CHARGE_TYPE_STEPS) {
            Iterator<Integer> iter = steps.keySet().iterator();
            while (iter.hasNext()) {
                Integer i = iter.next();
                if (num>=i.intValue()) { // 假設 num=20 我們要用 10的級距的
                    ret = steps.get(i).intValue();
                    sb.delete(0, sb.length());
                    sb.append(i.intValue()+"人或以上");
        		}
                else
                    break;
            }
        }
        else if (this.chargeType == CHARGE_TYPE_HOURS) {
            if (num<threshold)
                return normal;
            ret = normal + (num-threshold)*beyond;
            sb.append(normal + "+((" + num + "-" + threshold + ")*" + beyond + ")");
        }
        else if (this.chargeType == CHARGE_TYPE_ACCUM) {
            int total = 0;
            int curp = this.getDefaultAmount();
            for (int i=1; i<=num; i++) {
                Integer value = steps.get(new Integer(i));
                if (value!=null) {
                    curp = value.intValue();
                    sb.delete(0, sb.length());
                    sb.append(i+"人或以上");
                }
                total += curp;
            }
            ret = total;
        }
        return ret;
    }    // ###################

}
