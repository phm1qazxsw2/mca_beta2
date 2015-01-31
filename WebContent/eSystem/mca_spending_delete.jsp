<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>
<%!
    void deleteVitem(int tran_id, Vitem vi) 
        throws Exception
    {
        if (vi.getVerifystatus()!=Vitem.VERIFY_NO)
            throw new Exception("已覆核不可刪除");
        vi.setTotal(0);
        vi.setRealized(0);
        new VitemMgr(tran_id).save(vi);

        if (vi.getOrgtype()==Vitem.ORG_TYPE_INVENTORY) {
            InventoryMgr invmgr = new InventoryMgr(tran_id);
            Inventory inv = invmgr.find("id=" + vi.getOrgId());
            Object[] objs = { inv };
            invmgr.remove(objs);
        }
    }
%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();
        int cpid = Integer.parseInt(request.getParameter("cpid"));
        Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);
        Costpay2 cp = cpmgr.find("id=" + cpid);
        if (cp.getCostpayCostbookId()<=0)
            throw new Exception("1");
        McaReceipt mr = new McaReceiptMgr(tran_id).find("costpayId=" + cp.getId());
        if (mr!=null) {
            Object[] objs = { mr };
            new McaReceiptMgr(tran_id).remove(objs);
        }

        VitemMgr vimgr = new VitemMgr(tran_id);
        VPaidMgr vpmgr = new VPaidMgr(tran_id);
        ArrayList<VPaid> paids = vpmgr.retrieveList("costpayId=" + cpid, "");
        Iterator<VPaid> iter = paids.iterator();
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        while (iter.hasNext()) {
            VPaid vp = iter.next();
            Vitem vi = vimgr.find("id=" + vp.getVitemId());
            deleteVitem(tran_id, vi);
            vsvc.genVoucherForVitem(vi, ud2.getId(), "刪");
            vp.setAmount(0);
            vpmgr.save(vp);
        }

        // ### delete any cheque associated with this costpay ###
        if (cp.getCostpayChequeId()>0) {
            ChequeMgr cqmgr = new ChequeMgr(tran_id);
            Cheque cq = cqmgr.find("id=" + cp.getCostpayChequeId());
            Object[] rmcqs = { cq };
            cqmgr.remove(rmcqs);
        }
        // ######################
        
        cp.setCostpayCostNumber(0);
        cp.setCostpayIncomeNumber(0);
        cp.setOrgAmount(0);
        cp.setReceiptNo("");
        cp.setPayerName("");
        cp.setCheckInfo("");
        cpmgr.save(cp);

        String reason = (cp.getCostpayNumberInOut()==0)?"收款":"付款";
        vsvc.genVoucherForVitemPay(cp, ud2.getId(), "刪除"+reason);        

        //Object[] rmcps = { cp };
        //cpmgr.remove(rmcps); 

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
        if (e.getMessage()!=null&&e.getMessage().equals("1")) {
          %><script>alert("刪除的記錄有誤");history.go(-1);</script><%
              return;
        } else { 
            if (e.getMessage()!=null) {
          %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
            }
            else {
          %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            }
            return;
        }          
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>刪除成功!
<script>
    parent.do_reload = true;
</script>