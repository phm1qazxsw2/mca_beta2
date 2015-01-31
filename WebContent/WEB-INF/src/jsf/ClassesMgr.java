package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ClassesMgr extends Manager
{
    private static ClassesMgr _instance = null;

    ClassesMgr() {}

    public synchronized static ClassesMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ClassesMgr();
        }
        return _instance;
    }

    public ClassesMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "classes";
    }

    protected Object makeBean()
    {
        return new Classes();
    }

    protected int getBeanId(Object obj)
    {
        return ((Classes)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Classes item = (Classes) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	classesName		 = rs.getString("classesName");
            String	classesEnglishName		 = rs.getString("classesEnglishName");
            int	classesStatus		 = rs.getInt("classesStatus");
            int	classesXid		 = rs.getInt("classesXid");
            int	classesAllPeople		 = rs.getInt("classesAllPeople");

            item
            .init(id, created, modified
            , classesName, classesEnglishName, classesStatus
            , classesXid, classesAllPeople);
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
        Classes item = (Classes) obj;

        String ret = "modified=NOW()"
            + ",classesName='" + ServerTool.escapeString(item.getClassesName()) + "'"
            + ",classesEnglishName='" + ServerTool.escapeString(item.getClassesEnglishName()) + "'"
            + ",classesStatus=" + item.getClassesStatus()
            + ",classesXid=" + item.getClassesXid()
            + ",classesAllPeople=" + item.getClassesAllPeople()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, classesName, classesEnglishName, classesStatus, classesXid, classesAllPeople";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Classes item = (Classes) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getClassesName()) + "'"
            + ",'" + ServerTool.escapeString(item.getClassesEnglishName()) + "'"
            + "," + item.getClassesStatus()
            + "," + item.getClassesXid()
            + "," + item.getClassesAllPeople()
        ;
        return ret;
    }
}
