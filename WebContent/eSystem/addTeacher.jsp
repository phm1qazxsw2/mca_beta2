<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=6;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,701))
    {
        response.sendRedirect("authIndex.jsp?code=701");
    }    
%>
<%@ include file="leftMenu6.jsp"%>
<%
    JsfAdmin ja=JsfAdmin.getInstance();
    Classes[] cl=ja.getAllActiveClasses();
%>
<script>
function doCheck(f)
{
    if (f.teacherFirstName.value.length==0 && teacherLastName.value.length==0) {
        alert("姓名不可以為空白");
        f.teacherFirstName.focus();
        return false;
    }

    return true;
}
</script>
<head>

<script language="JavaScript" src="js/calendar.js"></script>
<script language="JavaScript" src="js/overlib_mini.js"></script>
</head>

<body>

<script type="text/javascript" src="js/in.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
<script type="text/javascript" src="openWindow.js"></script>
<script type="text/javascript" src="js/highlight-active-input.js.js"></script>

<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>


<form method="post" action="addTeacher2.jsp"  name="xs" onsubmit="return doCheck(this);">


<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增<%=(pZ2.getCustomerType()==0)?"教職員":"員工"%>資料</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>

<blockquote>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1> 
	<tr align=left valign=middle><td class=es02 colspan=2 bgcolor="#4A7DBD" align=center><font color=white><b>基本資料</b></font></td></tr>
  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">姓名<font color=red>*</font></td>
    <td class=es02>
    	姓<input name="teacherFirstName" type="text" id="teacherFirstName" size="5">
        名<input name="teacherLastName" type="text" id="teacherLastName" size="10">
    </td>
  </tr>
   <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">性別</td>
    <td class=es02>
        <input type=radio name="teacherSex" value=1 id="teacherSex">男
		<input type=radio name="teacherSex" value=2 id="teacherSex" checked>女
	</td>
  </tr>
 
 
  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">英文名稱</td>
    <td class=es02>
        <input name="teacherNickname" type="text" id="teacherNickname" size="10">
	</td>
  </tr>
 
  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">身份證字號</td>
    <td class=es02>
        <input name="teacherIdNumber" type="text" id="teacherIdNumber" size="15" maxlength="10" onkeyup="up3tab(this,10,'teacherBirth');upCase2(this)">
    (線上考勤需登入身份證字號的後五碼; 薪資轉帳需要此欄位正確填寫)
      </td>
  </tr>

  <tr bgcolor=#ffffff align=left valign=middle>
  	<td class=es02 bgcolor="#f0f0f0">生日</td>
  	<td class=es02><input  class="textInput" type=text size=10 name="teacherBirth" size=10 value="1980/10/10"> 
		
	</td>
	</tr>

  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">畢業學校</td>
    <td class=es02>
        <input name="teacherSchool" type="text" id="teacherSchool">
      </td>
  </tr>
  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">手機號碼</td>
    <td class=es02>
   手機1<input name="teacherMobile" type="text" id="teacherMobile" size=15>
   
   手機2<input name="teacherMobile2" type="text" id="teacherMobile2" size=15>
   
   手機3<input name="teacherMobile3" type="text" id="teacherMobile3" size=15>
   
   </td>
  </tr>
   <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">Email</td>
    <td class=es02>
        <input name="teacherEmail" type="text" size="30" onblur="emailCheck(this)"> 
            (考勤系統可自動發送刷卡記錄到此email.) &nbsp;&nbsp;    
	</td>
  </tr>
  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">家中室內電話</td>
    <td class=es02>
        電話1
        <input name="teacherPhone" type="text" id="teacherPhone" size=15>
    	電話2
    	<input name="teacherPhone2" type="text" id="teacherPhone2" size=15>
    	電話3
    	<input name="teacherPhone3" type="text" id="teacherPhone3" size=15>
    </td>
  </tr>
  
  <tr bgcolor=#ffffff align=left valign=middle>
  
  	<td class=es02 bgcolor="#f0f0f0">地址</td>
  	<td class=es02>郵遞區號:<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="teacherZipCode" size=5>
	住址:
	 <SELECT name="address_county1"  onchange="changearea('1')" onKeyDown="if(event.keyCode==13) event.keyCode=9;">
                <OPTION value="0">請選擇</OPTION>
            <SCRIPT type="text/javascript" language="JavaScript" src="js/changearea1_1.js"> </SCRIPT>
        </SELECT> 
        <SELECT name="address_area1" onKeyDown="if(event.keyCode==13) event.keyCode=9;">
                <OPTION value="0">請選擇</OPTION>
       	    <SCRIPT type="text/javascript" language="JavaScript" src="js/changearea1_2.js"> </SCRIPT>
       </SELECT>
	<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="teacherAddress" size=30>
	</td>
	</tr>

  <tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">其他聯絡人</td>
  	<td class=es02>
	姓名:<input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="rName" size=15>
	關係:
	<%
	Relation[] ra=ja.getAllRelation(_ws.getBunitSpace("bunitId"));
	if(ra==null)
	{
		out.println("尚未加入關係");
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
	電話:<input type=text name="rPhone" size=10>	
	電話2:<input   type=text name="rPhone2" size=10>
	手機: <input  type=text name="rMobile" size=10><br>
	備註:<input type=text name="rPs" size=30>
	</td>
</tr>		
  
  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">到職日期</td>
    <td class=es02>
		<%
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
		%>

        <input name="teacherComeDate" type="text" value="<%=sdf.format(new Date())%>">
    </td>
  </tr>
	<tr align=left valign=middle><td class=es02 colspan=2 bgcolor="#4A7DBD" align=center><font color=white><b>工作設定/帳務資料</b></font></td></tr>
  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">部門</td>
    <td class=es02>
<%

    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b = bm.retrieveListX("status ='1' and flag='0'","", _ws.getBunitSpace("buId"));

    if(b !=null && b.size()>0){
%>
        <select name="bunitId" size=1>
            <option value="0" <%=(ud2.getUserBunitCard()==0)?"selected":""%>>未定</option>

<%      for(int i=0;i<b.size();i++){    
            Bunit bb=b.get(i);
%>  
            <option value="<%=bb.getId()%>" <%=(ud2.getUserBunitCard()==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
<%      }   %>
        </select>

<%  }else{  %>
    <input type=hidden name="bunitId" value="0">
<%  }   %>
    </td>
    </tr>

  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">狀態</td>
    <td class=es02>
        <input type="radio" name="teacherStatus" value="3">面試/尚未就職 
        
        <input type="radio" name="teacherStatus" value="2" checked>試用
        <input type="radio" name="teacherStatus" value="1">在職

   </td>
  </tr>
<!--
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">單位 
		<a href="#" Onclick="javascript:openwindow7('listDepart.jsp');return false">(修改)</a>
	</td>
	<td class=es02>

<%
	Depart[] de=ja.getAllDepart();
	if(de==null)
	{
		out.println("<font size=2 color=red><b>尚未加入單位</b></font>");
	}
	else
	{
	%>
	<input type=radio name="teacherDepart" value=0 checked>未定
	<%
		for(int i=0;i<de.length;i++)
		{
%>
		<input type=radio name="teacherDepart" value=<%=de[i].getId()%> onKeyDown="if(event.keyCode==13) event.keyCode=9;"><%=de[i].getDepartName()%>
<%
		}	
		
	}
	%>	
	
	</td></tr>
	
	 <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">職位
    
	<a href="#" Onclick="javascript:openwindow7('listPosition.jsp');return false">(修改)</a>
    </td>
    <td class=es02>
    <%
	Position[] po=ja.getAllPosition();
	if(po==null)
	{
		out.println("<font size=2 color=red><b>尚未設定職位</b></font>");
	}
	else
	{
	%>
		<input type=radio name="teacherPosition" value=0 checked>未定
	<%
		
		for(int i=0;i<po.length;i++)
		{
%>
		<input type=radio name="teacherPosition" value=<%=po[i].getId()%> onKeyDown="if(event.keyCode==13) event.keyCode=9;"><%=po[i].getPositionName()%>
<%
		}	
		
	}
	%>	
	
	</td></tr>	
    
    
      
  	
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">班別
	<a href="#" Onclick="javascript:openwindow7('listClass.jsp');return false">(修改)</a>
	</td>
	<td class=es02>			
	<%
	if(cl==null){
	
		out.println("<font size=2 color=red><b>尚未設定班別</b></font>");
	
	}else{
%>
		<input type=radio name="teacherClass" value="0" checked>跨班
<%	

		for(int i=0;i<cl.length;i++)
		{
		%>
		<input type=radio name="teacherClass" value=<%=cl[i].getId()%>><%=cl[i].getClassesName()%>
		
		<%
		}
	}
	%>
	</td></tr>
	
<tr bgcolor=#ffffff align=left valign=middle>
	<td class=es02 bgcolor="#f0f0f0">年級
		<a href="#" Onclick="javascript:openwindow7('listLevel.jsp');return false">(修改)</a>
	</td>
	<td class=es02>

<%
	Level[] le=ja.getAllLevel();
	if(le ==null)
	{
	
		out.println("<font size=2 color=red><b>尚未設定年級</b></font>");
	}
	else
	{
%>
		<input type=radio name="teacherLevel" value="0" checked>跨年級
<%
	
		for(int i=0;i<le.length;i++)
		{
		%>
		<input type=radio name="teacherLevel" value=<%=le[i].getId()%> onKeyDown="if(event.keyCode==13) event.keyCode=9;"><%=le[i].getLevelName()%>
		<%
		}
	}
	%>
	</font></td></tr>
-->
 <!--
 <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">聘僱方式</td>
    <td class=es02>
    	<input type=radio name="teacherParttime" value=0 checked>教職員工(正職) 
		<input type=radio name="teacherParttime" value=1>課內才藝(約聘) 
 		<input type=radio name="teacherParttime" value=2>課後才藝(約聘) 
  </td>
  </tr>
 -->

  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">薪資領取方式</td>
    <td class=es02>
    	<input type=radio name="payWay" value=0 checked>櫃臺領取
		<input type=radio name="payWay" value=1>匯款
	
  </td>
  </tr>

  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">銀行匯款帳號1</td>
    <td class=es02>
    	<input type=radio name="bankDefault" value=1 checked>預設
    銀行名稱<input type=text name="teacherBankName1" value="" size=4>
    代號<input name="teacherBank1" type="text" id="teacherBank1" size="5">
  	帳號 <input name="teacherAccountNumber1" type="text" size=20>
  	戶名<input name="teacherAccountName1" type="text" size=10>
	<br>
	<font color=red>*</font> 
	輸出薪資轉帳報表時使用，若台新銀行客戶可結合電子檔案傳輸。  </td>
  </tr>
  
  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">銀行匯款帳號2</td>
    <td class=es02>
    	<input type=radio name="bankDefault" value=2>預設
    銀行名稱<input type=text name="teacherBankName2" value="" size=4>
    代號<input name="teacherBank2" type="text" id="teacherBank1" size="5">
  	帳號<input name="teacherAccountNumber2" type="text" size=20>
  	戶名<input name="teacherAccountName2" type="text" size=10>
  </td>
  </tr>
  <tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">備註</td>
  	<td class=es02>
		<textarea name=teacherPs rows=10 cols=70></textarea>
	</td></tr>
  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 colspan=2> <center>
    
    	<input type="submit" value="新增" onClick="return(confirm('確認新增此筆資料?'))">
    </center>
    </td>
  </tr>
</table>
</td></tr></table>
</form>
</blockquote>
<%@ include file="bottom.jsp"%>