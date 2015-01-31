package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class tag_studentMgr extends Manager
{
    private static tag_studentMgr _instance = null;

    tag_studentMgr() {}

    public synchronized static tag_studentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new tag_studentMgr();
        }
        return _instance;
    }

    public tag_studentMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "tag_student";
    }

    protected Object makeBean()
    {
        return new tag_student();
    }

    protected int getBeanId(Object obj)
    {
        return ((tag_student)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        tag_student item = (tag_student) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	tagId		 = rs.getInt("tagId");
            int	studentId		 = rs.getInt("studentId");

            item
            .init(id, created, modified
            , tagId, studentId);
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
        tag_student item = (tag_student) obj;

        String ret = "modified=NOW()"
            + ",tagId=" + item.getTagId()
            + ",studentId=" + item.getStudentId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, tagId, studentId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        tag_student item = (tag_student) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getTagId()
            + "," + item.getStudentId()
        ;
        return ret;
    }
}
