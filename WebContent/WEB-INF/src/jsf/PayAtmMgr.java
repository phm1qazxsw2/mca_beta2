package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class PayAtmMgr extends Manager
{
    private static PayAtmMgr _instance = null;

    PayAtmMgr() {}

    public synchronized static PayAtmMgr getInstance()
    {
        if (_instance==null) {
            _instance = new PayAtmMgr();
        }
        return _instance;
    }

    public PayAtmMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "payatm";
    }

    protected Object makeBean()
    {
        return new PayAtm();
    }

    protected int getBeanId(Object obj)
    {
        return ((PayAtm)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        PayAtm item = (PayAtm) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	payAtmNumber		 = rs.getInt("payAtmNumber");
            int	payAtmNumberUnique		 = rs.getInt("payAtmNumberUnique");
            java.util.Date	payAtmPayDate		 = rs.getTimestamp("payAtmPayDate");
            int	payAtmPayMoney		 = rs.getInt("payAtmPayMoney");
            java.util.Date	payAtmMonth		 = rs.getTimestamp("payAtmMonth");
            String	payAtmAccountFirst5		 = rs.getString("payAtmAccountFirst5");
            int	payAtmFeeticketId		 = rs.getInt("payAtmFeeticketId");
            String	payAtmWay		 = rs.getString("payAtmWay");
            String	payAtmBankId		 = rs.getString("payAtmBankId");
            String	payAtmSource		 = rs.getString("payAtmSource");
            int	payAtmStatus		 = rs.getInt("payAtmStatus");
            String	payAtmPs		 = rs.getString("payAtmPs");
            String	payAtmException		 = rs.getString("payAtmException");

            item
            .init(id, created, modified
            , payAtmNumber, payAtmNumberUnique, payAtmPayDate
            , payAtmPayMoney, payAtmMonth, payAtmAccountFirst5
            , payAtmFeeticketId, payAtmWay, payAtmBankId
            , payAtmSource, payAtmStatus, payAtmPs
            , payAtmException);
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
        PayAtm item = (PayAtm) obj;

        String ret = "modified=NOW()"
            + ",payAtmNumber=" + item.getPayAtmNumber()
            + ",payAtmNumberUnique=" + item.getPayAtmNumberUnique()
            + ",payAtmPayDate=" + (((d=item.getPayAtmPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",payAtmPayMoney=" + item.getPayAtmPayMoney()
            + ",payAtmMonth=" + (((d=item.getPayAtmMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",payAtmAccountFirst5='" + ServerTool.escapeString(item.getPayAtmAccountFirst5()) + "'"
            + ",payAtmFeeticketId=" + item.getPayAtmFeeticketId()
            + ",payAtmWay='" + ServerTool.escapeString(item.getPayAtmWay()) + "'"
            + ",payAtmBankId='" + ServerTool.escapeString(item.getPayAtmBankId()) + "'"
            + ",payAtmSource='" + ServerTool.escapeString(item.getPayAtmSource()) + "'"
            + ",payAtmStatus=" + item.getPayAtmStatus()
            + ",payAtmPs='" + ServerTool.escapeString(item.getPayAtmPs()) + "'"
            + ",payAtmException='" + ServerTool.escapeString(item.getPayAtmException()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, payAtmNumber, payAtmNumberUnique, payAtmPayDate, payAtmPayMoney, payAtmMonth, payAtmAccountFirst5, payAtmFeeticketId, payAtmWay, payAtmBankId, payAtmSource, payAtmStatus, payAtmPs, payAtmException";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        PayAtm item = (PayAtm) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getPayAtmNumber()
            + "," + item.getPayAtmNumberUnique()
            + "," + (((d=item.getPayAtmPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getPayAtmPayMoney()
            + "," + (((d=item.getPayAtmMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getPayAtmAccountFirst5()) + "'"
            + "," + item.getPayAtmFeeticketId()
            + ",'" + ServerTool.escapeString(item.getPayAtmWay()) + "'"
            + ",'" + ServerTool.escapeString(item.getPayAtmBankId()) + "'"
            + ",'" + ServerTool.escapeString(item.getPayAtmSource()) + "'"
            + "," + item.getPayAtmStatus()
            + ",'" + ServerTool.escapeString(item.getPayAtmPs()) + "'"
            + ",'" + ServerTool.escapeString(item.getPayAtmException()) + "'"
        ;
        return ret;
    }
}
