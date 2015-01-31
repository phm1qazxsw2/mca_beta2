<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%

   String id=request.getParameter("id"); 


   JsfAdmin ad=JsfAdmin.getInstance();
   BigItem bi=ad.getBigItemById(Integer.parseInt(id));	

   int active=bi.getBigItemActive();
%>

  <form action="ModifyBigItem2.jsp" method="post">
  
  <input type=text name="itemName" value="<%=bi.getBigItemName()%>">
  <input type=radio name=active value=1 <%=(active==1)?"checked":""%>>運作中
  <input type=radio name=active value=0 <%=(active==0)?"checked":""%>>取消  
  <input type=hidden name=id value="<%=id%>">
  <input type=submit value="修改">
  </form>	