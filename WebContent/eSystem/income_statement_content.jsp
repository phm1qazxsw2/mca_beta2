<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<link href="ft02.css" rel=stylesheet type=text/css>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<style type="text/css">
<!--
.x1 {  border: #A498BD double; height: 0px; color: #4D2078; border-width: 0px 0px 3px} 
-->
</style>
<%
    boolean commit = false;
    int tran_id = 0;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    Date d1=null;
    Date d2=new Date();

    Calendar c=Calendar.getInstance();
    c.setTime(d2);
    c.set(Calendar.DATE,1);    
    d1=c.getTime();

    String d1S=request.getParameter("d1");
    String d2S=request.getParameter("d2");
    
    try{
        if(d1S !=null)
            d1=sdf.parse(d1S);

        if(d2S !=null)
            d2=sdf.parse(d2S);
    }catch(Exception e){}    

    Date nextDay = null;
    try {
        //d = sdf.parse(request.getParameter("d"));
        c.setTime(d2);
        c.add(Calendar.DATE, 1);
        nextDay = c.getTime();
    }
    catch (Exception e) {
    }

    StringBuffer sb=new StringBuffer("");
    StringBuffer sbScript=new StringBuffer("<script>");
    double totalIncome=0;
    double totalCost=0;
    DecimalFormat mnf = new DecimalFormat("###,###.#"); 
    String groupByS=request.getParameter("groupBy");
    int groupBy=0;

    if(groupByS !=null)
        groupBy=Integer.parseInt(groupByS);

    boolean show_main=(groupBy==0)?true:false;

    int printPage=0;
    String ppS=request.getParameter("printPage");
    if(ppS !=null)
        printPage=Integer.parseInt(ppS);

    try {           
        tran_id = dbo.Manager.startTransaction();
        VchrItemSumMgr vismgr = new VchrItemSumMgr(tran_id);

        String query ="'"+sdf.format(d1)+"'<= vchr_holder.registerDate and vchr_holder.registerDate<'" + sdf.format(nextDay) + "'";
        query += " and vchr_holder.type=" + VchrHolder.TYPE_INSTANCE;

        String groupString=" group by acode.main ";
        if(groupBy==1)
            groupString=" group by fullkey";

        WebSecurity _ws3 = WebSecurity.getInstance(pageContext);
        ArrayList<VchrItemSum> sums = vismgr.retrieveListX(query,groupString, _ws3.getBunitSpace("vchr_holder.buId"));
        boolean show_main_only = true;
        Map<String, ArrayList<VchrItemSum>> sumsMap = new SortingMap(sums).doSortA("getFirstDigit");

        String[] loops = { "4", "收入","7", "業外收入費用", "5", "成本", "6", "費用" };

        for (int i=0; i<loops.length; )
        {
   
            String cat = loops[i++];
            String name = loops[i++];

            int acode=Integer.parseInt(cat);
            sums = sumsMap.get(cat);
            if (acode==4)
                sb.append("<tr class=es02 bgcolor=ffffff><td colspan=6 align=left><b>收 入 :</b></td></tr> ");
            else if(acode==5)
                sb.append("<tr class=es02 bgcolor=ffffff><td colspan=6 align=left><b>費 用 :</b></td></tr> ");

            //if (sums!=null)
            //    sb.append("<tr class=es02 bgcolor=ffffff><td colspan=6 align=left>&nbsp;&nbsp;"+name+"(" + acode + ")</td></tr> ");

            double debit = 0;
            double credit = 0;
            if (sums!=null) {
                VchrSumInfo vinfo = new VchrSumInfo(sums, show_main_only, tran_id);
                for (int j=0; j<sums.size(); j++) {
                    VchrItemSum s = sums.get(j);
                    double nowTotal = 0;
                    String divName="";
                    if(acode==4 || acode==7){
                        nowTotal=s.getCredit()-s.getDebit();
                        totalIncome+=nowTotal;
                        divName="in"+acode+j;
                    }else{
                        nowTotal=s.getDebit()-s.getCredit();
                        totalCost+=nowTotal;
                        divName="co"+acode+j;
                    }
    
                    if(nowTotal==0)
                        continue;

                    if(acode==4 || acode==7)
                        sbScript.append("runPercentIncome('"+divName+"','"+(int)nowTotal+"');");
                    else
                        sbScript.append("runPercentCost('"+divName+"','"+(int)nowTotal+"');");

                    sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" class=es02><td></td>"+vinfo.printTableSum(s,nowTotal,show_main));
                    sb.append("<td width=30></td><td align=right class=es02><div id='"+divName+"'></div></td><td align=middle class=es02><a target=_blank href='vchr/history.jsp?a="+s.getAcodeId()+
                        ((d1!=null)?"&d1=" + sdf.format(d1):"")+((d2!=null)?"&d=" + sdf.format(d2):"")+"'>明細</a></td></tr>");
                }
            }

            if(acode==7)
                    sb.append("<tr class=es02 bgcolor=ffffff><td colspan=3 align=middle><b>收入合計</b></td><td align=right><u>"+mnf.format(totalIncome)+"</u></td><td align=right><u>100</u></td><td></td></tr>");
            else if(acode==6)
                    sb.append("<tr class=es02 bgcolor=ffffff><td colspan=3 align=middle><b>費用合計</b></td><td align=right><u>"+mnf.format(totalCost)+"</u></td><td align=right><u>100</u></td><td></td></tr>");
            
        }

        sbScript.append("</script>");
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit){
            dbo.Manager.rollback(tran_id);
            out.println("系統發生錯誤,請洽必亨客服");
        }else{

            PaySystemMgr pmzx2=PaySystemMgr.getInstance();
            PaySystem pZ2x=(PaySystem)pmzx2.find(1);
            WebSecurity _ws_ = WebSecurity.getInstance(pageContext);
            String title=((printPage==0)?"":new BunitHelper().getCompanyNameTitle(_ws_.getSessionBunitId()))
                +"&nbsp;損益表 (Income Statement)";

%>
<title><%=title%></title>
<script>
    function runPercentIncome(divName,itemTotal){
        var inTotal=<%=(int)totalIncome%>;
        document.getElementById(divName).innerHTML=parseInt((eval(itemTotal)/eval(inTotal)*100));
    }

    function runPercentCost(divName,itemTotal){
        var inTotal=<%=(int)totalCost%>;
        document.getElementById(divName).innerHTML=parseInt((eval(itemTotal)/eval(inTotal)*100));
    }
</script>
<br>

<% if (printPage==0) { %>

<div class=es02>
<b>&nbsp;&nbsp;
<%=title%></b>
</div>

<ul>
    <form name="f" action="income_statement.jsp" method="get" onsubmit="return doSubmit(this)">
   損益區間　
    從:
    <input type=text name="d1" value="<%=sdf.format(d1)%>" size=8>&nbsp;<a href="#" onclick="displayCalendar(document.f.d1,'yyyy-mm-dd',this);return false"><img src="pic/blog4.gif" border=0></a>
    &nbsp;&nbsp;至:
    <input type=text name="d2" value="<%=sdf.format(d2)%>" size=8>&nbsp;<a href="#" onclick="displayCalendar(document.f.d2,'yyyy-mm-dd',this);return false"><img src="pic/blog4.gif" border=0></a>
    <input type=submit value="查詢">
    </form>

</ul>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table> 

    <br> 
    <div class=es02 align=right>
        <%  if(groupBy==0){ %>
        <a href="income_statement.jsp?d1=<%=sdf.format(d1)%>&d2=<%=sdf.format(d2)%>&groupBy=1">以次科目分類</a>          
        <%  }else{  %>
        <a href="income_statement.jsp?d1=<%=sdf.format(d1)%>&d2=<%=sdf.format(d2)%>&groupBy=0">以主科目分類</a>          
        <%  }   %>
         | <a href="income_statement_content.jsp?d1=<%=sdf.format(d1)%>&d2=<%=sdf.format(d2)%>&printPage=1&groupBy=<%=groupBy%>" target="_blank"><img src="pic/print.png" border=0>&nbsp;列印本頁</a>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<%  }
    else {  %>

<div class=es02>
<b>&nbsp;&nbsp;
<%=title%>
<br>
&nbsp;&nbsp;&nbsp;區間: <%=d1S%> 至 <%=d2S%>
</b>
</div>

<%  }   %>

    <br>
    <blockquote>
    <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
            <td bgcolor="#e9e3de">
            <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
                    <td></td><td align=middle>會計科目名稱</tD><td align=middle>金 額</td><td align=middle>小計</td><td align=middle> % </td><tD></td>
                </tr>
                <%=sb.toString()%>
                <tr class=es02>
                    <td colspan=3><b>淨 利:</b></td><td align=right class=es02><b><div class=x1><%=mnf.format(totalIncome-totalCost)%></div></b><td></td></td><tD></td>
                </tr>
                </table>
            </td>
        </tr>
    </table>
    </blockquote>
    <br>
    <br>
    <%=sbScript%>
<%
        }
    }    
%>