package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class StunoticeMgr extends Manager
{
    private static StunoticeMgr _instance = null;

    StunoticeMgr() {}

    public synchronized static StunoticeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new StunoticeMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "stunotice";
    }

    protected Object makeBean()
    {
        return new Stunotice();
    }

    protected int getBeanId(Object obj)
    {
        return ((Stunotice)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Stunotice item = (Stunotice) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	stunoticeCategory		 = rs.getInt("stunoticeCategory");
            int	stunoticeXid		 = rs.getInt("stunoticeXid");
            java.util.Date	stunoticeDate		 = rs.getTimestamp("stunoticeDate");
            int	stunoticeStatus		 = rs.getInt("stunoticeStatus");
            int	stunoticeImportant		 = rs.getInt("stunoticeImportant");
            int	stunoticeStudentId		 = rs.getInt("stunoticeStudentId");

            item
            .init(id, created, modified
            , stunoticeCategory, stunoticeXid, stunoticeDate
            , stunoticeStatus, stunoticeImportant, stunoticeStudentId
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
        Stunotice item = (Stunotice) obj;

        String ret = "modified=NOW()"
            + ",stunoticeCategory=" + item.getStunoticeCategory()
            + ",stunoticeXid=" + item.getStunoticeXid()
            + ",stunoticeDate=" + (((d=item.getStunoticeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",stunoticeStatus=" + item.getStunoticeStatus()
            + ",stunoticeImportant=" + item.getStunoticeImportant()
            + ",stunoticeStudentId=" + item.getStunoticeStudentId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, stunoticeCategory, stunoticeXid, stunoticeDate, stunoticeStatus, stunoticeImportant, stunoticeStudentId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Stunotice item = (Stunotice) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getStunoticeCategory()
            + "," + item.getStunoticeXid()
            + "," + (((d=item.getStunoticeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getStunoticeStatus()
            + "," + item.getStunoticeImportant()
            + "," + item.getStunoticeStudentId()
        ;
        return ret;
    }
}
