<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
 request.setCharacterEncoding("UTF-8");
  
 String BIname=request.getParameter("BIname");	 
 int bID=Integer.parseInt(request.getParameter("bigItemId")); 

%>

<h3><font color=blue><%=BIname%></font>次項目管理</h3>

<a href="addSmallItem.jsp?bigItemId=<%=bID%>&BIname=<%=BIname%>">新增次項目</a>

<%
	JsfAdmin ja=JsfAdmin.getInstance();
	SmallItem[] si=ja.getAllSmallItemByBID(bID);
	
	if(si==null)
	{
		out.println("<br><br>目前沒有次項目！！");
		return;
	}	

%>
<br><br>
<table>
	<tr bgcolor="#c9c9c9">
	<td>名稱</td><td>狀態</td><td></td>
	</tr>
<%	
	for(int i=0;i<si.length;i++)
	{
%>
	<tr>	
		<td><%=si[i].getSmallItemName()%></td>
		<td><%=si[i].getSmallItemActive()==1?"運作中":"取消"%></td>
		<td><a href="modifySmallItem2.jsp?sid=<%=si[i].getId()%>">修改次項目</a></td>
	</tr>	
<%
	}
%>		
	
	</table>
	<br>
	<br>
	<br>
	
<a href=ListBigItem.jsp>回管理支出主項目</a>	