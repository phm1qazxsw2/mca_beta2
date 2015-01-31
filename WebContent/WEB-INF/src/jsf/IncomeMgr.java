package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class IncomeMgr extends Manager
{
    private static IncomeMgr _instance = null;

    IncomeMgr() {}

    public synchronized static IncomeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new IncomeMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "income";
    }

    protected Object makeBean()
    {
        return new Income();
    }

    protected int getBeanId(Object obj)
    {
        return ((Income)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Income item = (Income) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	incomeName		 = rs.getString("incomeName");
            int	incomeMoney		 = rs.getInt("incomeMoney");
            int	incomePayWay		 = rs.getInt("incomePayWay");
            java.util.Date	incomeDate		 = rs.getTimestamp("incomeDate");
            String	incomeFrom		 = rs.getString("incomeFrom");
            int	incomeLog		 = rs.getInt("incomeLog");
            int	incomeVerify		 = rs.getInt("incomeVerify");
            int	incomeVerifyNameId		 = rs.getInt("incomeVerifyNameId");
            java.util.Date	incomeVerifyDate		 = rs.getTimestamp("incomeVerifyDate");
            int	incomeBigItem		 = rs.getInt("incomeBigItem");
            int	incomeSmallItem		 = rs.getInt("incomeSmallItem");
            int	incomeFeenumber		 = rs.getInt("incomeFeenumber");

            item
            .init(id, created, modified
            , incomeName, incomeMoney, incomePayWay
            , incomeDate, incomeFrom, incomeLog
            , incomeVerify, incomeVerifyNameId, incomeVerifyDate
            , incomeBigItem, incomeSmallItem, incomeFeenumber
            );
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getSaveString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Income item = (Income) obj;

        String ret = "modified=NOW()"
            + ",incomeName='" + ServerTool.escapeString(item.getIncomeName()) + "'"
            + ",incomeMoney=" + item.getIncomeMoney()
            + ",incomePayWay=" + item.getIncomePayWay()
            + ",incomeDate=" + (((d=item.getIncomeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",incomeFrom='" + ServerTool.escapeString(item.getIncomeFrom()) + "'"
            + ",incomeLog=" + item.getIncomeLog()
            + ",incomeVerify=" + item.getIncomeVerify()
            + ",incomeVerifyNameId=" + item.getIncomeVerifyNameId()
            + ",incomeVerifyDate=" + (((d=item.getIncomeVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",incomeBigItem=" + item.getIncomeBigItem()
            + ",incomeSmallItem=" + item.getIncomeSmallItem()
            + ",incomeFeenumber=" + item.getIncomeFeenumber()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, incomeName, incomeMoney, incomePayWay, incomeDate, incomeFrom, incomeLog, incomeVerify, incomeVerifyNameId, incomeVerifyDate, incomeBigItem, incomeSmallItem, incomeFeenumber";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Income item = (Income) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getIncomeName()) + "'"
            + "," + item.getIncomeMoney()
            + "," + item.getIncomePayWay()
            + "," + (((d=item.getIncomeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getIncomeFrom()) + "'"
            + "," + item.getIncomeLog()
            + "," + item.getIncomeVerify()
            + "," + item.getIncomeVerifyNameId()
            + "," + (((d=item.getIncomeVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getIncomeBigItem()
            + "," + item.getIncomeSmallItem()
            + "," + item.getIncomeFeenumber()
        ;
        return ret;
    }
}
