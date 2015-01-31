package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MembrInfoBillRecordMgr extends dbo.Manager<MembrInfoBillRecord>
{
    private static MembrInfoBillRecordMgr _instance = null;

    MembrInfoBillRecordMgr() {}

    public synchronized static MembrInfoBillRecordMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MembrInfoBillRecordMgr();
        }
        return _instance;
    }

    public MembrInfoBillRecordMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membrbillrecord join membr join billrecord join bill";
    }

    protected Object makeBean()
    {
        return new MembrInfoBillRecord();
    }

    protected String JoinSpace()
    {
         return "membrbillrecord.membrId=membr.id and membrbillrecord.billRecordId=billrecord.id and billrecord.billId=bill.id";
    }

    protected String getFieldList()
    {
         return "membrId,billRecordId,ticketId,receivable,received,paidStatus,printDate,membrbillrecord.billDate,membr.name,membr.birth,billrecord.billDate,billrecord.month,balanceWay,prettyName,billrecord.name,billId,membr.surrogateId,pending_cheque,billType,bill.name,inheritUnpaid,threadId,bill.payNote,bill.comName,bill.comAddr,bill.regInfo,bill.bunitId,forcemodify";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MembrInfoBillRecord item = (MembrInfoBillRecord) obj;
        try {
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	billRecordId		 = rs.getInt("billRecordId");
            item.setBillRecordId(billRecordId);
            String	ticketId		 = rs.getString("ticketId");
            item.setTicketId(ticketId);
            int	receivable		 = rs.getInt("receivable");
            item.setReceivable(receivable);
            int	received		 = rs.getInt("received");
            item.setReceived(received);
            int	paidStatus		 = rs.getInt("paidStatus");
            item.setPaidStatus(paidStatus);
            java.util.Date	billDate		 = rs.getTimestamp("membrbillrecord.billDate");
            item.setBillDate(billDate);
            long	printDate		 = 0;try { printDate = Long.parseLong(new String(rs.getBytes("printDate"))); } catch (Exception ee) {}
            item.setPrintDate(printDate);
            int	pending_cheque		 = rs.getInt("pending_cheque");
            item.setPending_cheque(pending_cheque);
            int	inheritUnpaid		 = rs.getInt("inheritUnpaid");
            item.setInheritUnpaid(inheritUnpaid);
            int	threadId		 = rs.getInt("threadId");
            item.setThreadId(threadId);
            java.util.Date	parentBillDate		 = rs.getTimestamp("billrecord.billDate");
            item.setParentBillDate(parentBillDate);
            String	membrName		 = rs.getString("membr.name");
            item.setMembrName(membrName);
            java.util.Date	billMonth		 = rs.getTimestamp("billrecord.month");
            item.setBillMonth(billMonth);
            java.util.Date	membrBirth		 = rs.getTimestamp("membr.birth");
            item.setMembrBirth(membrBirth);
            int	balanceWay		 = rs.getInt("balanceWay");
            item.setBalanceWay(balanceWay);
            String	billRecordName		 = rs.getString("billrecord.name");
            item.setBillRecordName(billRecordName);
            String	billPrettyName		 = rs.getString("bill.prettyName");
            item.setBillPrettyName(billPrettyName);
            int	billId		 = rs.getInt("billId");
            item.setBillId(billId);
            int	membrSurrogateId		 = rs.getInt("membr.surrogateId");
            item.setMembrSurrogateId(membrSurrogateId);
            int	billType		 = rs.getInt("billType");
            item.setBillType(billType);
            String	billName		 = rs.getString("bill.name");
            item.setBillName(billName);
            String	comName		 = rs.getString("bill.comName");
            item.setComName(comName);
            String	comAddr		 = rs.getString("bill.comAddr");
            item.setComAddr(comAddr);
            String	payNote		 = rs.getString("bill.payNote");
            item.setPayNote(payNote);
            String	regInfo		 = rs.getString("bill.regInfo");
            item.setRegInfo(regInfo);
            int	bunitId		 = rs.getInt("bill.bunitId");
            item.setBunitId(bunitId);
            long	forcemodify		 = 0;try { forcemodify = Long.parseLong(new String(rs.getBytes("forcemodify"))); } catch (Exception ee) {}
            item.setForcemodify(forcemodify);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
