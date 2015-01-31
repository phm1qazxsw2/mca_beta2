package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BinfoMgr extends dbo.Manager<Binfo>
{
    private static BinfoMgr _instance = null;

    BinfoMgr() {}

    public synchronized static BinfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BinfoMgr();
        }
        return _instance;
    }

    public BinfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "bunit_info";
    }

    protected Object makeBean()
    {
        return new Binfo();
    }

    protected String getIdentifier(Object obj)
    {
        Binfo o = (Binfo) obj;
        return "bunitId = " + o.getBunitId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Binfo item = (Binfo) obj;
        try {
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
            int	bankId		 = rs.getInt("bankId");
            item.setBankId(bankId);
            String	virtualID		 = rs.getString("virtualID");
            item.setVirtualID(virtualID);
            String	storeID		 = rs.getString("storeID");
            item.setStoreID(storeID);
            String	serviceID		 = rs.getString("serviceID");
            item.setServiceID(serviceID);
            int	studentBunitId		 = rs.getInt("studentBunitId");
            item.setStudentBunitId(studentBunitId);
            int	acodeBunitId		 = rs.getInt("acodeBunitId");
            item.setAcodeBunitId(acodeBunitId);
            int	metaBunitId		 = rs.getInt("metaBunitId");
            item.setMetaBunitId(metaBunitId);
            int	unpaidBunitId		 = rs.getInt("unpaidBunitId");
            item.setUnpaidBunitId(unpaidBunitId);
            String	fullname		 = rs.getString("fullname");
            item.setFullname(fullname);
            String	address		 = rs.getString("address");
            item.setAddress(address);
            String	phone		 = rs.getString("phone");
            item.setPhone(phone);
            String	web		 = rs.getString("web");
            item.setWeb(web);
            String	billNote		 = rs.getString("billNote");
            item.setBillNote(billNote);
            String	smsText		 = rs.getString("smsText");
            item.setSmsText(smsText);
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
        Binfo item = (Binfo) obj;

        String ret = 
            "bunitId=" + item.getBunitId()
            + ",bankId=" + item.getBankId()
            + ",virtualID='" + ServerTool.escapeString(item.getVirtualID()) + "'"
            + ",storeID='" + ServerTool.escapeString(item.getStoreID()) + "'"
            + ",serviceID='" + ServerTool.escapeString(item.getServiceID()) + "'"
            + ",studentBunitId=" + item.getStudentBunitId()
            + ",acodeBunitId=" + item.getAcodeBunitId()
            + ",metaBunitId=" + item.getMetaBunitId()
            + ",unpaidBunitId=" + item.getUnpaidBunitId()
            + ",fullname='" + ServerTool.escapeString(item.getFullname()) + "'"
            + ",address='" + ServerTool.escapeString(item.getAddress()) + "'"
            + ",phone='" + ServerTool.escapeString(item.getPhone()) + "'"
            + ",web='" + ServerTool.escapeString(item.getWeb()) + "'"
            + ",billNote='" + ServerTool.escapeString(item.getBillNote()) + "'"
            + ",smsText='" + ServerTool.escapeString(item.getSmsText()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "bunitId,bankId,virtualID,storeID,serviceID,studentBunitId,acodeBunitId,metaBunitId,unpaidBunitId,fullname,address,phone,web,billNote,smsText";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Binfo item = (Binfo) obj;

        String ret = 
            "" + item.getBunitId()
            + "," + item.getBankId()
            + ",'" + ServerTool.escapeString(item.getVirtualID()) + "'"
            + ",'" + ServerTool.escapeString(item.getStoreID()) + "'"
            + ",'" + ServerTool.escapeString(item.getServiceID()) + "'"
            + "," + item.getStudentBunitId()
            + "," + item.getAcodeBunitId()
            + "," + item.getMetaBunitId()
            + "," + item.getUnpaidBunitId()
            + ",'" + ServerTool.escapeString(item.getFullname()) + "'"
            + ",'" + ServerTool.escapeString(item.getAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getPhone()) + "'"
            + ",'" + ServerTool.escapeString(item.getWeb()) + "'"
            + ",'" + ServerTool.escapeString(item.getBillNote()) + "'"
            + ",'" + ServerTool.escapeString(item.getSmsText()) + "'"

        ;
        return ret;
    }
}
