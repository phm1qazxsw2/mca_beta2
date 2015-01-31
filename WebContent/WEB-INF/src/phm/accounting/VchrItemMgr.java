package phm.accounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VchrItemMgr extends dbo.Manager<VchrItem>
{
    private static VchrItemMgr _instance = null;

    VchrItemMgr() {}

    public synchronized static VchrItemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VchrItemMgr();
        }
        return _instance;
    }

    public VchrItemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vchr_item";
    }

    protected Object makeBean()
    {
        return new VchrItem();
    }

    protected String getIdentifier(Object obj)
    {
        VchrItem o = (VchrItem) obj;
        return "vchrId = " + o.getVchrId() + " and " + "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        VchrItem item = (VchrItem) obj;
        try {
            int	vchrId		 = rs.getInt("vchrId");
            item.setVchrId(vchrId);
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	flag		 = rs.getInt("flag");
            item.setFlag(flag);
            int	threadId		 = rs.getInt("threadId");
            item.setThreadId(threadId);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
            int	acodeId		 = rs.getInt("acodeId");
            item.setAcodeId(acodeId);
            double	debit		 = rs.getDouble("debit");
            item.setDebit(debit);
            double	credit		 = rs.getDouble("credit");
            item.setCredit(credit);
            int	note		 = rs.getInt("note");
            item.setNote(note);
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
        VchrItem item = (VchrItem) obj;

        String ret = 
            "vchrId=" + item.getVchrId()
            + ",id=" + item.getId()
            + ",flag=" + item.getFlag()
            + ",threadId=" + item.getThreadId()
            + ",bunitId=" + item.getBunitId()
            + ",acodeId=" + item.getAcodeId()
            + ",debit=" + item.getDebit()
            + ",credit=" + item.getCredit()
            + ",note=" + item.getNote()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "vchrId,id,flag,threadId,bunitId,acodeId,debit,credit,note";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        VchrItem item = (VchrItem) obj;

        String ret = 
            "" + item.getVchrId()
            + "," + item.getId()
            + "," + item.getFlag()
            + "," + item.getThreadId()
            + "," + item.getBunitId()
            + "," + item.getAcodeId()
            + "," + item.getDebit()
            + "," + item.getCredit()
            + "," + item.getNote()

        ;
        return ret;
    }
}
