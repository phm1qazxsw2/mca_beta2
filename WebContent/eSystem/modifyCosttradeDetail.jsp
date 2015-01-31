<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
	int ctId=Integer.parseInt(request.getParameter("ctId"));
	
	String contactor=request.getParameter("contactor");
	String mobile=request.getParameter("mobile");
	String uNumber=request.getParameter("uNumber");
	String phone1=request.getParameter("phone1");
	String phone2=request.getParameter("phone2");
	String address=request.getParameter("address");
	String ps=request.getParameter("ps");

	String cname=request.getParameter("cname");
    int active=Integer.parseInt(request.getParameter("active"));
	
	CosttradeMgr ctm=CosttradeMgr.getInstance();
	Costtrade ct=(Costtrade)ctm.find(ctId);
	ct.setCosttradeContacter   	(contactor);
	ct.setCosttradeUnitnumber   	(uNumber);
	ct.setCosttradePhone1   	(phone1);
	ct.setCosttradePhone2   	(phone2);
	ct.setCosttradeMobile   	(mobile);
	ct.setCosttradeAddress   	(address);
	ct.setCosttradePs   	(ps);
    ct.setCosttradeName(cname.trim());
    ct.setCosttradeActive(active);
	ctm.save(ct);
	
	response.sendRedirect("listCosttradeX.jsp?ctId="+ctId);

%>	