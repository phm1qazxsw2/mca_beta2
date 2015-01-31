<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!  
    void setupClientCharge(FeeDetail fd, ChargeItem citem, int num, BillItem bi, String orgNote)
        throws Exception
    {
        bi.parseCharge();
        if (bi.getChargeType()==BillItem.CHARGE_TYPE_COUNT) {
            fd.setUnitPrice(bi.getChargeUnitPrice(num, null));
            fd.setNum(num);
            fd.setNote(orgNote);
        }
        else if (bi.getChargeType()==BillItem.CHARGE_TYPE_STEPS) {
            StringBuffer note = new StringBuffer();
            fd.setUnitPrice(bi.getChargeUnitPrice(num, note));
            fd.setNum(num);
            fd.setNote(note.toString());
        }
        else if (bi.getChargeType()==BillItem.CHARGE_TYPE_HOURS) {
            StringBuffer note = new StringBuffer();
            fd.setUnitPrice(bi.getChargeUnitPrice(num, note));
            fd.setNum(1);
            fd.setNote(note.toString());
        }
        else if (bi.getChargeType()==BillItem.CHARGE_TYPE_ACCUM) {
            StringBuffer note = new StringBuffer();
            fd.setUnitPrice(bi.getChargeUnitPrice(num, note));
            fd.setNum(1);
            fd.setNote(note.toString());
        }
    }

    ChargeItem findSalaryChargeItemForManHour(int tran_id, ChargeItem billcitem)
        throws Exception
    {
        SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
        // 先找看 salary 的 billrecord 在不在
        BillRecordInfoMgr brmgr = new BillRecordInfoMgr(tran_id);
        BillRecord br = brmgr.find("billrecord.id=" + billcitem.getBillRecordId());
        BillRecord br_salary = brmgr.find("billType=" + Bill.TYPE_SALARY + 
            " and month='" + sdf1.format(br.getMonth()) + "' and bill.name='代收款'");
        if (br_salary==null)
            throw new Exception("該月份的薪資記錄尚未產生,無法進行派遣薪資登入");

        ArrayList<BillChargeItem> bcitems = new BillChargeItemMgr(tran_id).retrieveList(
            "billitem.name='鐘點費' and billType="+Bill.TYPE_SALARY, "");

        if (bcitems.size()==0) {
            throw new Exception("薪資項目找不到[鐘點費]");
        }

        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        ChargeItem citem = cimgr.find("billitemId=" + bcitems.get(0).getBillItemId() + " and billRecordId=" + br_salary.getId());
        if (citem==null) {
            EzCountingService ezsvc = EzCountingService.getInstance();
            citem = ezsvc.makeChargeItem(tran_id, br_salary.getId(), bcitems.get(0).getBillItemId());
        }
        return citem;
    }

    int getFdAmount(ArrayList<FeeDetail> fds)
    {
        int ret = 0;
        if (fds==null)
            return 0;
        for (int i=0; i<fds.size(); i++) {
            FeeDetail fd = fds.get(i);
            ret += fd.getUnitPrice()*fd.getNum();
        }
        return ret;
    }

    boolean integrityCheck(int tran_id, MembrInfoBillRecord mbr)
        throws Exception
    {
        ArrayList<ChargeItemMembr> charges = new ChargeItemMembrMgr(tran_id).retrieveList("ticketId='" + mbr.getTicketId() + "'", "");
        String chargeitemIds = new RangeMaker().makeRange(charges, "getChargeItemId");
        ArrayList<FeeDetail> fds = new FeeDetailMgr(tran_id).retrieveList("chargeItemId in (" + chargeitemIds + 
            ") and membrId=" + mbr.getMembrId(), "");
        Map<String, ArrayList<FeeDetail>> feedetailMap = new SortingMap(fds).doSortA("getChargeKey");
        int total = 0;
        for (int i=0; i<charges.size(); i++) {
            ChargeItemMembr ci = charges.get(i);
            ArrayList<FeeDetail> myfds = feedetailMap.get(ci.getMembrId()+"#"+ci.getChargeItemId());
            if (myfds==null) { // 這個不是 manhour 來的 charge
                total += ci.getMyAmount();
            }
            else {
                int charge_total = getFdAmount(myfds);
                if (ci.getMyAmount()!=charge_total) {
                    return false;
                }
                total += charge_total;
            }
        }
        if (total!=mbr.getReceivable())
            return false;
        return true;
    }
%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat monthsdf = new SimpleDateFormat("yyyy-MM-dd");
    int executeMembrId = Integer.parseInt(request.getParameter("executeMembrId"));
    int targetMembrId = Integer.parseInt(request.getParameter("target"));
    Date occurDate = sdf.parse(request.getParameter("occurDate"));
    Date month = monthsdf.parse(request.getParameter("month"));
    int num = Integer.parseInt(request.getParameter("quant"));
    String chargestr = request.getParameter("charge"); // billitemId_billrecordId_chargeitemId_amount
    String[] tokens = chargestr.split("_");
    int recordId = Integer.parseInt(tokens[1]);
    int bitemId = Integer.parseInt(tokens[0]);
    int citemId = Integer.parseInt(tokens[2]);
    String note = request.getParameter("note");
    Membr target = MembrMgr.getInstance().find("id=" + targetMembrId);
    Membr executor = MembrMgr.getInstance().find("id=" + executeMembrId);
    int mhId = 0;
    try { mhId = Integer.parseInt(request.getParameter("id")); } catch (Exception e) {}
    boolean modify = false;
    try { modify = request.getParameter("m").equals("1"); } catch (Exception e) {}

    boolean commit = false;
    int tran_id = 0;
    try {        
        tran_id = dbo.Manager.startTransaction();

        EzCountingService ezsvc = EzCountingService.getInstance();
        ManHourMgr mhmgr = new ManHourMgr(tran_id);

        if (modify) {
            ArrayList<ManHour> manhours = mhmgr.retrieveList("id=" + mhId, "");
            // 這里面也要處理 voucher 的事
            ezsvc.removeManhours(tran_id, manhours, ud2);
        }
        
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        BillItemMgr bimgr = new BillItemMgr(tran_id);
        ChargeItem citem = cimgr.find("id=" + citemId);
        if (citem==null)
            citem = ezsvc.makeChargeItem(tran_id, recordId, bitemId);
        BillItem bi = bimgr.find("id=" + citem.getBillItemId());
    
        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);
        FeeDetail fd = new FeeDetail();
        fd.setChargeItemId(citem.getId());
        fd.setMembrId(targetMembrId);
        setupClientCharge(fd, citem, num, bi, note);
        fd.setFeeTime(occurDate);
        fd.setUserId(ud2.getId());
        fd.setNote(executor.getName());
        fdmgr.create(fd);

        boolean do_remove = false;
        ezsvc.updateFeeDetail(tran_id, fd, do_remove, ud2);   

        // 處理附屬 billitem 的部分
        BillChargeItemMgr bcmgr = new BillChargeItemMgr(tran_id);
        BillChargeItem bcitem = bcmgr.find("chargeitem.id=" + citem.getId());
        ArrayList<BillItem> subitems = bimgr.retrieveList("mainBillItemId=" + bcitem.getBillItemId(), "");             
        ArrayList<FeeDetail> fdsubs = new ArrayList<FeeDetail>();
        for (int i=0; i<subitems.size(); i++) {
            bi = subitems.get(i);
            ChargeItem cci = cimgr.find("billItemId=" + bi.getId() + " and billRecordId=" + recordId);
            if (cci==null)
                cci = ezsvc.makeChargeItem(tran_id, recordId, bi.getId());
            FeeDetail fdsub = new FeeDetail();
            fdsub.setChargeItemId(cci.getId());
            fdsub.setMembrId(targetMembrId);
            setupClientCharge(fdsub, cci, num, bi, "");
            fdsub.setFeeTime(occurDate);
            fdsub.setUserId(ud2.getId());
            fdsub.setNote(executor.getName());
            fdmgr.create(fdsub);
            ezsvc.updateFeeDetail(tran_id, fdsub, do_remove, ud2);   
            fdsubs.add(fdsub);
        }

        // 2008/12/30 by decided, decide only track modification if bill already has voucher
        // voucher is created upon 發布
        /*
        VoucherService vsvc = new VoucherService(tran_id, _ws.getSessionBunitId());
        MembrInfoBillRecord bill = new MembrInfoBillRecordMgr(tran_id).find("billRecordId=" +
            bcitem.getBillRecordId() + " and membrId=" + targetMembrId);
        vsvc.genVoucherForBill(bill, ud2.getId(), bcitem.getName()+"(派遣)");
        */
        MembrInfoBillRecord bill = new MembrInfoBillRecordMgr(tran_id).find("billRecordId=" +
            bcitem.getBillRecordId() + " and membrId=" + targetMembrId);

        // 處理薪資部分
        // 1. 找出 percent 數
        // 2. 算金額 (x/1.05)*percent
        // 3. 找 "鐘點費" 的薪資項目，沒有產生(一并產生派遣月份的 chargeitem)
        // 4. 產生 feedetail
        MembrTeacher mt = new MembrTeacherMgr(tran_id).find("membr.id=" + executeMembrId);
        int percent = mt.getTeacherLevel();
        int base = fd.getUnitPrice()*fd.getNum(); // 不考慮 附屬item
        int salary = (int) ((((double)base)/1.05)*((double)percent)/((double)100));
        ChargeItem salary_citem = findSalaryChargeItemForManHour(tran_id, citem);

        FeeDetail fd2 = new FeeDetail();
        fd2.setChargeItemId(salary_citem.getId());
        fd2.setMembrId(executeMembrId);
        fd2.setUnitPrice(salary);
        fd2.setNum(1);
        fd2.setFeeTime(occurDate);
        fd2.setUserId(ud2.getId());
        String nt = target.getName()+ (fd.getUnitPrice()*fd.getNum()) + "/1.05*" + percent + "%";
        fd2.setNote(nt);
        fdmgr.create(fd2);

        ezsvc.updateFeeDetail(tran_id, fd2, do_remove, ud2);   

        ManHour mh = new ManHour();
        mh.setClientMembrId(targetMembrId);
        mh.setExecuteMembrId(executeMembrId);
        mh.setRecordTime(new Date());
        mh.setModifyTime(new Date());
        mh.setOccurDate(occurDate);
        mh.setBillfdId(fd.getId());
        mh.setSalaryfdId(fd2.getId());
        mh.setUserId(ud2.getId());
        mhmgr.create(mh);

        // update manhourId again
        fd.setManhourId(mh.getId());
        fd2.setManhourId(mh.getId());
        fdmgr.save(fd);
        fdmgr.save(fd2);
        for (int i=0; i<fdsubs.size(); i++) {
            FeeDetail tmp = fdsubs.get(i);
            tmp.setManhourId(mh.getId());
            fdmgr.save(tmp);
        }

        MembrInfoBillRecord salarybill = new MembrInfoBillRecordMgr(tran_id).find("billRecordId=" +
            salary_citem.getBillRecordId() + " and membrId=" + executeMembrId);

        if (!integrityCheck(tran_id, salarybill))
            ezsvc.sendWarningMessage("salary wrong for " + salarybill.getTicketId() + " manhourId=" + mh.getId());
        if (!integrityCheck(tran_id, bill))
            ezsvc.sendWarningMessage("bill wrong for " + bill.getTicketId() + " manhourId=" + mh.getId());

        dbo.Manager.commit(tran_id);
        commit = true;
    } 
    catch (Exception e) {
e.printStackTrace();
        if (e.getMessage()!=null) { 
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>'); history.go(-1);</script><%
        } else { 
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            e.printStackTrace();
        }
        return;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<br>
<br>
<blockquote>
<% if (modify) { %>
修改完成!
<% } else { %>
複製成功！
<% } %>
<blockquote>
<script>
    parent.do_reload = true;
</script>
