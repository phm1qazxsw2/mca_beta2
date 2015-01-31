package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CosttradeMgr extends Manager
{
    private static CosttradeMgr _instance = null;

    CosttradeMgr() {}

    public synchronized static CosttradeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CosttradeMgr();
        }
        return _instance;
    }

    public CosttradeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "costtrade";
    }

    protected Object makeBean()
    {
        return new Costtrade();
    }

    protected int getBeanId(Object obj)
    {
        return ((Costtrade)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Costtrade item = (Costtrade) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	costtradeName		 = rs.getString("costtradeName");
            int	costtradeActive		 = rs.getInt("costtradeActive");
            String	costtradeContacter		 = rs.getString("costtradeContacter");
            String	costtradeUnitnumber		 = rs.getString("costtradeUnitnumber");
            String	costtradePhone1		 = rs.getString("costtradePhone1");
            String	costtradePhone2		 = rs.getString("costtradePhone2");
            String	costtradeMobile		 = rs.getString("costtradeMobile");
            String	costtradeAddress		 = rs.getString("costtradeAddress");
            String	costtradePs		 = rs.getString("costtradePs");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , costtradeName, costtradeActive, costtradeContacter
            , costtradeUnitnumber, costtradePhone1, costtradePhone2
            , costtradeMobile, costtradeAddress, costtradePs
            , bunitId);
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
        Costtrade item = (Costtrade) obj;

        String ret = "modified=NOW()"
            + ",costtradeName='" + ServerTool.escapeString(item.getCosttradeName()) + "'"
            + ",costtradeActive=" + item.getCosttradeActive()
            + ",costtradeContacter='" + ServerTool.escapeString(item.getCosttradeContacter()) + "'"
            + ",costtradeUnitnumber='" + ServerTool.escapeString(item.getCosttradeUnitnumber()) + "'"
            + ",costtradePhone1='" + ServerTool.escapeString(item.getCosttradePhone1()) + "'"
            + ",costtradePhone2='" + ServerTool.escapeString(item.getCosttradePhone2()) + "'"
            + ",costtradeMobile='" + ServerTool.escapeString(item.getCosttradeMobile()) + "'"
            + ",costtradeAddress='" + ServerTool.escapeString(item.getCosttradeAddress()) + "'"
            + ",costtradePs='" + ServerTool.escapeString(item.getCosttradePs()) + "'"
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, costtradeName, costtradeActive, costtradeContacter, costtradeUnitnumber, costtradePhone1, costtradePhone2, costtradeMobile, costtradeAddress, costtradePs, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Costtrade item = (Costtrade) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getCosttradeName()) + "'"
            + "," + item.getCosttradeActive()
            + ",'" + ServerTool.escapeString(item.getCosttradeContacter()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradeUnitnumber()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradePhone1()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradePhone2()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradeMobile()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradeAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradePs()) + "'"
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
