package phm.ezcounting;

import java.util.*;
import java.text.*;
import jsf.*;

public class FeeDetailHandler
{
    private boolean outsourcing = false;
    private Map<Integer, Membr> payrollmembrMap = null;
    private ArrayList<FeeDetail> fds = null;

    public FeeDetailHandler() {}

    public FeeDetailHandler(ArrayList<FeeDetail> fds, boolean outsourcing)
        throws Exception
    {
        this.outsourcing = outsourcing;
        if (outsourcing && fds!=null) {
            String membrIds = new RangeMaker().makeRange(fds, "getPayrollMembrId");
            payrollmembrMap = new SortingMap(MembrMgr.getInstance().retrieveList
                ("id in (" + membrIds + ")", "")).doSortSingleton("getId");
        }
        this.fds = fds;
    }

    public static FeeDetailHandler getInstance(FeeDetail fd, boolean outsourcing)
        throws Exception
    {
        ArrayList<FeeDetail> fds = new ArrayList<FeeDetail>();
        fds.add(fd);
        return new FeeDetailHandler(fds, outsourcing);
    }

    public static ChargeItem findPayrollChargeItem(int tran_id, BillRecord br)
        throws Exception
    {
        // 取得同一個月份的代收款 billrecord
        BillRecordInfo sbr = new BillRecordInfoMgr(tran_id).find("month='" + sdf.format(br.getMonth()) + 
            "' and billType=" + Bill.TYPE_SALARY + " and bill.name='代收款'");
        if (sbr==null) {
            Bill b = new BillMgr(tran_id).find("name='代收款'");
            sbr = new BillRecordInfo();
            sbr.setBillId(b.getId());
            sbr.setName(monthsdf.format(br.getMonth()) + " 代收款");
            sbr.setMonth(br.getMonth());
            sbr.setBillDate(br.getBillDate());
            new BillRecordMgr(tran_id).create(sbr);
        }

        // call updateFeeDetail 要有 chargeItem 
        EzCountingService ezsvc = EzCountingService.getInstance();
        ArrayList<BillItem> bi = new BillItemMgr(tran_id).retrieveList("name='鐘點費' and billId=" + 
            sbr.getBillId() + " and status=1","");

        if (bi==null)
            throw new Exception("找不到薪資項目[鐘點費]");

        ChargeItem nci = new ChargeItemMgr(tran_id).find("billItemId=" + bi.get(0).getId() + " and billRecordId=" + sbr.getId());
        if (nci==null) {
            nci = ezsvc.makeChargeItem(tran_id, sbr.getId(), bi.get(0).getId());
        }
        return nci;
    }

    private static SimpleDateFormat monthsdf = new SimpleDateFormat("yyyy-MM");
    private static SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    public FeeDetail addPayrollEntry(int tran_id, FeeDetail fd, User user, Date nextFreezeDay)
        throws Exception
    {
        if (fd.getPayrollMembrId()==0) // 沒有派員的不理
            throw new Exception("## fd.getChargeItemId() is not supposed to be 0");

        ChargeItem ci = new ChargeItemMgr(tran_id).find("id=" + fd.getChargeItemId());
        BillRecordInfoMgr brmgr = new BillRecordInfoMgr(tran_id);
        BillRecordInfo br = brmgr.find("billrecord.id=" + ci.getBillRecordId());
        if (br.getBillType()!=Bill.TYPE_BILLING)  // 不是帳單的不理
            throw new Exception("## billrecord is supposed to be of type billing");

        ChargeItem nci = findPayrollChargeItem(tran_id, br);

        // 算出 membr 的加成
        MembrTeacher mt = new MembrTeacherMgr(tran_id).find("membr.id=" + fd.getPayrollMembrId());
        int percent = mt.getTeacherLevel();
        int base = fd.getUnitPrice()*fd.getNum(); // 不考慮 附屬item
        int salary = (int) ((((double)base)/1.05)*((double)percent)/((double)100));
        Membr target = new MembrMgr(tran_id).find("id=" + fd.getMembrId());
        
        FeeDetail sfd = new FeeDetail();
        sfd.setChargeItemId(nci.getId());
        sfd.setMembrId(fd.getPayrollMembrId());

        sfd.setUnitPrice(salary);
        sfd.setNum(1);
        sfd.setFeeTime(fd.getFeeTime());
        String nt = target.getName()+ (fd.getUnitPrice()*fd.getNum()) + "/1.05*" + percent + "%";
        sfd.setNote(nt);
        sfd.setUserId(user.getId());
        sfd.setPayrollFdId(fd.getId());
        new FeeDetailMgr(tran_id).create(sfd);

        boolean do_remove = false;
        EzCountingService ezsvc = EzCountingService.getInstance();
        ezsvc.updateFeeDetail(tran_id, sfd, do_remove, user, nextFreezeDay);

        return sfd;
    }

    public void updatePayrollEntry(int tran_id, FeeDetail fd, User user, Date nextFreezeDay)
        throws Exception
    {
        if (fd.getPayrollMembrId()==0) // 沒有派員的不理
            return;

        ChargeItem ci = new ChargeItemMgr(tran_id).find("id=" + fd.getChargeItemId());
        BillRecordInfoMgr brmgr = new BillRecordInfoMgr(tran_id);
        BillRecordInfo br = brmgr.find("billrecord.id=" + ci.getBillRecordId());
        if (br.getBillType()!=Bill.TYPE_BILLING)  // 不是帳單的不理
            return;
        
        MembrTeacher mt = new MembrTeacherMgr(tran_id).find("membr.id=" + fd.getPayrollMembrId());
        int percent = mt.getTeacherLevel();
        int base = fd.getUnitPrice()*fd.getNum(); // 不考慮 附屬item
        int salary = (int) ((((double)base)/1.05)*((double)percent)/((double)100));
        Membr target = new MembrMgr(tran_id).find("id=" + fd.getMembrId());

        FeeDetail sfd = new FeeDetailMgr(tran_id).find("id=" + fd.getPayrollFdId());
        sfd.setUnitPrice(salary);
        sfd.setNum(1);
        sfd.setFeeTime(fd.getFeeTime());
        String nt = target.getName()+ (fd.getUnitPrice()*fd.getNum()) + "/1.05*" + percent + "%";
        sfd.setNote(nt);
        sfd.setUserId(user.getId());
        new FeeDetailMgr(tran_id).save(sfd);

        EzCountingService ezsvc = EzCountingService.getInstance();
        boolean do_remove = false;
        ezsvc.updateFeeDetail(tran_id, sfd, do_remove, user, nextFreezeDay);
    }

    public boolean hasOutsourcingEntries()
    {
        if (!this.outsourcing)
            return false;
        for (int i=0; this.fds!=null && i<this.fds.size(); i++) {
            if (this.fds.get(i).getPayrollFdId()>0)
                return true;
        }
        return false;
    }

    public void deletePayrollEntry(int tran_id, FeeDetail fd, User user, Date nextFreezeDay)
        throws Exception
    {
        if (fd.getPayrollMembrId()==0) // 沒有派員的不理
            return;

        FeeDetail sfd = new FeeDetailMgr(tran_id).find("id=" + fd.getPayrollFdId());
        EzCountingService ezsvc = EzCountingService.getInstance();
        
        Object[] targets = { sfd };
        new FeeDetailMgr(tran_id).remove(targets);

        boolean do_remove = false;
        ezsvc.updateFeeDetail(tran_id, sfd, do_remove, user, nextFreezeDay);
    }

    public void prepareNotes()
        throws Exception
    {
        for (int i=0; this.fds!=null&&i<this.fds.size(); i++) {
            FeeDetail fd = this.fds.get(i);
            fd.setNote(getNote(fd, false, false));
        }
    }

    public String getPayrollMembrName(FeeDetail fd) {
        Membr m = payrollmembrMap.get(fd.getPayrollMembrId());
        if (m==null)
            return "";
        return m.getName();
    }

    String makePayrollLink(int payrollFdId, Membr m)
        throws Exception
    {
        FeeDetailInfo fdi = FeeDetailInfoMgr.getInstance().find("feedetail.id=" + payrollFdId);
System.out.println("## fdi=" + fdi + " payrollFdId=" + payrollFdId);
        return "<a target=_blank href=\"salary_detail_express.jsp?rid=" + fdi.getBillRecordId() + 
            "&sid=" + m.getId() + "&backurl=1\">" + m.getName() + "</a>";
    }

    public String getNote(FeeDetail fd)
        throws Exception
    {
        return getNote(fd, true, true);
    }

    public String getNote(FeeDetail fd, boolean hasLink, boolean hasParans)
        throws Exception
    {
        String note = "";
        if (outsourcing) { // 派遣
            if (fd.getPayrollMembrId()>0) {
                Membr m = payrollmembrMap.get(fd.getPayrollMembrId());
                if (m==null)
                    return "";
                if (fd.getPayrollFdId()>0 && hasLink)
                    note = "<a target=_blank href=\"fd_to_salary.jsp?id="+fd.getPayrollFdId()+"\">" + m.getName() + "</a>";
                else
                    note = m.getName(); // 附屬的就沒有
            }
        }
        if (fd.getNote()!=null&&fd.getNote().length()>0) {
            if (note.length()>0)
                note += ",";
            note += fd.getNote();
        }
        if (note.length()>0 && hasParans)
            note = " (" + note + ")";
        return note;

    }

    public String getSalaryNote(FeeDetail fd)
        throws Exception
    {
        String note = "";
        if (fd.getNote()!=null&&fd.getNote().length()>0) {
            if (note.length()>0)
                note += ",";
            note += fd.getNote();
        }
        if (outsourcing) { // 派遣
            if (fd.getPayrollFdId()>0) {
                note = "<a target=_blank href=\"fd_to_bill.jsp?id="+fd.getPayrollFdId()+"\">" + note + "</a>";
            }
        }
        
        if (note.length()>0)
            note = " (" + note + ")";

        return note;

    }

}
