package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SchswRecordMgr extends dbo.Manager<SchswRecord>
{
    private static SchswRecordMgr _instance = null;

    SchswRecordMgr() {}

    public synchronized static SchswRecordMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SchswRecordMgr();
        }
        return _instance;
    }

    public SchswRecordMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "schswrecord";
    }

    protected Object makeBean()
    {
        return new SchswRecord();
    }

    protected String getIdentifier(Object obj)
    {
        SchswRecord o = (SchswRecord) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SchswRecord item = (SchswRecord) obj;
        try {
            int	id		 = rs.getInt("id");
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
        SchswRecord item = (SchswRecord) obj;

        String ret = 
            "schswId=" + item.getSchswId()
            + ",occurDate=" + (((d=item.getOccurDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",membrId=" + item.getMembrId()
            + ",schdefId=" + item.getSchdefId()
            + ",type=" + item.getType()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "schswId,occurDate,membrId,schdefId,type";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SchswRecord item = (SchswRecord) obj;

        String ret = 
            "" + item.getSchswId()
            + "," + (((d=item.getOccurDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getMembrId()
            + "," + item.getSchdefId()
            + "," + item.getType()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        SchswRecord o = (SchswRecord) obj;
        o.setId(auto_id);
    }
}
