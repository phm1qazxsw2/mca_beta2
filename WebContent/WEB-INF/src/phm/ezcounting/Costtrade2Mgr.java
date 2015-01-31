package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class Costtrade2Mgr extends dbo.Manager<Costtrade2>
{
    private static Costtrade2Mgr _instance = null;

    Costtrade2Mgr() {}

    public synchronized static Costtrade2Mgr getInstance()
    {
        if (_instance==null) {
            _instance = new Costtrade2Mgr();
        }
        return _instance;
    }

    public Costtrade2Mgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "costtrade";
    }

    protected Object makeBean()
    {
        return new Costtrade2();
    }

    protected String getIdentifier(Object obj)
    {
        Costtrade2 o = (Costtrade2) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Costtrade2 item = (Costtrade2) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            java.util.Date	modified		 = rs.getTimestamp("modified");
            item.setModified(modified);
            String	costtradeName		 = rs.getString("costtradeName");
            item.setCosttradeName(costtradeName);
            int	costtradeActive		 = rs.getInt("costtradeActive");
            item.setCosttradeActive(costtradeActive);
            String	costtradeContacter		 = rs.getString("costtradeContacter");
            item.setCosttradeContacter(costtradeContacter);
            String	costtradeUnitnumber		 = rs.getString("costtradeUnitnumber");
            item.setCosttradeUnitnumber(costtradeUnitnumber);
            String	costtradePhone1		 = rs.getString("costtradePhone1");
            item.setCosttradePhone1(costtradePhone1);
            String	costtradePhone2		 = rs.getString("costtradePhone2");
            item.setCosttradePhone2(costtradePhone2);
            String	costtradeMobile		 = rs.getString("costtradeMobile");
            item.setCosttradeMobile(costtradeMobile);
            String	costtradeAddress		 = rs.getString("costtradeAddress");
            item.setCosttradeAddress(costtradeAddress);
            String	costtradePs		 = rs.getString("costtradePs");
            item.setCosttradePs(costtradePs);
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
        Costtrade2 item = (Costtrade2) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",modified=" + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",costtradeName='" + ServerTool.escapeString(item.getCosttradeName()) + "'"
            + ",costtradeActive=" + item.getCosttradeActive()
            + ",costtradeContacter='" + ServerTool.escapeString(item.getCosttradeContacter()) + "'"
            + ",costtradeUnitnumber='" + ServerTool.escapeString(item.getCosttradeUnitnumber()) + "'"
            + ",costtradePhone1='" + ServerTool.escapeString(item.getCosttradePhone1()) + "'"
            + ",costtradePhone2='" + ServerTool.escapeString(item.getCosttradePhone2()) + "'"
            + ",costtradeMobile='" + ServerTool.escapeString(item.getCosttradeMobile()) + "'"
            + ",costtradeAddress='" + ServerTool.escapeString(item.getCosttradeAddress()) + "'"
            + ",costtradePs='" + ServerTool.escapeString(item.getCosttradePs()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,modified,costtradeName,costtradeActive,costtradeContacter,costtradeUnitnumber,costtradePhone1,costtradePhone2,costtradeMobile,costtradeAddress,costtradePs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Costtrade2 item = (Costtrade2) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getCosttradeName()) + "'"
            + "," + item.getCosttradeActive()
            + ",'" + ServerTool.escapeString(item.getCosttradeContacter()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradeUnitnumber()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradePhone1()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradePhone2()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradeMobile()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradeAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getCosttradePs()) + "'"

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Costtrade2 o = (Costtrade2) obj;
        o.setId(auto_id);
    }
}
