package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class AreaMgr extends dbo.Manager<Area>
{
    private static AreaMgr _instance = null;

    AreaMgr() {}

    public synchronized static AreaMgr getInstance()
    {
        if (_instance==null) {
            _instance = new AreaMgr();
        }
        return _instance;
    }

    public AreaMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "area";
    }

    protected Object makeBean()
    {
        return new Area();
    }

    protected String getIdentifier(Object obj)
    {
        Area o = (Area) obj;
        return "level = " + o.getLevel() + " and " + "code = '" + o.getCode()+"'";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Area item = (Area) obj;
        try {
            int	level		 = rs.getInt("level");
            item.setLevel(level);
            String	code		 = rs.getString("code");
            item.setCode(code);
            String	cName		 = rs.getString("cName");
            item.setCName(cName);
            String	eName		 = rs.getString("eName");
            item.setEName(eName);
            String	parentCode		 = rs.getString("parentCode");
            item.setParentCode(parentCode);
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
        Area item = (Area) obj;

        String ret = 
            "level=" + item.getLevel()
            + ",code='" + ServerTool.escapeString(item.getCode()) + "'"
            + ",cName='" + ServerTool.escapeString(item.getCName()) + "'"
            + ",eName='" + ServerTool.escapeString(item.getEName()) + "'"
            + ",parentCode='" + ServerTool.escapeString(item.getParentCode()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "level,code,cName,eName,parentCode";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Area item = (Area) obj;

        String ret = 
            "" + item.getLevel()
            + ",'" + ServerTool.escapeString(item.getCode()) + "'"
            + ",'" + ServerTool.escapeString(item.getCName()) + "'"
            + ",'" + ServerTool.escapeString(item.getEName()) + "'"
            + ",'" + ServerTool.escapeString(item.getParentCode()) + "'"

        ;
        return ret;
    }
}
