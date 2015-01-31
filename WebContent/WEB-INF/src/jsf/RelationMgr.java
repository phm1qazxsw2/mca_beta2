package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class RelationMgr extends Manager
{
    private static RelationMgr _instance = null;

    RelationMgr() {}

    public synchronized static RelationMgr getInstance()
    {
        if (_instance==null) {
            _instance = new RelationMgr();
        }
        return _instance;
    }

    public RelationMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "relation";
    }

    protected Object makeBean()
    {
        return new Relation();
    }

    protected int getBeanId(Object obj)
    {
        return ((Relation)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Relation item = (Relation) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	relationName		 = rs.getString("relationName");
            int	relationActive		 = rs.getInt("relationActive");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , relationName, relationActive, bunitId
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
        Relation item = (Relation) obj;

        String ret = "modified=NOW()"
            + ",relationName='" + ServerTool.escapeString(item.getRelationName()) + "'"
            + ",relationActive=" + item.getRelationActive()
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, relationName, relationActive, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Relation item = (Relation) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getRelationName()) + "'"
            + "," + item.getRelationActive()
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
