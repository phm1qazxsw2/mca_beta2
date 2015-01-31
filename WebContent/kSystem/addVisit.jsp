<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<% 
JsfAdmin ja=JsfAdmin.getInstance();
JsfTool jt=JsfTool.getInstance();
Classes[] cl=ja.getAllActiveClasses();
Degree[] degree=ja.getAllActiveDegree(_ws2.getStudentBunitSpace("bunitId"));
%>
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css> 

<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>

<%
 PaySystemMgr pmx2=PaySystemMgr.getInstance();
 PaySystem pd2=(PaySystem)pmx2.find(1);
%>
<head>
<title><%=pd2.getPaySystemCompanyName()%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">

</head> 

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onunload="henrytest()">
<table bgcolor=#ff0000 background=pic/bg01.gif width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02><img src=pic/bg01.gif border=0></td>
</tr>
</table>
<!--- start 水平列書籤式按鈕 01 --->
<table bgcolor=#696A6E width="100%" height="24" border="0" cellpadding="4" cellspacing="0">
<tr align=left valign=middle>
<td class=es02r align=right><%=pd2.getPaySystemCompanyName()%></td>
</tr>
</table>


<br>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>網路報名</b>
<br> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<form action="addVisit2.jsp" method=post name="xs" id="xs" onsubmit="return(checkX())">
<tr bgcolor=#ffffff align=left valign=middle> 
	<td class=es02 bgcolor="#f0f0f0"><font color=red>*</font>幼生姓名</td>
	<td><input type=text size=20 name="studentName" size=6></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">English Name</td>
	<td><input type=text size=20 name="studentNickname" size=6></td>
</tr>
 
<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0"><font color=red>*</font>身份證字號</td>
	<td><input type=text size=10 name="studentIDNumber" size=6  onkeyup="up3tab(this,10,'studentIDNumber');upCase2(this)"><font size=2>(含英文字共十碼)</font></td>
</tr>
	
<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">性別</td><td><input type=radio size=20 name="studentSex" value="1" checked onKeyDown="if(event.keyCode==13) event.keyCode=9;">男
 				<input type=radio size=20 name="studentSex" value="2" onKeyDown="if(event.keyCode==13) event.keyCode=9;">女</td></tr>
 				




<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">出生日期</td>
	<td>
	<input type=text size=10 name="studentBirth" size=10 value="2005/10/10"> 
	</td>
</tr>



<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">同胞人數</td>
<td>
兄<input value="0" type=text size=5 name="studentBrother" size=6>人,
姐<input value="0" type=text size=5 name="studentBigSister" size=6>人,
弟<input value="0" type=text size=5 name="studentYoungBrother" size=6>人,
妹<input value="0" type=text size=5 name="studentYoungSister" size=6>人

</td>
</tr> 
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">父親</td><td>姓名:<input type=text name="studentFather" size=6>
		職業<input type=text name="studentFathJob" size=6>
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

<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0"><font color=red>*</font>家中電話</td><td>
<input type=radio name=phoneDefault value="1" checked>(預設)
電話1<input type=text name="studentPhone" size=10><br>
<input type=radio name=phoneDefault value="2">(預設)
電話2<input type=text name="studentPhone2" size=10><br>
<input type=radio name=phoneDefault value="3">(預設)
電話3<input type=text name="studentPhone3" size=10><br>
</td>
</tr>		
<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">地址</td><td>郵遞區號:<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="studentZipCode" size=5>

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

<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">方便的聯絡時間/建議</td>
<td>
<textarea name=studentSpecial rows=10 cols=50></textarea>

</td></tr>
<%
	Date sDate=new Date();
	
	long allLong=sDate.getTime()+(long)1000*60*60*24*3; 
	
	Date xDate=new Date(allLong);	
	
	SimpleDateFormat sdfX=new SimpleDateFormat("yyyy/MM/dd");
%>

<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">預約參觀日期</td><td>
	<input type=text size=10 name="studentVisitDate" value="<%=sdfX.format(xDate)%>"> 

</td></tr>

<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">認證碼</td><td>
	<img border=0 src="image.jsp">
	<input type=text name="rand" maxlength=4 value="">
</td></tr>

<input type=hidden name="studentStatus" value="1">

<tr align=left valign=middle><td colspan=3><center><input type=submit onClick="checkYear2();checkYear7(); return(confirm('確認新增此筆資料?'))" value="新增"></center></td></tr>



</form>

</table>		
</td>
</tr>
</table>
</blockquote>

<script>
	
	   function checkX()
	   {
 
	   	 	
	   	 	  	if(document.xs.studentName.value.length ==0)
				{
					alert('請填入"幼生姓名"');
 
					document.xs.studentName.focus();	
  					return false;
  				}
  				
  				if(document.xs.studentIDNumber.value.length !=10)
				{
					alert('請填入正確的"身份證字號"');
 
					document.xs.studentIDNumber.focus();	
  					return false;
  				}
				
				if(document.xs.studentPhone.value.length ==0)
				{
					alert('請填入"家中電話"');
 
					document.xs.studentPhone.focus();	
  					return false;
  				}
  					
  				if(document.xs.rand.value.length !=4)
				{
					alert('請填入正確的"驗證碼"');
					document.xs.rand.focus();	
  					return false;
  				}
  						
  				
			return true;
 		} 	

</script>



</body>

