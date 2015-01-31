package phm.accounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class VchrThread
{

    private int   	id;
    private int   	srcType;
    private String   	srcInfo;


    public VchrThread() {}


    public int   	getId   	() { return id; }
    public int   	getSrcType   	() { return srcType; }
    public String   	getSrcInfo   	() { return srcInfo; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setSrcType   	(int srcType) { this.srcType = srcType; }
    public void 	setSrcInfo   	(String srcInfo) { this.srcInfo = srcInfo; }

    public static final int SRC_TYPE_BILL = 1;
    public static final int SRC_TYPE_SALARY = 2;
    public static final int SRC_TYPE_INCOME = 3;
    public static final int SRC_TYPE_BILLPAY = 4;
    public static final int SRC_TYPE_BILLPAID = 5;
    public static final int SRC_TYPE_INSIDETRADE = 6;
    public static final int SRC_TYPE_SALARYPAY = 7;
    public static final int SRC_TYPE_SALARYPAID = 8;
    public static final int SRC_TYPE_SPENDING = 9;
    public static final int SRC_TYPE_BUYGOODS = 10;
    public static final int SRC_TYPE_MANUAL = 11;
    public static final int SRC_TYPE_CHEQUE_CASHIN = 12;
    public static final int SRC_TYPE_CHEQUE_CASHOUT = 13;
    public static final int SRC_TYPE_FUNDING = 14;
    public static final int SRC_TYPE_FUNDING_DIST = 15;


    public static String getSrcTypeName(String srcTypes, char sep)
    {
        if (srcTypes==null || srcTypes.length()==0)
	    return "";
	String[] types = srcTypes.split(",");
        StringBuffer sb = new StringBuffer();
	for (int i=0; i<types.length; i++) {
	    if (sb.length()>0)
	        sb.append(sep);
            switch (Integer.parseInt(types[i])) {
                case SRC_TYPE_BILL: sb.append("帳單"); break;
                case SRC_TYPE_SALARY: sb.append("薪資"); break;
                case SRC_TYPE_INCOME: sb.append("雜費收入"); break;
                case SRC_TYPE_BILLPAY: sb.append("帳單付款"); break;
                case SRC_TYPE_BILLPAID: sb.append("帳單沖帳"); break;
                case SRC_TYPE_INSIDETRADE: sb.append("現金轉帳"); break;
                case SRC_TYPE_SALARYPAY: sb.append("薪資付款"); break;
                case SRC_TYPE_SALARYPAID: sb.append("薪資沖帳"); break;
                case SRC_TYPE_SPENDING: sb.append("雜費支出"); break;
                case SRC_TYPE_BUYGOODS: sb.append("學用品進貨"); break;
                case SRC_TYPE_MANUAL: sb.append("人工輸入"); break;
                case SRC_TYPE_CHEQUE_CASHIN: sb.append("應收票據"); break;
                case SRC_TYPE_CHEQUE_CASHOUT: sb.append("應付票據"); break;
                case SRC_TYPE_FUNDING: sb.append("補助款"); break;
                case SRC_TYPE_FUNDING_DIST: sb.append("補助分配"); break;
	    }
	}
	return sb.toString();
    }

}
