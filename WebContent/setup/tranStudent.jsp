<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%> 
<%@ include file="jumpTop.jsp"%>
<jsp:useBean id='form' scope='request' class='web.Student1Form'/>
<jsp:setProperty name='form' property='*'/>
<link rel="stylesheet" href="style.css" type="text/css">
<%

String departId2=request.getParameter("depart");
String classId2=request.getParameter("classx");
String level2=request.getParameter("level");	
String orderQes=request.getParameter("orderNum");
String pageNum=request.getParameter("pageNum");

JsfAdmin ja=JsfAdmin.getInstance();
JsfTool jt=JsfTool.getInstance();

%>


<br>
<b>&nbsp;&nbsp;&nbsp;團體轉班</b>
<br>
<blockquote>
<form action=tranStudent.jsp method=get>
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
		<option value="0" <%=form.getDepartSelectionAttr("0")%>>全部</option>
	<%
		for(int i=0;i<de.length;i++)
		{
	%>
			<option value=<%=de[i].getId()%> <%=form.getDepartSelectionAttr(String.valueOf(de[i].getId()))%>><%=de[i].getDepartName()%></option>
	<%
		}
	%>
	</select>
<%
	}
%>	
年級:
<%
	Level[] le=ja.getAllLevel();
	if(le ==null)
	{
	
		out.println("<font size=2 color=red><b>尚未設定年級</b></font>");
	}
	else
	{
%>	
		<select name="level" size=1>
		<option value="0" <%=form.getLevelSelectionAttr("0")%>>全部</option>	
	<%
		for(int i=0;i<le.length;i++)
		{
	%>
		<option value=<%=le[i].getId()%> <%=form.getLevelSelectionAttr(String.valueOf(le[i].getId()))%>><%=le[i].getLevelName()%></option>
		
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
	<option value="0" <%=form.getClassxSelectionAttr("0")%>>全部</option>
		<%
		for(int i=0;i<cl.length;i++)
		{
		%>
		<option value=<%=cl[i].getId()%> <%=form.getClassxSelectionAttr(String.valueOf(cl[i].getId()))%>><%=cl[i].getClassesName()%></option>
		<%
		}
		%>
		<option value="999" <%=form.getClassxSelectionAttr("999")%>>未定</option>
	</select>
<%
	}	
	
	
%>

	<input type=submit value="查詢">
</form>

</blockquote>
 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<SCRIPT LANGUAGE="JavaScript">
<!-- Modified By:  Steve Robison, Jr. (stevejr@ce.net) -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var checkflag = "false";
function check(field) {
if (checkflag == "false") {
for (i = 0; i < field.length; i++) {
field[i].checked = true;}
checkflag = "true";
return "Uncheck All"; }
else {
for (i = 0; i < field.length; i++) {
field[i].checked = false; }
checkflag = "false";
return "Check All"; }
}
//  End -->
</script>

<%
int classId=0;

int level=0;
int departId=0;
int pageNumber=1;

if(classId2==null)
{
	out.println("<br>開始查詢!!");
	return;
}
else
{
	classId=Integer.parseInt(classId2);
	
	level=Integer.parseInt(level2);
	departId=Integer.parseInt(departId2);
}	


	
int orderNum=0;

if(orderQes!=null)
	orderNum=Integer.parseInt(orderQes);
		
	
Student[] st=ja.getStudyStudents(classId,departId,level,orderNum);

if(st==null)
{
	out.println("沒有學生!!");
	return;
}	

int studentLength=st.length;
%>
 
 
 

<script>
	function  go(status)
	{ 
 
 
		<% 
			String outWord="尚未設定";
			LeaveReason[] lr=ja.getActiveLeaveReason();
			if(lr !=null)
 
			{  
				outWord="<select name=rlId size=1>"
; 
				
				for(int k=0;k<lr.length;k++)	
					outWord+="<option value="+lr[k].getId()+">"+lr[k].getLeaveReasonName()
+"</option>"; 
				
				outWord+="</select>";	
			} 

		%>
				
		if(status>=97 && status<999)
 
		{ 
 
			showType.innerHTML="離校原因";
			show.innerHTML="<%=outWord%>"; 
			psType.innerHTML="離校備註";
			ps.innerHTML="<textarea name='leavePs' rows=3 cols=20></textarea>"; 

		}else{
			showType.innerHTML="";
			show.innerHTML=""; 
 
			psType.innerHTML="";
			ps.innerHTML=""; 

		}
	}
</script>
<form action="tranStudent2.jsp" method="post">
<center>
<table border=0 width=90%>
<tr>
	<tD width=60% valign=top> 

		<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
		<tr align=left valign=top>
		<td bgcolor="#e9e3de">
		
		<table width="100%" border=0 cellpadding=4 cellspacing=1>
			<tr bgcolor=#f0f0f0 class=es02>
				<td>資料比數</td>
				<tD bgcolor=ffffff><%=studentLength%></tD>
			</tr>
			<tr bgcolor=#f0f0f0 class=es02>
				<td>學生姓名<br>
					<input type="checkbox" onClick="this.value=check(this.form.stuId)">全選
				</td>
				<td bgcolor=ffffff>
				<%
				for(int i=0;i<studentLength;i++)
				{
				%>
					<input type=checkbox name="stuId" value="<%=st[i].getId()%>"><a href="#" onClick="javascript:openwindow15('<%=st[i].getId()%>');return false"><%=st[i].getStudentName()%></a>
				<%
 
					int j=i+1;
					if(j>5 && j%6==0)
 
						out.println("<br>");	
				
				}
				%>
				</td>	
			</tr>
		</table>
		</td>
		</tr>
		</table>

	</tD>
	<td width="5%">-></td>
 
	<tD width="25%" align=lrft valign=top>
		
			<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
			<tr align=left valign=top>
			<td bgcolor="#e9e3de">
			
			<table width="100%" border=0 cellpadding=4 cellspacing=1>
			<tr bgcolor=#f0f0f0 class=es02>
				<td>修改</tD>
				<tD>選項</tD> 
 	
			</tr>
			<tr bgcolor=ffffff class=es02>
				<tD>狀態</tD> 
				<tD>
					<select name="status" size=1 onChange="go(this.value)">
						<option value="999" selected>不更動</option>
 
						<option value="3">試讀</option>
						<option value="4">在學</option>
						<option value="97">離校</option>
						<option value="99">畢業</option>
					</select>
				</tD>
			</tR>
			<tr bgcolor=ffffff class=es02>
				<tD>部門</tD> 
				<tD>
				<select name="depart" size=1>
					<option value="999" selected>不更動</option>
					<%
					if(de !=null)
 
					{ 
						for(int i=0;i<de.length;i++)
						{
					%>
							<option value=<%=de[i].getId()%>>轉為-><%=de[i].getDepartName()%></option>
					<%
						}
					}
					%>
						<option value="0">轉為->未定</option>
					</select>
				</tD>
			</tR>
			<tr bgcolor=ffffff class=es02>
				<tD>年級</tD> 
				<tD>
					<select name="level" size=1>
						<option value="999" selected>不更動</option>	
					<%
					if(le !=null)
 
					{ 
						for(int i=0;i<le.length;i++)
						{
					%>
						<option value=<%=le[i].getId()%>>轉為-><%=le[i].getLevelName()%></option>
					<%
						}
					}
					%>
 
						<option value="0">轉為->未定</option>
						</select>
				</tD>
			</tR> 
			<tr bgcolor=ffffff class=es02>
				<tD>班級</tD> 
				<tD>
				<select name="classx" size=1>
 
				
					
					<option value="999" selected>不更動</option>
					<%
 
					if(cl !=null)
  					{
	 					for(int i=0;i<cl.length;i++)
						{
						%>
						<option value=<%=cl[i].getId()%>>轉為-><%=cl[i].getClassesName()%></option>
					<%
						}
					}
					%>
					<option value="0">轉為->未定</option>
				</select>
				</tD>
			</tR> 
 
			<tr bgcolor=ffffff class=es02>
				<td id=showType></tD>
				<tD id=show></tD>
			</tr>			
			<tr bgcolor=ffffff class=es02>
				<td id=psType></tD>
				<tD id=ps></tD>
			</tr>	
		</table> 
		</tD>
		</tr>
		</table>
		
		<br>
		
		</tD>
   	</tr>
	<tr>
		<td colspan=3>
			<centeR>
			<input type=submit value="執行轉班" onClick="return(confirm('確認執行轉班?'))">
 
			</center>
		</tD>
	</tR>
   	</table>
  
 </center> 
   	<br>
   	<br>
  </form> 	


