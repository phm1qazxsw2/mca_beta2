<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int teacherId=Integer.parseInt(request.getParameter("teacherId"));
    int cid=Integer.parseInt(request.getParameter("cid"));
    int membrId=Integer.parseInt(request.getParameter("membrId"));

    CardMembrMgr cmm=CardMembrMgr.getInstance();
    CardMembr ci=cmm.find("id="+cid);
    ci.setActive2(0);
    cmm.save(ci);

    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");   
    String toString=sdf.format(new Date()); 
    Date d=sdf.parse(toString);
    Calendar c=Calendar.getInstance();
    c.setTime(d);
    c.add(Calendar.DATE,1);
    Date d2=c.getTime();

    String cardNum1="mm"+pd2.getPaySystemCompanyUniteId()+membrId;
    CardMembr cm=new CardMembr();
    cm.setCreated(d2);
    cm.setCardId(cardNum1);
    cm.setMembrId(membrId);
    cm.setActive2(2);
    cmm.create(cm);

    response.sendRedirect("modifyTeacherCard.jsp?teacherId="+teacherId);

    
%>