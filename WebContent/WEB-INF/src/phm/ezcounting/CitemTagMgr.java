package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CitemTagMgr extends dbo.Manager<CitemTag>
{
    private static CitemTagMgr _instance = null;

    CitemTagMgr() {}

    public synchronized static CitemTagMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CitemTagMgr();
        }
        return _instance;
    }

    public CitemTagMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "citemtag";
    }

    protected Object makeBean()
    {
        return new CitemTag();
    }

    protected String getIdentifier(Object obj)
    {
        CitemTag o = (CitemTag) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        CitemTag item = (CitemTag) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	tagId		 = rs.getInt("tagId");
            item.setTagId(tagId);
            int	chargeItemId		 = rs.getInt("chargeItemId");
            item.setChargeItemId(chargeItemId);
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
        CitemTag item = (CitemTag) obj;

        String ret = 
            "tagId=" + item.getTagId()
            + ",chargeItemId=" + item.getChargeItemId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "tagId,chargeItemId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        CitemTag item = (CitemTag) obj;

        String ret = 
            "" + item.getTagId()
            + "," + item.getChargeItemId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        CitemTag o = (CitemTag) obj;
        o.setId(auto_id);
    }
}
