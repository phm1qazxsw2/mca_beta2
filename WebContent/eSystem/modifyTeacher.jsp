<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    if(!checkAuth(ud2,authHa,700))
    {
        response.sendRedirect("authIndex.jsp?code=700");
    }
 	int teacherId=Integer.parseInt(request.getParameter("teacherId"));
 
 	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
 
	TeacherMgr tm=TeacherMgr.getInstance();
	Teacher tea=(Teacher)tm.find(teacherId); 
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");	
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
<script type="text/javascript" src="js/in.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
<script type="text/javascript" src="openWindow.js"></script>
<script type="text/javascript" src="js/highlight-active-input.js"></script>
<script> 
	
	function goReload()
	{ 
		 window.location.reload();
	}

</script>

<table width="100%" height="" border="0" cellpadding="8" cellspacing="0">
<tr align=left valign=top>
<td class=es02>
<%=(pd2.getCustomerType()==0)?"老師":"員工"%>: <font color=blue><b><%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></b></font>-<b>&nbsp;&nbsp;&nbsp;基本資料</b><br><br>
基本資料 | 
<a href="modifyTeacherWork.jsp?teacherId=<%=tea.getId()%>">工作設定</a> | 
<a href="modifyTeacherFee.jsp?teacherId=<%=tea.getId()%>">勞健保設定</a> |
<a href="modifyTeacherAccount.jsp?teacherId=<%=tea.getId()%>">帳務資料</a>
<% if (pd2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) { %>
| <a href="modifyTeacherUser.jsp?teacherId=<%=tea.getId()%>">登入設定</a>
| <a href="modify_outsourcing.jsp?teacherId=<%=tea.getId()%>">派遣對象</a>
<% } %>
<% if (pd2.getCardread()!=0) { %>
| <a href="modifyTeacherCard.jsp?teacherId=<%=tea.getId()%>">感應卡設定</a>
<%  }   %>

<!--
<%
	if(ud2.getUserRole()<=2) 
	{ 
%>
 | <a href="listTeacherSalary.jsp?teacherId=<%=tea.getId()%>">薪資明細</a>
<%
	}
%>
-->
</td>
</tr>
</table>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<form method="post" action="modifyTeacher2.jsp" name="xs" onsubmit="return doCheck(this);">
<table width="100%" border=0 cellpadding=4 cellspacing=1>

  <tr bgcolor=#ffffff align=left valign=middle>  
        <td colspan=2 align=middle>
    <%
    if(checkAuth(ud2,authHa,701)){
    %>    
        <center>
    	<input type=hidden name="teacherId" value="<%=tea.getId()%>">    
    	<input type="submit" value="確認修改">
        </center>
    <%  }else{  %>
            沒有修改權限,系統代碼:701

    <%  }   %>
        </td>
  </tr>
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0" width=20%>姓名<font color=red>*</font> </td>
    <td class=es02>
    姓<input name="teacherFirstName" type="text" id="teacherFirstName" size="5" value="<%=tea.getTeacherFirstName()%>">
    名<input name="teacherLastName" type="text" id="teacherLastName" size="10" value="<%=tea.getTeacherLastName()%>">
    </td>
  </tr>
  
     <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0">性別</td>
    <td class=es02>
        <input type=radio name="teacherSex" value=1 id="teacherSex" <%=(tea.getTeacherSex()==1)?"checked":""%>>男
	<input type=radio name="teacherSex" value=2 id="teacherSex" <%=(tea.getTeacherSex()==2)?"checked":""%>>女
</td>
  </tr>
 
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0">暱稱</td>
    <td class=es02>
        <input name="teacherNickname" type="text" id="teacherNickname" size="10" value="<%=tea.getTeacherNickname()%>">
</td>
  </tr>
 
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0">身份證字號</td>
    <td class=es02>
        <input name="teacherIdNumber" type="text" id="teacherIdNumber" size="15" maxlength="10" value="<%=tea.getTeacherIdNumber()%>" onkeyup="up3tab(this,10,'teacherBirth')"><br>(線上考勤需登入身份證字號的後五碼; 薪資轉帳需要此欄位正確填寫) 
      </td>
  </tr>
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0">生日</td>
    <td class=es02>
        <input name="teacherBirth" type="text" id="teacherBirth" size="10" value="<%=(tea.getTeacherBirth()!=null)?sdf.format(tea.getTeacherBirth()):""%>">ex: 1980/10/10
      </td>
  </tr>
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0">畢業學校</td>
    <td class=es02>
        <input name="teacherSchool" type="text" id="teacherSchool" value="<%=tea.getTeacherSchool()%>">
      </td>
  </tr>
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0">手機</td>
    <td class=es02>
        <input name="teacherMobile" type="text" id="teacherMobile" value="<%=tea.getTeacherMobile()%>" size=15>
   	手機2<input name="teacherMobile2" type="text" id="teacherMobile2" value="<%=tea.getTeacherMobile2()%>" size=15>
   	手機3<input name="teacherMobile3" type="text" id="teacherMobile3" value="<%=tea.getTeacherMobile3()%>" size=15>
   </td>
  </tr>
   <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0">Email</td>
    <td class=es02>
        <input name="teacherEmail" type="text" size="30" value="<%=tea.getTeacherEmail()%>" onblur="emailCheck(this)">(考勤系統可自動發送刷卡記錄到此email.)    
</td>
  </tr>
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0">家中電話</td>
    <td class=es02>
        <input name="teacherPhone" type="text" id="teacherPhone" value="<%=tea.getTeacherPhone()%>" size=15>
        家中電話2
    	<input name="teacherPhone2" type="text" id="teacherPhone2" size=15 value="<%=tea.getTeacherPhone2()%>">
    	家中電話3
    	<input name="teacherPhone3" type="text" id="teacherPhone3" size=15 value="<%=tea.getTeacherPhone3()%>">
    </td>
  </tr>
  
   <tr bgcolor=#ffffff align=left valign=middle> <td class=es02 bgcolor="#f0f0f0">地址</td>
   <td  class=es02>郵遞區號:<input  class="textInput" value="<%=tea.getTeacherZipCode()%>" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="teacherZipCode" size=5>

	住址:
	
	<input  class="textInput" value="<%=tea.getTeacherAddress()%>" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text name="teacherAddress" size=30></td></tr>
  </tr>		

  <input type=hidden name="teacherComeDate" value="<%=(tea.getTeacherComeDate()!=null)?sdf.format(tea.getTeacherComeDate()):""%>">
<%

Relation[] ra=ja.getAllRelation(_ws2.getStudentBunitSpace("bunitId"));
Tcontact[] cons=ja.getAllTcontact(teacherId);
if(cons!=null)
{
	for(int i=0;i<cons.length;i++)
	{
%>

<tr bgcolor=#ffffff align=left valign=middle> <td class=es02 bgcolor="#f0f0f0">其他聯絡人 <%=i+1%>
<font size=2>
<a href="#" Onclick="javascript:openwindow10('<%=cons[i].getId()%>');return false">修改</a>
</font>
</td><td class=es02>
	姓名:<input type=text name="rName" size=15 value="<%=cons[i].getTcontactName()%>">
	關係:
	<%
	int raId=cons[i].getTcontactReleationId();
	
	if(ra==null)
	{
		out.println("尚未加入關係");
	}
	else
	{
%>
		<select name="rRelation" size=1>	
<%	
		for(int j=0;j<ra.length;j++)
		{
%>
		<option value="<%=ra[j].getId()%>" <%=(raId==ra[j].getId()?"selected":"")%>><%=ra[j].getRelationName()%></option>
	
<%
		}	
		out.println("</select>");
	}
	%>	
	<br>
	<font size=2>
	電話:<input type=text name="rPhone" size=10 value="<%=cons[i].getTcontactPhone1()%>">	
	電話2:<input type=text name="rPhone2" size=10 value="<%=cons[i].getTcontactPhone2()%>">
	手機: <input type=text name="rMobile" size=10 value="<%=cons[i].getTcontactMobile()%>">
	<br>
	備註:<input type=text name="rPs" size=30 value="<%=cons[i].getTcontactPs()%>">  
	
	
	</td>
</tr>		
<%
	}
}

if(checkAuth(ud2,authHa,701)){
    %>  
<tr bgcolor=#ffffff align=left valign=middle> <td class=es02 bgcolor="#f0f0f0"></td><td class=es02>
<a href="#" Onclick="javascript:openwindow11('<%=teacherId%>');return false"><img src="pic/add.gif" border=0 width=12>&nbsp;新增其他聯絡人</a>
</td>
</tr>
    <%  }   %>		
  <tr bgcolor=#ffffff align=left valign=middle> 
  	<td class=es02 bgcolor="#f0f0f0">備註</td>
  	<td>
		<textarea name=teacherPs rows=10 cols=50><%=tea.getTeacherPs()%></textarea>
	</td></tr>
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td colspan=2 class=es02 align=middle> 
    <%
    if(checkAuth(ud2,authHa,701)){
    %>    
        <center>
    	<input type=hidden name="teacherId" value="<%=tea.getId()%>">    
    	<input type="submit" value="確認修改">
        </center>
    <%  }else{  %>
            沒有修改權限,系統代碼:701

    <%  }   %>
    </td>
  </tr>
</table>
</td></tr></table>
</form>
</blockquote> 

<br>
<br>
<script>
    top.nowpage=1;
</script>
