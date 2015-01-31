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


 

<table width="100%" height="" border="0" cellpadding="8" cellspacing="0">
<tr align=left valign=top>
<td class=es02>

<%=(pd2.getCustomerType()==0)?"老師":"員工"%>:<font color=blue><b><%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></b></font><br><br>
<a href="modifyTeacher.jsp?teacherId=<%=tea.getId()%>">基本資料</a>
 | 
 工作設定 | 
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
<br> 
<b>&nbsp;&nbsp;&nbsp;工作設定</b>

<blockquote>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<form method="post" action="modifyTeacherWork2.jsp" name="xs">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
<%
    int status=tea.getTeacherStatus();
    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws2.getBunitSpace("buId"));
%>
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
<%  if(b !=null && b.size()>0){ %>
<tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">部門</td>
    <td class=es02>
        <select name="bunit">
            <option value="0" <%=(tea.getTeacherBunitId()==0)?"selected":""%>>未定</option>
        <%
            for(int i=0;i<b.size();i++){
                Bunit bb=b.get(i);
        %>        
            <option value="<%=bb.getId()%>" <%=(tea.getTeacherBunitId()==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>                
        <%  }   %>
        </select>
   </td>
  </tr>
<%  }else{  %>

    <input type=hidden name="bunit" value="0">
<%  }   %>

<tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">狀態</td>
    <td class=es02>
        <input type="radio" name="teacherStatus" value="3" <%=(status==3)?"checked":""%>>面試
        <input type="radio" name="teacherStatus" value="2" <%=(status==2)?"checked":""%>>試用
        <input type="radio" name="teacherStatus" value="1" <%=(status==1)?"checked":""%>>在職
   	<input type="radio" name="teacherStatus" value="0" <%=(status==0)?"checked":""%>>離職
   </td>
  </tr>
<!--
 <tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">單位 <font size=2>
	<a href="#" Onclick="javascript:openwindow7('listDepart.jsp');return false" onKeyDown="if(event.keyCode==13) event.keyCode=9;">修改</a></font></td>
	<td class=es02>
<%
	int depart=tea.getTeacherDepart();

	
	Depart[] de=ja.getAllDepart();
	if(de==null)
	{
		out.println("<font size=2 color=red><b>尚未加入單位</b></font>");
	}
	else
	{
	%>
		<input type=radio name="teacherDepart" value=0 <%=(depart==0)?"checked":""%>>未定
	<%
	
		for(int i=0;i<de.length;i++)
		{
%>
		<input type=radio name="teacherDepart" value=<%=de[i].getId()%> <%=(depart==de[i].getId())?"checked":""%> onKeyDown="if(event.keyCode==13) event.keyCode=9;"><%=de[i].getDepartName()%>
<%
		}	
		
	}
	%>	
	
	</td></tr>
 
 
 
 
 
 
 <tr bgcolor=#ffffff align=left valign=middle>
 <td class=es02 bgcolor="#f0f0f0">職位
    <font size=2>
	<a href="#" Onclick="javascript:openwindow7('listPosition.jsp');return false" onKeyDown="if(event.keyCode==13) event.keyCode=9;">修改</a></font>
    </td>
    <td class=es02>
    <%
    
    	int positionId=tea.getTeacherPosition();
	Position[] po=ja.getAllPosition();
	if(po==null)
	{
		out.println("<font size=2 color=red><b>尚未設定職位</b></font>");
	}
	else
	{
	%>
		<input type=radio name="teacherPosition" value=0 <%=(positionId==0)?"checked":""%>>未定	
	<%
		for(int i=0;i<po.length;i++)
		{
%>
		<input type=radio name="teacherPosition" value=<%=po[i].getId()%> <%=(positionId==po[i].getId())?"checked":""%> onKeyDown="if(event.keyCode==13) event.keyCode=9;"><%=po[i].getPositionName()%>
<%
		}	
		
	}
	%>	
	
	</td>
	</tr>	
<tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">班別<font size=2>	
	<a href="#" Onclick="javascript:openwindow7('listClass.jsp');return false" onKeyDown="if(event.keyCode==13) event.keyCode=9;">修改</a></font></td>
	<td class=es02>			
	
	<%
	int classId=tea.getTeacherClasses();
	Classes[] cl=ja.getAllActiveClasses();
	if(cl==null){
	
		out.println("<font size=2 color=red><b>尚未設定班別</b></font>");
	
	}else{
	%>
		<input type=radio name="teacherClass" value=0 <%=(classId==0)?"checked":""%>>跨班	
	<%
	
		for(int i=0;i<cl.length;i++)
		{
		%>
		<input type=radio name="teacherClass" <%=(classId==cl[i].getId())?"checked":""%> value=<%=cl[i].getId()%>><%=cl[i].getClassesName()%>
		
		<%
		}
	}
	%>
	</td></tr>
	
	<tr bgcolor=#ffffff align=left valign=middle>
		<td class=es02 bgcolor="#f0f0f0">年級
			<font size=2>	
				<a href="#" Onclick="javascript:openwindow7('listLevel.jsp');return false" onKeyDown="if(event.keyCode==13) event.keyCode=9;">修改</a>
			</font>
		</td>
		<td  class=es02>

<%
	int levelId=tea.getTeacherLevel();
	Level[] le=ja.getAllLevel();
	if(le ==null)
	{
		out.println("<font size=2 color=red><b>尚未設定年級</b></font>");
	}
	else
	{
	%>
		<input type=radio name="teacherLevel" value=0 <%=(levelId==0)?"checked":""%>>跨年級	
	<%
	
		for(int i=0;i<le.length;i++)
		{
		%>
		<input type=radio name="teacherLevel" <%=(levelId==le[i].getId())?"checked":""%> value=<%=le[i].getId()%> onKeyDown="if(event.keyCode==13) event.keyCode=9;"><%=le[i].getLevelName()%>
		<%
		}
	}
	%>
	
	</td></tr>
-->	
  <tr bgcolor=#ffffff align=left valign=middle> 
    <td class=es02 bgcolor="#f0f0f0">到園日期</td>
    <td class=es02>
        <input name="teacherComeDate" type="text" id="teacherComeDate" value="<%=jt.ChangeDateToString(tea.getTeacherComeDate())%>" size=10>
    ex: 2006/10/10 
    </td>
  </tr>
  <tr bgcolor=#ffffff align=left valign=middle><td class=es02 bgcolor="#f0f0f0">備註</td>
  <td>
  	
	<textarea name=teacherPs rows=10 cols=50><%=tea.getTeacherPs()%></textarea>
	</td></tr>
</table>
	</td></tr></table>
</form>
</blockquote>

<script>
    top.nowpage=2;
</script>