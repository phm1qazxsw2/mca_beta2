package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillItemInfoMgr extends dbo.Manager<BillItemInfo>
{
    private static BillItemInfoMgr _instance = null;

    BillItemInfoMgr() {}

    public synchronized static BillItemInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillItemInfoMgr();
        }
        return _instance;
    }

    public BillItemInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billitem join bill";
    }

    protected Object makeBean()
    {
        return new BillItemInfo();
    }

    protected String JoinSpace()
    {
         return "billId=bill.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillItemInfo item = (BillItemInfo) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	billId		 = rs.getInt("billId");
            item.setBillId(billId);
            String	name		 = rs.getString("name");
            item.setName(name);
            int	aliasId		 = rs.getInt("aliasId");
            item.setAliasId(aliasId);
            int	smallItemId		 = rs.getInt("smallItemId");
            item.setSmallItemId(smallItemId);
            int	pitemId		 = rs.getInt("pitemId");
            item.setPitemId(pitemId);
            int	status		 = rs.getInt("status");
            item.setStatus(status);
            String	description		 = rs.getString("description");
            item.setDescription(description);
            int	defaultAmount		 = rs.getInt("defaultAmount");
            item.setDefaultAmount(defaultAmount);
            int	copyStatus		 = rs.getInt("copyStatus");
            item.setCopyStatus(copyStatus);
            int	mainBillItemId		 = rs.getInt("mainBillItemId");
            item.setMainBillItemId(mainBillItemId);
            int	pos		 = rs.getInt("pos");
            item.setPos(pos);
            String	color		 = rs.getString("color");
            item.setColor(color);
            int	templateVchrId		 = rs.getInt("templateVchrId");
            item.setTemplateVchrId(templateVchrId);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
