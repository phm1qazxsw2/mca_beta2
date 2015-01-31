package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class AreaChangeMgr extends dbo.Manager<AreaChange>
{
    private static AreaChangeMgr _instance = null;

    AreaChangeMgr() {}

    public synchronized static AreaChangeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new AreaChangeMgr();
        }
        return _instance;
    }

    public AreaChangeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "area_change";
    }

    protected Object makeBean()
    {
        return new AreaChange();
    }

    protected String getIdentifier(Object obj)
    {
        AreaChange o = (AreaChange) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        AreaChange item = (AreaChange) obj;
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
            int	orgLevel		 = rs.getInt("orgLevel");
            item.setOrgLevel(orgLevel);
            String	orgCode		 = rs.getString("orgCode");
            item.setOrgCode(orgCode);
            String	orgParent		 = rs.getString("orgParent");
            item.setOrgParent(orgParent);
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
        AreaChange item = (AreaChange) obj;

        String ret = 
            "level=" + item.getLevel()
            + ",code='" + ServerTool.escapeString(item.getCode()) + "'"
            + ",cName='" + ServerTool.escapeString(item.getCName()) + "'"
            + ",eName='" + ServerTool.escapeString(item.getEName()) + "'"
            + ",parentCode='" + ServerTool.escapeString(item.getParentCode()) + "'"
            + ",orgLevel=" + item.getOrgLevel()
            + ",orgCode='" + ServerTool.escapeString(item.getOrgCode()) + "'"
            + ",orgParent='" + ServerTool.escapeString(item.getOrgParent()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "level,code,cName,eName,parentCode,orgLevel,orgCode,orgParent";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        AreaChange item = (AreaChange) obj;

        String ret = 
            "" + item.getLevel()
            + ",'" + ServerTool.escapeString(item.getCode()) + "'"
            + ",'" + ServerTool.escapeString(item.getCName()) + "'"
            + ",'" + ServerTool.escapeString(item.getEName()) + "'"
            + ",'" + ServerTool.escapeString(item.getParentCode()) + "'"
            + "," + item.getOrgLevel()
            + ",'" + ServerTool.escapeString(item.getOrgCode()) + "'"
            + ",'" + ServerTool.escapeString(item.getOrgParent()) + "'"

        ;
        return ret;
    }
}
