<%@ page language="java"  import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<html>
<%
 PaySystemMgr pmx2=PaySystemMgr.getInstance();
 PaySystem pd2=(PaySystem)pmx2.find(1);

%>
<head>
<title><%=pd2.getPaySystemCompanyName()%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">
<link href=ft02.css rel=stylesheet type=text/css>
<script type="text/javascript" src="openWindow.js"></script>
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table bgcolor=#ff0000 background=pic/bg01.gif width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02><img src=pic/bg01.gif border=0></td>
</tr>
</table>


<!--- start 水平列書籤式按鈕 01 --->
<table bgcolor=#696A6E width="100%" height="24" border="0" cellpadding="4" cellspacing="0">
<tr align=left valign=middle>
<td class=es02r><%=pd2.getPaySystemCompanyName()%></td>
</tr>
</table>
<!--- end 水平列書籤式按鈕 01 ---> 

<%
JsfAdmin ja=JsfAdmin.getInstance();
JsfTool jt=JsfTool.getInstance();
Classes[] cl=ja.getAllActiveClasses();
Degree[] degree=ja.getAllActiveDegree(_ws2.getStudentBunitSpace("bunitId"));
%>


<style>
fieldset {
  width: 350px;
}

.textInput,textarea {
 
  font-family: arial;
  background-color: #FFFFFF;
  border: 1px solid #000;
}

.inputHighlighted {
  background-color: #FFCE31;
  color: #000;
  border: 1px solid #000;
}


</style>

</head>


<script language="JavaScript" src="js/calendar.js"></script>
<script language="JavaScript" src="js/overlib_mini.js"></script>
<script language="JavaScript" src="js/in.js"></script>


<body>
<blockquote>

<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>


<br>
<b><<新增參觀學生>></b>
<br>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1> 

<form action="addVisitNotLog2.jsp" method=post name="xs">

<tr bgcolor=#ffffff align=left valign=middle> 
	<td class=es02 bgcolor="#f0f0f0">幼生姓名</td>
	<td><input class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text size=20 name="studentName" size=6></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">English Name</td>
	<td><input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text size=20 name="studentNickname" size=6></td>
</tr>
 
<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">身份證字號</td>
	<td><input  class="textInput" type=text size=20 name="studentIDNumber" size=6><font size=2>(含英文字共十碼)</font></td>
</tr>
	
<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">性別</td><td><input type=radio size=20 name="studentSex" value="1" checked onKeyDown="if(event.keyCode==13) event.keyCode=9;">男
 				<input type=radio size=20 name="studentSex" value="2" onKeyDown="if(event.keyCode==13) event.keyCode=9;">女</td></tr>
 				




<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">出生年月</td>
	<td><input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text size=10 name="studentBirth" size=10> 
<a href="javascript:show_calendar('xs.studentBirth');" onMouseOver="window.status='選擇日曆上的日期.'; overlib('選擇日曆上的日期.'); return true;" onMouseOut="window.status=''; nd(); return true;"><img src="images/show-calendar.gif" width=24 height=22 border=0></a>
<font size=2>

ex:2006/10/10  
</td></tr>



<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">同胞人數</td>
<td>
兄<input  class="textInput" value="0" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text size=5 name="studentBrother" size=6 onkeyup="up3tab(this,10,'studentBirth');upCase1(this)">人,
姐<input  class="textInput" value="0" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text size=5 name="studentBigSister" size=6 onkeyup="up3tab(this,10,'studentBirth');upCase1(this)">人,
弟<input  class="textInput" value="0" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text size=5 name="studentYoungBrother" size=6 onkeyup="up3tab(this,10,'studentBirth');upCase1(this)">人,
妹<input  class="textInput" value="0" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text size=5 name="studentYoungSister" size=6 onkeyup="up3tab(this,10,'studentBirth');upCase1(this)">人

</td>
</tr> 
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">父親</td><td>姓名:<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentFather" size=6>
		職業<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentFathJob" size=6>
		教育程度
		<%
		if(degree==null)
		{
		%>
			請先設定教育程度
		<%
		}
		else
		{
		%>
			<select name=studentFatherDegree size=1>
			<%
				for(int j=0;j<degree.length;j++)
				{
			%>
				<option value="<%=degree[j].getId()%>"><%=degree[j].getDegreeName()%>
			<%
				}
			%>
			</select>
		<%
		}
		%>		
		<br>
		<input type=radio name=emailDefault value="1" checked>(預設)
		email <input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentFatherEmail" size=30 onblur="emailCheck(this)">
		<br>
		<input type=radio name=mobileDefault value="1" checked>(預設)
		手機1<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentFatherMobile" size=10 onkeyup="up3tab(this,10,'studentFatherMobile2')">
		<input type=radio name=mobileDefault value="2">(預設)
		手機2<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentFatherMobile2" size=10 onkeyup="up3tab(this,10,'fatherSkype')">
		<br>
		<input type=radio name=skypeDefault value="1" checked>(預設)
		Skype ID <input type=text  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" name="fatherSkype" size=10 onkeyup="up3tab(this,10,'studentMother')">
		
		</td></tr>
<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">母親</td>
	<td>姓名:<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentMother" size=6>
		職業<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentMothJob" size=6>
		教育程度
		
		<%
		if(degree==null)
		{
		%>
			請先設定教育程度
		<%
		}
		else
		{
		%>
			<select name=studentMothDegree size=1>
			<%
				for(int j=0;j<degree.length;j++)
				{
			%>
				<option value="<%=degree[j].getId()%>"><%=degree[j].getDegreeName()%>
			<%
				}
			%>
			</select>
		<%
		}
		%>		
		<br>
		<input type=radio name=emailDefault value="2">(預設)
		email <input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentMotherEmail" size=30 onblur="emailCheck(this)">	
		<br>
		<input type=radio name=mobileDefault value="3">(預設)
		手機1 <input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentMotherMobile" size=10 onkeyup="up3tab(this,10,'studentMotherMobile2')">
		<input type=radio name=mobileDefault value="4">(預設)
		手機2 <input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentMotherMobile2" size=10 onkeyup="up3tab(this,10,'motheSkype')">
		<br>
		<input type=radio name=skypeDefault value="2">(預設)
		Skype ID <input type=text  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" name="motheSkype" size=10 onkeyup="up3tab(this,10,'studentPhone')">			
		</td></tr>
<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">其他聯絡人</td><td>
	姓名:<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="rName" size=15>
	<br>
	關係:
	<%
	Relation[] ra=ja.getAllRelation(_ws2.getStudentBunitSpace("bunitId"));
	if(ra==null)
	{
		out.println("<font size=2 color=red><b>尚未加入關係</b></font>");
	}
	else
	{
%>
		
		<select name="rRelation" size=1 onKeyDown="if(event.keyCode==13) event.keyCode=9;">	
<%	
		for(int i=0;i<ra.length;i++)
		{
%>
		<option value="<%=ra[i].getId()%>"><%=ra[i].getRelationName()%></option>
	
<%
		}	
		out.println("</select>");
	}
	%>	
	
	<font size=2>
	<a href="#" Onclick="javascript:openwindow7('listRelation.jsp');return false">修改</a></font><br>
	電話:<input  type=text name="rPhone" size=10>	
	電話2:<input type=text name="rPhone2" size=10>
	手機: <input type=text name="rMobile" size=10><br>
	備註:<input type=text name="rPs" size=30>
	</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">家中電話</td><td>
<input type=radio name=phoneDefault value="1" checked>(預設)
家中電話1<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentPhone" size=10><br>
<input type=radio name=phoneDefault value="2">(預設)
家中電話2<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentPhone2" size=10><br>
<input type=radio name=phoneDefault value="3">(預設)
家中電話3<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentPhone3" size=10><br>
</td>
</tr>		
<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">地址</td><td>郵遞區號:<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentZipCode" size=5><a href="http://www.post.gov.tw/post/internet/f_searchzone/index.jsp?ID=190102" target="_blank" onKeyDown="if(event.keyCode==13) event.keyCode=9;"><font size=2>查詢</font></a> 

	住址: 
	 <SELECT name="address_county1"  onchange="changearea('1')" onKeyDown="if(event.keyCode==13) event.keyCode=9;">
                <OPTION value="0">請選擇</OPTION>
            <SCRIPT type="text/javascript" language="JavaScript" src="js/changearea1_1.js"> </SCRIPT>
            </SELECT> 
                            <SELECT name="address_area1" onKeyDown="if(event.keyCode==13) event.keyCode=9;">
                <OPTION value="0">請選擇</OPTION>
            <SCRIPT type="text/javascript" language="JavaScript" src="js/changearea1_2.js"> </SCRIPT>
            </SELECT>
	<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentAddress" size=30></td></tr>



<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">接送方式</td>
	<td>
	<input type="radio" name="studentGohome" value="1" checked>自接送
	<input type="radio" name="studentGohome" value="2">乘坐娃娃車
	</td></tr>
<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">是否曾經上學</td>
	<td>
	<input type="radio" name="studentSchool" value="0" checked>否
	<input type="radio" name="studentSchool" value="1">是
	</td></tr>

<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">幼兒特殊狀況</td>
<td>
<textarea  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" name=studentSpecial rows=10 cols=70></textarea>

</td></tr>


<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">預約參觀日期</td><td>
<input  class="textInput" type=text size=10 name="studentVisitDate" size=10  onkeyup="up2tab(this)"> 
<a href="javascript:show_calendar('xs.studentVisitDate');" onMouseOver="window.status='選擇日曆上的日期.'; overlib('選擇日曆上的日期.'); return true;" onMouseOut="window.status=''; nd(); return true;"><img src="images/show-calendar.gif" width=24 height=22 border=0></a>
<font size=2>
ex:2006/10/10  
</td></tr>

<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">目前狀態</td><td class=es02 colspan=2>
			<input type=radio name="studentStatus" value=1 checked>參觀登記
			<input type=radio name="studentStatus" value=2>報名/等待入學
			<input type=radio name="studentStatus" value=3>試讀
			
	</td></tr>


<tr bgcolor=#ffffff align=left valign=middle><td colspan=3><center><input type=submit onClick="checkYear2();checkYear7(); return(confirm('確認新增此筆資料?'))" value="填寫完畢"></center></td></tr>



</form>





</table>		


</td>
</tr>
</table>
</blockquote>


<script language="JavaScript">
<!--
  initInputHighlightScript();
	document.xs.studentName.focus();
//-->
</script>
</body>

