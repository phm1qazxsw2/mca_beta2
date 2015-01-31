package phm.accounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class AcodeMgr extends dbo.Manager<Acode>
{
    private static AcodeMgr _instance = null;

    AcodeMgr() {}

    public synchronized static AcodeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new AcodeMgr();
        }
        return _instance;
    }

    public AcodeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "acode";
    }

    protected Object makeBean()
    {
        return new Acode();
    }

    protected String getIdentifier(Object obj)
    {
        Acode o = (Acode) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Acode item = (Acode) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            String	main		 = rs.getString("main");
            item.setMain(main);
            String	sub		 = rs.getString("sub");
            item.setSub(sub);
            int	name1		 = rs.getInt("name1");
            item.setName1(name1);
            int	name2		 = rs.getInt("name2");
            item.setName2(name2);
            int	catId		 = rs.getInt("catId");
            item.setCatId(catId);
            int	rootId		 = rs.getInt("rootId");
            item.setRootId(rootId);
            int	active		 = rs.getInt("active");
            item.setActive(active);
            int	type		 = rs.getInt("type");
            item.setType(type);
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
        Acode item = (Acode) obj;

        String ret = 
            "main='" + ServerTool.escapeString(item.getMain()) + "'"
            + ",sub='" + ServerTool.escapeString(item.getSub()) + "'"
            + ",name1=" + item.getName1()
            + ",name2=" + item.getName2()
            + ",catId=" + item.getCatId()
            + ",rootId=" + item.getRootId()
            + ",active=" + item.getActive()
            + ",type=" + item.getType()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "main,sub,name1,name2,catId,rootId,active,type,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Acode item = (Acode) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getMain()) + "'"
            + ",'" + ServerTool.escapeString(item.getSub()) + "'"
            + "," + item.getName1()
            + "," + item.getName2()
            + "," + item.getCatId()
            + "," + item.getRootId()
            + "," + item.getActive()
            + "," + item.getType()
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
        Acode o = (Acode) obj;
        o.setId(auto_id);
    }
}
