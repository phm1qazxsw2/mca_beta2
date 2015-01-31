package cardreader;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class EntryMgr extends dbo.Manager<Entry>
{
    private static EntryMgr _instance = null;

    EntryMgr() {}

    public synchronized static EntryMgr getInstance()
    {
        if (_instance==null) {
            _instance = new EntryMgr();
        }
        return _instance;
    }

    public EntryMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "entry";
    }

    protected Object makeBean()
    {
        return new Entry();
    }

    protected String getIdentifier(Object obj)
    {
        Entry o = (Entry) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Entry item = (Entry) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            int	machineId		 = rs.getInt("machineId");
            item.setMachineId(machineId);
            String	cardId		 = rs.getString("cardId");
            item.setCardId(cardId);
            int	datatype		 = rs.getInt("datatype");
            item.setDatatype(datatype);
            int	datauser		 = rs.getInt("datauser");
            item.setDatauser(datauser);
            int	number		 = rs.getInt("number");
            item.setNumber(number);
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
        Entry item = (Entry) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",machineId=" + item.getMachineId()
            + ",cardId='" + ServerTool.escapeString(item.getCardId()) + "'"
            + ",datatype=" + item.getDatatype()
            + ",datauser=" + item.getDatauser()
            + ",number=" + item.getNumber()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,machineId,cardId,datatype,datauser,number";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Entry item = (Entry) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getMachineId()
            + ",'" + ServerTool.escapeString(item.getCardId()) + "'"
            + "," + item.getDatatype()
            + "," + item.getDatauser()
            + "," + item.getNumber()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Entry o = (Entry) obj;
        o.setId(auto_id);
    }
}
