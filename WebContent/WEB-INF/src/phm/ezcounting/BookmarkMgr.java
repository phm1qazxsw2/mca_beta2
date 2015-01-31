package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BookmarkMgr extends dbo.Manager<Bookmark>
{
    private static BookmarkMgr _instance = null;

    BookmarkMgr() {}

    public synchronized static BookmarkMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BookmarkMgr();
        }
        return _instance;
    }

    public BookmarkMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "bookmark";
    }

    protected Object makeBean()
    {
        return new Bookmark();
    }

    protected String getIdentifier(Object obj)
    {
        Bookmark o = (Bookmark) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Bookmark item = (Bookmark) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            String	name		 = rs.getString("name");
            item.setName(name);
            String	url		 = rs.getString("url");
            item.setUrl(url);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
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
        Bookmark item = (Bookmark) obj;

        String ret = 
            "userId=" + item.getUserId()
            + ",name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",url='" + ServerTool.escapeString(item.getUrl()) + "'"
            + ",created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "userId,name,url,created";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Bookmark item = (Bookmark) obj;

        String ret = 
            "" + item.getUserId()
            + ",'" + ServerTool.escapeString(item.getName()) + "'"
            + ",'" + ServerTool.escapeString(item.getUrl()) + "'"
            + "," + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Bookmark o = (Bookmark) obj;
        o.setId(auto_id);
    }
}
