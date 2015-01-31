package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class FeeticketMgr extends Manager
{
    private static FeeticketMgr _instance = null;

    FeeticketMgr() {}

    public synchronized static FeeticketMgr getInstance()
    {
        if (_instance==null) {
            _instance = new FeeticketMgr();
        }
        return _instance;
    }

    public FeeticketMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "feeticket";
    }

    protected Object makeBean()
    {
        return new Feeticket();
    }

    protected int getBeanId(Object obj)
    {
        return ((Feeticket)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Feeticket item = (Feeticket) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	feeticketMonth		 = rs.getTimestamp("feeticketMonth");
            int	feeticketFeenumberId		 = rs.getInt("feeticketFeenumberId");
            int	feeticketStuId		 = rs.getInt("feeticketStuId");
            int	feeticketStuClassId		 = rs.getInt("feeticketStuClassId");
            int	feeticketStuGroupId		 = rs.getInt("feeticketStuGroupId");
            int	feeticketStuLevelId		 = rs.getInt("feeticketStuLevelId");
            int	feeticketSholdMoney		 = rs.getInt("feeticketSholdMoney");
            int	feeticketDiscountMoney		 = rs.getInt("feeticketDiscountMoney");
            int	feeticketTotalMoney		 = rs.getInt("feeticketTotalMoney");
            int	feeticketPayMoney		 = rs.getInt("feeticketPayMoney");
            java.util.Date	feeticketPayDate		 = rs.getTimestamp("feeticketPayDate");
            int	feeticketStatus		 = rs.getInt("feeticketStatus");
            java.util.Date	feeticketEndPayDate		 = rs.getTimestamp("feeticketEndPayDate");
            String	feeticketPs		 = rs.getString("feeticketPs");
            int	feeticketNewFeenumber		 = rs.getInt("feeticketNewFeenumber");
            int	feeticketNewFeenumberCmId		 = rs.getInt("feeticketNewFeenumberCmId");
            int	feeticketLock		 = rs.getInt("feeticketLock");
            int	feeticketPrintUpdate		 = rs.getInt("feeticketPrintUpdate");

            item
            .init(id, created, modified
            , feeticketMonth, feeticketFeenumberId, feeticketStuId
            , feeticketStuClassId, feeticketStuGroupId, feeticketStuLevelId
            , feeticketSholdMoney, feeticketDiscountMoney, feeticketTotalMoney
            , feeticketPayMoney, feeticketPayDate, feeticketStatus
            , feeticketEndPayDate, feeticketPs, feeticketNewFeenumber
            , feeticketNewFeenumberCmId, feeticketLock, feeticketPrintUpdate
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
        Feeticket item = (Feeticket) obj;

        String ret = "modified=NOW()"
            + ",feeticketMonth=" + (((d=item.getFeeticketMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",feeticketFeenumberId=" + item.getFeeticketFeenumberId()
            + ",feeticketStuId=" + item.getFeeticketStuId()
            + ",feeticketStuClassId=" + item.getFeeticketStuClassId()
            + ",feeticketStuGroupId=" + item.getFeeticketStuGroupId()
            + ",feeticketStuLevelId=" + item.getFeeticketStuLevelId()
            + ",feeticketSholdMoney=" + item.getFeeticketSholdMoney()
            + ",feeticketDiscountMoney=" + item.getFeeticketDiscountMoney()
            + ",feeticketTotalMoney=" + item.getFeeticketTotalMoney()
            + ",feeticketPayMoney=" + item.getFeeticketPayMoney()
            + ",feeticketPayDate=" + (((d=item.getFeeticketPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",feeticketStatus=" + item.getFeeticketStatus()
            + ",feeticketEndPayDate=" + (((d=item.getFeeticketEndPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",feeticketPs='" + ServerTool.escapeString(item.getFeeticketPs()) + "'"
            + ",feeticketNewFeenumber=" + item.getFeeticketNewFeenumber()
            + ",feeticketNewFeenumberCmId=" + item.getFeeticketNewFeenumberCmId()
            + ",feeticketLock=" + item.getFeeticketLock()
            + ",feeticketPrintUpdate=" + item.getFeeticketPrintUpdate()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, feeticketMonth, feeticketFeenumberId, feeticketStuId, feeticketStuClassId, feeticketStuGroupId, feeticketStuLevelId, feeticketSholdMoney, feeticketDiscountMoney, feeticketTotalMoney, feeticketPayMoney, feeticketPayDate, feeticketStatus, feeticketEndPayDate, feeticketPs, feeticketNewFeenumber, feeticketNewFeenumberCmId, feeticketLock, feeticketPrintUpdate";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Feeticket item = (Feeticket) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getFeeticketMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getFeeticketFeenumberId()
            + "," + item.getFeeticketStuId()
            + "," + item.getFeeticketStuClassId()
            + "," + item.getFeeticketStuGroupId()
            + "," + item.getFeeticketStuLevelId()
            + "," + item.getFeeticketSholdMoney()
            + "," + item.getFeeticketDiscountMoney()
            + "," + item.getFeeticketTotalMoney()
            + "," + item.getFeeticketPayMoney()
            + "," + (((d=item.getFeeticketPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getFeeticketStatus()
            + "," + (((d=item.getFeeticketEndPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getFeeticketPs()) + "'"
            + "," + item.getFeeticketNewFeenumber()
            + "," + item.getFeeticketNewFeenumberCmId()
            + "," + item.getFeeticketLock()
            + "," + item.getFeeticketPrintUpdate()
        ;
        return ret;
    }
}
