package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TagMembrMgr extends dbo.Manager<TagMembr>
{
    private static TagMembrMgr _instance = null;

    TagMembrMgr() {}

    public synchronized static TagMembrMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TagMembrMgr();
        }
        return _instance;
    }

    public TagMembrMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "tagmembr";
    }

    protected Object makeBean()
    {
        return new TagMembr();
    }

    protected String getIdentifier(Object obj)
    {
        TagMembr o = (TagMembr) obj;
        return "tagId = " + o.getTagId() + " and " + "membrId = " + o.getMembrId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TagMembr item = (TagMembr) obj;
        try {
            int	tagId		 = rs.getInt("tagId");
            item.setTagId(tagId);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            java.util.Date	bindTime		 = rs.getTimestamp("bindTime");
            item.setBindTime(bindTime);
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
        TagMembr item = (TagMembr) obj;

        String ret = 
            "tagId=" + item.getTagId()
            + ",membrId=" + item.getMembrId()
            + ",bindTime=" + (((d=item.getBindTime())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "tagId,membrId,bindTime";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        TagMembr item = (TagMembr) obj;

        String ret = 
            "" + item.getTagId()
            + "," + item.getMembrId()
            + "," + (((d=item.getBindTime())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }
}
