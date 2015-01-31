<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=10;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu10.jsp"%>
<%
	String tradeDate=request.getParameter("tradeDate");
	String ps=request.getParameter("ps");
	
	int number=Integer.parseInt(request.getParameter("number"));
	
	if(number <=0)
	{
%>
    <br>
    <br>
    <blockquote>
        <div class=es02><font color=red>Error:</font>金額不得小於或等於0.
        <br>
        <br>

        <a href="incomeOwner.jsp">重新登入</a>
        </div>
    </blockquote>
<%
		return;
	}
	
	String ownerIdS=request.getParameter("ownerId");
	
	if(ownerIdS==null)
	{
%>
          <br>
    <br>
    <blockquote>
        <div class=es02><font color=red>Error:</font>尚未選擇交易股東.
        <br>
        <br>

        <a href="incomeOwner.jsp">重新登入</a>
        </div>
    </blockquote>
 
<%
		return;
	}
	
	int ownerId=Integer.parseInt(ownerIdS);
	
	int Totype=Integer.parseInt(request.getParameter("Totype"));
	int paywayX=Integer.parseInt(request.getParameter("paywayX"));
	
	int TotradeaccountId=0;;
	int TobankName=0;
	if(Totype==1)
	{
		String TotradeaccountIdS=request.getParameter("TotradeaccountId");
		
		if(TotradeaccountIdS==null)
		{
			out.println("尚未選擇交易戶頭");
			return;
		}else{
			TotradeaccountId=Integer.parseInt(TotradeaccountIdS);
		}
	}else{
		
		String TobankNamesS=request.getParameter("TobankName");
		
		if(TobankNamesS==null)
		{
			out.println("尚未選擇交易戶頭");
			return;
		}else{
			TobankName=Integer.parseInt(TobankNamesS);
		}
	}


	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 
	
	
	
	Ownertrade ow=new Ownertrade();
	ow.setOwnertradeOwnerId   	(ownerId);
	ow.setOwnertradeInOut   	(0);
	ow.setOwnertradeNumber   	(number);
	ow.setOwnertradeWay   	(paywayX);
	ow.setOwnertradeAccountDate   	(df.parse(tradeDate));
	ow.setOwnertradeLogId   	(ud2.getId());
	ow.setOwnertradeLogPs   	(ps);
	ow.setOwnertradeCheckLog   	(0);
	ow.setOwnertradeCheckUserId   	(0);
	//ow.setOwnertradeCheckDate   	(Date ownertradeCheckDate);
	//ow.setOwnertradeCheckPs   	(String ownertradeCheckPs);
	
	if(Totype==1)
	{
		ow.setOwnertradeAccountType(1);
   		ow.setOwnertradeAccountId(TotradeaccountId);
	}else{
		ow.setOwnertradeAccountType(2);
   		ow.setOwnertradeAccountId(TobankName);
	}
	
	
	JsfPay jp=JsfPay.getInstance();
	
	if(jp.addIncomeOwnertrade(ow, _ws.getSessionBunitId()))
    {
	    %><script>location.href='addIncomeOwerResult.jsp';</script><%
    }else{
 %>
    <br>
    <br>
    <blockquote>
        <div class=es02><font color=red>Error:</font>系統登入失敗.
        <br>
        <br>

        <a href="incomeOwner.jsp">重新登入</a>
        </div>
    </blockquote>
<%       
    }
%>

<%@ include file="bottom.jsp"%>
