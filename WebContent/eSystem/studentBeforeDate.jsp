<%@ page language="java" import="phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>

<%
	
	Student[] st=jp.getStudentByBeforedate(beforeDate, _ws.getStudentBunitSpace("bunitId"));
	JsfTool jt=JsfTool.getInstance();
	if(st==null)
	{
	

	}else{
		
%>

<div class=es02>
<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;學生名單</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;更動概況: <a href="#" onClick="showForm('stuDiv');return false"><%=st.length%> 筆</a>
</div>
<div id=stuDiv style="display:none" class=es02>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
<td><b>學生姓名</b></td> 
<td>入學狀態</td> 

<td>性別</td>
<td>生日</td>
<td>家中電話1</td>

<td colspan=3></td></tr>	
<%

for(int i=0;i<st.length;i++)
{
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
	<td class=es02><a href="#" onClick="javascript:openwindow15('<%=st[i].getId()%>');return false"><%=st[i].getStudentName()%></a></td>
	<td class=es02> 
		<%
			switch(st[i].getStudentStatus())
			{ 
				case 1:
					out.println("參觀登記/上網登入");
					break;
				case 2:
					out.println("報名/等待入學");
					break;
				case 3:
					out.println("試讀");
					break;
				case 4:
					out.println("入學");
					break;
				case 97:
					out.println("離校");
					break;
				case 99:
					out.println("畢業");
					break;
			}
		%>
	</tD>
	<td class=es02><%=(st[i].getStudentSex()==1)?"男":"女"%>
	</td>
	<td class=es02>
	     <%=jt.ChangeDateToString(st[i].getStudentBirth())%>
	     </td>
	<td class=es02>
	     <%=st[i].getStudentPhone()%>
	     </td>
	<td class=es02>
	
        <a href="#" onClick="javascript:openwindow15('<%=st[i].getId()%>');return false">詳細資料</a>
    <%
        
        if(AuthAdmin.authPage(ud2,4))
        {
            Membr membr = MembrMgr.getInstance().find("type=" + Membr.TYPE_STUDENT + " and surrogateId=" + st[i].getId());
    %>
        | <a href="javascript:openwindow_phm('pay_info.jsp?sid=<%=membr.getId()%>','繳費歷史',800,500,false);">繳費資訊</a>	
    <%
        }
    %>
	</td>
	
	</tr>
	
	
<%
}
%>
</table>
</td></tr></table>
</div>
<br>
<%
	}
%>