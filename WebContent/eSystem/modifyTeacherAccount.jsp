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
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");	

%>


<script type="text/javascript" src="js/in.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
<script type="text/javascript" src="openWindow.js"></script>
<script type="text/javascript" src="js/highlight-active-input.js"></script>
<script>
    function dosubmit(f)
    {

    }
</script>

<table width="100%" height="" border="0" cellpadding="8" cellspacing="0">
<tr align=left valign=top>
<td class=es02>

<%=(pd2.getCustomerType()==0)?"老師":"員工"%>:<font color=blue><b><%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></b></font><br><br>
<a href="modifyTeacher.jsp?teacherId=<%=tea.getId()%>">基本資料</a>
 | 
<a href="modifyTeacherWork.jsp?teacherId=<%=tea.getId()%>">工作設定</a>
 | 
<a href="modifyTeacherFee.jsp?teacherId=<%=tea.getId()%>">勞健保設定</a> |
帳務資料
<% if (pd2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) { %>
| <a href="modifyTeacherUser.jsp?teacherId=<%=tea.getId()%>">登入設定</a>
| <a href="modify_outsourcing.jsp?teacherId=<%=tea.getId()%>">派遣對象</a>
<% } %>
<% if (pd2.getCardread()!=0) { %>
| <a href="modifyTeacherCard.jsp?teacherId=<%=tea.getId()%>">感應卡設定</a>
<%  }   %>

<!--
<%
    if(AuthAdmin.authPage(ud2,3))
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
<br> 

<b>&nbsp;&nbsp;&nbsp;帳務資料</b>
<blockquote>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<form method="post" action="modifyTeacherAccount2.jsp" name="xs" onsubmit="return dosubmit(this)">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
 
<%
	int bankDefaultx=tea.getTeacherAccountDefaut();

%>
<!--
 <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">聘僱方式</td>
    <td class=es02> 
    	<input type=radio name="teacherParttime" value=0 <%=(tea.getTeacherParttime()==0)?"checked":""%>>教職員工(正職)
    	<input type=radio name="teacherParttime" value=1 <%=(tea.getTeacherParttime()==1)?"checked":""%>>課內才藝(約聘) 
		<input type=radio name="teacherParttime" value=2 <%=(tea.getTeacherParttime()==2)?"checked":""%>>課後才藝(約聘)
  	</td>
  </tr>
-->
  <tr bgcolor=#ffffff > 
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

  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">薪資領取方式</td>
    <td class=es02>
    	<input type=radio name="payWay" value=0 <%=(tea.getTeacherAccountPayWay()==0)?"checked":""%>>櫃臺領取
		<input type=radio name="payWay" value=1 <%=(tea.getTeacherAccountPayWay()==1)?"checked":""%>>匯款
  	</td>
  </tr>
	
<tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">銀行匯款帳號1</td>
    <td class=es02>
    	<input type=radio name="bankDefault" value=1 <%=(bankDefaultx==1)?"checked":""%>>預設
 銀行名稱<input type=text name="teacherBankName1" value="<%=(tea.getTeacherBankName1()!=null)?tea.getTeacherBankName1():""%>" size=4>
        代號<input name="teacherBank1" type="text" id="teacherBank1" size="5" value="<%=tea.getTeacherBank1()%>">
  	帳號 <input name="teacherAccountNumber1" type="text" size=20 value="<%=tea.getTeacherAccountNumber1()%>">
  	戶名<input name="teacherAccountName1" type="text" size=10 value="<%=tea.getTeacherAccountName1()%>">

  </td>
  </tr>
  
  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">銀行匯款帳號2</td>
    <td class=es02>
    	<input type=radio name="bankDefault" value=2 <%=(bankDefaultx==2)?"checked":""%>>預設
       銀行名稱<input type=text name="teacherBankName2" value="<%=(tea.getTeacherBankName2()!=null)?tea.getTeacherBankName2():""%>" size=4> 代號<input name="teacherBank2" type="text" id="teacherBank1" size="5" value="<%=tea.getTeacherBank2()%>">
  	帳號<input name="teacherAccountNumber2" type="text" size=20  value="<%=tea.getTeacherAccountNumber2()%>">
  	戶名<input name="teacherAccountName2" type="text" size=10 value="<%=tea.getTeacherAccountName2()%>">
  </td>
  </tr>
  

  <tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">備註</td>
  <td>
  	
	<textarea name=teacherPs rows=10 cols=50><%=tea.getTeacherPs()%></textarea>
	</td></tr>
	</table>
	</td>
	</tR>
	</table>
</form>

<script>
    top.nowpage=4;
</script>