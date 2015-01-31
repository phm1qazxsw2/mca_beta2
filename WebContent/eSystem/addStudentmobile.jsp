<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%> 
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>

<%@ include file="jumpTop.jsp"%>


<% 
	int to=Integer.parseInt(request.getParameter("to"));
	int xId=Integer.parseInt(request.getParameter("stuId"));
	String mNumber=request.getParameter("mNumber"); 
	
    JsfPay jp=JsfPay.getInstance();

	String toname="";
	
	if(to==1) 
	{
	
        StudentMgr sm=StudentMgr.getInstance();
		Student stu=(Student)sm.find(xId); 
		toname= stu.getStudentName() ;
	
    }else if(to==2){
		TeacherMgr tm=TeacherMgr.getInstance();
		Teacher tea=(Teacher)tm.find(xId); 
		toname=tea.getTeacherFirstName()+tea.getTeacherLastName();
	}else if(to ==3){
		UserMgr um=UserMgr.getInstance();
		User uXX=(User)um.find(xId);
		toname=uXX.getUserFullname();
	}
 
  
 %>


<form action="addStudentmobile2.jsp" method="post"> 
<b>&nbsp;&nbsp;&nbsp;<img src="pic/mobile.gif" border=0> 發送簡訊-單筆</b> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>	<br>
<center>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de"> 
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
			<tD>發送對象</td>
			<tD bgcolor=#ffffff><%=toname%></td>
		</tr>
			<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
				
                <td>手機號碼</tD>
				<tD bgcolor=#ffffff>
				<% 

					boolean  validNum=jp.checkMobile(mNumber.trim());
				%>
				<%=mNumber%>
				<%=(!validNum)?"<font color=red>無效的號碼</font>":""%> 
				
				
				</tD>
			</tr>
			<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
				<td>簡訊內容</td>
				<td bgcolor=#ffffff> 
					<textarea rows=5 cols=20 name="content"></textarea><br>
  			<font color=red>*</font>不得超過70個中文字
				</tD>
			</tr>
			<tr class=es02 align=left valign=middle>
				<td colspan=2> 
					 <center>
						<input type=hidden name="mNumber" value="<%=mNumber%>"> 
						<%
						if(validNum)
  						{
  						%>
 						<input type=submit value="送出" onClick="retunr(confirm('確認送出?'))">
						<%
							}
						%>
					</centeR>	
				</td>
			</tr>	
			
			</table> 
			</td>
			</tr>
			</table>
			</form>
			</center>