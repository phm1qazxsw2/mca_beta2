package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TagMembrTeacherMgr extends dbo.Manager<TagMembrTeacher>
{
    private static TagMembrTeacherMgr _instance = null;

    TagMembrTeacherMgr() {}

    public synchronized static TagMembrTeacherMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TagMembrTeacherMgr();
        }
        return _instance;
    }

    public TagMembrTeacherMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membr join teacher";
    }

    protected Object makeBean()
    {
        return new TagMembrTeacher();
    }

    protected String JoinSpace()
    {
         return "membr.type=2 and membr.surrogateId=teacher.id";
    }

    protected String getFieldList()
    {
         return "tagId,membr.name,tag.name,membr.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TagMembrTeacher item = (TagMembrTeacher) obj;
        try {
            int	membrId		 = rs.getInt("membr.id");
            item.setMembrId(membrId);
            int	tagId		 = rs.getInt("tagId");
            item.setTagId(tagId);
            String	tagName		 = rs.getString("tag.name");
            item.setTagName(tagName);
            String	membrName		 = rs.getString("membr.name");
            item.setMembrName(membrName);
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
        return ret;
    }
}
