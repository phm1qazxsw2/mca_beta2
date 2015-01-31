<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
String cpIdS=request.getParameter("cpId");

String baid=request.getParameter("baid");
int cpId=Integer.parseInt(cpIdS);
String showType=request.getParameter("showType");

if(showType==null) 
	 showType="0";

int vStatus=Integer.parseInt(request.getParameter("vStatus"));
String vPs=request.getParameter("vPs");

CostpayMgr cpm=CostpayMgr.getInstance();
Costpay cp=(Costpay)cpm.find(cpId);

cp.setCostpayVerifyStatus   	(vStatus);
cp.setCostpayVerifyDate   	(new Date());
cp.setCostpayVerifyId   	(ud2.getId());
cp.setCostpayVerifyPs(vPs);   	

cpm.save(cp);

response.sendRedirect("showCostpayDetailBank2.jsp?baid="+baid+"&showType="+showType);
%>
