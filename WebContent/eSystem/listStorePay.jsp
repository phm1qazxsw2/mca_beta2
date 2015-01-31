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
	
	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	
	String sDate=request.getParameter("sDate");
 	String eDate=request.getParameter("eDate");
 	
 	 Date now=new Date();
	 long nowLong=now.getTime();
	 long beforeLong=nowLong-(long)1000*60*60*24*31;
	 
	 Date beforeDate=new Date(beforeLong);
	 
	 
	 String nowString=jt.ChangeDateToString(now);	
	 String beforeString=jt.ChangeDateToString(beforeDate);
	 String statusX=request.getParameter("status");
         String typeX=request.getParameter("type");
%>
<head>
<script language="JavaScript" src="js/calendar.js"></script>
<script language="JavaScript" src="js/overlib_mini.js"></script>
<script language="JavaScript" src="js/in.js"></script>

</head>
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>

<blockquote>
<br>
<b><<便利商店繳款查詢介面>></b>
<BR>
<br>
<table>
	<tr>
	<form action="listStorePay.jsp" method=get name="xs">
	<td valign=top>
		<select size=1 name="status">
			<option value="99" <%=(statusX!=null && statusX.equals("99"))?"selected":""%>>全選</option>
			<option value="1" <%=(statusX!=null && statusX.equals("1"))?"selected":""%>>匯入成功</option>
			<option value="0" <%=(statusX!=null && statusX.equals("0"))?"selected":""%>>匯入失敗</option>
		</select>
	</td>
	<td valign=top>
		<select size=1 name="type">
			<option value="0" <%=(typeX!=null && typeX.equals("0"))?"selected":""%>>上傳日期</option>
			<option value="1" <%=(typeX!=null && typeX.equals("1"))?"selected":""%>>繳款日期</option>
		</select>
	</td>
	<td valign=top>
		<input type=text name=sDate size=10 value="<%=(sDate==null)?beforeString:sDate%>">
		<a href="javascript:show_calendar('xs.sDate');" onMouseOver="window.status='選擇日曆上的日期.'; overlib('選擇日曆上的日期.'); return true;" onMouseOut="window.status=''; nd(); return true;"><img src="images/show-calendar.gif" width=24 height=22 border=0></a>
		
		-<input type=text name=eDate size=10 value="<%=(eDate==null)?nowString:eDate%>">
		<a href="javascript:show_calendar('xs.eDate');" onMouseOver="window.status='選擇日曆上的日期.'; overlib('選擇日曆上的日期.'); return true;" onMouseOut="window.status=''; nd(); return true;"><img src="images/show-calendar.gif" width=24 height=22 border=0></a>
	</td>
	
	
	<td valign=top>
	<input type=submit onClick="checkYear10()" value="查詢">
  	</form>
  	</td>
  	</tr>
  	
 </table>
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<%

if(sDate ==null || typeX==null)
	return;
	
Date sDate2=jt.ChangeToDate(sDate);
Date eDate2=jt.ChangeToDate(eDate);
int status=Integer.parseInt(statusX);
int type=Integer.parseInt(typeX);

PayStore[] ps=jt.getPayStoreBySdateEdate(type,sDate2,eDate2,status);

if(ps==null)
{
	out.println("此其間沒有資料");
	return;
}	


	
%>
	<table>
	<tr>
		<td>姓名</td>
		<td>匯入日期</td>
		<td>繳款日期</td>
		<td>狀態</td>
		<td>帳單流水號</td>
		<td></td>
	</tr>
<%
	StudentMgr sm=StudentMgr.getInstance();
	for(int i=0;i<ps.length;i++)
	{
	
		Feeticket ft=ja.getFeeticketByNumberId(ps[i].getPayStoreFeeticketId());
            	Student stu=(Student)sm.find(ft.getFeeticketStuId());	
%>	
	<tr>
	<td><%=stu.getStudentName()%></td>
	<td><%=jt.ChangeDateToString(ps[i].getCreated())%></td>
	<td><%=jt.ChangeDateToString(ps[i].getPayStorePayDate())%></td>
	<td><%
		switch(ps[i].getPayStoreStatus())
		{
		
			case 2:out.println("<font color=red>原始字串長度</font>");
				break;
			case 3:out.println("<font color=red>原始內容無法轉換</font>");
				break;
			case 4:out.println("<font color=red>流水編號錯誤</font>");
				break;
			case 5:out.println("<font color=red>無法銷單</font>");
				break;
			case 6:out.println("<font color=red>重複銷單</font>");
				break;	
			case 90:out.println("<font color=blue>銷單成功</font>");
				break;		
		}
		
	%></td>
	<td>
	<a href="#" onClick="javascript:openwindow34('<%=ps[i].getPayStoreFeeticketId()%>');return false"><%=ps[i].getPayStoreFeeticketId()%></a></td>
	<td><%
		if(ps[i].getPayStoreStatus()<90)
		{
			out.println(ps[i].getPayStoreException());
		}else{
	%>
			<a href="#" onClick="javascript:openwindow35('3','<%=ps[i].getId()%>');return false">詳細資料</a>
	<%
		}
	%>		
	
	</td>
	</tr>
<%
	}
%>
	</table>	
<%@ include file="bottom.jsp"%>