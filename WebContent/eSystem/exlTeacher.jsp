<%@ page language="java"  import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=6;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu6.jsp"%>
<jsp:useBean id='form' scope='request' class='web.Teacher1Form'/>
<jsp:setProperty name='form' property='*'/>
 <link rel="stylesheet" href="style.css" type="text/css">
<%

String classId2=request.getParameter("classx");
String status2=request.getParameter("status");
String level2=request.getParameter("level");	
String orderQes=request.getParameter("orderNum");
String departId2=request.getParameter("depart");
String position2=request.getParameter("position");
JsfAdmin ja=JsfAdmin.getInstance();

%>

<head>
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

</head>

<body>
<br> 

<b>&nbsp;&nbsp;&nbsp;<img src="images/excel2.gif" border=0>新增教師萬用表單</b> 

<form action=exlTeacher.jsp method=get>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;狀態:
<select name=status size=1>
	<option value="99" <%=form.getStatusSelectionAttr("99")%>>全部</option>
	<option value="1" <%=form.getStatusSelectionAttr("1")%>>在職</option>
	<option value="2" <%=form.getStatusSelectionAttr("2")%>>試用</option>
	<option value="3" <%=form.getStatusSelectionAttr("3")%>>面試</option>
	<option value="0" <%=form.getStatusSelectionAttr("0")%>>離職</option>
</select>

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

職位	
<%
	Position[] po=ja.getAllPosition();
	if(po==null)
	{
		out.println("<font size=2 color=red><b>尚未加入職位</b></font>");
	}
	else
	{
%>
	<select name="position" size=1>
		<option value="0" <%=form.getPositionSelectionAttr("0")%>>全部</option>
	<%
		for(int i=0;i<po.length;i++)
		{
	%>
			<option value=<%=po[i].getId()%> <%=form.getPositionSelectionAttr(String.valueOf(po[i].getId()))%>><%=po[i].getPositionName()%></option>
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
	<input type=submit value="查詢">
</form> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<%
int classId=0;

int level=0;
int departId=0;
int status=99;
int position=0;

if(classId2==null)
{
	out.println("<br>開始查詢!!");
	return;
}
else
{
	classId=Integer.parseInt(classId2);
	status=Integer.parseInt(status2);
	level=Integer.parseInt(level2);
	departId=Integer.parseInt(departId2);
	position=Integer.parseInt(position2);
}	

int orderNum=0;

if(orderQes!=null)
	orderNum=Integer.parseInt(orderQes);

Teacher[] st=ja.getAllTeacher(status,departId,position,classId,level,0);
//Student[] st=ja.getStudyStudents(classId,departId,level,orderNum);

if(st==null)
{
	out.println("目前沒有資料!!");
	return;
}	
%>

<form action=exlTeacher2.jsp method="post"> 

<table border=0 marginwidth="0" marginheight="0"  >
	<tr>
	<td valign="top">

<table width="350" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02 bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
		<td>
			<input type="checkbox" onClick="this.value=check(this.form.teaId)">全選
		</td>
		<td>老師姓名</td>
	</tr>	


<%
ClassesMgr cm=ClassesMgr.getInstance();
DepartMgr dm=DepartMgr.getInstance();
LevelMgr lm=LevelMgr.getInstance();
PositionMgr pm=PositionMgr.getInstance();


for(int i=0;i<st.length;i++)
{
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
	<td>
		<input type="checkbox" name="teaId" value="<%=st[i].getId()%>">
	</td>

	<td><%=st[i].getTeacherFirstName()%><%=st[i].getTeacherLastName()%>

<%

int deId=st[i].getTeacherDepart();
if(deId ==0)
{
	out.println(" ( 未定");	
}else{
	Depart dp=(Depart)dm.find(deId);
	out.println(" ( "+dp.getDepartName());
}
%>
-
<%

int poId=st[i].getTeacherPosition();
if(poId ==0)
{
	out.println(" ( 未定");	
}else{
	Position px=(Position)pm.find(poId);
	out.println(px.getPositionName());
}
%>

-
<%
		int cid=st[i].getTeacherClasses(); 
		if(cid==0)
		{
			out.println("未定");
		}
		else
		{
			Classes cla=(Classes)cm.find(cid);
			out.println(cla.getClassesName());
		}	
	     %>-
	<%
		int lid=st[i].getTeacherLevel(); 
		if(lid==0)
		{
			out.println("未定 )");
		}
		else
		{
			Level lev=(Level)lm.find(lid);
			out.println(lev.getLevelName()+" )");
		}	
	     %>
	  </td>
	
	</tr>	
<%
}
%>
	</table> 
	</td>
	</tr>
	</table>		

	</td>
	<td valign="top">

<table width="150" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02 bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
		<td>
			<input type="checkbox" onClick="this.value=check(this.form.choice)">全選
		</td>
		<td>項目</td>
	</tr>		
</tr> 

<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="1"></td><td>姓名</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="17"></td><td>性別</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="2"></td><td>身份證字號</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="3"></td><td>生日</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="4"></td><td>部門</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="5"></td><td>職位</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="6"></td><td>班別</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="7"></td><td>年級</td></tr>

<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="9"></td><td>手機</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="10"></td><td>Email</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="11"></td><td>家中電話1</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="12"></td><td>家中電話2</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="13"></td><td>家中電話3</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="14"></td><td>郵遞區號</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="15"></td><td>地址</td></tr>
<tr class=es02 bgcolor=ffffff><td><input type="checkbox" name="choice" value="16"></td><td>畢業學校</td></tr>
</table>

</td>
</tr>
</table>
	
	</td>
	<td valign="top">
	
	<%
		Date da=new Date();
	
		SimpleDateFormat sdf=new SimpleDateFormat("MM/dd");	
	%>
	<table width="300" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td class=es02 bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
		<td>標題</td>
		<td bgcolor=ffffff>
		<input type=text name="creatTitle" value="教職員萬用表單 <%=sdf.format(da)%>">
		</td>
		</tr>
		
		<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
		<td>檔名</td>
		<td bgcolor=ffffff>
		
			<input type=text name="creatFile" value="<%=da.getTime()%>">
		</td>
		</tr>
	
		<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
		<td>備註</td>
		<td bgcolor=ffffff>
			<textarea name="exlPs" rows=3 cols=20></textarea>
		</td>
		</tr> 
		<tr>
			<td colspan=2 align=middle>
				<input type=submit value="產生excel檔案">
			</tD>
		</tr>		
		</table>	
		</td>
		</tr>
		</table>	


	</td>
	</tr>
	</table>
</form>
	
</body>	




<!--- end 表單01 --->



<!--- end 主內容 --->


<%@ include file="bottom.jsp"%>	