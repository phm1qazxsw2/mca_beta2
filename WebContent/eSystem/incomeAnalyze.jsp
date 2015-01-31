<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*,jsi.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=5;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu2-new.jsp"%>
 
<%
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat sdf3=new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");

    VitemMgr vpmgr = VitemMgr.getInstance();
    MembrInfoBillRecordMgr mbrmgr = MembrInfoBillRecordMgr.getInstance();

    Date start = new Date();
    Date end = new Date();
    if (vpmgr.numOfRowsX("", _ws.getBunitSpace("bunitId"))>0) {
        Object[] objs = vpmgr.retrieveX("", "order by recordTime asc limit 1", _ws.getBunitSpace("bunitId"));
        Vitem first = (Vitem) objs[0];
        objs = vpmgr.retrieveX("", "order by recordTime desc limit 1", _ws.getBunitSpace("bunitId"));
        Vitem last = (Vitem) objs[0];
        start = first.getRecordTime();
        end = last.getRecordTime();
    }
    if (mbrmgr.numOfRowsX("", _ws.getBunitSpace("bill.bunitId"))>0) {
        Object[] objs = mbrmgr.retrieveX("", "order by ticketId asc limit 1", _ws.getBunitSpace("bill.bunitId"));
        MembrInfoBillRecord first = (MembrInfoBillRecord) objs[0];
        objs = mbrmgr.retrieveX("", "order by ticketId desc limit 1", _ws.getBunitSpace("bill.bunitId"));
        MembrInfoBillRecord last = (MembrInfoBillRecord) objs[0];
        if (first.getBillMonth().compareTo(start)<0)
            start = first.getBillMonth();
        if (last.getBillMonth().compareTo(end)>0)
            end = last.getBillMonth();
    }

    EzCountingService ezsvc = EzCountingService.getInstance();

    Calendar cal = Calendar.getInstance();
    String[] monstr = request.getParameterValues("t");
    Date[][] cur=null;
    int[][] numbers=null;
    Hashtable ha=new Hashtable();
    if (monstr!=null) {
         cur=new Date[monstr.length][2];        
         numbers=new int[monstr.length][8]; //

        ArrayList<MembrInfoBillRecord> bills =null; //new ArrayList<MembrInfoBillRecord>();
        ArrayList<MembrInfoBillRecord> salaries =null; //new ArrayList<MembrInfoBillRecord>();
        ArrayList<Vitem> income =null; //new ArrayList<Vitem>();
        ArrayList<Vitem> cost = null; //new ArrayList<Vitem>();


        for(int i=0;i<monstr.length;i++)
        {
            ha.put((String)monstr[i],(String)"1");

            Date curX = sdf.parse(monstr[i]);
            bills = new ArrayList<MembrInfoBillRecord>();
            salaries = new ArrayList<MembrInfoBillRecord>();
            income = new ArrayList<Vitem>();
            cost = new ArrayList<Vitem>();

            cur[i][0] = sdf.parse(sdf.format(curX));
            cal.setTime(cur[i][0]);
            cal.add(Calendar.MONTH, 1);
            cur[i][1] = cal.getTime();
            ezsvc.getMonthlyNumbers(_ws.getSessionBunitId(), numbers[i], cur[i][0], cur[i][1], bills, salaries, income, cost);
        }
    }
%>
<script>
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


</script>
<br>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;<b>跨月損益統計</b></div>
<center>
<TABLE width=80%>
    <TR class=es02>
<form action="" method="get">
        <td width=80 align=middle bgcolor="#f0f0f0">
            
            <b>查詢月份:</b><br>

            <input type="checkbox" onClick="this.value=check(this.form.t)">全選&nbsp;
        </td>
        <td width=500>
            <table border=0 100%><tr>
            <%
            Calendar c = Calendar.getInstance();
            c.setTime(end);
            int i = 0;  int nowrpw=0;
            //String curmonstr = sdf.format(cur);
            for (Date d=c.getTime(); d.compareTo(start)>=0; c.add(Calendar.MONTH, -1),d=c.getTime()) {
                String mstr = sdf.format(d);

                if(nowrpw>0 && nowrpw%6==0)
                    out.println("<tr>");
                
                out.println("<td>");
              %>
                <input type=checkbox name="t" value="<%=mstr%>" <%=(ha.get(mstr)!=null)?"checked":""%>><%=mstr%>
              <%
                out.println("</td>");

                if(nowrpw>0 && nowrpw%6==5)
                    out.println("</tr>");                
                nowrpw++;
            }
          %>
            </table>
        </td>
        <tD width=40>
            <input type=submit onchange="this.form.submit();" value="確認">    
        </td>
</form>
    </tr>
    </table>  
</center>     

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


<%

    if(monstr==null){
%>
        <br>
        <br>
        <blockquote>
            <div class=es02>請點選預查詢的月份.</div>
        </blockquote>
        <%@ include file="bottom.jsp"%>
<%
        return;
    }
%>
    <br>
    <br>
<%
if(monstr.length >6){
%>
    <center>
<%
    }else{
%>
    <blockquote>
<%  }   %>
	<table height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=f0f0f0 class=es02>
        <td width=80></td>
<%
    for(int j=0;j<monstr.length;j++){
%>
        <tD width=80 align=middle><b><%=monstr[j]%></b></td>
<%
        }
%>  
        <tD width=80 align=middle><b>小 計</b></td>
        </tr>        
<%
    int totalFee=0;
    int totalIncome=0;
    int totalSalary=0;
    int totalCost=0;

    for(int k=0;k<6;k++)
    {

        if(k==0){

%>
            <tr bgcolor=f0f0f0 class=es02>
                <tD>學費收入</td>
<%
            for(int j=0;j<monstr.length;j++){

                totalFee+=numbers[j][4];
%>
                <td bgcolor=ffffff align=right><%=mnf.format(numbers[j][4])%></td>
<%
            }
%>
            <td width=80 align=right><%=mnf.format(totalFee)%></tD>
            </tr>
<%
        }else if(k==1){
%>
            <tr bgcolor=f0f0f0 class=es02>
                <tD>雜費收入</td>
<%
            for(int j=0;j<monstr.length;j++){

                totalIncome+=numbers[j][0];
%>
                <td bgcolor=ffffff align=right><%=mnf.format(numbers[j][0])%></td>
<%
            }
%>  
            <td width=80 align=right><%=mnf.format(totalIncome)%></tD>
            </tr>
<%
        }else if(k==2){
%>
            <tr bgcolor=f0f0f0 class=es02>
                <tD>薪資支出</td>
<%
                for(int j=0;j<monstr.length;j++){

                    totalSalary+=numbers[j][6];
%>
                    <td bgcolor=ffffff align=right><%=mnf.format(numbers[j][6])%></td>
<%
                }
%>  
                <td width=80 align=right><%=mnf.format(totalSalary)%></tD>
            </tr>
<%
        }else if(k==3){
%>
            <tr bgcolor=f0f0f0 class=es02>
                <tD>雜費支出</td>
<%
                for(int j=0;j<monstr.length;j++){
                    totalCost+=numbers[j][2];
%>
                    <td bgcolor=ffffff align=right><%=mnf.format(numbers[j][2])%></td>
<%
                }
%>              
                <td width=80 align=right><%=mnf.format(totalCost)%></tD>
            </tr>
<%
        }
    }
%>
    <tr class=es02>
        <td align=middle><b>損 益</b></tD>
<%
    int total=0;        
    for(int j=0;j<monstr.length;j++){
        int monthTotal=numbers[j][4]+numbers[j][0]-numbers[j][2]-numbers[j][6];

        total+=monthTotal;
%>
        <tD align=right><b><%=mnf.format(monthTotal)%></b></td>
<%
        }
%>
        <td width=80 align=right><b><%=mnf.format(total)%></b></tD>
    </table>
    </td>
    </tr>
    </table>  
<%
if(monstr.length > 6){
%>
    </center>
<%
    }else{
%>
    </blockquote>
<%  }   %>   
    <br>
    <br>


<%@ include file="bottom.jsp"%>