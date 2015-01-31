package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MainTagStudentMgr extends dbo.Manager<MainTagStudent>
{
    private static MainTagStudentMgr _instance = null;

    MainTagStudentMgr() {}

    public synchronized static MainTagStudentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MainTagStudentMgr();
        }
        return _instance;
    }

    public MainTagStudentMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membr join student";
    }

    protected Object makeBean()
    {
        return new MainTagStudent();
    }

    protected String JoinSpace()
    {
         return "membr.type=1 and membr.surrogateId=student.id";
    }

    protected String getFieldList()
    {
         return "tagId,membr.name,tag.name,membr.id,student.id,studentStatus";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MainTagStudent item = (MainTagStudent) obj;
        try {
            int	membrId		 = rs.getInt("membr.id");
            item.setMembrId(membrId);
            int	tagId		 = rs.getInt("tagId");
            item.setTagId(tagId);
            String	tagName		 = rs.getString("tag.name");
            item.setTagName(tagName);
            String	membrName		 = rs.getString("membr.name");
            item.setMembrName(membrName);
            int	studentId		 = rs.getInt("student.id");
            item.setStudentId(studentId);
            int	studentStatus		 = rs.getInt("studentStatus");
            item.setStudentStatus(studentStatus);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (tagmembr,tag,tagtype) ON membrId=membr.id and tagId=tag.id and tag.typeId=tagtype.id and tagtype.main=1 ";
        return ret;
    }
}
