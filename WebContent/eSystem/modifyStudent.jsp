<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
	JsfAdmin ja=JsfAdmin.getInstance();
	
	JsfTool jt=JsfTool.getInstance();
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.findX(studentId, _ws2.getStudentBunitSpace("bunitId")); 
	
    if (stu==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

	Classes[] cl=ja.getAllActiveClasses();	
%>	
    <script type="text/javascript" src="js/in.js"></script>
    <SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
    <script type="text/javascript" src="openWindow.js"></script>
    <link rel="stylesheet" href="css/ajax-tooltip.css" media="screen" type="text/css">
    <script language="JavaScript" src="js/in.js"></script>
    <script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
    <script type="text/javascript" src="js/ajax.js"></script>
    <script type="text/javascript" src="js/ajax-tooltip.js"></script>

<script>
function check(f)
{
    if (f.studentName.value.length==0) {
        alert("請輸入名字");
        f.studentName.focus();
        return false;
    }
    if (!confirm('確認修改此筆資料?')) {
        return false;
    }
    return true;
}
</script>
&nbsp;&nbsp;&nbsp;<%=(pd2.getCustomerType()==0)?"學　生":"客  戶"%>:<b><font color=blue><%=stu.getStudentName()%></font></b> -<img src="pic/fix.gif" border=0>基本資料<br><br>
&nbsp;&nbsp;&nbsp;基本資料 |   
<a href="studentContact.jsp?studentId=<%=stu.getId()%>">聯絡資訊</a> | 
<a href="studentStatus.jsp?studentId=<%=stu.getId()%>"><%=(pd2.getCustomerType()==0)?"就學狀態":"狀態設定"%></a>|
<%
    if(pd2.getMembrService()==1){
%>
<a href="addClientService.jsp?studentId=<%=stu.getId()%>">新增客服</a>|
<a href="listClientServiceById.jsp?studentId=<%=stu.getId()%>">客服列表</a>|

<%
    }
%>
<%  if(pd2.getCustomerType()==0){   %>
    <a href="studentStuff.jsp?studentId=<%=stu.getId()%>">學用品規格</a> |
    <a href="studentSuggest.jsp?studentId=<%=stu.getId()%>">電訪/反應事項</a> |
    <a href="studentVisit.jsp?studentId=<%=stu.getId()%>">入學資訊</a>  
<%  }   %> 
  <br>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>  
<center>
<form action="modifyStudent2.jsp" method=post name="xs" onsubmit="return check(this);">
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1>
<%
   if(checkAuth(ud2,authHa,601))
   {
%>

<tr bgcolor=#ffffff align=left valign=middle>
<td class=es02 colspan=2><center><input type=submit value="確認修改"></center></td></tr>
<%
    }
%>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>
<font color="red">*</font><%=(pd2.getCustomerType()==0)?"學生姓名":"客戶名稱"%></td><td class=es02><input type=text size=<%=(pd2.getCustomerType()==0)?"15":"25"%> name="studentName" size=6 value="<%=stu.getStudentName()%>">
&nbsp;
<%=(pd2.getCustomerType()==0)?"學號":"客戶編號"%>: <input type=text name="studentNumber" value="<%=(stu.getStudentNumber()!=null)?stu.getStudentNumber():""%>">

</td></tr>
<tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>English Name</td><td class=es02>
    <input type=text size=<%=(pd2.getCustomerType()==0)?"15":"25"%> name="studentNickname" size=6 value="<%=stu.getStudentNickname()%>">
    &nbsp;        
    簡稱: <input type=text size=15 name="studentShortName" value="<%=(stu.getStudentShortName()!=null)?stu.getStudentShortName():""%>">
</td></tr>
<%  if(pd2.getCustomerType()==0){   %>
     <tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>性別</td><td class=es02><input type=radio size=20 name="studentSex" value="1" <%=stu.getStudentSex()==1?"checked":""%>>男
 				<input type=radio size=20 name="studentSex" value="2" <%=stu.getStudentSex()==2?"checked":""%>>女
            &nbsp;&nbsp;&nbsp;&nbsp;血型: 
            <input type="text" name="bloodType" value="<%=(stu.getBloodType()==null)?"":stu.getBloodType()%>" size=5>

    </td></tr>
<%  }else{  %>
    <input type=hidden name="studentSex" value="<%=stu.getStudentSex()%>">
    <input type="hidden" name="bloodType" value="" size=5>
<%  }   %>
<tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02><%=(pd2.getCustomerType()==0)?"身份證字號":"統一編號"%></td><td class=es02><input type=text size=8 name="studentIDNumber" value="<%=stu.getStudentIDNumber()%>"><%=(pd2.getCustomerType()==0)?"<font size=2>(含英文字共十碼)</font>":""%></td></tr>
<%  if(pd2.getCustomerType()==0){   %>

<tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>生日</td><td><input type=text size=10 name="studentBirth" size=10 value="<%=JsfTool.showDate(stu.getStudentBirth())%>">

ex:<%=JsfTool.showDate(new Date())%>
<%
          EsystemMgr em=EsystemMgr.getInstance();
          Esystem e=(Esystem)em.find(1);
          if(e.getEsystemDateType()==0)
          {
%>
		<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=3',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
<%          }else{  %>
		<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=18',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>


<%      }   %>

</td></tr>
<tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>同胞人數</td>
<td class=es02> 

兄<input  class="textInput" type=text size=5 name="studentBrother" size=6 value="<%=stu.getStudentBrother()%>">人,
姐<input  class="textInput" type=text size=5 name="studentBigSister" size=6 value="<%=stu.getStudentBigSister()%>">人,
弟<input  class="textInput" type=text size=5 name="studentYoungBrother" size=6 value="<%=stu.getStudentYoungBrother()%>">人,
妹<input  class="textInput" type=text size=5 name="studentYoungSister" size=6 value="<%=stu.getStudentYoungSister()%>">人
</td>
</tr> 
<%  }else{  %>
    <input type=hidden name="studentBirth" value="<%=jt.ChangeDateToString(stu.getStudentBirth())%>">
    <input type=hidden name="studentBrother" value="<%=stu.getStudentBrother()%>">
    <input type=hidden name="studentBigSister" value="<%=stu.getStudentBigSister()%>">
    <input type=hidden name="studentYoungBrother" value="<%=stu.getStudentYoungBrother()%>">
    <input type=hidden name="studentYoungSister" value="<%=stu.getStudentYoungSister()%>">
<%  }   %>
<tr bgcolor=#ffffff align=left valign=middle><td  bgcolor=#f0f0f0  class=es02>備註</td><td class=es02>
	<textarea name=studentPs rows=5 cols=50><%=stu.getStudentPs()%></textarea>
	</td></tr>
	
	<input type=hidden name="studentId" value="<%=stu.getId()%>">

<tr bgcolor=#ffffff align=left valign=middle>
<td class=es02 colspan=2 align=middle>
<%
   if(checkAuth(ud2,authHa,601))
   {
%>
    <center><input type=submit value="確認修改"></center>
<%  }else{  %>

        沒有修改權限,系統代碼:601
<%  }   %>

</td></tr>

</td>
	</tr>


	</table>
</td></tr></table>	
</form>

</center>


<script>
    top.nowpage=1;
</script>

