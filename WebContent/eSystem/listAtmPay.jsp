<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=7");
    }

	DecimalFormat mnf = new DecimalFormat("###,###,##0"); 
	
	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
 
	
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	String sDate=request.getParameter("sDate");
 	String eDate=request.getParameter("eDate");
 	
 	 Date now=new Date();
	 long nowLong=now.getTime();
	 long beforeLong=nowLong-(long)1000*60*60*24*31;
	 
	 Date beforeDate=new Date(beforeLong);
	 
	 
	 String nowString=jt.ChangeDateToString(now);	
	 String beforeString=jt.ChangeDateToString(beforeDate);
	
	 String payWayS=request.getParameter("payWay");
     String logIdS=request.getParameter("logId");
     
     
	 User[] u=ja.getLogUsers();

%>
<head>
<script language="JavaScript" src="js/calendar.js"></script>
<script language="JavaScript" src="js/overlib_mini.js"></script>
<script language="JavaScript" src="js/in.js"></script>

</head>
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>

<br> 
<b>&nbsp;&nbsp;&nbsp;<img src="pic/feeIn.png" border=0> 繳款單管理-收款查詢</b>
<BR>
<br>

<table>
	<tr>
	<form action="listAtmPay.jsp" method=get name="xs">
	<td valign=top>
		&nbsp;&nbsp;&nbsp;付款方式:
		<select name="payWay">	
			<option value=999 <%=(payWayS==null)?"selected":""%>>全部</option>
			<option value=4 <%=(payWayS!=null && payWayS.equals("4"))?"selected":""%>>櫃臺繳款</option>
			<option value=3 <%=(payWayS!=null && payWayS.equals("3"))?"selected":""%>>便利商店</option> 
			<option value=2 <%=(payWayS!=null && payWayS.equals("2"))?"selected":""%>>固定虛擬帳號</option>
			<option value=1 <%=(payWayS!=null && payWayS.equals("1"))?"selected":""%>>浮動虛擬帳號</option>
		</select>	
	</td>
 
	<td valign=top>
		登入人
		<select name="logId">	
			<option value=0 <%=(logIdS==null)?"selected":""%>>全部</option>
			<%
				for(int j=0;j<u.length ;j++)
				{
		    %>	
				<option value="<%=u[j].getId()%>" <%=(logIdS!=null && Integer.parseInt(logIdS)==u[j].getId())?"selected":""%>><%=u[j].getUserFullname()%></option>
			<%				
				}		
			%>
		 </select>		

	</td>	
	
	<td valign=top> 
		繳款區間:
		<input type=text name=sDate size=10 value="<%=(sDate==null)?beforeString:sDate%>">
		-
		<input type=text name=eDate size=10 value="<%=(eDate==null)?nowString:eDate%>">
		
	</td>
	<td valign=top>
	<input type=submit value="查詢">
  	</form>
  	
  	</td>
  	</tr>
  	
 </table>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>	
<%

if(sDate ==null ||payWayS==null)
	return;

Date sDate2=jt.ChangeToDate(sDate);
Date eDate2=jt.ChangeToDate(eDate);
int payWay=Integer.parseInt(payWayS);
int logId=Integer.parseInt(logIdS);

PayFee[] pf=jt.getPayFeeByDate(payWay,logId,sDate2,eDate2); 

if(pf==null)
 
{ 
	out.println("沒有資料");
%>
	<%@ include file="bottom.jsp"%>	
<%	
	return;
} 


	
%>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共計: <font color=blue><%=pf.length%></font>筆
<center>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 align=left valign=middle>
		<td>姓名</td>
		<td>繳款方式</td>
		<td>登入日期</td>
		<td>繳款日期</td>
		<td>項目</td>
		<td>繳款登入</td>
		<td>金額</td>
		<td></td>
		<td>入帳狀態</td>
		<td></td>	
	</tr>
<%
 
	UserMgr um=UserMgr.getInstance();
	
	int xTotal=0;
	StudentMgr sm=StudentMgr.getInstance();
	for(int i=0;i<pf.length;i++)
	{
	
		Feeticket ft=ja.getFeeticketByNumberId(pf[i].getPayFeeFeenumberId());
        Student stu=(Student)sm.find(ft.getFeeticketStuId());	
%>	
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
	<td class=es02><%=stu.getStudentName()%></td>
	<td class=es02>
		<%
			int payWayA=pf[i].getPayFeeSourceCategory(); 
			
			switch(payWayA)
			{ 
				case 3:out.println("便利商店代收");
						break;
				case 2:out.println("固定虛擬帳號");
					break;
				case 1:out.println("浮動虛擬帳號");
					break;
				case 4:out.println("櫃臺繳款");
					break;
			} 

			
		%>
	</td>
	<td class=es02><%=jt.ChangeDateToString(pf[i].getPayFeeLogDate())%></td>
	<td class=es02><%=jt.ChangeDateToString(pf[i].getPayFeeLogPayDate())%></td>
	<td class=es02>
		<%
			ClassesFee[] cf=ja.getClassesFeeByNumber(ft.getFeeticketFeenumberId());		
			
			if(cf !=null)
 
			{ 
			
				for(int j=0;j<cf.length;j++)
				{		
					int cmId=cf[j].getClassesFeeCMId();
					ClassesMoney cm=(ClassesMoney)cmm.find(cmId);
		%>		
					<%=cm.getClassesMoneyName()%>: <%=mnf.format(cf[j].getClassesFeeShouldNumber()-cf[j].getClassesFeeTotalDiscount())%> <br>
			
		<%
				}
			}
		%>
	</td>
	<td class=es02>
		<%
			User ux=(User)um.find(pf[i].getPayFeeLogId()); 
			
			if(ux!=null) 
				out.println(ux.getUserFullname());
		%>
	</td>
	<td class=es02 align=right><%
 
	
		int fNumber=pf[i].getPayFeeMoneyNumber();
		xTotal +=fNumber;
		out.println(mnf.format(fNumber));

	%></td>
	
	<td class=es02>
			<a href="addPayFeeType4x.jsp?z=<%=pf[i].getPayFeeFeenumberId()%>">帳單明細</a>
	</td> 
<%	
	if(pf[i].getPayFeeVstatus()!=1)
	{
%>
	<form action="modifyPayFeeVstatus.jsp" method="post"> 
	<td class=es02 <%=(pf[i].getPayFeeVstatus()==9)?"bgcolor=FF8822":""%>>
 
		<input type=radio name="vStatus" value="0" <%=(pf[i].getPayFeeVstatus()==0)?"checked":""%>>尚未對帳<br>
		<input type=radio name="vStatus" value="9" <%=(pf[i].getPayFeeVstatus()==9)?"checked":""%>>警示 <br>		
		<input type=radio name="vStatus" value="1" <%=(pf[i].getPayFeeVstatus()==1)?"checked":""%>>已對帳
	</td>
	<td class=es02>
		<input type=hidden name="vPs" value="<%=pf[i].getPayFeeVPs()%>"> 
		<input type=hidden name="payWay" value="<%=payWayS%>">
		<input type=hidden name="logId" value="<%=logIdS%>">
		<input type=hidden name="sDate" value="<%=sDate%>">
		<input type=hidden name="eDate" value="<%=eDate%>">
 
			<input type=hidden name="pfId" value="<%=pf[i].getId()%>">
 	
		<input type=submit value="修改">
	</td>	
	</form>
<%
}else{
%>
	<td class=es02 colspan=3>
		已對帳
		<%
			int uId=pf[i].getPayFeeVId();
			User uaa=(User)um.find(uId);
			
			if(uaa !=null) 
				out.println("-"+uaa.getUserFullname());	
		%>

	</td>
<%
}
%>	
	</form>
	</tr>
<%
	}
%>
 
	<tr class=es02>
		<td colspan=6>
 
			 合 計 
		</td>
		<td align=right> 
			<b><%=mnf.format(xTotal)%></b>
		</td>
 
		<td colspan=4>
  		</td>
	</tr>

	</table>	
	
	</td>
	</tr>
	</table> 
</center>
	<br>
	<br>
<%@ include file="bottom.jsp"%>	