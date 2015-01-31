<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
	JsfAdmin ja=JsfAdmin.getInstance();
	int studentId=Integer.parseInt(request.getParameter("studentId"));

	ClassesFee[] cf=ja.getClassesFeeByStuIdx(studentId);
	
	if(cf==null)
	{
		out.println("沒有資料");
		return;
	}
	
	
	
	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.find(studentId);

	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	

	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
%>
<script type="text/javascript" src="openWindow.js"></script>
<h3><font color=blue><%=stu.getStudentName()%>-繳費紀錄</font></h3>
<table>

	<tr align="center" bgcolor="lightgrey" cellpadding="1" cellspacing="0" width="98%" border="1" bordercolordark="#ffffff" bordercolorlight="#000000" bordercolor="#a8a8a8">
		<td>名稱</td><td>開徵月份</td><td>應繳金額-狀態</td><td>已繳金額</td>
	</tr>
	<%
	int total=0;
	for(int i=0;i<cf.length;i++)
	{
		ClassesMoney cmx=(ClassesMoney)cmm.find(cf[i].getClassesFeeCMId());
		int payTotal=ja.getPayFeeNumber(cf[i].getId(),studentId);
		int stat=cf[i].getClassesFeeStatus();
		
		total+=payTotal;		
	%>
	<tr class="normal" onmouseover="this.className='highlight'" onmouseout="this.className='normal'">	
		<td><%=cmx.getClassesMoneyName()%></td>
		<td><%=sdf.format(cmx.getClassesMoneyMonth())%></td>
		<td><%=payTotal%>-<font color=blue>已繳</font></td>
		
		<td>
		<a href="#" Onclick="javascript:openwindow3('<%=cf[i].getId()%>','<%=studentId%>');return false">繳款明細</a></td>
		
	</tr>
	<%
		
	}
	%>	
	
	<tr><td colspan=4><center><b><font color=blue>合計</font></center></td>		
	<tr>
		<td colspan=2 bgcolor="lightgrey">收款合計</td>
		<td colspan=2 align=right><font color=blue><b><%=total%></b></font>
		
		</td>
	</tr>
</table>