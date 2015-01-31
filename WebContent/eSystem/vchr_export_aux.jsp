<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*" contentType="text/html;charset=UTF-8"%>
<%
    VchrSumInfo vinfo = new VchrSumInfo(sums, show_main_only, 0);

    boolean commit = false;
    int tran_id = 0;
    VchrHolder v = null;
    try {           
        tran_id = dbo.Manager.startTransaction();
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        LiteralStore store = new LiteralStore(tran_id, "literal", null);
        VchrHolderMgr vhmgr = new VchrHolderMgr(tran_id);

        v = new VchrHolder();
        Date registerDate = new Date();
        v.setSerial(vsvc.getSerialNo("_my", registerDate));
        Date create_date = new Date();
        v.setCreated(create_date);
        v.setRegisterDate(registerDate);
        v.setUserId(ud2.getId());
        v.setThreadId(-999);
        v.setType(VchrHolder.TYPE_EXPORT);
        v.setBuId(_ws2.getSessionBunitId());

        String note = title.replace("#", "\n");
        int noteId = (int) LiteralStore.create(store, note);
        v.setNote(noteId);
        vhmgr.create(v);
        
        for (int i=0, idx=0; i<sums.size(); i++) {
            VchrItemSum s = sums.get(i);
            double dvalue = (full_mode)?s.getDebit():vinfo.getNominalDebit(s);
            double cvalue = (full_mode)?s.getCredit():vinfo.getNominalCredit(s);
            if (dvalue==0 && cvalue==0)
                continue;
            VchrItem vi = new VchrItem();
            if (dvalue>cvalue) {
                vi.setFlag(VchrItem.FLAG_DEBIT);
                vi.setDebit(dvalue);
                vi.setCredit(cvalue);
            }
            else {
                vi.setFlag(VchrItem.FLAG_CREDIT);
                vi.setDebit(dvalue);
                vi.setCredit(cvalue);
            }
            vi.setVchrId(v.getId());
            vi.setAcodeId(vinfo.getNominalAcodeId(s));
                        
            // pass -999 to threadId 很重要，不然 getDirectItems 沒有 thread 時會抓一堆 threadId=0 的回來
            vsvc.addItem(idx++, v, vi.getBunitId(), vi.getAcodeId(), vi.getFlag(), -999, vi.getDebit(), 
                vi.getCredit(), 0);
        }

        dbo.Manager.commit(tran_id);
        commit = true;

        response.sendRedirect("vchr_edit.jsp?id=" + v.getId() + "&export=true");
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>

