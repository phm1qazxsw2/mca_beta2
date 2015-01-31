package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class InsidetradeMgr extends Manager
{
    private static InsidetradeMgr _instance = null;

    InsidetradeMgr() {}

    public synchronized static InsidetradeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new InsidetradeMgr();
        }
        return _instance;
    }

    public InsidetradeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "insidetrade";
    }

    protected Object makeBean()
    {
        return new Insidetrade();
    }

    protected int getBeanId(Object obj)
    {
        return ((Insidetrade)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Insidetrade item = (Insidetrade) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	insidetradeUserId		 = rs.getInt("insidetradeUserId");
            String	insidetradeUserPs		 = rs.getString("insidetradeUserPs");
            int	insidetradeNumber		 = rs.getInt("insidetradeNumber");
            int	insidetradeWay		 = rs.getInt("insidetradeWay");
            java.util.Date	insidetradeDate		 = rs.getTimestamp("insidetradeDate");
            int	insidetradeFromType		 = rs.getInt("insidetradeFromType");
            int	insidetradeFromId		 = rs.getInt("insidetradeFromId");
            int	insidetradeToType		 = rs.getInt("insidetradeToType");
            int	insidetradeToId		 = rs.getInt("insidetradeToId");
            int	insidetradeCheckLog		 = rs.getInt("insidetradeCheckLog");
            int	insidetradeCheckUserId		 = rs.getInt("insidetradeCheckUserId");
            java.util.Date	insidetradeCheckDate		 = rs.getTimestamp("insidetradeCheckDate");
            String	insidetradeCheckPs		 = rs.getString("insidetradeCheckPs");
            int	threadId		 = rs.getInt("threadId");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , insidetradeUserId, insidetradeUserPs, insidetradeNumber
            , insidetradeWay, insidetradeDate, insidetradeFromType
            , insidetradeFromId, insidetradeToType, insidetradeToId
            , insidetradeCheckLog, insidetradeCheckUserId, insidetradeCheckDate
            , insidetradeCheckPs, threadId, bunitId
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
        Insidetrade item = (Insidetrade) obj;

        String ret = "modified=NOW()"
            + ",insidetradeUserId=" + item.getInsidetradeUserId()
            + ",insidetradeUserPs='" + ServerTool.escapeString(item.getInsidetradeUserPs()) + "'"
            + ",insidetradeNumber=" + item.getInsidetradeNumber()
            + ",insidetradeWay=" + item.getInsidetradeWay()
            + ",insidetradeDate=" + (((d=item.getInsidetradeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",insidetradeFromType=" + item.getInsidetradeFromType()
            + ",insidetradeFromId=" + item.getInsidetradeFromId()
            + ",insidetradeToType=" + item.getInsidetradeToType()
            + ",insidetradeToId=" + item.getInsidetradeToId()
            + ",insidetradeCheckLog=" + item.getInsidetradeCheckLog()
            + ",insidetradeCheckUserId=" + item.getInsidetradeCheckUserId()
            + ",insidetradeCheckDate=" + (((d=item.getInsidetradeCheckDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",insidetradeCheckPs='" + ServerTool.escapeString(item.getInsidetradeCheckPs()) + "'"
            + ",threadId=" + item.getThreadId()
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, insidetradeUserId, insidetradeUserPs, insidetradeNumber, insidetradeWay, insidetradeDate, insidetradeFromType, insidetradeFromId, insidetradeToType, insidetradeToId, insidetradeCheckLog, insidetradeCheckUserId, insidetradeCheckDate, insidetradeCheckPs, threadId, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Insidetrade item = (Insidetrade) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getInsidetradeUserId()
            + ",'" + ServerTool.escapeString(item.getInsidetradeUserPs()) + "'"
            + "," + item.getInsidetradeNumber()
            + "," + item.getInsidetradeWay()
            + "," + (((d=item.getInsidetradeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getInsidetradeFromType()
            + "," + item.getInsidetradeFromId()
            + "," + item.getInsidetradeToType()
            + "," + item.getInsidetradeToId()
            + "," + item.getInsidetradeCheckLog()
            + "," + item.getInsidetradeCheckUserId()
            + "," + (((d=item.getInsidetradeCheckDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getInsidetradeCheckPs()) + "'"
            + "," + item.getThreadId()
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
