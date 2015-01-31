<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    if(!checkAuth(ud2,authHa,202)){
        response.sendRedirect("authIndex.jsp?code=202");
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String[] vids = request.getParameterValues("vid");
    StringBuffer sb = new StringBuffer();
    for (int i=0; i<vids.length; i++) {
        if (sb.length()>0) sb.append(",");
        sb.append(vids[i]);
    }
    ArrayList<Vitem> vitems = VitemMgr.getInstance().retrieveList("id in (" + sb.toString() + ")", "");

    int amount = Integer.parseInt(request.getParameter("amount"));
    String acctinfo = request.getParameter("acct");
    String[] tokens = acctinfo.split(",");
    int acctType = Integer.parseInt(tokens[0]);
    int acctId = 0;
    if (tokens.length>1)
        acctId = Integer.parseInt(tokens[1]);

    int bunitId = 0;
    if (acctType==1) {
        Tradeaccount ta = (Tradeaccount) TradeaccountMgr.getInstance().find(acctId);
        bunitId = ta.getBunitId();
    }
    else if (acctType==2) {
        BankAccount ba = (BankAccount) BankAccountMgr.getInstance().find(acctId);
        bunitId = ba.getBunitId();
    }
    else
        bunitId = ud2.getUserBunitAccounting(); //## 對管理多單位的行政來講，這張支票還是算在原單位

    Date payDate = sdf.parse(request.getParameter("payDate"));
    String ps=request.getParameter("ps");
    String chequeId = request.getParameter("chequeId");
    Date cashDate = sdf.parse(request.getParameter("cashDate"));
    int vitemType = vitems.get(0).getType();

    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = Manager.startTransaction();
        EzCountingService ezsvc = EzCountingService.getInstance();
        Costpay2 cp = ezsvc.realizeVitems(tran_id, vitems, payDate, acctType, acctId, amount, vitemType, ud2, ps, bunitId);

        if (acctType==3) { // cheque
            ChequeMgr cqmgr = new ChequeMgr(tran_id);
            Cheque cq = new Cheque();
            if (vitemType==Vitem.TYPE_INCOME) {
                cq.setInAmount(amount);
                cq.setType(Cheque.TYPE_SPENDING_INCOME);
            }
            else if (vitemType==Vitem.TYPE_SPENDING) {
                cq.setOutAmount(amount);
                cq.setType(Cheque.TYPE_SPENDING_PAY);
            }
            else if (vitemType==Vitem.TYPE_COST_OF_GOODS) {
                cq.setOutAmount(amount);
                cq.setType(Cheque.TYPE_COST_OF_GOODS);
            }

            cq.setChequeId(chequeId);
            cq.setCashDate(cashDate);
            //cq.setTitle();
            cq.setCostpayId(cp.getId());
            cq.setRecordTime(new Date());
            cq.setBunitId(bunitId);
            cqmgr.create(cq); 
            
            cp.setCostpayChequeId(cq.getId());
            new Costpay2Mgr(tran_id).save(cp);
        }

        VoucherService vsvc = new VoucherService(tran_id, bunitId);
        vsvc.genVoucherForVitemPay(cp, ud2.getId(), (vitemType==0 || vitemType==2)?"付款":"收款");

        Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
        if (e.getMessage()!=null&&e.getMessage().equals("m")) {
      %><script>alert("所付金額超過單據總額");history.go(-1);</script><%
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
%>

<body>
<blockquote>
<%=(vitemType==0 || vitemType==2)?"付款":"收款"%>成功！
</blockquote>
</body>
