package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CfDiscountMgr extends Manager
{
    private static CfDiscountMgr _instance = null;

    CfDiscountMgr() {}

    public synchronized static CfDiscountMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CfDiscountMgr();
        }
        return _instance;
    }

    public CfDiscountMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "cfdiscount";
    }

    protected Object makeBean()
    {
        return new CfDiscount();
    }

    protected int getBeanId(Object obj)
    {
        return ((CfDiscount)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        CfDiscount item = (CfDiscount) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	cfDiscountClassesFeeId		 = rs.getInt("cfDiscountClassesFeeId");
            int	cfDiscountNumber		 = rs.getInt("cfDiscountNumber");
            int	cfDiscountStudentId		 = rs.getInt("cfDiscountStudentId");
            int	cfDiscountClassId		 = rs.getInt("cfDiscountClassId");
            int	cfDiscountGroupId		 = rs.getInt("cfDiscountGroupId");
            int	cfDiscountLevelId		 = rs.getInt("cfDiscountLevelId");
            int	cfDiscountCmId		 = rs.getInt("cfDiscountCmId");
            java.util.Date	cfDiscountMonth		 = rs.getTimestamp("cfDiscountMonth");
            int	cfDiscountFeenumberId		 = rs.getInt("cfDiscountFeenumberId");
            int	cfDiscountLogId		 = rs.getInt("cfDiscountLogId");
            String	cfDiscountLogPs		 = rs.getString("cfDiscountLogPs");
            int	cfDiscountVerify		 = rs.getInt("cfDiscountVerify");
            int	cfDiscountVLogId		 = rs.getInt("cfDiscountVLogId");
            String	cfDiscountVPs		 = rs.getString("cfDiscountVPs");
            java.util.Date	cfDiscountVDate		 = rs.getTimestamp("cfDiscountVDate");
            int	cfDiscountStuatus		 = rs.getInt("cfDiscountStuatus");
            int	cfDiscountTypeId		 = rs.getInt("cfDiscountTypeId");
            int	cfDiscountContinue		 = rs.getInt("cfDiscountContinue");

            item
            .init(id, created, modified
            , cfDiscountClassesFeeId, cfDiscountNumber, cfDiscountStudentId
            , cfDiscountClassId, cfDiscountGroupId, cfDiscountLevelId
            , cfDiscountCmId, cfDiscountMonth, cfDiscountFeenumberId
            , cfDiscountLogId, cfDiscountLogPs, cfDiscountVerify
            , cfDiscountVLogId, cfDiscountVPs, cfDiscountVDate
            , cfDiscountStuatus, cfDiscountTypeId, cfDiscountContinue
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
        CfDiscount item = (CfDiscount) obj;

        String ret = "modified=NOW()"
            + ",cfDiscountClassesFeeId=" + item.getCfDiscountClassesFeeId()
            + ",cfDiscountNumber=" + item.getCfDiscountNumber()
            + ",cfDiscountStudentId=" + item.getCfDiscountStudentId()
            + ",cfDiscountClassId=" + item.getCfDiscountClassId()
            + ",cfDiscountGroupId=" + item.getCfDiscountGroupId()
            + ",cfDiscountLevelId=" + item.getCfDiscountLevelId()
            + ",cfDiscountCmId=" + item.getCfDiscountCmId()
            + ",cfDiscountMonth=" + (((d=item.getCfDiscountMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",cfDiscountFeenumberId=" + item.getCfDiscountFeenumberId()
            + ",cfDiscountLogId=" + item.getCfDiscountLogId()
            + ",cfDiscountLogPs='" + ServerTool.escapeString(item.getCfDiscountLogPs()) + "'"
            + ",cfDiscountVerify=" + item.getCfDiscountVerify()
            + ",cfDiscountVLogId=" + item.getCfDiscountVLogId()
            + ",cfDiscountVPs='" + ServerTool.escapeString(item.getCfDiscountVPs()) + "'"
            + ",cfDiscountVDate=" + (((d=item.getCfDiscountVDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",cfDiscountStuatus=" + item.getCfDiscountStuatus()
            + ",cfDiscountTypeId=" + item.getCfDiscountTypeId()
            + ",cfDiscountContinue=" + item.getCfDiscountContinue()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, cfDiscountClassesFeeId, cfDiscountNumber, cfDiscountStudentId, cfDiscountClassId, cfDiscountGroupId, cfDiscountLevelId, cfDiscountCmId, cfDiscountMonth, cfDiscountFeenumberId, cfDiscountLogId, cfDiscountLogPs, cfDiscountVerify, cfDiscountVLogId, cfDiscountVPs, cfDiscountVDate, cfDiscountStuatus, cfDiscountTypeId, cfDiscountContinue";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        CfDiscount item = (CfDiscount) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getCfDiscountClassesFeeId()
            + "," + item.getCfDiscountNumber()
            + "," + item.getCfDiscountStudentId()
            + "," + item.getCfDiscountClassId()
            + "," + item.getCfDiscountGroupId()
            + "," + item.getCfDiscountLevelId()
            + "," + item.getCfDiscountCmId()
            + "," + (((d=item.getCfDiscountMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getCfDiscountFeenumberId()
            + "," + item.getCfDiscountLogId()
            + ",'" + ServerTool.escapeString(item.getCfDiscountLogPs()) + "'"
            + "," + item.getCfDiscountVerify()
            + "," + item.getCfDiscountVLogId()
            + ",'" + ServerTool.escapeString(item.getCfDiscountVPs()) + "'"
            + "," + (((d=item.getCfDiscountVDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getCfDiscountStuatus()
            + "," + item.getCfDiscountTypeId()
            + "," + item.getCfDiscountContinue()
        ;
        return ret;
    }
}
