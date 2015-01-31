package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TagTypeMgr extends dbo.Manager<TagType>
{
    private static TagTypeMgr _instance = null;

    TagTypeMgr() {}

    public synchronized static TagTypeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TagTypeMgr();
        }
        return _instance;
    }

    public TagTypeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "tagtype";
    }

    protected Object makeBean()
    {
        return new TagType();
    }

    protected String getIdentifier(Object obj)
    {
        TagType o = (TagType) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TagType item = (TagType) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            String	name		 = rs.getString("name");
            item.setName(name);
            int	num		 = rs.getInt("num");
            item.setNum(num);
            int	main		 = rs.getInt("main");
            item.setMain(main);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
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
        TagType item = (TagType) obj;

        String ret = 
            "name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",num=" + item.getNum()
            + ",main=" + item.getMain()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "name,num,main,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        TagType item = (TagType) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + item.getNum()
            + "," + item.getMain()
            + "," + item.getBunitId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        TagType o = (TagType) obj;
        o.setId(auto_id);
    }
}
