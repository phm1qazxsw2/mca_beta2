<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=4;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,603))
    {
        response.sendRedirect("authIndex.jsp?code=603");
    }   
%>
<%@ include file="leftMenu4.jsp"%>
<%@ include file="tag_selection.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%


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
//  End -->
</script>

</head>

<body>
<br>
<div class=es02>
    <b>&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/pdf.gif" border=0>&nbsp;<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>貼標製作</b> 
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <a href="formIndex.jsp"><img src="pic/last.gif" border=0>&nbsp;回表單中心</a>    
</div>
<blockquote>
<form action=tagStudent.jsp method=get>

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
    </td>
    <td><img src="images/spacer.gif" width=20></td>
    <td valign=top nowrap>
        <%@ include file="tag_selection_body.jsp"%>
    </td>
    <td><img src="images/spacer.gif" width=20></td>
    <td>
        <input type=submit value="查詢">
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

        <div class=es02>開始查詢!</font>

    </blockquote>

<br>
<br>
<%@ include file="bottom.jsp"%>	
<%	
	return;
}
%>

<center>
<form action=tagStudent2.jsp method="post">

<table border=0 marginwidth="0" marginheight="0" width=95%>
	<tr>
	<td valign="top" width=60% align=middle>

    <div class=es02 align=left><input type="checkbox" onClick="this.value=check(this.form.stuId)">全選</div>
	<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
		<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td colspan=3 align=middle>
                <b>Step 1. 勾選<%=(pZ2.getCustomerType()==0)?"學生姓名":"客戶名單"%></b>
            </td>
		</tr>	


<%
for(int i=0;i<st.length;i++)
{
%>
    <% if(i%3==0){  %>
    	<tr bgcolor=#ffffff class=es02>
	<%  }   %>
    	<td width=150>
		    <input type="checkbox" name="stuId" value="<%=st[i].getId()%>">
		    <a href="#" onClick="javascript:openwindow15('<%=st[i].getId()%>');return false"><%=st[i].getStudentName()%></a>
        </td>
    <% if(i%3==2){  %>  </tr>	   <%   }   %>
<%
}
%>
</table>
 
	</td>
	</tr>
	</table>

	</td>
	<td valign="top" align=middle width=40%>
    <br>
    
    <center>
	<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
		<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=ffffff class=es02>
            <td bgcolor=f0f0f0>標籤內容</td>
            <td>
                <textarea name="tagContent" cols=30 rows=5>#post# #address# 
    #name#  #client1#收</textarea>
            </td>
        </tr>
		<tr bgcolor=ffffff class=es02>
            <td bgcolor=f0f0f0>說明</td>
            <td>
                #name# : <%=(pZ2.getCustomerType()==0)?"姓名":"客戶名稱"%><br>
                #post# : 郵遞區號<br>
                #address# :地址<br>
                #client1# : <%=(pZ2.getCustomerType()==0)?"父親":"負責人"%><br>
                #client2# : <%=(pZ2.getCustomerType()==0)?"母親":"聯絡人"%><br>
<%
                Iterator<TagType> titer = TagTypeMgr.getInstance().retrieveListX("","", _ws.getStudentBunitSpace("bunitId")).iterator();
                while (titer.hasNext()) { 
                    TagType tp = titer.next();
%>                    
                #tag<%=tp.getId()%># : <%=tp.getName()%><br>
            <%  }  %>
            </td>
        </tr>
		<tr bgcolor=#f0f0f0 class=es02>
            <tD>字型大小</td>
            <td bgcolor=ffffff> 
                <input type=radio name=fsize checked value=1>適中
                <input type=radio name=fsize value=2>較大
                <input type=radio name=fsize value=3>最大
            </td>
		</tr>
		<tr bgcolor=#f0f0f0 class=es02>
            <tD>是否列印格線</td>
            <td bgcolor=ffffff> 
                <input type=radio name=grid checked value=1>是
                <input type=radio name=grid  value=0>否
            </td>
		</tr>
		<tr bgcolor=#f0f0f0 class=es02>
            <tD>長*寬</td>
            <td bgcolor=ffffff> 
                長 <input type=text size=3 value="10" name="heiEach">格  * 寬<input type=text size=3 value="3" name="weiEach">格 
            </td>
		</tr>
		<tr bgcolor=#f0f0f0 class=es02>
            <tD>邊寬設定</td>
            <td bgcolor=ffffff> 
                高 <input type=text size=3 value="0" name="topWidth">px 底<input type=text size=3 value="0" name="bottomWidth">px<br>
                左 <input type=text size=3 value="0" name="leftWidth">px 右<input type=text size=3 value="0" name="rightWidth">px
            </td>
		</tr>
        <tr>
            <td valign=middle colspan=2>     
                <center>
                <input type=submit value="產生pdf檔案">
                </center>
            </td>
		</tr>
        </table>
    </td>
    </tr>
    </table>
    </center>
	</form>

	</td>
	</tr>
	</table>
	</center>
<br>
<br>
<%@ include file="bottom.jsp"%>