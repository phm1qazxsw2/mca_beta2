package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TagMembrInfoMgr extends dbo.Manager<TagMembrInfo>
{
    private static TagMembrInfoMgr _instance = null;

    TagMembrInfoMgr() {}

    public synchronized static TagMembrInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TagMembrInfoMgr();
        }
        return _instance;
    }

    public TagMembrInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "tagmembr";
    }

    protected Object makeBean()
    {
        return new TagMembrInfo();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TagMembrInfo item = (TagMembrInfo) obj;
        try {
            int	tagId		 = rs.getInt("tagId");
            item.setTagId(tagId);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            String	tagName		 = rs.getString("tag.name");
            item.setTagName(tagName);
            int	progId		 = rs.getInt("progId");
            item.setProgId(progId);
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
        TagMembrInfo item = (TagMembrInfo) obj;

        String ret = 
            "tagId=" + item.getTagId()
            + ",membrId=" + item.getMembrId()
            + ",tagName='" + ServerTool.escapeString(item.getTagName()) + "'"
            + ",progId=" + item.getProgId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "tagId,membrId,tagName,progId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        TagMembrInfo item = (TagMembrInfo) obj;

        String ret = 
            "" + item.getTagId()
            + "," + item.getMembrId()
            + ",'" + ServerTool.escapeString(item.getTagName()) + "'"
            + "," + item.getProgId()

        ;
        return ret;
    }
    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (tag) ON tagmembr.tagId=tag.id ";
        return ret;
    }
}
