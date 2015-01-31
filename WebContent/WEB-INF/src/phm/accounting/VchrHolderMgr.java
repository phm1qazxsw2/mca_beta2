package phm.accounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VchrHolderMgr extends dbo.Manager<VchrHolder>
{
    private static VchrHolderMgr _instance = null;

    VchrHolderMgr() {}

    public synchronized static VchrHolderMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VchrHolderMgr();
        }
        return _instance;
    }

    public VchrHolderMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vchr_holder";
    }

    protected Object makeBean()
    {
        return new VchrHolder();
    }

    protected String getIdentifier(Object obj)
    {
        VchrHolder o = (VchrHolder) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        VchrHolder item = (VchrHolder) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            java.util.Date	registerDate		 = rs.getTimestamp("registerDate");
            item.setRegisterDate(registerDate);
            String	serial		 = rs.getString("serial");
            item.setSerial(serial);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	type		 = rs.getInt("type");
            item.setType(type);
            int	threadId		 = rs.getInt("threadId");
            item.setThreadId(threadId);
            int	note		 = rs.getInt("note");
            item.setNote(note);
            int	buId		 = rs.getInt("buId");
            item.setBuId(buId);
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
        VchrHolder item = (VchrHolder) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",registerDate=" + (((d=item.getRegisterDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",serial='" + ServerTool.escapeString(item.getSerial()) + "'"
            + ",userId=" + item.getUserId()
            + ",type=" + item.getType()
            + ",threadId=" + item.getThreadId()
            + ",note=" + item.getNote()
            + ",buId=" + item.getBuId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,registerDate,serial,userId,type,threadId,note,buId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        VchrHolder item = (VchrHolder) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getRegisterDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getSerial()) + "'"
            + "," + item.getUserId()
            + "," + item.getType()
            + "," + item.getThreadId()
            + "," + item.getNote()
            + "," + item.getBuId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        VchrHolder o = (VchrHolder) obj;
        o.setId(auto_id);
    }
}
