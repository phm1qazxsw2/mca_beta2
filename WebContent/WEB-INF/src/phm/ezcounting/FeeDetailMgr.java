package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class FeeDetailMgr extends dbo.Manager<FeeDetail>
{
    private static FeeDetailMgr _instance = null;

    FeeDetailMgr() {}

    public synchronized static FeeDetailMgr getInstance()
    {
        if (_instance==null) {
            _instance = new FeeDetailMgr();
        }
        return _instance;
    }

    public FeeDetailMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "feedetail";
    }

    protected Object makeBean()
    {
        return new FeeDetail();
    }

    protected String getIdentifier(Object obj)
    {
        FeeDetail o = (FeeDetail) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        FeeDetail item = (FeeDetail) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	chargeItemId		 = rs.getInt("chargeItemId");
            item.setChargeItemId(chargeItemId);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	unitPrice		 = rs.getInt("unitPrice");
            item.setUnitPrice(unitPrice);
            int	num		 = rs.getInt("num");
            item.setNum(num);
            java.util.Date	feeTime		 = rs.getTimestamp("feeTime");
            item.setFeeTime(feeTime);
            String	note		 = rs.getString("note");
            item.setNote(note);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	manhourId		 = rs.getInt("manhourId");
            item.setManhourId(manhourId);
            int	payrollMembrId		 = rs.getInt("payrollMembrId");
            item.setPayrollMembrId(payrollMembrId);
            int	payrollFdId		 = rs.getInt("payrollFdId");
            item.setPayrollFdId(payrollFdId);
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
        FeeDetail item = (FeeDetail) obj;

        String ret = 
            "chargeItemId=" + item.getChargeItemId()
            + ",membrId=" + item.getMembrId()
            + ",unitPrice=" + item.getUnitPrice()
            + ",num=" + item.getNum()
            + ",feeTime=" + (((d=item.getFeeTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"
            + ",userId=" + item.getUserId()
            + ",manhourId=" + item.getManhourId()
            + ",payrollMembrId=" + item.getPayrollMembrId()
            + ",payrollFdId=" + item.getPayrollFdId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "chargeItemId,membrId,unitPrice,num,feeTime,note,userId,manhourId,payrollMembrId,payrollFdId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        FeeDetail item = (FeeDetail) obj;

        String ret = 
            "" + item.getChargeItemId()
            + "," + item.getMembrId()
            + "," + item.getUnitPrice()
            + "," + item.getNum()
            + "," + (((d=item.getFeeTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"
            + "," + item.getUserId()
            + "," + item.getManhourId()
            + "," + item.getPayrollMembrId()
            + "," + item.getPayrollFdId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        FeeDetail o = (FeeDetail) obj;
        o.setId(auto_id);
    }
}
