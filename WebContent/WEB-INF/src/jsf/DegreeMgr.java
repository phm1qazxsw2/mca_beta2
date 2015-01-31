package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class DegreeMgr extends Manager
{
    private static DegreeMgr _instance = null;

    DegreeMgr() {}

    public synchronized static DegreeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new DegreeMgr();
        }
        return _instance;
    }

    public DegreeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "degree";
    }

    protected Object makeBean()
    {
        return new Degree();
    }

    protected int getBeanId(Object obj)
    {
        return ((Degree)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Degree item = (Degree) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	degreeName		 = rs.getString("degreeName");
            int	degreeActive		 = rs.getInt("degreeActive");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , degreeName, degreeActive, bunitId
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
        Degree item = (Degree) obj;

        String ret = "modified=NOW()"
            + ",degreeName='" + ServerTool.escapeString(item.getDegreeName()) + "'"
            + ",degreeActive=" + item.getDegreeActive()
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, degreeName, degreeActive, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Degree item = (Degree) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getDegreeName()) + "'"
            + "," + item.getDegreeActive()
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
