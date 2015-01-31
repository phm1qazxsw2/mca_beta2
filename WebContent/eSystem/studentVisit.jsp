<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
	JsfAdmin ja=JsfAdmin.getInstance();
	
	JsfTool jt=JsfTool.getInstance();
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.findX(studentId, _ws2.getStudentBunitSpace("bunitId")); 

    if (stu==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }
    
	Classes[] cl=ja.getAllActiveClasses();	
%>	
<script type="text/javascript" src="js/in.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
<script type="text/javascript" src="openWindow.js"></script>

<link rel="stylesheet" href="css/ajax-tooltip.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>


&nbsp;&nbsp;&nbsp;學生:<font color=blue><%=stu.getStudentName()%></font> -<img src="pic/fix.gif" border=0>入園資訊<br><br>
&nbsp;&nbsp;&nbsp;<a href="modifyStudent.jsp?studentId=<%=stu.getId()%>">基本資料</a> |   
<a href="studentContact.jsp?studentId=<%=stu.getId()%>">聯絡資訊</a>  | 
<a href="studentStatus.jsp?studentId=<%=stu.getId()%>">就學狀態</a>  |
<a href="studentStuff.jsp?studentId=<%=stu.getId()%>">學用品規格</a> | 
<!-- <a href="studentTadent.jsp?studentId=<%=stu.getId()%>">才藝班紀錄</a> | -->
<a href="studentSuggest.jsp?studentId=<%=stu.getId()%>">電訪/反應事項</a> |
 入學資訊</a>
  <br>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<form action="studentModifyVisit.jsp" method="post">
<center>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr align=left valign=middle bgcolor=ffffff><td colspan=6 class=es02 align=middle><b>參 觀 資 訊</b></td></tr>
</td></tr>	
<tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>帶領參觀人員</td>
<td>
<%

	Teacher[] tea=ja.getActiveTeacher(1);


	if(tea==null)
	{
		out.println("尚未登入老師資料!");
	}
	else
	{
	%>
		<select size=1 name="studentVisitTeacher">
			<option value=0 <%=(stu.getStudentVisitTeacher()==0)?"selected":""%>>尚無</option>
			<%
				for(int i=0;i<tea.length;i++)
				{
			%>
					<option value="<%=tea[i].getId()%>" <%=(tea[i].getId()==stu.getStudentVisitTeacher())?"selected":""%>><%=tea[i].getTeacherFirstName()%><%=tea[i].getTeacherLastName()%></option>	
			<%
			}
		out.println("</select>");
	}
	%>

</td></tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>參觀日期</td>
	<td>
	<%
	String visitDate="";
	if(stu.getStudentVisitDate()!=null)
	{
		visitDate=jt.ChangeDateToString(stu.getStudentVisitDate());
	}
	%>

	<input  class="textInput" type=text size=10 name="studentVisitDate" size=10 value="<%=visitDate%>"> 

	ex:095/03/10  

	<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=7',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
	
	</td>
</tr>
<%
String tryDate="";
if(stu.getStudentTryDate()!=null)
{
	tryDate=jt.ChangeDateToString(stu.getStudentTryDate());
}
%>

<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>預定試讀日期</td>
	<td>
		<input  class="textInput" type=text size=10 name="studentTryDate" size=10 value="<%=tryDate%>"> 
		ex:095/03/10   

		<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=7',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
	</td>
</tr>
<tr align=left valign=middle bgcolor=ffffff>
	<td colspan=2 class=es02 align=middle><b>入 學 電 訪 資 訊</b></td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>電訪老師</td>
	<td>
<%
	if(tea==null)
	{
		out.println("尚未登入老師資料!");
	
	
	}
	else
	{
	%>
		<select size=1 name="studentPhoneTeacher">
		
		<option value=0>無</option>
	<%
		for(int i=0;i<tea.length;i++)
		{
	%>
			<option value="<%=tea[i].getId()%>" <%=(tea[i].getId()==stu.getStudentPhoneTeacher())?"selected":""%>><%=tea[i].getTeacherFirstName()%><%=tea[i].getTeacherLastName()%></option>	
	
	<%
		}
		
		out.println("</select>");
	}
	%>
	</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>電訪日期</td>
<%
String phoneDate="";
if(stu.getStudentPhoneDate()!=null)
	phoneDate=jt.ChangeDateToString(stu.getStudentPhoneDate());

%>
	<td>
		<input  class="textInput" type=text size=10 name="studentPhoneDate" value="<%=phoneDate%>" size=10> 
			ex:095/03/10  
			<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=7',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
	</td>
	</tr>
<tr align=left valign=middle bgcolor=ffffff>
	<td colspan=2 class=es02 align=middle><b>入 學 相 關 資 訊</b></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>接送方式</td>
	<td class=es02>
		<input type="radio" name="studentGohome" value="0" <%=(stu.getStudentGohome()==0)?"checked":""%>>尚未填入
		<input type="radio" name="studentGohome" value="1" <%=(stu.getStudentGohome()==1)?"checked":""%>>自接送
		<input type="radio" name="studentGohome" value="2" <%=(stu.getStudentGohome()==2)?"checked":""%>>乘坐娃娃車
	</td>
	</tr>
<tr bgcolor=#ffffff align=left valign=middle class=es02>
	<td  bgcolor=#f0f0f0  class=es02>是否曾經上學</td>
	<td>
		<input type="radio" name="studentSchool" value="0" <%=(stu.getStudentSchool()==0)?"checked":""%>>否
		<input type="radio" name="studentSchool" value="1" <%=(stu.getStudentSchool()==1)?"checked":""%>>是
	</td></tr>

<tr bgcolor=#ffffff align=left valign=middle class=es02>
	<td  bgcolor=#f0f0f0  class=es02>學生特殊狀況</td>
	<td>
		<textarea  class="textInput" name="studentSpecial" rows=10 cols=50><%=stu.getStudentSpecial()%></textarea>
	</td>
</tr>
<%
    if(checkAuth(ud2,authHa,601))
    {
%>
<tr bgcolor=ffffff>
	<td colspan=2 align=middle>
		<input type=hidden name="studentId" value="<%=studentId%>">

		<input type=submit value="修改" onsubmit="return conform('確認修改入學資訊?')">

	</td>
</tr>
<%
    }else{
%>
<tr bgcolor=ffffff class=es02>
	<td colspan=2 align=middle>
	    
        沒有修改權限,系統代碼:601
	</td>
</tr>

<%  }   %>

</table>
</td>
</tr>
</table>	
</center>
</form>
<br>
<br>
<script>
    top.nowpage=6;
</script>