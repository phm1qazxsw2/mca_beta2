<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=6;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,700))
	{ 
       response.sendRedirect("authIndex.jsp?code=700");
	
	}
%>
<%@ include file="leftMenu6.jsp"%>
<%

 
	String orderString=request.getParameter("order");
	String pageNum=request.getParameter("pageNum");
	
	int order=0;
	
	if(orderString !=null)
		order=Integer.parseInt(orderString);
	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	Teacher[] tea=ja.getLeaveTeacher(order);
	
	if(tea==null)
	{
		out.println("<br><br><font color=red>沒有資料</font>");
		return;
	}
	
	int pageNumber=1;
	int teacherLength=tea.length;
%>
<script type="text/javascript" src="openWindow.js"></script>

<br>
<b>&nbsp;&nbsp;&nbsp;非在職教師列表</b>
<br>
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
 <br>

<center>


<%
	EsystemMgr em=EsystemMgr.getInstance();
	Esystem e=(Esystem)em.find(1);
	// int pageContent=e.getEsystemTeapage();
    int pageContent = 50;
	
	if(pageNum!=null)
		pageNumber=Integer.parseInt(pageNum);
	
	int pageTotal=1;
	pageTotal=teacherLength/pageContent;
	
	if(teacherLength%pageContent!=0)
		pageTotal+=1;

	if(pageNumber !=1)
	{
		int lastPage=pageNumber-1;
		out.println("<a href=\"listLeaveTeacher.jsp?order="+order+"&pageNum="+lastPage+"\">上一頁</a>");
	}
	for(int j=0;j<pageTotal;j++)
	{
		int jx=j+1;
		
		if(pageNumber==jx)
		{
			out.println("<b>"+jx+"</b>");
		
		}
		else
		{
			out.println("<a href=\"listLeaveTeacher.jsp?order="+order+"&pageNum="+jx+"\">"+jx+"</a>");
		}
	}
	if(pageNumber !=pageTotal)
	{
		int lastPage=pageNumber+1;
		out.println("<a href=\"listLeaveTeacher.jsp?order="+order+"&pageNum="+lastPage+"\">下一頁</a>");
	}

	
%>

<div align=right>共計: <font color=blue><b><%=teacherLength%></b></font> 筆資料</div>


<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02 bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
		<td class=es02>姓名</td>
		<td class=es02>
		<%
		if(order==9)
		{
		%>
			<a href="listLeaveTeacher.jsp?order=10&pageNum=<%=pageNumber%>">>>>狀態</a>
		<%
		}else{
		%>
			<a href="listLeaveTeacher.jsp?order=9&pageNum=<%=pageNumber%>"><<<狀態</a>
		<%
		}
		%>		
		</td>
<!--
		<td class=es02>
		<%
		if(order==1)
		{
		%>
			<a href="listLeaveTeacher.jsp?order=2&pageNum=<%=pageNumber%>">>>>單位</a>
		<%
		}else{
		%>
			<a href="listLeaveTeacher.jsp?order=1&pageNum=<%=pageNumber%>"><<<單位</a>
		<%
		}
		%>
		
		</td>
		<td class=es02>
		<%
		if(order==3)
		{
		%>
			<a href="listLeaveTeacher.jsp?order=4&pageNum=<%=pageNumber%>">>>>職稱</a>
		<%
		}else{
		%>
			<a href="listLeaveTeacher.jsp?order=3&pageNum=<%=pageNumber%>"><<<職稱</a>
		<%
		}
		%>
		</td>
		<td class=es02>
		<%
		if(order==5)
		{
		%>
			<a href="listLeaveTeacher.jsp?order=6&pageNum=<%=pageNumber%>">>>>班級</a>
		<%
		}else{
		%>
			<a href="listLeaveTeacher.jsp?order=5&pageNum=<%=pageNumber%>"><<<班級</a>
		<%
		}
		%>
		</td>
-->
        <td class=es02>
		<%
		if(order==7)
		{
		%>
			<a href="listLeaveTeacher.jsp?order=8&pageNum=<%=pageNumber%>">>>>到職日</a>
		<%
		}else{
		%>
			<a href="listLeaveTeacher.jsp?order=7&pageNum=<%=pageNumber%>"><<<到職日</a>
		<%
		}
		%>
		
		</td>
		<td class=es02></td>
		
	</tr>
<%
	DepartMgr dm=DepartMgr.getInstance();
	PositionMgr pm=PositionMgr.getInstance();
	ClassesMgr cm=ClassesMgr.getInstance();
	LevelMgr lm=LevelMgr.getInstance();

	int startRow=(pageNumber-1)*pageContent;
	int endRow=startRow+pageContent;
	if(endRow > teacherLength)
		endRow=teacherLength;
	for(int i=startRow;i<endRow;i++)
	{

%>
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td class=es02><%=tea[i].getTeacherFirstName()%><%=tea[i].getTeacherLastName()%></td>
		<td class=es02>
		<%
			int statusx=tea[i].getTeacherStatus();
			
			switch(statusx)
			{
				case 1:out.println("在職");
					break;
				case 2:out.println("試用");
					break;
				case 3:out.println("面試");
					break;
				case 0:out.println("離職");
					break;
				default:out.println("未定");

			}
		
		%>
		</td>
<!--
        <td class=es02><%
			int departId=tea[i].getTeacherDepart();
			
			if(departId !=0)
			{			
			Depart de=(Depart)dm.find(departId);
			out.println(de.getDepartName());
			
			}else{
			out.println("未定");
			}
			%></td>
		<td class=es02><%
			int positionId=tea[i].getTeacherPosition();
			if(positionId !=0)
			{	
			
			Position po=(Position)pm.find(positionId);
			out.println(po.getPositionName());
			
			}else{
			out.println("未定");
			}
		   %></td>
		<td class=es02><%
			int classxId=tea[i].getTeacherClasses();
			int levelxId=tea[i].getTeacherLevel();
			
			if(classxId !=0)
			{
				Classes cla=(Classes)cm.find(classxId);
				out.println(cla.getClassesName()+"-");
			}else{
				out.println("未定-");
			}
			if(levelxId !=0)
			{
				Level le=(Level)lm.find(levelxId);
				out.println(le.getLevelName());
			}else{
				out.println("未定");
			}
			%>
		
		</td>
-->
        <td class=es02>
		<%=jt.ChangeDateToString(tea[i].getTeacherComeDate())%>
		</td>
		
		<td class=es02>
			<a href="#" onClick="javascript:openwindow16('<%=tea[i].getId()%>');return false">詳細資料</a>
		</td>
		
		
		
		<!--
		<td class=es02>
		<form action=>
			<input type=hidden name="teacherId" value="<%=tea[i].getId()%>">
			<input type=submit value="薪資明細">
		</form>
		</td>	
		
		<td class=es02>
		<form action=>
			<input type=hidden name="teacherId" value="<%=tea[i].getId()%>">
			<input type=submit value="刪除">
		</form>
		</td>	
			-->
	</tr>
<%
	}
%>
</table>	
	
</td></tr></table>

</center>
<!--- end 表單01 --->



<!--- end 主內容 --->


<%@ include file="bottom.jsp"%>	