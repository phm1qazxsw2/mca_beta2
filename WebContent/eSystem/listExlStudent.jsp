<%@ page language="java"  import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=6;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%> 
<%@ include file="leftMenu6.jsp"%>

<%

JsfAdmin ja=JsfAdmin.getInstance();
JsfTool jt=JsfTool.getInstance();

Exl[] ex=ja.getAllExl();

if(ex==null)
{
	out.println("目前沒有已產生的檔案");
	return;
}

%>

<table>
<tr bgcolor="lightgrey">
<td>日期</td><td>檔名</td><td>標題</td><td> 備註</td><td></td><td></td>
</tr>
<%
 for(int i=0;i<ex.length;i++)
 {
%>
<tr>
<td><%=jt.ChangeDateToString(ex[i].getCreated())%></td>
<td><%=ex[i].getExlFileName()%>.xls</td>
<td><%=ex[i].getExlTitle()%></td>
<td><%=ex[i].getExlPs()%></td>
<td><a href="exlfile/<%=ex[i].getExlFileName()%>.xls">下載</a></td>
<td><a href="deleteExl.jsp?eId=<%=ex[i].getId()%>" onClick="return(confirm('確認刪除此筆資料?'))">刪除</a></td>
</tr>
<%
	}
%>
</table>

<%@ include file="bottom.jsp"%>	