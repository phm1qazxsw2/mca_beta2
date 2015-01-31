<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
DecimalFormat mnf = new DecimalFormat("###,###,##0");

FeeAdmin fa=FeeAdmin.getInstance();

int cmId=Integer.parseInt(request.getParameter("cmId"));
String sYear=request.getParameter("year");
String sMonth=request.getParameter("month");

SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
Date runDate=sdf.parse(sYear+"-"+sMonth);

CfDiscount[] cfs=fa.getCfDiscountTalent(runDate,cmId);
ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
ClassesMoney cmx=(ClassesMoney)cmm.find(cmId);
if(cfs==null)
{
	out.println("沒有資料");
	return;
}
JsfTool jt=JsfTool.getInstance();
DiscountTypeMgr dtm=DiscountTypeMgr.getInstance();
StudentMgr stuM=StudentMgr.getInstance();
ClassesMgr cm=ClassesMgr.getInstance();

long runLong=runDate.getTime();

boolean runContinue=false;
Date continueDate=cmx.getClassesMoneyContinueDate();
Date lastDate=jt.getContinuedDate(continueDate,cmx.getClassesMoneyContinue());
long lastDateLong=lastDate.getTime();
if(lastDateLong ==runLong)
	runContinue=true;
%>
<script type="text/javascript" src="openWindow.js"></script> 
<script>
	function goAlert(){
		
		window.location.reload();
	
	} 
</script>
 <b><%=sdf.format(runDate)%> <%=cmx.getClassesMoneyName()%> 折扣明細</b>
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
 
<%
if(cfs==null)
{
	out.println("沒有資料");
	return;
}

%>
合計:<font color=blue><%=cfs.length%></font>筆 

<center>
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>延續</td><td>姓名</td><td>班級</td><td>折扣類別</td><td>折扣金額</td><td></td>
		</tr>
<%
int total=0; 
int totalNum=0;

for(int i=0;i<cfs.length;i++)
{
	int stuId=cfs[i].getCfDiscountStudentId();
	Student stu=(Student)stuM.find(stuId);
	DiscountType dt=(DiscountType)dtm.find(cfs[i].getCfDiscountTypeId());
	Classes cla=(Classes)cm.find(cfs[i].getCfDiscountClassId());
 
	
%>

<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
	<td class=es02>
		<%=(cfs[i].getCfDiscountContinue()==1)?"<font color=blue>是</font>":"否"%> <br>
		<a href="#" onClick="javascript:openwindow31x('<%=cfs[i].getId()%>');return false" onClick="return(confirm('確認修改延續狀態?'))">修改</a>
	</td>
	<td class=es02><%=stu.getStudentName()%></td>
	<td class=es02><%=cla.getClassesName()%></td>
	<td class=es02><%=dt.getDiscountTypeName()%></td>
	<td  class=es02 align=right><%=mnf.format(cfs[i].getCfDiscountNumber())%></td>
	<td class=es02>
		<a href="_getClassFeeByCfIdV2.jsp?z=<%=cfs[i].getCfDiscountClassesFeeId()%>&page2=cla">詳細資料</a>
	</td>
</form>
</tr>
<% 
		if(cfs[i].getCfDiscountContinue()==1)
		{
			totalNum++;
			total +=cfs[i].getCfDiscountNumber();		
		}

}
%>
<tr>
	<td colspan=5 class=es02>
		延續折扣人數:<font color=blue><%=totalNum%></font>
		&nbsp;&nbsp;&nbsp;延續金額:<font color=blue><%=mnf.format(total)%></font></tD>
 
	<td></tD>
</tr>
	

</table>

</td>
</tr>
</table>
</center>