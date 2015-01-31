package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CoModifyMgr extends Manager
{
    private static CoModifyMgr _instance = null;

    CoModifyMgr() {}

    public synchronized static CoModifyMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CoModifyMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "comodify";
    }

    protected Object makeBean()
    {
        return new CoModify();
    }

    protected int getBeanId(Object obj)
    {
        return ((CoModify)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        CoModify item = (CoModify) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	coModifyIncomeId		 = rs.getInt("coModifyIncomeId");
            String	coModifyNotice		 = rs.getString("coModifyNotice");
            int	coModifyUser		 = rs.getInt("coModifyUser");

            item
            .init(id, created, modified
            , coModifyIncomeId, coModifyNotice, coModifyUser
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
        CoModify item = (CoModify) obj;

        String ret = "modified=NOW()"
            + ",coModifyIncomeId=" + item.getCoModifyIncomeId()
            + ",coModifyNotice='" + ServerTool.escapeString(item.getCoModifyNotice()) + "'"
            + ",coModifyUser=" + item.getCoModifyUser()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, coModifyIncomeId, coModifyNotice, coModifyUser";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        CoModify item = (CoModify) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getCoModifyIncomeId()
            + ",'" + ServerTool.escapeString(item.getCoModifyNotice()) + "'"
            + "," + item.getCoModifyUser()
        ;
        return ret;
    }
}
