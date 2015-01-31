package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class PayFeeMgr extends Manager
{
    private static PayFeeMgr _instance = null;

    PayFeeMgr() {}

    public synchronized static PayFeeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new PayFeeMgr();
        }
        return _instance;
    }

    public PayFeeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "payfee";
    }

    protected Object makeBean()
    {
        return new PayFee();
    }

    protected int getBeanId(Object obj)
    {
        return ((PayFee)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        PayFee item = (PayFee) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	payFeeFeenumberId		 = rs.getInt("payFeeFeenumberId");
            int	payFeeMoneyNumber		 = rs.getInt("payFeeMoneyNumber");
            java.util.Date	payFeeLogDate		 = rs.getTimestamp("payFeeLogDate");
            java.util.Date	payFeeLogPayDate		 = rs.getTimestamp("payFeeLogPayDate");
            int	payFeeManPCType		 = rs.getInt("payFeeManPCType");
            int	payFeeSourceCategory		 = rs.getInt("payFeeSourceCategory");
            int	payFeeSourceId		 = rs.getInt("payFeeSourceId");
            String	payFeeSourceFileName		 = rs.getString("payFeeSourceFileName");
            int	payFeeStatus		 = rs.getInt("payFeeStatus");
            int	payFeeLogId		 = rs.getInt("payFeeLogId");
            String	payFeeLogPs		 = rs.getString("payFeeLogPs");
            int	payFeeVId		 = rs.getInt("payFeeVId");
            String	payFeeVPs		 = rs.getString("payFeeVPs");
            int	payFeeMessageStatus		 = rs.getInt("payFeeMessageStatus");
            int	payFeeAccountType		 = rs.getInt("payFeeAccountType");
            int	payFeeAccountId		 = rs.getInt("payFeeAccountId");
            int	payFeeVstatus		 = rs.getInt("payFeeVstatus");

            item
            .init(id, created, modified
            , payFeeFeenumberId, payFeeMoneyNumber, payFeeLogDate
            , payFeeLogPayDate, payFeeManPCType, payFeeSourceCategory
            , payFeeSourceId, payFeeSourceFileName, payFeeStatus
            , payFeeLogId, payFeeLogPs, payFeeVId
            , payFeeVPs, payFeeMessageStatus, payFeeAccountType
            , payFeeAccountId, payFeeVstatus);
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
        PayFee item = (PayFee) obj;

        String ret = "modified=NOW()"
            + ",payFeeFeenumberId=" + item.getPayFeeFeenumberId()
            + ",payFeeMoneyNumber=" + item.getPayFeeMoneyNumber()
            + ",payFeeLogDate=" + (((d=item.getPayFeeLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",payFeeLogPayDate=" + (((d=item.getPayFeeLogPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",payFeeManPCType=" + item.getPayFeeManPCType()
            + ",payFeeSourceCategory=" + item.getPayFeeSourceCategory()
            + ",payFeeSourceId=" + item.getPayFeeSourceId()
            + ",payFeeSourceFileName='" + ServerTool.escapeString(item.getPayFeeSourceFileName()) + "'"
            + ",payFeeStatus=" + item.getPayFeeStatus()
            + ",payFeeLogId=" + item.getPayFeeLogId()
            + ",payFeeLogPs='" + ServerTool.escapeString(item.getPayFeeLogPs()) + "'"
            + ",payFeeVId=" + item.getPayFeeVId()
            + ",payFeeVPs='" + ServerTool.escapeString(item.getPayFeeVPs()) + "'"
            + ",payFeeMessageStatus=" + item.getPayFeeMessageStatus()
            + ",payFeeAccountType=" + item.getPayFeeAccountType()
            + ",payFeeAccountId=" + item.getPayFeeAccountId()
            + ",payFeeVstatus=" + item.getPayFeeVstatus()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, payFeeFeenumberId, payFeeMoneyNumber, payFeeLogDate, payFeeLogPayDate, payFeeManPCType, payFeeSourceCategory, payFeeSourceId, payFeeSourceFileName, payFeeStatus, payFeeLogId, payFeeLogPs, payFeeVId, payFeeVPs, payFeeMessageStatus, payFeeAccountType, payFeeAccountId, payFeeVstatus";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        PayFee item = (PayFee) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getPayFeeFeenumberId()
            + "," + item.getPayFeeMoneyNumber()
            + "," + (((d=item.getPayFeeLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getPayFeeLogPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getPayFeeManPCType()
            + "," + item.getPayFeeSourceCategory()
            + "," + item.getPayFeeSourceId()
            + ",'" + ServerTool.escapeString(item.getPayFeeSourceFileName()) + "'"
            + "," + item.getPayFeeStatus()
            + "," + item.getPayFeeLogId()
            + ",'" + ServerTool.escapeString(item.getPayFeeLogPs()) + "'"
            + "," + item.getPayFeeVId()
            + ",'" + ServerTool.escapeString(item.getPayFeeVPs()) + "'"
            + "," + item.getPayFeeMessageStatus()
            + "," + item.getPayFeeAccountType()
            + "," + item.getPayFeeAccountId()
            + "," + item.getPayFeeVstatus()
        ;
        return ret;
    }
}
