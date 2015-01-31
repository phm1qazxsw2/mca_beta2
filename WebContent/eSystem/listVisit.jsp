<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=4;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<br>

<link rel="stylesheet" href="css/ajax-tooltip.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>

<b>&nbsp;&nbsp;&nbsp;潛在<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>名單</b>
<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=11',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
<br>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
<%
	int chooce=1;
	
	String sChooce=request.getParameter("choice");
	String pageNum=request.getParameter("pageNum");
	
	if(sChooce !=null)
		chooce=Integer.parseInt(sChooce);
		
	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	Student[] stu=ja.getNewStudent(chooce, _ws.getStudentBunitSpace("bunitId"));
	TeacherMgr tm=TeacherMgr.getInstance();
	
	if(stu ==null)
	{
%>
    <div class=es02>
    <%=(pZ2.getCustomerType()==0)?"目前沒有登入的潛在學生":"目前沒有登入的潛在客戶"%>
    </div>
<%
	}
	else
	{
	
	int pageNumber=1;
	int studentLength=stu.length;
	EsystemMgr em=EsystemMgr.getInstance();
	Esystem e=(Esystem)em.find(1);
	int pageContent=e.getEsystemStupage();
	
	if(pageNum!=null)
		pageNumber=Integer.parseInt(pageNum);
	
	int pageTotal=1;
	pageTotal=studentLength/pageContent;
	
	if(studentLength%pageContent!=0)
		pageTotal+=1;

	if(pageNumber !=1)
	{
		int lastPage=pageNumber-1;
		out.println("<a href=\"listVisit.jsp?pageNum="+lastPage+"&choice="+chooce+"\">上一頁</a>");
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
			out.println("<a href=\"listVisit.jsp?pageNum="+jx+"&choice="+chooce+"\">"+jx+"</a>");
		}
	}
	if(pageNumber !=pageTotal)
	{
		int lastPage=pageNumber+1;
		out.println("<a href=\"listVisit.jsp?pageNum="+lastPage+"&choice="+chooce+"\">下一頁</a>");
	}
	
	String d=request.getParameter("d");

	if(d !=null)
	{
%>
	<SCRIPT>
		alert('已成功修改為不入學!');
	</SCRIPT>
<%
	}

%>

<div align=right>共計: <font color=blue><b><%=studentLength%></b></font> 筆資料</div>

<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
	<td class=es02>
幼生姓名
</td>
<td class=es02>
	<%
	if(chooce ==1)
	{
	%> 
		<a href="listVisit.jsp?pageNum=<%=pageNumber%>&choice=2">登入時間<img src="images/Upicon2.gif" border=0></a>
	<%}else{%>
		<a href="listVisit.jsp?pageNum=<%=pageNumber%>&choice=1">登入時間</a>
		
	<%}%>
</td>
<td class=es02>生日</td>
<td class=es02>
<%
if(chooce==3)
{
%> 
	<a href="listVisit.jsp?pageNum=<%=pageNumber%>&choice=4">狀態<img src="images/Upicon2.gif" border=0></a>
<%}else{%>
	<a href="listVisit.jsp?pageNum=<%=pageNumber%>&choice=3">狀態<img src="images/Downicon2.gif" border=0></a>
	
<%}%>
</td>
<td class=es02>電訪時間</td>
<td class=es02>
<%
if(chooce==5)
{
%> 
	<a href="listVisit.jsp?pageNum=<%=pageNumber%>&choice=6">參觀時間<img src="images/Upicon2.gif" border=0></a>
<%}else{%>
	<a href="listVisit.jsp?pageNum=<%=pageNumber%>&choice=5">參觀時間<img src="images/Downicon2.gif" border=0></a>
	
<%}%>



</td>
<td class=es02>
<%
if(chooce==7)
{
%> 
	<a href="listVisit.jsp?pageNum=<%=pageNumber%>&choice=8">試讀日期<img src="images/Upicon2.gif" border=0></a>
<%}else{%>
	<a href="listVisit.jsp?pageNum=<%=pageNumber%>&choice=7">試讀日期<img src="images/Downicon2.gif" border=0></a>
	
<%}%>


</td>
<td class=es02></td></tr>
<%

int startRow=(pageNumber-1)*pageContent;


int endRow=startRow+pageContent;

if(endRow > studentLength)
	endRow=studentLength;

for(int i=startRow;i<endRow;i++)
{
%>
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
	<td class=es02><a href="#" onClick="javascript:openwindow14('<%=stu[i].getId()%>');return false"><%=stu[i].getStudentName()%></a></td>
	<td class=es02><%=jt.ChangeDateToString(stu[i].getCreated())%></td>
	<td class=es02><%=jt.ChangeDateToString(stu[i].getStudentBirth())%></td>
	<td class=es02><%
	 switch(stu[i].getStudentStatus())
	 {
	 	case 1: out.println("<font color=blue>參觀登記/上網登入</font>");
	 		break;
	 	case 2: out.println("<font color=blue>報名/等待入學</font>");
	 		break;
	 	case 3: out.println("<font color=red>試讀</font>");
	 		break;
	 }
	
	%> </td>
	<td class=es02>
	<%
	
	
	if(stu[i].getStudentPhoneTeacher()==0)
	{
	%>
		尚未
	<%
	}
	else
	{
		Teacher tea=(Teacher)tm.find(stu[i].getStudentPhoneTeacher());
		out.println(jt.ChangeDateToString(stu[i].getStudentPhoneDate())+"-"+tea.getTeacherFirstName()+tea.getTeacherLastName());
	}
	%>
	
	</td>
	<td class=es02>
	<%
	if(stu[i].getStudentVisitDate() ==null)
	{
		out.println("尚未預約");
	}
	else
	{
		if(stu[i].getStudentVisitTeacher()==0)
		{
			out.println("<font color=red>"+jt.ChangeDateToString(stu[i].getStudentVisitDate())+"</font>");
		}else{
			out.println(jt.ChangeDateToString(stu[i].getStudentVisitDate()));	
		}
	}
	
	
	if(stu[i].getStudentVisitTeacher()==0)
	{
		out.println("");
	}else{
		Teacher tea=(Teacher)tm.find(stu[i].getStudentVisitTeacher());
		out.println("-"+tea.getTeacherFirstName()+tea.getTeacherLastName());
	}
	%>
	</td>
	
	<td class=es02>
	<%
	if(stu[i].getStudentTryDate()==null)
	{
		out.println("尚無資料");
	}
	else
	{
		out.println("<font color=blue>"+jt.ChangeDateToString(stu[i].getStudentTryDate())+"</font>");
	}	
	
	
	%>
	
	</td>
	<td class=es02>
	<a href="#" onClick="javascript:openwindow15a('<%=stu[i].getId()%>');return false">詳細資料</a>
	|
<%
    if(checkAuth(ud2,authHa,601))
    {
%>
	<a href="deleteStudent.jsp?studentId=<%=stu[i].getId()%>" onClick="return(confirm('確認將入學狀態改為未入學?'))">改為未入學</a>
<%
    }
%>
	</td>
	</tr>
<%
	}
%>

</table>

<%
	}
%>

	
</td></tr></table>

</blockquote>
<!--- end 表單01 --->



<!--- end 主內容 --->


<%@ include file="bottom.jsp"%>	