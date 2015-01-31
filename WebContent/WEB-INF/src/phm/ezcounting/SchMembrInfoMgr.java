package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SchMembrInfoMgr extends dbo.Manager<SchMembrInfo>
{
    private static SchMembrInfoMgr _instance = null;

    SchMembrInfoMgr() {}

    public synchronized static SchMembrInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SchMembrInfoMgr();
        }
        return _instance;
    }

    public SchMembrInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "schmembr join schdef";
    }

    protected Object makeBean()
    {
        return new SchMembrInfo();
    }

    protected String JoinSpace()
    {
         return "schdefId=schdef.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SchMembrInfo item = (SchMembrInfo) obj;
        try {
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	schdefId		 = rs.getInt("schdefId");
            item.setSchdefId(schdefId);
            String	note		 = rs.getString("note");
            item.setNote(note);
            String	name		 = rs.getString("name");
            item.setName(name);
            java.util.Date	startDate		 = rs.getTimestamp("startDate");
            item.setStartDate(startDate);
            java.util.Date	endDate		 = rs.getTimestamp("endDate");
            item.setEndDate(endDate);
            int	type		 = rs.getInt("type");
            item.setType(type);
            String	content		 = rs.getString("content");
            item.setContent(content);
            String	color		 = rs.getString("color");
            item.setColor(color);
            int	rootId		 = rs.getInt("rootId");
            item.setRootId(rootId);
            int	newestId		 = rs.getInt("newestId");
            item.setNewestId(newestId);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
