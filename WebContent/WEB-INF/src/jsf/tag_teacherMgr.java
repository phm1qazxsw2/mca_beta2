package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class tag_teacherMgr extends Manager
{
    private static tag_teacherMgr _instance = null;

    tag_teacherMgr() {}

    public synchronized static tag_teacherMgr getInstance()
    {
        if (_instance==null) {
            _instance = new tag_teacherMgr();
        }
        return _instance;
    }

    public tag_teacherMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "tag_teacher";
    }

    protected Object makeBean()
    {
        return new tag_teacher();
    }

    protected int getBeanId(Object obj)
    {
        return ((tag_teacher)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        tag_teacher item = (tag_teacher) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	tagId		 = rs.getInt("tagId");
            int	teacherId		 = rs.getInt("teacherId");

            item
            .init(id, created, modified
            , tagId, teacherId);
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
        tag_teacher item = (tag_teacher) obj;

        String ret = "modified=NOW()"
            + ",tagId=" + item.getTagId()
            + ",teacherId=" + item.getTeacherId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, tagId, teacherId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        tag_teacher item = (tag_teacher) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getTagId()
            + "," + item.getTeacherId()
        ;
        return ret;
    }
}
