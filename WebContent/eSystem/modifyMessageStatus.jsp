<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%
int meId=Integer.parseInt(request.getParameter("meid"));
int status2=Integer.parseInt(request.getParameter("status"));

SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
String messageHandleContent=request.getParameter("messageHandleContent"); 

MessageMgr mm=MessageMgr.getInstance();
Message me=(Message)mm.find(meId); 

me.setMessageToStatus(status2);	
me.setMessageHandleContent(messageHandleContent);
me.setMessageHandleDate(new Date()); 
me.setMessageHandleId(ud2.getId());
mm.save(me);


response.sendRedirect("detailMessage.jsp?meId="+meId);
%>
 
 
