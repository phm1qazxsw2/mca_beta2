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
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");
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

    Date nowdate=new Date();
    int month=nowdate.getMonth();

    String monthS=request.getParameter("month");
    
    if(monthS !=null)
        month=Integer.parseInt(monthS);
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
 <b>&nbsp;&nbsp;&nbsp;<img src="images/excel2.gif">&nbsp;壽星名單</b> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="formIndex.jsp"><img src="pic/last.gif" border=0>&nbsp;回表單中心</a>
</div>
<blockquote>
<form action=birthIndex.jsp method=get>

    <% // ############# 搜尋選單 ############### %>
    <table border=0 cellpadding=0 cellspacing=0><tr><td nowrap>
    
    月份:
    <select name="month">
        <option value="0" <%=(month==0)?"selected":""%>>一月</option>
        <option value="1" <%=(month==1)?"selected":""%>>二月</option>
        <option value="2" <%=(month==2)?"selected":""%>>三月</option>
        <option value="3" <%=(month==3)?"selected":""%>>四月</option>
        <option value="4" <%=(month==4)?"selected":""%>>五月</option>
        <option value="5" <%=(month==5)?"selected":""%>>六月</option>
        <option value="6" <%=(month==6)?"selected":""%>>七月</option>
        <option value="7" <%=(month==7)?"selected":""%>>八月</option>
        <option value="8" <%=(month==8)?"selected":""%>>九月</option>
        <option value="9" <%=(month==9)?"selected":""%>>十月</option>
        <option value="10" <%=(month==10)?"selected":""%>>十一月</option>
        <option value="11" <%=(month==11)?"selected":""%>>十二月</option>
    </select>
    <input type=hidden name="status" value="2">

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

    Student[] st = ezsvc.searchStudent("", studentIds, 10, statusStr, _ws.getStudentBunitSpace("bunitId"));
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
<form action=birthIndex2.jsp method="post">

<table border=0 marginwidth="0" marginheight="0" width=600>
	<tr>
	<td valign="top" width=350 align=middle>

    <div class=es02 align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" onClick="this.value=check(this.form.stuId)">全選</div>
	<table width="300" height="" border="0" cellpadding="0" cellspacing="0">
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
    Date stBirth=st[i].getStudentBirth();
    
    if(stBirth ==null || stBirth.getMonth()!=month )
        continue;
%>
    <tr bgcolor=#ffffff class=es02>
        <td width=150>
            <input type="checkbox" name="stuId" value="<%=st[i].getId()%>">
            <a href="#" onClick="javascript:openwindow15('<%=st[i].getId()%>');return false"><%=st[i].getStudentName()%></a>
        </td>
        <td width=150>
            <%=JsfTool.showDate(stBirth)%>                
        </td>
    </tr>
    
<%
}
%>
</table>
 
	</td>
	</tr>
	</table>

	</td>
	<td valign="top" width=250 align=middle>
		<%
			Date da=new Date();
		%>
 
	<div class=es02>&nbsp;<br></div>	
	<table width="200" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td colspan=2 align=middle>
                <b>Step 2. 輸入標題</b>
            </td>
		</tr>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>標題</td>
			<td bgcolor=ffffff>
			<input type=text name="creatTitle" value="<%=new BunitHelper().getCompanyNameTitle(_ws.getSessionBunitId())%>  壽星" size=20>
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
