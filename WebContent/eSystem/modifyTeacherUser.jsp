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
    Membr membr = MembrMgr.getInstance().find("type=" + Membr.TYPE_TEACHER + " and surrogateId=" + teacherId);
    MembrUserData u2 = MembrUserDataMgr.getInstance().find("membrId=" + membr.getId());
    boolean create = true;
    String loginId = "";
    String password = "";
    int percent = 50;
    int status = 1;
    if (u2!=null) {
        loginId = u2.getUserLoginId();
        password = u2.getUserPassword();
        status = u2.getUserActive();
        percent = tea.getTeacherLevel();
        create = false;
    }

    String m=request.getParameter("m");

    if(m !=null){
%>
    <script>
        alert('修改完成!');
    </script>        
<%
    }
%> 	
<script type="text/javascript" src="js/in.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
<script type="text/javascript" src="openWindow.js"></script>
<script type="text/javascript" src="js/highlight-active-input.js"></script>
<script>
function checkValidId(id)
{
    if (id.length==0)
        return false;
    for (var i=0; i<id.length; i++) {
   
         var c = id.charAt(i);
         if(c>='0' && c<='9')
            continue;

         if ((c>'z') || (c<'A')) {
            return false;    
        }
    }
    return true;
}

function doCheck(f)
{
    if (!checkValidId(f.userLoginId.value)) {
        alert("帳號僅可使用英文字母及數字, 不分大小寫");
        f.userLoginId.focus();
        return false;
    }

    if(f.userPassword.value.length<=0){
        alert("尚未填入登入的密碼");
        f.userPassword.focus();
        return false;
    }

    return true;
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
<a href="modifyTeacherAccount.jsp?teacherId=<%=tea.getId()%>">帳務資料</a> 
<% if (pd2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) { %>
| 登入設定
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


<blockquote>	
<%
    if(u2==null) {
%>
    <b>尚未開啟!</b>

<%  }   %>

<form action="modifyTeacherUser2.jsp" method=post onsubmit="return doCheck(this);">

    <input type=hidden name="userRole" value="5">  <% //老師  %>
    <input type=hidden name="membrId" value="<%=membr.getId()%>"> 
    <input type=hidden name="teaId" value="<%=tea.getId()%>"> 

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

    <table width="100%" border=0 cellpadding=4 cellspacing=1 class=es02>

		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>帳號 </td>
			<td bgcolor=#ffffff class=es02>
			<input type="text" name="userLoginId" value="<%=loginId%>"><br>
            帳號僅可使用英文字母及數字, 不分大小寫
			</td>
		</tr>
		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>密碼</td>
			<td bgcolor=#ffffff class=es02>
			<input type="text" name="userPassword" value="<%=password%>"><br>密碼可用字母和符號,有區分大小寫
			</td>
		</tr>
 
		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>使用狀態</td>
			<td bgcolor=#ffffff class=es02>
                <input type=radio name="userActive" value="1" <%=(status==1)?"checked":""%>>使用中
                <input type=radio name="userActive" value="0" <%=(status==0)?"checked":""%>>停用
			</td>
		</tr>

		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>薪資%</td>
			<td bgcolor=#ffffff class=es02>
                <input type=text name="percent" value="<%=percent%>" size=1>%
			</td>
		</tr>

		<tr bgcolor=#ffffff align=left valign=middle>
			<td colspan=2 class=es02> 
				<center>
					<input type=submit value="<%=(create)?"新增":"修改"%>">
				</center>
			</td>
		</tr>
    </table>
</td>
</tr>
</table>
</blockquote>

<script>
    top.nowpage=5;
</script>