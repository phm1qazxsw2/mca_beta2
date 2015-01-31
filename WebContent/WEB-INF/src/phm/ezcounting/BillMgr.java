package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillMgr extends dbo.Manager<Bill>
{
    private static BillMgr _instance = null;

    BillMgr() {}

    public synchronized static BillMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillMgr();
        }
        return _instance;
    }

    public BillMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "bill";
    }

    protected Object makeBean()
    {
        return new Bill();
    }

    protected String getIdentifier(Object obj)
    {
        Bill o = (Bill) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Bill item = (Bill) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            String	name		 = rs.getString("name");
            item.setName(name);
            String	prettyName		 = rs.getString("prettyName");
            item.setPrettyName(prettyName);
            int	status		 = rs.getInt("status");
            item.setStatus(status);
            int	balanceWay		 = rs.getInt("balanceWay");
            item.setBalanceWay(balanceWay);
            int	billType		 = rs.getInt("billType");
            item.setBillType(billType);
            int	privLevel		 = rs.getInt("privLevel");
            item.setPrivLevel(privLevel);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
            String	comName		 = rs.getString("comName");
            item.setComName(comName);
            String	comAddr		 = rs.getString("comAddr");
            item.setComAddr(comAddr);
            String	payNote		 = rs.getString("payNote");
            item.setPayNote(payNote);
            String	regInfo		 = rs.getString("regInfo");
            item.setRegInfo(regInfo);
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
        Bill item = (Bill) obj;

        String ret = 
            "name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",prettyName='" + ServerTool.escapeString(item.getPrettyName()) + "'"
            + ",status=" + item.getStatus()
            + ",balanceWay=" + item.getBalanceWay()
            + ",billType=" + item.getBillType()
            + ",privLevel=" + item.getPrivLevel()
            + ",bunitId=" + item.getBunitId()
            + ",comName='" + ServerTool.escapeString(item.getComName()) + "'"
            + ",comAddr='" + ServerTool.escapeString(item.getComAddr()) + "'"
            + ",payNote='" + ServerTool.escapeString(item.getPayNote()) + "'"
            + ",regInfo='" + ServerTool.escapeString(item.getRegInfo()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "name,prettyName,status,balanceWay,billType,privLevel,bunitId,comName,comAddr,payNote,regInfo";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Bill item = (Bill) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getName()) + "'"
            + ",'" + ServerTool.escapeString(item.getPrettyName()) + "'"
            + "," + item.getStatus()
            + "," + item.getBalanceWay()
            + "," + item.getBillType()
            + "," + item.getPrivLevel()
            + "," + item.getBunitId()
            + ",'" + ServerTool.escapeString(item.getComName()) + "'"
            + ",'" + ServerTool.escapeString(item.getComAddr()) + "'"
            + ",'" + ServerTool.escapeString(item.getPayNote()) + "'"
            + ",'" + ServerTool.escapeString(item.getRegInfo()) + "'"

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Bill o = (Bill) obj;
        o.setId(auto_id);
    }
}
