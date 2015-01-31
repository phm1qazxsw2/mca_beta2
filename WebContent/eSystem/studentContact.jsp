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
	Degree[] degree=ja.getAllActiveDegree(_ws2.getStudentBunitSpace("bunitId"));
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
	function goReload()
	{
		window.location.reload();
	}
</script>

&nbsp;&nbsp;&nbsp;<%=(pd2.getCustomerType()==0)?"學　生":"客  戶"%>: <font color=blue><b><%=stu.getStudentName()%></b></font> -<img src="pic/fix.gif" border=0>聯絡資訊<br><br>
&nbsp;&nbsp;&nbsp;<a href="modifyStudent.jsp?studentId=<%=stu.getId()%>">基本資料</a> |   
 聯絡資訊  | 
<a href="studentStatus.jsp?studentId=<%=stu.getId()%>"><%=(pd2.getCustomerType()==0)?"就學狀態":"狀態設定"%></a>| 
<%
    if(pd2.getMembrService()==1){
%>
    <a href="addClientService.jsp?studentId=<%=stu.getId()%>">新增客服</a>|
    <a href="listClientServiceById.jsp?studentId=<%=stu.getId()%>">客服列表</a>|
<%  }   %>
<!-- <a href="studentTadent.jsp?studentId=<%=stu.getId()%>">才藝班紀錄</a> | -->
<%
if(pd2.getCustomerType()==0){
%>
<a href="studentStuff.jsp?studentId=<%=stu.getId()%>">學用品規格</a> |
<a href="studentSuggest.jsp?studentId=<%=stu.getId()%>">電訪/反應事項</a> |
<a href="studentVisit.jsp?studentId=<%=stu.getId()%>">入學資訊</a>
<%  }   %>
<br>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br> 

<center>
<form action="studentContact2.jsp" method=post name="xs">
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1 class=es02>
<%
   if(checkAuth(ud2,authHa,601))
   {
%>
<tr bgcolor=#ffffff align=left valign=middle><td colspan=2>
	<input type=hidden name="studentId" value="<%=stu.getId()%>">
		<center>
		<input type=submit onClick="return(confirm('確認修改此筆資料?'))" value="確認修改">
		</center>
		</td>
		</tr>
<%
    }
%>
<tr bgcolor=#ffffff align=left valign=middle>
<td  bgcolor=#f0f0f0  class=es02>
<%
	if(stu.getStudentEmailDefault()==1)
	{
%>
		<font color=red>*</font>
<%
	}
%>
    <%=(pd2.getCustomerType()==0)?"父親":"負責人"%>
	 <br>
	<input type=radio name="emailDefault" value="1" <%=(stu.getStudentEmailDefault()==1)?"checked":""%>>(預設聯絡人)
</td><td class=es02>

姓名:&nbsp;&nbsp;&nbsp;<input  class="textInput" type=text name="studentFather" value="<%=stu.getStudentFather()%>" size=6>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		教育程度: 
		<%
		if(degree==null)
		{
		%>
			請先設定教育程度
		<%
		}
		else
		{
		%>
			<select name=studentFatherDegree size=1>
			<%
				for(int j=0;j<degree.length;j++)
				{
			%>
				<option value="<%=degree[j].getId()%>" <%=(degree[j].getId()==stu.getStudebtFatherDegree())?"selected":""%>><%=degree[j].getDegreeName()%>
			<%
				}
			%>
			</select>
		<%
		}
		%>		
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		職業: <input  class="textInput" type=text name="studentFathJob" value="<%=stu.getStudentFathJob()%>" size=6>
	
		<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=4',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
		<br>
		手機1: <input  class="textInput" type=text name="studentFatherMobile" value="<%=stu.getStudentFatherMobile()%>" size=10>
		手機2: <input  class="textInput" type=text name="studentFatherMobile2" value="<%=stu.getStudentFatherMobile2()%>" size=10>
		公司電話: <input  class="textInput" type=text name="studentFatherOffice" value="<%=(stu.getStudentFatherOffice()!=null)?stu.getStudentFatherOffice():""%>" size=12>
		<br>
		Email: <input  class="textInput" type=text name="studentFatherEmail" value="<%=stu.getStudentFatherEmail()%>" size=50 onblur="emailCheck(this)">
		</td>
	</tr>
		
<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>
	<%
	if(stu.getStudentEmailDefault()==2)
	{
%>
		<font color=red>*</font>
<%
	}
%>	
    <%=(pd2.getCustomerType()==0)?"母親":"聯絡人"%>
    <br>
	<input type=radio name="emailDefault" value="2" <%=(stu.getStudentEmailDefault()==2)?"checked":""%>>(預設聯絡人)	
	</td>
	<td>
		姓名:&nbsp;&nbsp;&nbsp;<input  class="textInput" type=text name="studentMother" value="<%=stu.getStudentMother()%>" size=6>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		教育程度: 
		<%
		if(degree==null)
		{
		%>
			請先設定教育程度
		<%
		}
		else
		{
		%>
			<select name=studentMothDegree size=1>
			<%
				for(int j=0;j<degree.length;j++)
				{
			%>
				<option value="<%=degree[j].getId()%>"  <%=(degree[j].getId()==stu.getStudentMothDegree())?"selected":""%>><%=degree[j].getDegreeName()%>
			<%
				}
			%>
			</select>
		<%
		}
		%>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		職業: <input  class="textInput" type=text name="studentMothJob" value="<%=stu.getStudentMothJob()%>" size=6>
		
				<a href="#" onmouseover="ajax_showTooltip('showInfo.jsp?id=4',this);return false" onmouseout="ajax_hideTooltip()"><img src="pic/info-icon-ss.gif" border=0></a>
		<br>		
		手機1: <input  class="textInput" type=text name="studentMotherMobile" value="<%=stu.getStudentMotherMobile()%>" size=10>
		手機2: <input  class="textInput" type=text name="studentMotherMobile2"  value="<%=stu.getStudentMotherMobile2()%>" size=10>
		公司電話: <input  class="textInput" type=text name="studentMotherOffice" value="<%=(stu.getStudentMotherOffice()!=null)?stu.getStudentMotherOffice():""%>" size=12>
		<br>
		Email: <input  class="textInput" type=text name="studentMotherEmail" value="<%=stu.getStudentMotherEmail()%>" size=50 onblur="emailCheck(this)">	
		<br>
		
		</td></tr>
<%

Relation[] ra=ja.getAllRelation(_ws2.getStudentBunitSpace("bunitId"));
Contact[] cons=ja.getAllContact(studentId);
if(cons!=null)
{
	for(int i=0;i<cons.length;i++)
	{
%>

<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>
		其他聯絡人 <%=i+1%>		
		<br>
		<%
		if(i==0)
		{
		%>
			<input type=radio name="emailDefault" value="0" <%=(stu.getStudentEmailDefault()==0)?"checked":""%>>(預設聯絡人)	
		<%
		}
		%>
<%
if(checkAuth(ud2,authHa,601))
{
%>
            <a href="modifyContact.jsp?contactId=<%=cons[i].getId()%>"><img src="pic/fix.gif" border=0 width=12>&nbsp;修改</a>
<%  }   %>
	</td>
	<td>
		姓名:<font color=blue><%=cons[i].getContactName()%></font>
		&nbsp;&nbsp;&nbsp;

    <%
    if(pd2.getCustomerType()==0){
    %>
        關係:<font color=blue> 
		<%
		int raId=cons[i].getContactReleationId();
		RelationMgr rm=RelationMgr.getInstance();
		Relation ra2x=(Relation)rm.find(raId);
        if(ra2x != null)
    		out.println(ra2x.getRelationName());
		%></font>	
		&nbsp;&nbsp;&nbsp;	
    <%
    }
    %>
    <br>
	手機:<font color=blue><%=cons[i].getContactMobile()%></font>		
	&nbsp;&nbsp;&nbsp;電話1:<font color=blue><%=cons[i].getContactPhone1()%></font>		
	&nbsp;&nbsp;&nbsp;Email:<font color=blue><%=cons[i].getContactPhone2()%></font><br>
	備註:
        
        <font color=blue>
        <%=cons[i].getContactPs().replace("\n","<br>")%>
        </font>

	</td>
</tr>		
<%
	}
}

int phoneDefault=1;

if(stu.getStudentPhoneDefault()==0)
    phoneDefault=1;
else
    phoneDefault=stu.getStudentPhoneDefault();       


if(checkAuth(ud2,authHa,601))
{
    
%>
<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>
            
    </td>
	<td>    
        <a href="addContact.jsp?studentId=<%=studentId%>"><img src="pic/add.gif" border=0 width=12>&nbsp;新增其他聯絡人</a></a>
	</td>
</tr>
<%  }   %>
<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>    <%=(pd2.getCustomerType()==0)?"家中電話":"公司電話"%></td>
	<td>
		<input type=radio name=phoneDefault value="1" <%=(phoneDefault==1)?"checked":""%>>(預設)
		<%=(pd2.getCustomerType()==0)?"家中":"公司"%>電話1<input type=text name="studentPhone" size=10 value="<%=stu.getStudentPhone()%>"><br>
		<input type=radio name=phoneDefault value="2" <%=(phoneDefault==2)?"checked":""%>>(預設)
	    <%=(pd2.getCustomerType()==0)?"家中":"公司"%>電話2<input type=text name="studentPhone2" size=10 value="<%=stu.getStudentPhone2()%>"><br>
		<input type=radio name=phoneDefault value="3" <%=(phoneDefault==3)?"checked":""%>>(預設)
	    <%=(pd2.getCustomerType()==0)?"家中":"公司"%>傳真 <input type=text name="studentPhone3" size=10 value="<%=stu.getStudentPhone3()%>"><br>
	
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>地址</td>
	<td>
        郵遞區號:<input type=text name="studentZipCode" size=5 value="<%=stu.getStudentZipCode()%>"><a href="http://www.post.gov.tw/post/internet/f_searchzone/index.jsp?ID=190102" target="_blank"><font size=2>查詢</font></a> 

	住址: 	
	<input type=text name="studentAddress" size=40 value="<%=stu.getStudentAddress()%>"></td></tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>網址</td>
	<td>
        <input type=text name="studentWeb" value="<%=(stu.getStudentWeb()==null)?"":stu.getStudentWeb()%>" size=70>
	</td>
</tr>	
<tr bgcolor=#ffffff align=left valign=middle>
	<td  bgcolor=#f0f0f0  class=es02>備註</td>
	<td>
		<textarea name=studentPs rows=5 cols=50><%=stu.getStudentPs()%></textarea>
	</td></tr>	
	
<tr bgcolor=#ffffff align=left valign=middle><td colspan=2 class=es02 align=middle>
	<input type=hidden name="studentId" value="<%=stu.getId()%>">
    <%
       if(checkAuth(ud2,authHa,601))
       {
    %>
		<center>
		<input type=submit onClick="return(confirm('確認修改此筆資料?'))" value="確認修改">
		</center>
    <%  }else{%>
            沒有修改權限,系統代碼:601
    <%  }   %>

		</td>
		</tr>



	</table>
</td></tr></table>	
</form>
<br>
<br>
<script>
    top.nowpage=2;
</script>