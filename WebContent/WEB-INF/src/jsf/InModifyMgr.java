package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class InModifyMgr extends Manager
{
    private static InModifyMgr _instance = null;

    InModifyMgr() {}

    public synchronized static InModifyMgr getInstance()
    {
        if (_instance==null) {
            _instance = new InModifyMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "inmodify";
    }

    protected Object makeBean()
    {
        return new InModify();
    }

    protected int getBeanId(Object obj)
    {
        return ((InModify)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        InModify item = (InModify) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	inModifyIncomeId		 = rs.getInt("inModifyIncomeId");
            String	inModifyNotice		 = rs.getString("inModifyNotice");
            int	inModifyUser		 = rs.getInt("inModifyUser");

            item
            .init(id, created, modified
            , inModifyIncomeId, inModifyNotice, inModifyUser
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
        InModify item = (InModify) obj;

        String ret = "modified=NOW()"
            + ",inModifyIncomeId=" + item.getInModifyIncomeId()
            + ",inModifyNotice='" + ServerTool.escapeString(item.getInModifyNotice()) + "'"
            + ",inModifyUser=" + item.getInModifyUser()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, inModifyIncomeId, inModifyNotice, inModifyUser";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        InModify item = (InModify) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getInModifyIncomeId()
            + ",'" + ServerTool.escapeString(item.getInModifyNotice()) + "'"
            + "," + item.getInModifyUser()
        ;
        return ret;
    }
}
