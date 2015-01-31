<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
JsfAdmin ja=JsfAdmin.getInstance();
%>

<form action="birth2.jsp" method="get">

單位	
<%


	Depart[] de=ja.getAllDepart();
	if(de==null)
	{
		out.println("<font size=2 color=red><b>尚未加入單位</b></font>");
	}
	else
	{
%>
	<select name="depart" size=1>
		<option value="0">全部</option>
	<%
		for(int i=0;i<de.length;i++)
		{
	%>
			<option value=<%=de[i].getId()%>><%=de[i].getDepartName()%></option>
	<%
		}
	%>
	</select>
<%
	}
%>

班級:	
<%
	Classes[] cl=ja.getAllActiveClasses();
	if(cl==null)
	{	
		out.println("<font size=2 color=red><b>尚未加入班級</b></font>");	
	
	}
	else
	{
%>
	
	<select name="classx" size=1>
	<option value="0">全部</option>
		<%
		for(int i=0;i<cl.length;i++)
		{
		%>
		<option value=<%=cl[i].getId()%>><%=cl[i].getClassesName()%></option>
		<%
		}
		%>
	</select>
<%
	}	
	
	
%>


<input type=submit value="產生生日表單">
</form>