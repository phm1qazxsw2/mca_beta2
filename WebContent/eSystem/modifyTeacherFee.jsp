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
function checkHealthFee()
{

	SDIV = document.getElementById("healthFee");
	var url = "_showHeakthFee.jsp?teacherHealthPeople="+xs.teacherHealthPeople.value+"&teacherHealthMoney="+xs.teacherHealthMoney.value+"&z="+(new Date()).getTime();

	var req = new XMLHttpRequest();
	if (req) 
	{
		req.onreadystatechange = function() 
		{
			if (req.readyState == 4 && req.status == 200) 
			{
				SDIV.innerHTML = req.responseText;
			}
		}
	};
	req.open('GET', url);
	req.send(null);
}

function checkLabor()
{

	SDIV = document.getElementById("laborDiv");
	var url = "_showLaborFee.jsp?teacherLaborMoney="+xs.teacherLaborMoney.value+"&z="+(new Date()).getTime();

	var req = new XMLHttpRequest();
	if (req) 
	{
		req.onreadystatechange = function() 
		{
			if (req.readyState == 4 && req.status == 200) 
			{
				SDIV.innerHTML = req.responseText;
			}
		}
	};
	req.open('GET', url);
	req.send(null);
}


function checkRetire(){

	SDIV = document.getElementById("retire");

    var retireMoney=xs.teacherRetireMoney.value*xs.teacherRetirePercent.value/100;

    SDIV.innerHTML ="自付費用為: <font color=blue>"+retireMoney+"</font> 元";
}    

</script>

<table width="100%" height="" border="0" cellpadding="8" cellspacing="0">
<tr align=left valign=top>
<td class=es02>
<%=(pd2.getCustomerType()==0)?"老師":"員工"%>: <font color=blue><b><%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%></b></font><br><br>
<a href="modifyTeacher.jsp?teacherId=<%=tea.getId()%>">基本資料</a>
 | 
<a href="modifyTeacherWork.jsp?teacherId=<%=tea.getId()%>">工作設定</a> |
 
勞健保設定 |
<a href="modifyTeacherAccount.jsp?teacherId=<%=tea.getId()%>">帳務資料</a> 
<% if (pd2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) { %>
| <a href="modifyTeacherUser.jsp?teacherId=<%=tea.getId()%>">登入設定</a>
| <a href="modify_outsourcing.jsp?teacherId=<%=tea.getId()%>">派遣對象</a>
<% } %>
<% if (pd2.getCardread()!=0) { %>
| <a href="modifyTeacherCard.jsp?teacherId=<%=tea.getId()%>">感應卡設定</a>
<%  }   %>


</td>
</tr>
</table>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<form method="post" action="modifyTeacherFee2.jsp" name="xs" onsubmit="return doCheck(this);">
<center>
        <input type=submit value="確認修改">
        <input type=hidden name="teacherId" value="<%=teacherId%>">
</center>
<b>&nbsp;&nbsp;&nbsp;健保設定</b>
<blockquote>
<table width="75%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1>
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0" width=30%>費率公式</td>
    <td class=es02 width=30%>
        <input type=radio name="teacherHealthType" value=1 checked>私立學校教職員
    </td>
    <td class=es02 rowspan=3 valign=bottom>
         
        <div id=healthFee></div>
        <br>
        <A href="#" onClick="checkHealthFee();return false">自付金額試算</a>
    </td>
  </tr>
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0">投保金額</td>
    <td class=es02>
        <input type=text name="teacherHealthMoney" size=10 value="<%=tea.getTeacherHealthMoney()%>">元
    </td>
  </tr>  
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0">眷屬人數</td>
    <td class=es02 nowrap>
        本人+   
        <select name="teacherHealthPeople">
            <option value="1" <%=(tea.getTeacherHealthPeople()==1)?"selected":""%>>無眷屬</option>
            <option value="2" <%=(tea.getTeacherHealthPeople()==2)?"selected":""%>>一位眷屬</option>
            <option value="3" <%=(tea.getTeacherHealthPeople()==3)?"selected":""%>>兩位眷屬</option>
            <option value="4" <%=(tea.getTeacherHealthPeople()==4)?"selected":""%>>三位眷屬</option>
        </select>
    </td>
  </tr>  
    </table>
    </td></tr></table>
</blockquote>
<b>&nbsp;&nbsp;&nbsp;勞保設定</b>
<blockquote>
<table width="75%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0" width=30%>投保金額</td>
    <td class=es02 width=30%>
        <input type=text name="teacherLaborMoney" size=10 value="<%=tea.getTeacherLaborMoney()%>">元
    </td>
    <td class=es02 valign=bottom>
        <div id="laborDiv"></div>
        <br>
        <A href="#" onClick="checkLabor();return false">自付金額試算</a>
    </tD>
  </tr>  
    </table>
    </td></tr></table>
</blockquote>
<b>&nbsp;&nbsp;&nbsp;勞退設定</b>
<blockquote>
<table width="75%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0" width=30%>投保金額</td>
    <td class=es02 width=30%>
        <input type=text name="teacherRetireMoney" size=10 value="<%=tea.getTeacherRetireMoney()%>">元
    </td>
    <td class=es02 rowspan=2 valign=bottom>
        <div id=retire></div>
        <br>
        <A href="#" onClick="checkRetire();return false">自付金額試算</a>

    </td>
  </tr>  
  <tr bgcolor=#ffffff align=left valign=middle>  
    <td class=es02 bgcolor="#f0f0f0" width=20%>自付%</td>
    <td class=es02>
        <input type=text name="teacherRetirePercent" size=5 value="<%=tea.getTeacherRetirePercent()%>">%
    </td>
  </tr>  
    </table>
    </td></tr></table>
</blockquote>
</form>

<script>
    top.nowpage=3;
</script>