package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class FeeDetailInfoMgr extends dbo.Manager<FeeDetailInfo>
{
    private static FeeDetailInfoMgr _instance = null;

    FeeDetailInfoMgr() {}

    public synchronized static FeeDetailInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new FeeDetailInfoMgr();
        }
        return _instance;
    }

    public FeeDetailInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "feedetail join chargeitem join membrbillrecord";
    }

    protected Object makeBean()
    {
        return new FeeDetailInfo();
    }

    protected String JoinSpace()
    {
         return "feedetail.chargeItemId=chargeitem.id and feedetail.membrId=membrbillrecord.membrId and chargeitem.billRecordId=membrbillrecord.billRecordId";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        FeeDetailInfo item = (FeeDetailInfo) obj;
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
            int	billRecordId		 = rs.getInt("membrbillrecord.billRecordId");
            item.setBillRecordId(billRecordId);
            int	billItemId		 = rs.getInt("billItemId");
            item.setBillItemId(billItemId);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
