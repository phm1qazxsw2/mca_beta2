<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>

<br>
<blockquote>


<b><<自動產生帳單介面 步驟一:確認學生名單>></b>
<% 
JsfAdmin ja=JsfAdmin.getInstance();
Classes[] cl=ja.getAllActiveClasses();
%>
<br>
<br>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>班級</td><td bgcolor=#f0f0f0 class=es02>人數</tD><td bgcolor=#f0f0f0 class=es02 align=middle>詳細名單</tD>
</tr> 
<% 
int totalNumber=0;
for(int i=0;i<cl.length;i++)
{ 
	Student[] st=ja.getStudyStudents(cl[i].getId(),999,999,0); 
	int jx=1;

	if(st !=null) 
	{
	
		totalNumber +=st.length;
%>
<tr bgcolor=#ffffff align=left valign=middle>

		<td class=es02>
		<%=cl[i].getClassesName()%> 
		</td>
		<td align=right><%=st.length%></td>
		<td>
<%	
		
		for(int j=0;j<st.length;j++){
%>
			<a href="#" onClick="javascript:openwindow15('<%=st[j].getId()%>');return false"><%=st[j].getStudentName()%></a>
<%		
			if(jx%10==0) 
			{
				out.println("<br>"); 
					
			} 
			jx++;	
		}
			
%>
		</td> 
	 </tr>
<% 
	}
}	
%>
<tr> 
<%
	Student[] st2=ja.getStudyStudents(999,999,999,0); 
	
	if(st2 !=null)
  	{
  			totalNumber +=st2.length;
 
  	
  %>
<tr bgcolor=#ffffff align=left valign=middle>

		<td class=es02>未定</td>
		<td align=right><%=st2.length%></td>
		<td>
<%	
		int jx2=1; 
		
		if(st2!=null)
  		{
	 		for(int j2=0;j2<st2.length;j2++){
%>
				<a href="#" onClick="javascript:openwindow15('<%=st2[j2].getId()%>');return false"><%=st2[j2].getStudentName()%></a>
<%		
				if(jx2%10==0) 
				{
					out.println("<br>"); 
						
				}
	 
				jx2++;	
			}
		}		
%>
		</td>
 
	 </tr>

<%
}
%>

<tr bgcolor="#ffffff"><td colspan=3>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
</td>
</tr> 
<tr>
<tr>
	<td>共計</td>
	<td><b><%=totalNumber%></b></td>
	<td></td>
</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td colspan=3>
<center><a href="autoClassesMoney.jsp"><font color=red><b>步驟二: 依班級產生帳單</b></font></a></center></td></tr>
</table>	

</td></tr></table>

<%@ include file="bottom.jsp"%>
