package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ChargeMembrMgr extends dbo.Manager<ChargeMembr>
{
    private static ChargeMembrMgr _instance = null;

    ChargeMembrMgr() {}

    public synchronized static ChargeMembrMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ChargeMembrMgr();
        }
        return _instance;
    }

    public ChargeMembrMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "charge join membr";
    }

    protected Object makeBean()
    {
        return new ChargeMembr();
    }

    protected String JoinSpace()
    {
         return "charge.membrId=membr.id";
    }

    protected String getFieldList()
    {
         return "membrId,chargeItemId,membr.name";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        ChargeMembr item = (ChargeMembr) obj;
        try {
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	chargeItemId		 = rs.getInt("chargeItemId");
            item.setChargeItemId(chargeItemId);
            String	membrName		 = rs.getString("membr.name");
            item.setMembrName(membrName);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
