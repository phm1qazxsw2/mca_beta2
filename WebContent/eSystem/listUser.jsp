<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%

if(!AuthAdmin.authPage(ud2,2))
{
    response.sendRedirect("authIndex.jsp?page=9&info=1");
}

 JsfAdmin ja=JsfAdmin.getInstance();
 User[] u2=ja.getAllRunUsers(_ws.getBunitSpace("userBunitAccounting"));
  
 int uRole=ud2.getUserRole();

String m=request.getParameter("m");
 
 SimpleDateFormat sdfLog=new SimpleDateFormat("MM/dd HH:mm");
%>
<br>

&nbsp;&nbsp;&nbsp;<img src="pic/user.gif" border=0> <b>使用者列表</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<BR> 
<%		
if(uRole<=2)
{
%>		
    <div class=es02>	
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	<a href="addUser.jsp" border=0><img src="pic/add.gif" border=0 alt="新增使用者" width=12>&nbsp;新增使用者</a>
    </div>
<%
	}

    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> ba = bm.retrieveList("flag=" + Bunit.FLAG_SCH,"");
    Map<Integer, Bunit> bunitMap = new SortingMap(ba).doSortSingleton("getId"); 

%>	
<blockquote>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02 nowrap>姓名</td> 
	<td bgcolor=#f0f0f0 class=es02 nowrap>使用狀態</td>
	<td bgcolor=#f0f0f0 class=es02 nowrap>登入身份</td>
	<td bgcolor=#f0f0f0 class=es02 nowrap>帳號 </td>
<%
    if(ba !=null  && ba.size()>0){
%>
	<td bgcolor=#f0f0f0 class=es02 nowrap>&nbsp;考勤部門&nbsp;</td>
<%  }   %>

<!--	<td bgcolor=#f0f0f0 class=es02>Email報表</td>  -->
	<td bgcolor=#f0f0f0 class=es02 nowrap>電話 </td>
	<td bgcolor=#f0f0f0 class=es02 nowrap>Email</td>
 
<%	

	
if(uRole<=2)
{
%> 
	<td bgcolor=#f0f0f0 class=es02 nowrap>上次登入時間</td>
	<td bgcolor=#f0f0f0 class=es02></td>
<%
}
%>
</tr>	
<% 
 for(int i=0;u2!=null&&i<u2.length;i++)
 {
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
	
	<td class=es02 nowrap>&nbsp;<%=u2[i].getUserFullname()%>&nbsp;</td> 
	<td class=es02 nowrap> 
	<%
		int active=u2[i].getUserActive();
		
		if(active==1) 
		{ 
			out.println("<img src=\"pic/yes2.gif\" border=0><br>使用中");		
		} else{
			out.println("<img src=\"pic/no2.gif\" border=0><br>停用");	
		}

	%>
	</td>	
	
        <td class=es02 nowrap><%=ja.getChineseRole(u2[i].getUserRole())%></td>
	    <td class=es02 nowrap><%=u2[i].getUserLoginId()%></td>
	
<%
    if(ba.size()>0){
%>
        <td class=es02 nowrap>&nbsp;
            <%
                if(u2[i].getUserBunitCard()==0){
                    out.println("跨部門");
                }else{
                    Bunit bu=bunitMap.get(new Integer(u2[i].getUserBunitCard()));
                    if(bu !=null)
                        out.println(bu.getLabel());
                }
            %>&nbsp;
        </td>
<%  }   %>
	<!--
	<td class=es02>
		<% 
 			if(u2[i].getUserEmailReport()==0)
			{
		%>
			<img src="pic/no2.gif" border=0> 
		<%
			}else{
		%>
			<img src="pic/yes2.gif" border=0>
		<%
			} 
		%>						
	</td>
  -->
	<td class=es02 nowrap>
 
	<% 
	if(u2[i].getUserPhone()!=null &&u2[i].getUserPhone().length()>0)
  	{
  	%>
 	<a href="#" onClick="javascript:openwindow62('<%=u2[i].getId()%>','<%=u2[i].getUserPhone()%>','3');return false"><img src="pic/mobile2.gif" border=0><%=u2[i].getUserPhone()%></a>
	<%
	}
	%>
	</td>
	<td class=es02 nowrap><%=u2[i].getUserEmail()%></td> 
 
<%		
if(uRole<=2)
{
%>		
	<td class=es02 nowrap> 
	<%
		Userlog[] uls=ja.getUserlogById(u2[i].getId());
		
		if(uls !=null) 
		{ 
			out.println(sdfLog.format(uls[0].getUserlogDate()));
		} else{
			out.println("[未曾登入]");
		}
	%>
	</td>
	<td class=es02 align=middle nowrap>
		<a href="modifyUser.jsp?userId=<%=u2[i].getId()%>">修改</a> 
	</td>
<%
}
%>
</tr>

<%
}
%>
</table>

</td></tr></table> 
	<br>
	<br> 
	
</blockquote>

<%
if(m!=null) 
{ 
%> 
	<script>
		alert('修改完成!');
	</script>
<%
}
%>
<%@ include file="bottom.jsp"%>