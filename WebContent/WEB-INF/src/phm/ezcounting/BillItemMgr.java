package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillItemMgr extends dbo.Manager<BillItem>
{
    private static BillItemMgr _instance = null;

    BillItemMgr() {}

    public synchronized static BillItemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillItemMgr();
        }
        return _instance;
    }

    public BillItemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billitem";
    }

    protected Object makeBean()
    {
        return new BillItem();
    }

    protected String getIdentifier(Object obj)
    {
        BillItem o = (BillItem) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillItem item = (BillItem) obj;
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

    protected String getSaveString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BillItem item = (BillItem) obj;

        String ret = 
            "billId=" + item.getBillId()
            + ",name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",aliasId=" + item.getAliasId()
            + ",smallItemId=" + item.getSmallItemId()
            + ",pitemId=" + item.getPitemId()
            + ",status=" + item.getStatus()
            + ",description='" + ServerTool.escapeString(item.getDescription()) + "'"
            + ",defaultAmount=" + item.getDefaultAmount()
            + ",copyStatus=" + item.getCopyStatus()
            + ",mainBillItemId=" + item.getMainBillItemId()
            + ",pos=" + item.getPos()
            + ",color='" + ServerTool.escapeString(item.getColor()) + "'"
            + ",templateVchrId=" + item.getTemplateVchrId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "billId,name,aliasId,smallItemId,pitemId,status,description,defaultAmount,copyStatus,mainBillItemId,pos,color,templateVchrId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BillItem item = (BillItem) obj;

        String ret = 
            "" + item.getBillId()
            + ",'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + item.getAliasId()
            + "," + item.getSmallItemId()
            + "," + item.getPitemId()
            + "," + item.getStatus()
            + ",'" + ServerTool.escapeString(item.getDescription()) + "'"
            + "," + item.getDefaultAmount()
            + "," + item.getCopyStatus()
            + "," + item.getMainBillItemId()
            + "," + item.getPos()
            + ",'" + ServerTool.escapeString(item.getColor()) + "'"
            + "," + item.getTemplateVchrId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        BillItem o = (BillItem) obj;
        o.setId(auto_id);
    }
}
