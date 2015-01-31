<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String chequeId = request.getParameter("chequeId");
    String acctinfo = request.getParameter("acct");
    String[] tokens = acctinfo.split(",");
    int acctType = Integer.parseInt(tokens[0]);
    int acctId = Integer.parseInt(tokens[1]);
    Date payDate = sdf.parse(request.getParameter("payDate"));
    String ps=request.getParameter("ps");   
    String name = "存入";

    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = Manager.startTransaction();
        ChequeMgr chmgr = new ChequeMgr(tran_id);
        Cheque ch = chmgr.findX("id=" + chequeId, _ws2.getBunitSpace("bunitId"));   
        boolean in = (ch.getType()==Cheque.TYPE_INCOME_TUITION) || (ch.getType()==Cheque.TYPE_SPENDING_INCOME);
        name = (in)?"存入":"提出";
        ch.setCashed(new Date());
        /*
        if (1==1) {
            EzCountingService.getInstance().sendWarningMessage(request.getServerName()+" 要兌現支票,顯示尚未完成訊息");
            throw new Exception("Message from Peter:\n此處傳票功能尚未完成,再一兩天我弄好會馬上通知");
        }
        */
        Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);

        if (ch.getType()==Cheque.TYPE_INCOME_TUITION) {
            //存入帳戶
            Costpay2 cost = new Costpay2();
            cost.setCostpayDate(payDate);
            cost.setCostpaySide(1); // 外部交易
            cost.setCostpaySideID(0);

            if (ch.getType()==Cheque.TYPE_INCOME_TUITION) {
                cost.setCostpayFeeticketID(1); // 隨便設個>0的值告訴 search 這個有 feeticketId
                cost.setCostpayFeePayFeeID(Costpay2.COSPAY_TYPE_CHEQUE_TUITION);
                cost.setCostpayIncomeNumber(ch.getInAmount());
                cost.setCostpayNumberInOut(0); // income
                BillPay bp = new BillPayMgr(tran_id).find("chequeId=" + ch.getId() + " and amount>0"); // amount=0 可能是被刪的
                cost.setCostpayStudentAccountId(bp.getId());
                name = "存入";
                boolean pending_cheque = false;
                EzCountingService ezsvc = EzCountingService.getInstance();
                ezsvc.updateBillPendingCheque(tran_id, bp, pending_cheque);
            }
            cost.setCostpayAccountType(acctType);
            cost.setCostpayAccountId(acctId);
            cost.setCostpayLogWay(Costpay2.PAYWAY_CHEQUE);

            cost.setCostpayLogDate(payDate); // payDate need to be 入帳日期，因為帳戶列表使用這個日期來判斷
            cost.setCostpayLogId(ud2.getId());
            cost.setCostpayCostbookId(0); 
            cost.setCostpayCostCheckId(0);
            cost.setCostpayLogPs(ps);
            cost.setCostpayChequeId(ch.getId());
            cost.setBunitId(ch.getBunitId());
            cpmgr.create(cost);
            ch.setCostpayId(cost.getId());
        }
        else { // 其他后來 Vitem 式的, 已有 costpay
            Costpay2 cp = cpmgr.find("id=" + ch.getCostpayId());
            cp.setCostpayAccountType(acctType);
            cp.setCostpayAccountId(acctId);
            cpmgr.save(cp);
            ch.setCostpayId(cp.getId()); // 之前在 realizeVitems 已設過了，這里比較是再確認

            VitemMgr vimgr = new VitemMgr(tran_id);
            ArrayList<VPaid> vpaids = new VPaidMgr(tran_id).retrieveList("costpayId=" + cp.getId(), "");
            String vitemIds = new RangeMaker().makeRange(vpaids, "getVitemId");
            ArrayList<Vitem> vitems = vimgr.retrieveList("id in (" + vitemIds + ")", "");
            Iterator<Vitem> iter = vitems.iterator();
            while (iter.hasNext()) {
                Vitem vi = iter.next();
                vi.setPending(vi.getPending()-1); // 少張支票 pending
                vimgr.save(vi);
            }
        }
System.out.println("#1");
        chmgr.save(ch);
        
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.genVoucherForCheque(ch, ud2.getId(), "兌現-" + ch.getTitle());
System.out.println("#2");

        Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null) { 
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>'); history.go(-1);</script><%
          return;
        } else { 
      %><script>alert("錯誤發生，付款沒有寫入");history.go(-1);</script><%
            e.printStackTrace();
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
支票<%=name%>成功！
</blockquote>
</body>
