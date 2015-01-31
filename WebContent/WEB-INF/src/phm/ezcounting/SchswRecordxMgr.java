package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SchswRecordxMgr extends dbo.Manager<SchswRecordx>
{
    private static SchswRecordxMgr _instance = null;

    SchswRecordxMgr() {}

    public synchronized static SchswRecordxMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SchswRecordxMgr();
        }
        return _instance;
    }

    public SchswRecordxMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "schswrecord join schdef";
    }

    protected Object makeBean()
    {
        return new SchswRecordx();
    }

    protected String JoinSpace()
    {
         return "schdefId=schdef.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SchswRecordx item = (SchswRecordx) obj;
        try {
            int	id		 = rs.getInt("schswrecord.id");
            item.setId(id);
            int	schswId		 = rs.getInt("schswId");
            item.setSchswId(schswId);
            java.util.Date	occurDate		 = rs.getTimestamp("occurDate");
            item.setOccurDate(occurDate);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	schdefId		 = rs.getInt("schdefId");
            item.setSchdefId(schdefId);
            int	type		 = rs.getInt("type");
            item.setType(type);
            java.util.Date	startDate		 = rs.getTimestamp("startDate");
            item.setStartDate(startDate);
            java.util.Date	endDate		 = rs.getTimestamp("endDate");
            item.setEndDate(endDate);
            int	reqMembrId		 = rs.getInt("reqMembrId");
            item.setReqMembrId(reqMembrId);
            String	schdefName		 = rs.getString("schdef.name");
            item.setSchdefName(schdefName);
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
        ret += "LEFT JOIN (membr) ON membrId=membr.id ";
        ret += "LEFT JOIN (schsw) ON schswId=schsw.id ";
        return ret;
    }
}
