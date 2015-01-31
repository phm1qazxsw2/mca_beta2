package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TagMembrStudentMgr extends dbo.Manager<TagMembrStudent>
{
    private static TagMembrStudentMgr _instance = null;

    TagMembrStudentMgr() {}

    public synchronized static TagMembrStudentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TagMembrStudentMgr();
        }
        return _instance;
    }

    public TagMembrStudentMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membr join student";
    }

    protected Object makeBean()
    {
        return new TagMembrStudent();
    }

    protected String JoinSpace()
    {
         return "membr.type=1 and membr.surrogateId=student.id";
    }

    protected String getFieldList()
    {
         return "tagId,membr.name,tag.name,membr.id,student.id,studentStatus,student.modified,tagtype.name,bindTime";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TagMembrStudent item = (TagMembrStudent) obj;
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
            java.util.Date	modified		 = rs.getTimestamp("student.modified");
            item.setModified(modified);
            String	typeName		 = rs.getString("tagtype.name");
            item.setTypeName(typeName);
            java.util.Date	bindTime		 = rs.getTimestamp("bindTime");
            item.setBindTime(bindTime);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (tagmembr,tag) ON membrId=membr.id and tagId=tag.id ";
        ret += "LEFT JOIN (tagtype) ON tag.typeId=tagtype.id ";
        return ret;
    }
}
