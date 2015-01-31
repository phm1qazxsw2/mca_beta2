<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    String billS=request.getParameter("billId");

    int billId=Integer.parseInt(billS);

    Bill bill=BillMgr.getInstance().find("id='"+billId+"'");

    String comName=request.getParameter("comName");
    String comAddr=request.getParameter("comAddr");
    String payNote=request.getParameter("payNote");
    String regInfo=request.getParameter("regInfo");

    bill.setComName   	(comName);
    bill.setComAddr   	(comAddr);
    bill.setPayNote   	(payNote);
    bill.setRegInfo(regInfo);   

    BillMgr.getInstance().save(bill);

    response.sendRedirect("modifyBillInfo.jsp?billId="+billId+"&m=1");
%>

