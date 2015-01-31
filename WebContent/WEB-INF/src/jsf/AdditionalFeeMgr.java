package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class AdditionalFeeMgr extends Manager
{
    private static AdditionalFeeMgr _instance = null;

    AdditionalFeeMgr() {}

    public synchronized static AdditionalFeeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new AdditionalFeeMgr();
        }
        return _instance;
    }

    public AdditionalFeeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "additionalfee";
    }

    protected Object makeBean()
    {
        return new AdditionalFee();
    }

    protected int getBeanId(Object obj)
    {
        return ((AdditionalFee)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        AdditionalFee item = (AdditionalFee) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	additionalFeeOriginal		 = rs.getInt("additionalFeeOriginal");
            int	additionalFeeAddition		 = rs.getInt("additionalFeeAddition");
            int	additionalFeeActive		 = rs.getInt("additionalFeeActive");
            String	additionalFeePs		 = rs.getString("additionalFeePs");

            item
            .init(id, created, modified
            , additionalFeeOriginal, additionalFeeAddition, additionalFeeActive
            , additionalFeePs);
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
        AdditionalFee item = (AdditionalFee) obj;

        String ret = "modified=NOW()"
            + ",additionalFeeOriginal=" + item.getAdditionalFeeOriginal()
            + ",additionalFeeAddition=" + item.getAdditionalFeeAddition()
            + ",additionalFeeActive=" + item.getAdditionalFeeActive()
            + ",additionalFeePs='" + ServerTool.escapeString(item.getAdditionalFeePs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, additionalFeeOriginal, additionalFeeAddition, additionalFeeActive, additionalFeePs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        AdditionalFee item = (AdditionalFee) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getAdditionalFeeOriginal()
            + "," + item.getAdditionalFeeAddition()
            + "," + item.getAdditionalFeeActive()
            + ",'" + ServerTool.escapeString(item.getAdditionalFeePs()) + "'"
        ;
        return ret;
    }
}
