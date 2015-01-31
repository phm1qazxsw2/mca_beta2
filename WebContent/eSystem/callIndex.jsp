<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=4;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>
<%@ include file="tag_selection.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    if(!checkAuth(ud2,authHa,603))
    {
        response.sendRedirect("authIndex.jsp?code=603");
    }   
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM");
    String classId2=request.getParameter("classx");
    String status2=request.getParameter("status");
    String level2=request.getParameter("level");	
    String departId2=request.getParameter("depart");

    JsfAdmin ja=JsfAdmin.getInstance();
    ArrayList<TagType> all_tagtypes = TagTypeMgr.getInstance().retrieveListX("","order by num ", _ws.getStudentBunitSpace("bunitId"));
    ArrayList<Tag> all_tags = TagMgr.getInstance().retrieveListX("","", _ws.getStudentBunitSpace("bunitId"));
    Map<Integer/*typeId*/, Vector<Tag>> tagMap = new SortingMap(all_tags).doSort("getTypeId");

    int status=2;
    try { status = Integer.parseInt(request.getParameter("status")); } catch (Exception e) {}
%>

<head>
<SCRIPT LANGUAGE="JavaScript">
<!-- Modified By:  Steve Robison, Jr. (stevejr@ce.net) -->

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->

<!-- Begin
var checkflag = "false";
function check(field) {
if (checkflag == "false") {
for (i = 0; i < field.length; i++) {
field[i].checked = true;}
checkflag = "true";
return "Uncheck All"; }
else {
for (i = 0; i < field.length; i++) {
field[i].checked = false; }
checkflag = "false";
return "Check All"; }
}

var checkflag2 = "false";
function check2(field) {
if (checkflag2 == "false") {
for (i = 0; i < field.length; i++) {
field[i].checked = true;}
checkflag2 = "true";
return "Uncheck All"; }
else {
for (i = 0; i < field.length; i++) {
field[i].checked = false; }
checkflag2 = "false";
return "Check All"; }
}
//  End -->
</script>

</head>

<body>
<br>
<div class=es02>
 <b>&nbsp;&nbsp;&nbsp;<img src="images/excel2.gif">&nbsp;點名表</b> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="formIndex.jsp"><img src="pic/last.gif" border=0>&nbsp;回表單中心</a>
</div>
<blockquote>
<form action=callIndex.jsp method=get>

    <% // ############# 搜尋選單 ############### %>
    <table border=0 cellpadding=0 cellspacing=0><tr><td nowrap>
<%=(pZ2.getCustomerType()==0)?"就學":"合作"%>狀態
    <select name="status">
        <option value="999" <%=(status==999)?"selected":""%>>全部</option>
        <option value="1" <%=(status==1)?"selected":""%>>潛在<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%></option>
        <option value="2" <%=(status==2)?"selected":""%>><%=(pZ2.getCustomerType()==0)?"就讀學生":"合作客戶"%></option>
        <%    if(pZ2.getCustomerType()==0){   %>
        <option value="3" <%=(status==3)?"selected":""%>>離校學生-畢業校友</option>
        <option value="4" <%=(status==4)?"selected":""%>>離校學生-中途離校</option>    
        <option value="5" <%=(status==5)?"selected":""%>>離校學生-未入學</option>    
        <%  }else{  %>
        <option value="4" <%=(status==4)?"selected":""%>>無合作客戶</option>    
        <%  }   %>
    </select>
    <input type=submit value="查詢">
    </td>
    <td><img src="images/spacer.gif" width=20></td>
    <td valign=top nowrap>
        <%@ include file="tag_selection_body.jsp"%>
    </td></tr></table>
    <% // ###################################### %>
</form>
</blockquote>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
 <br>
 <%

    EzCountingService ezsvc = EzCountingService.getInstance();

    
    String statusStr ="";

    switch(status){
        case 1:
            statusStr="studentStatus in (1,2)"; 
            break;
        case 2:
            statusStr="studentStatus in (3,4)"; 
            break;
        case 3:
            statusStr="studentStatus in (97,98,99)"; 
            break;
    }

    Student[] st = ezsvc.searchStudent("", studentIds, 1, statusStr, _ws.getStudentBunitSpace("bunitId"));
	if(st==null)
	{
%>
    <br>
    <blockquote>

        <div class=es02>沒有搜尋結果!</font>

    </blockquote>

<br>
<br>
<%@ include file="bottom.jsp"%>	

<%	
	
	return;
}
%>

<center>
<form action=callIndex2.jsp method="post">

<table border=0 marginwidth="0" marginheight="0" width=95%>
	<tr>
	<td valign="top" width=300 align=middle>

    <div class=es02 align=left><input type="checkbox" onClick="this.value=check(this.form.stuId)">全選</div>
	<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
		<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td colspan=2 width=300 align=middle>
                <b>Step 1. 勾選<%=(pZ2.getCustomerType()==0)?"學生姓名":"客戶名單"%></b>
            </td>
		</tr>	


<%
ClassesMgr cm=ClassesMgr.getInstance();
DepartMgr dm=DepartMgr.getInstance();
LevelMgr lm=LevelMgr.getInstance();

for(int i=0;i<st.length;i++)
{
%>
    <% if(i%2==0){  %>
    	<tr bgcolor=#ffffff class=es02>
	<%  }   %>
    	<td width=150>
		    <input type="checkbox" name="stuId" value="<%=st[i].getId()%>">
    <a href="#" onClick="javascript:openwindow15('<%=st[i].getId()%>');return false"><%=st[i].getStudentName()%></a>
        </td>
    <% if(i%2==1){  %>  </tr>	   <%   }   %>
<%
}
%>
</table>
 
	</td>
	</tr>
	</table>

	</td>
	<td valign="top" align=middle width=30%>


	<div class=es02>&nbsp;<br></div>	    
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
		<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
		<td colspan=2 align=middle>
            <b>Step 2. 填入日期</b>
        </td>
		</tr>		
		<tr bgcolor=ffffff class=es02>
                <td colspan=2>
                    起始日:<input type=text name="startDate" value="<%=sdf.format(new Date())%>/01" size=6>
                </td>
        </tr>
		<tr bgcolor=ffffff class=es02>
                <td colspan=2>
                    結束日:<input type=text name="endDate"  value="<%=sdf.format(new Date())%>/30" size=6>
                </td>
        </tr>
	</table>
	</tD>
	</tR>
	</table>
	
	</td>
	<td valign="top" width=30%>
		<%
			Date da=new Date();
		%>
 
	<div class=es02>&nbsp;<br></div>	
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td colspan=2 align=middle>
                <b>Step 3. 輸入標題</b>
            </td>
		</tr>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>標題</td>
			<td bgcolor=ffffff>
			<input type=text name="creatTitle" value="<%=new BunitHelper().getCompanyNameTitle(_ws.getSessionBunitId())%> 點名表" size=30>
			</td>
		</tr>

        <input type=hidden name="creatFile" value="<%=da.getTime()%>" size=18>
		<tr>
            <td valign=middle colspan=2>     
                <center>
                <input type=submit value="產生excel檔案">
                </center>
            </td>
		</tr>
	</table>	
	</td>
	</tr>
	</table>	
	</form>
 


	</td>
	</tr>
	</table>
	</center>
<br>
<br>
<%@ include file="bottom.jsp"%>	
