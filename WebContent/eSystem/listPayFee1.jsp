<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
	JsfAdmin ja=JsfAdmin.getInstance();
	int cfId=Integer.parseInt(request.getParameter("cfId"));
	int stuId=Integer.parseInt(request.getParameter("stuId"));

	ClassesFeeMgr cfm=ClassesFeeMgr.getInstance();
	ClassesFee cf=(ClassesFee)cfm.find(cfId);
	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.find(cf.getClassesFeeStudentId());

	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	ClassesMoney cmx=(ClassesMoney)cmm.find(cf.getClassesFeeCMId());

	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");


	PayFee[] pf=ja.getPayFee(cfId,stuId);
	
	
	
%>

<center>
	<h3><%=stu.getStudentName()%>-<%=cmx.getClassesMoneyName()%>繳款明細</h3>

<%
	if(pf==null)
	{
		out.println("<font color=red>目前沒有繳費紀錄!!</font>");
		return;
	}
%>

	<table>
	
	<tr align="center" bgcolor="lightgrey" cellpadding="1" cellspacing="0" width="98%" border="1" bordercolordark="#ffffff" bordercolorlight="#000000" bordercolor="#a8a8a8">
		<td>繳款日期</td><td>繳款金額</td><td>收款人</td><td>付款方式</td><td>備註</td>
	</tr>	
<%

	int total=0;
	for(int i=0;i<pf.length;i++)
	{
		User u=ja.getUserById(pf[i].getPayFeeUserId());
%>
	<tr class="normal" onmouseover="this.className='highlight'" onmouseout="this.className='normal'">	
	<td><%=sdf.format(pf[i].getPayFeeDate())%></td>
	<td><%=pf[i].getPayFeeMoneyNumber()%></td>
	<td><%=u.getUserFullname()%></td>
	<td>
	<%
		int pfType=pf[i].getPayFeeType();
	%>
	<%=(pfType==1)?"現金":""%>
	<%=(pfType==2)?"匯款":""%>
	<%=(pfType==3)?"支票":""%>
	<%=(pfType==4)?"其他":""%>
	</td>
	<td><%=pf[i].getPayFeePs()%></td>
	</tr>	
<%
	total+=pf[i].getPayFeeMoneyNumber();

	}
%>
<tr><td colspan=5>------------------------------------------------------------------</td></tr>
<tr>
<td bgcolor="lightgrey" colspan=2>應繳金額</td><td align="right" colspan=3><%=cf.getClassesFeeShouldNumber()%></td>
</tr>
<tr>
<td bgcolor="lightgrey" colspan=2>已繳總額</td><td colspan=3 align="right"><font color=blue><%=total%></font></td>
</tr>
<tr>
<td bgcolor="lightgrey" colspan=2>尚欠金額</td>
<td colspan=3 align="right"><font color=red><%=cf.getClassesFeeShouldNumber()-total%></font></td>
</tr>
<table>

</center>

	
	
	
	