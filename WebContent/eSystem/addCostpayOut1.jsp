<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
		String payDate=request.getParameter("payDate");
		String typeString=request.getParameter("type");
		
		if(typeString==null)
		{
			out.println("請選擇付款方式");
			return;
		}
		int type=Integer.parseInt(typeString);
		
		String accoutIdString="";
		
		if(type==1)
		{
			accoutIdString=request.getParameter("tradeaccountId");
		
		}else if(type==2){
			accoutIdString=request.getParameter("bankName");
		}
		
		if(accoutIdString==null)
		{
			out.println("請選擇付款帳號");
			return;
		}
		
		int accoutnId=Integer.parseInt(accoutIdString);
		
		
		String paymoneyString=request.getParameter("paymoney");
		
		if(paymoneyString==null)
		{
			out.println("請輸入付款金額");
			return;
		}
		
		int payMoney=Integer.parseInt(paymoneyString);

		if(payMoney<=0)
		{
			out.println("付款金額需大於0");
			return;
		}
		
		int cid=Integer.parseInt(request.getParameter("cid"));
		
		CostbookMgr cbm=CostbookMgr.getInstance();
		Costbook cb=(Costbook)cbm.find(cid);
		int shouldPay=cb.getCostbookTotalMoney()-cb.getCostbookPaiedMoney();
		
		
		if(shouldPay<payMoney)
		{
			out.println("付款金額不得大於應付金額");
			return;
		}
		String ps=request.getParameter("ps");
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 
		int paywayX=Integer.parseInt(request.getParameter("paywayX"));
		int typeInOut=Integer.parseInt(request.getParameter("typeX"));

	
		Costpay cp=new Costpay();
		cp.setCostpayDate   	(df.parse(payDate)); 
		cp.setCostpaySide(1); 
		cp.setCostpayNumberInOut(typeInOut); 
		cp.setCostpayPayway(paywayX); 
		
        cp.setCostpayAccountType   	(type);
		cp.setCostpayAccountId   	(accoutnId);
        cp.setBunitId(_ws.getSessionBunitId());

		if(typeInOut==1) { 
			cp.setCostpayCostNumber   	(payMoney);
			cp.setCostpayIncomeNumber (0); 
		}else{
			cp.setCostpayCostNumber   	(0); 
			cp.setCostpayIncomeNumber (payMoney);
		}

		cp.setCostpayLogWay(1); 
		cp.setCostpayLogDate(new Date());
		
        cp.setCostpayLogId   	(ud2.getId());
		cp.setCostpayLogPs   	(ps);
		cp.setCostpayBanklog   	(0);
		cp.setCostpayCostbookId   	(cid);
		cp.setCostpayCostCheckId(cb.getCostbookCostcheckId());	

		JsfPay jp=JsfPay.getInstance();

		int cpId=jp.payCost(cb,cp);

        //匯款
		if(cpId !=0 && typeInOut==1 && paywayX==3)
		{ 
			String clientAccountS=request.getParameter("clientAccount"); 
			
			int clientAccount= Integer.parseInt(clientAccountS); 
			
			DoTradeMgr dtm=DoTradeMgr.getInstance();
			DoTrade  dt=new DoTrade ();
			
			dt.setDoTradedDate   	(df.parse(payDate));
		    dt.setDoTradeClientAccountId   	(clientAccount);
		    dt.setDoTradeCostpayId   	(cpId);
		    dt.setDoTradeUserId   	(ud2.getId());
		    dt.setDoTradeStatus(0);  
			
			
            dtm.createWithIdReturned(dt);
		}
		response.sendRedirect("modifyCostbook.jsp?cid="+cid+"&showType=3&editpay=1");
%>