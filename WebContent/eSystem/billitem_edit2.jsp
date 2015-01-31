<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,phm.accounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        //##v2
        int bid = Integer.parseInt(request.getParameter("bid"));
        String name = request.getParameter("name");
        if (name==null)
            throw new Exception("name is null");
        int smallitem = Integer.parseInt(request.getParameter("smallitem"));
        int defaultAmount = Integer.parseInt(request.getParameter("defaultAmount"));
        int copyStatus = Integer.parseInt(request.getParameter("copyStatus"));
        int alias = 0;
        try { alias = Integer.parseInt(request.getParameter("alias")); } catch (Exception e) {}
        int mainBillItemId = 0;
        try { mainBillItemId = Integer.parseInt(request.getParameter("mainBillItemId")); } catch (Exception e) {}
        String desc = request.getParameter("description");
        BillItemMgr bimgr = new BillItemMgr(tran_id);
        BillItem bitem = bimgr.find("id=" + bid);
        bitem.setName(name);
        bitem.setSmallItemId(smallitem);
        bitem.setDefaultAmount(defaultAmount);
        bitem.setDescription(desc);
        bitem.setCopyStatus(copyStatus);
        bitem.setAliasId(alias);
        bitem.setMainBillItemId(mainBillItemId);

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        String acctcode = request.getParameter("acctcode"); 
        Acode a = McaService.getMcaAcode(tran_id, _ws2.getSessionBunitId(), acctcode);

        if (a==null)
            throw new Exception("會計科目["+acctcode+"]不存在");
        // 要 replace 貸方
        vsvc.setBillItemTemplate(bitem, a, ud2.getId(), VchrItem.FLAG_CREDIT, VchrHolder.BILLITEM_DEFAULT);         

        if (pd2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) {
            try {
                bitem.parseCharge();
            }
            catch (Exception e) {
                %><script>alert("鐘點費計算格式不對");history.go(-1);</script><%
            }
        }

        try {
            int pitemId = Integer.parseInt(request.getParameter("pitemId"));
            PItem pi = new PItemMgr(tran_id).find("id=" + pitemId);
            if (pi!=null) {
                bitem.setPitemId(pi.getId());
                bitem.setDefaultAmount(pi.getSalePrice());
            }
        } catch (Exception e) {}
        
        bimgr.save(bitem);

        int citemId = Integer.parseInt(request.getParameter("cid"));

        boolean apply = false;
        try { apply = request.getParameter("apply").equals("1"); } catch (Exception e) {}

        ArrayList<ChargeItemMembr> citems = new ChargeItemMembrMgr(tran_id).retrieveList("chargeitem.id=" + citemId, "");
        String membrIds = new RangeMaker().makeRange(citems, "getMembrId");
        if (apply) {            
            if (citems.size()>0) { // 有可能有 chargeItem 但里面沒人                
                EzCountingService ezsvc = EzCountingService.getInstance();
                Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
                for (int i=0; i<citems.size(); i++)  {
                    ezsvc.setChargeItemMembrAmount(tran_id, citems.get(i), defaultAmount, ud2.getId(), nextFreezeDay);
                }
            }

            // 全部 apply 完才可改 chargeitem 的 chargeAmount, 不然在 setChargeItemMembrAmount 會不知 amount 有 diff 
            ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
            ChargeItem citem = cimgr.find("id=" + citemId);
            if (citem!=null) {
                citem.setChargeAmount(defaultAmount);
                cimgr.save(citem);
            }
        }
        // 沒有 apply 連 chargeItem 的 amount 都不能改，不然之前 charge 的 amount 為 0
        // (預設用 chargeItem 的就被改了但帳單金額沒跟著改就會出錯)

        // 2009/2/24 大家決議新科目無論如何要重新 apply
        if (citems.size()>0) {
            ArrayList<MembrInfoBillRecord> bills = new MembrInfoBillRecordMgr(tran_id).retrieveList("membrId in (" + membrIds + ") and billRecordId=" + citems.get(0).getBillRecordId() + " and threadId>0", "");    
            vsvc.genVoucherForBills(bills, ud2.getId(), citems.get(0).getChargeName_()+"(修)");
        }
        
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Locked l) {
      %><script>alert('本期已有單據發佈鎖定或已付款,無法套用設定\n若欲套用已開單據可先解除鎖定的單據\n或是選擇不要套用已開單據. \n沒有儲存任何資料！');history.go(-1);</script><%
          return;
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
          e.printStackTrace();
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
        } else {
          e.printStackTrace();
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<body>
<blockquote>
設定成功
</blockquote>
</body>
