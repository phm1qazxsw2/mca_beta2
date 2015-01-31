package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TagStudentMgr extends dbo.Manager<TagStudent>
{
    private static TagStudentMgr _instance = null;

    TagStudentMgr() {}

    public synchronized static TagStudentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TagStudentMgr();
        }
        return _instance;
    }

    public TagStudentMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "tagmembr join membr join student";
    }

    protected Object makeBean()
    {
        return new TagStudent();
    }

    protected String JoinSpace()
    {
         return "tagmembr.membrId=membr.id and membr.type=1 and membr.surrogateId=student.id";
    }

    protected String getFieldList()
    {
         return "tagId,membr.name,tag.name,membr.id,student.id,typeId";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TagStudent item = (TagStudent) obj;
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
            int	typeId		 = rs.getInt("typeId");
            item.setTypeId(typeId);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (tag) ON tagId=tag.id ";
        return ret;
    }
}
