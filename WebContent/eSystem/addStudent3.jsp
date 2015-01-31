<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=4;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>
<script type="text/javascript" src="openWindow.js"></script>
<%
 	request.setCharacterEncoding("UTF-8");

	String stuIdS=request.getParameter("stuId");

	int stuId=Integer.parseInt(stuIdS);

	StudentMgr sm=StudentMgr.getInstance();

	Student stu=(Student)sm.find(stuId);
    Membr membr = MembrMgr.getInstance().find("surrogateId=" + stu.getId() + " and type=" + Membr.TYPE_STUDENT);
%>
<div class=es02>
<br>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;<%=(pZ2.getCustomerType()==0)?"新增學生 - 就讀學生模式":"新增客戶"%></b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

	<blockquote>
    <div class=es02>
		<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>: <font color=blue><b><%=stu.getStudentName()%></b></font> 新增完成.

		<br>
		<br>
		<a href="addStudent.jsp">繼續新增<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%></a> 
		| 
		<a href="#" onClick="javascript:openwindow15('<%=stu.getId()%>');return false">編輯詳細資料</a> 
		| 
		<%
		String runPage="listVisit.jsp";
		if(stu.getStudentStatus()==3 || stu.getStudentStatus()==4)
			runPage="listStudent.jsp";
		
		%>				
		<a href="<%=runPage%>">回<%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>資料列表</a>
    </div>
    <br>
<%
    if(stu.getStudentStatus()==3 || stu.getStudentStatus()==4)
    {

        if(checkAuth(ud2,authHa,102))
        {
%>
    <div c;ass=es02>
    <a href="javascript:openwindow_phm('membrbillrecord_addsingle.jsp?mid=<%=membr.getId()%>&burl=addStudent.jsp','新增帳單',500,300,false)"><img src="pic/23.png" border=0 width=20>&nbsp;快速新增帳單</a>
    </div>
<%  
        }   
    }
%>
	</blockquote>

<%@ include file="bottom.jsp"%>	