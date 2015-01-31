<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>
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

        VitemMgr vimgr = new VitemMgr(tran_id);
        VPaidMgr vpmgr = new VPaidMgr(tran_id);
        ArrayList<VPaid> paids = vpmgr.retrieveList("costpayId=" + cpid, "");
        Iterator<VPaid> iter = paids.iterator();
        while (iter.hasNext()) {
            VPaid vp = iter.next();
            Vitem vi = vimgr.find("id=" + vp.getVitemId());
            int new_realized = vi.getRealized() - vp.getAmount();
            if (new_realized<0)
                throw new Exception("2");
            vi.setRealized(new_realized);
            if (new_realized==0)
                vi.setPaidstatus(Vitem.STATUS_NOT_PAID);
            else 
                vi.setPaidstatus(Vitem.STATUS_PARTLY_PAID);
            vimgr.save(vi);
System.out.println("## 1");
            //Object[] removed = { vp };
            //vpmgr.remove(removed);
            vp.setAmount(0);
            vpmgr.save(vp);
        }

System.out.println("## 2");
        // ### delete any cheque associated with this costpay ###
        if (cp.getCostpayChequeId()>0) {
            ChequeMgr cqmgr = new ChequeMgr(tran_id);
            Cheque cq = cqmgr.find("id=" + cp.getCostpayChequeId());
            Object[] rmcqs = { cq };
            cqmgr.remove(rmcqs);
        }
        // ######################
        
System.out.println("## 3");
        cp.setCostpayCostNumber(0);
        cp.setCostpayIncomeNumber(0);
        cpmgr.save(cp);

        String reason = (cp.getCostpayNumberInOut()==0)?"收款":"付款";
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.genVoucherForVitemPay(cp, ud2.getId(), "刪除"+reason);        

        //Object[] rmcps = { cp };
        //cpmgr.remove(rmcps); 

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
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
    response.sendRedirect(request.getParameter("backurl"));
%>
