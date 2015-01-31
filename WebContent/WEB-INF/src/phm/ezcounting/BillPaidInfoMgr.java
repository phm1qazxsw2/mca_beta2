package phm.ezcounting;

// 2008-12-3 by peter, add billpaid.amount>0 ?]?????F??? ???i??? billpaid ?Q?R?F?????u?O?N amount ?? 0

import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillPaidInfoMgr extends dbo.Manager<BillPaidInfo>
{
    private static BillPaidInfoMgr _instance = null;

    BillPaidInfoMgr() {}

    public synchronized static BillPaidInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillPaidInfoMgr();
        }
        return _instance;
    }

    public BillPaidInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billpaid join billpay";
    }

    protected Object makeBean()
    {
        return new BillPaidInfo();
    }

    protected String JoinSpace()
    {
         return "billPayId=billpay.id and billpaid.amount>0";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillPaidInfo item = (BillPaidInfo) obj;
        try {
            int	billPayId		 = rs.getInt("billPayId");
            item.setBillPayId(billPayId);
            String	ticketId		 = rs.getString("ticketId");
            item.setTicketId(ticketId);
            int	paidAmount		 = rs.getInt("billpaid.amount");
            item.setPaidAmount(paidAmount);
            int	via		 = rs.getInt("via");
            item.setVia(via);
            java.util.Date	paidTime		 = rs.getTimestamp("billpay.recordTime");
            item.setPaidTime(paidTime);
            java.util.Date	createTime		 = rs.getTimestamp("createTime");
            item.setCreateTime(createTime);
            int	payAmount		 = rs.getInt("billpay.amount");
            item.setPayAmount(payAmount);
            int	remain		 = rs.getInt("remain");
            item.setRemain(remain);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	billSourceId		 = rs.getInt("billSourceId");
            item.setBillSourceId(billSourceId);
            String	userLoginId		 = rs.getString("userLoginId");
            item.setUserLoginId(userLoginId);
            int	pending		 = rs.getInt("pending");
            item.setPending(pending);
            String	membrName		 = rs.getString("membr.name");
            item.setMembrName(membrName);
            int	membrId		 = rs.getInt("membr.id");
            item.setMembrId(membrId);
            int	billRecordId		 = rs.getInt("billRecordId");
            item.setBillRecordId(billRecordId);
            int	chequeId		 = rs.getInt("chequeId");
            item.setChequeId(chequeId);
            String	billPrettyName		 = rs.getString("bill.prettyName");
            item.setBillPrettyName(billPrettyName);
            java.util.Date	billMonth		 = rs.getTimestamp("billrecord.month");
            item.setBillMonth(billMonth);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (user) ON userId=user.id ";
        ret += "LEFT JOIN (membrbillrecord,membr) ON billpaid.ticketId=membrbillrecord.ticketId and membrbillrecord.membrId=membr.id ";
        ret += "LEFT JOIN (bill,billrecord) ON membrbillrecord.billRecordId=billrecord.id and billrecord.billId = bill.id ";
        return ret;
    }
}
