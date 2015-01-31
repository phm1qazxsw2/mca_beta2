<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf3 = new SimpleDateFormat("yyyy/MM/dd");
    Date d = new Date();
    Date nextDay = null;
    try {
        d = sdf.parse(request.getParameter("d"));
    }
    catch (Exception e) {
    }
    Calendar c = Calendar.getInstance();
    c.setTime(d);
    c.add(Calendar.DATE, 1);
    nextDay = c.getTime();

    //## 2009/3/2 peter 加損益區間
    c.add(Calendar.MONTH, -1);
    c.set(Calendar.DAY_OF_MONTH, 1);
    Date b = sdf2.parse(sdf2.format(c.getTime()));
    try { b = sdf.parse(request.getParameter("b")); } catch (Exception e) {}

    StringBuffer sb=new StringBuffer("");
    StringBuffer sbScript=new StringBuffer("<script>");
    double total1=0;
    double total2=0;
    double total3=0;
    DecimalFormat mnf = new DecimalFormat("###,###.#"); 
    String groupByS=request.getParameter("groupBy");
    int groupBy=0;

    if(groupByS !=null)
        groupBy=Integer.parseInt(groupByS);

    int printPage=0;

    String ppS=request.getParameter("printPage");
    if(ppS !=null)
        printPage=Integer.parseInt(ppS);

    boolean show_main=(groupBy==0)?true:false;
    try {           
        tran_id = dbo.Manager.startTransaction();
        VchrItemSumMgr vismgr = new VchrItemSumMgr(tran_id);

        String query = "vchr_holder.registerDate < '" + sdf.format(nextDay) + "'";

        query += " and vchr_holder.type=" + VchrHolder.TYPE_INSTANCE;

        String groupString=" group by acode.main ";
        if(groupBy==1)
            groupString=" group by fullkey ";
        
        WebSecurity _ws3 = WebSecurity.getInstance(pageContext);
        ArrayList<VchrItemSum> sums = vismgr.retrieveListX(query,groupString, _ws3.getBunitSpace("vchr_holder.buId"));
        Map<String, ArrayList<VchrItemSum>> sumsMap = new SortingMap(sums).doSortA("getFirstDigit");

        // 以下算本期損益
        query += " and vchr_holder.registerDate>='" + sdf.format(b) + "' and acode.main>'4'";
        ArrayList<VchrItemSum> inbetweens = vismgr.retrieveListX(query, groupString, _ws3.getBunitSpace("vchr_holder.buId"));

        double cur_net = 0;
        for (int i=0; i<inbetweens.size(); i++)
            cur_net += (inbetweens.get(i).getCredit() - inbetweens.get(i).getDebit());

        String[] loops = { "1", "資產", "2", "負債", "3", "業主權益"};

        for (int i=0; i<loops.length; )
        {
            String cat = loops[i++];
            String name = loops[i++];
            int section = Integer.parseInt(cat);
            sums = sumsMap.get(cat);

            int colspan = (printPage==0)?6:5;
            if (section==1) {
                sb.append("<tr class=es02 bgcolor=ffffff><td colspan="+colspan+" align=left><b>資 產 :</b></td></tr> ");
            }
            else if(section==2)
                sb.append("<tr class=es02 bgcolor=ffffff><td colspan="+colspan+" align=left><b>負 債 :</b></td></tr> ");
            else if(section==3)
                sb.append("<tr class=es02 bgcolor=ffffff><td colspan="+colspan+" align=left><b>業主權益 :</b></td></tr> ");

            double debit = 0;
            double credit = 0;

            if (sums!=null) {
                VchrSumInfo vinfo = new VchrSumInfo(sums, show_main, tran_id);
                for (int j=0; j<sums.size(); j++) {
                    VchrItemSum s = sums.get(j);
                    double nowTotal = 0;
                    String divName="";
                    if(section==1){
                        nowTotal=s.getDebit()-s.getCredit();
                        total1+=nowTotal;
                        divName="b1_"+j;

                    }else if(section==2){
                        nowTotal=s.getCredit()-s.getDebit();
                        total2+=nowTotal;
                        divName="b2_"+j;

                    }else{
                        nowTotal=s.getCredit()-s.getDebit();
                        total3+=nowTotal;
                        divName="b3_"+j;
                    }
                    
                    if(nowTotal==0)
                        continue;
                   
                    sbScript.append("runPercentB"+section+"('"+divName+"','"+(int)nowTotal+"');");
                    sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" class=es02><td></td>"+vinfo.printTableSum(s,nowTotal,show_main));
                    sb.append("<td width=30></td><td align=right class=es02><div id='"+divName+"'></div></td>");
                    if (printPage==0) {
                        sb.append("<td align=middle class=es02>明細</td></tr>");
                    }
                }
            }

            if(section==3){
                String divName="b3_3351";
                double accumulate = total1-total2-total3-cur_net; 
                sbScript.append("runPercentB3('"+divName+"','"+(int)accumulate+"');");                
                sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" class=es02><td></td><td class=es02>3351 累計盈餘:</td><td align=right class=es02>"+mnf.format(accumulate)+"</td>");
                sb.append("<td width=30></td><td align=right class=es02><div id='"+divName+"'></div></td>");

                if (printPage==0) {
                    c.setTime(b);
                    c.add(Calendar.DATE, -1);
                    sb.append("<td align=middle class=es02><a target=_blank href=\"income_statement.jsp?d1=0000-00-00&d2="+sdf.format(c.getTime())+"&groupBy="+groupBy+"\">明細</a></td></tr>");
                }

                divName="b3_3353";
                sbScript.append("runPercentB3('"+divName+"','"+(int)cur_net+"');");                
                sb.append("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" class=es02><td></td><td class=es02>3353 本期損益:</td><td align=right class=es02>"+mnf.format(cur_net)+"</td>");
                sb.append("<td width=30></td><td align=right class=es02><div id='"+divName+"'></div></td>");

                total3+=accumulate+cur_net;

                if (printPage==0) {
                    sb.append("<td align=middle class=es02><a target=_blank href=\"income_statement.jsp?d1="+sdf.format(b)+"&d2="+sdf.format(d)+"&groupBy="+groupBy+"\">明細</a></td></tr>");
                }
            }

            if(section==1)
                    sb.append("<tr class=es02 bgcolor=ffffff><td colspan=3 align=middle><b>資 產 合 計</b></td><td align=right><u>"+mnf.format(total1)+"</u></td><td align=right><u>100</u></td>" +
                    ((printPage==0)?"<td></td>":"")+"</tr>");
            else if(section==2)
                    sb.append("<tr class=es02 bgcolor=ffffff><td colspan=3 align=middle><b>負 債 合 計</b></td><td align=right><u>"+mnf.format(total2)+"</u></td><td align=right><u>100</u></td>" + 
                    ((printPage==0)?"<td></td>":"")+"</tr>");
            else if(section==3)
                    sb.append("<tr class=es02 bgcolor=ffffff><td colspan=3 align=middle><b>業 主 權 益 合 計</b></td><td align=right><u>"+mnf.format(total3)+"</u></td><td align=right><u>100</u></td>" + 
                    ((printPage==0)?"<td></td>":"")+"</tr>");

        }

        sbScript.append("</script>");

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit){
            dbo.Manager.rollback(tran_id);
        }else{
            WebSecurity _ws_ = WebSecurity.getInstance(pageContext);
            PaySystemMgr pmzx2=PaySystemMgr.getInstance();
            PaySystem pZ2x=(PaySystem)pmzx2.find(1);
            String title=((printPage==0)?"":new BunitHelper().getCompanyNameTitle(_ws_.getSessionBunitId()))+
                "&nbsp;資產負債表 (Balence Sheet)";
%>
<title><%=title%></title>

<script src="js/dateformat.js"></script>
<script>
    function runPercentB1(divName,itemTotal){

        var inTotal=<%=(int)total1%>;
        document.getElementById(divName).innerHTML=parseInt((eval(itemTotal)/eval(inTotal)*100));
    }

    function runPercentB2(divName,itemTotal){
        var inTotal=<%=(int)total2%>;
        document.getElementById(divName).innerHTML=parseInt((eval(itemTotal)/eval(inTotal)*100));
    }

    function runPercentB3(divName,itemTotal){
        var inTotal=<%=(int)total3%>;
        document.getElementById(divName).innerHTML=parseInt((eval(itemTotal)/eval(inTotal)*100));
    }

    function check_submit(f)
    {
        if (!isDate(f.b.value, "yyyy-MM-dd")) {
            alert("請輸入正確的損益區間起始日期");
            f.b.focus();
            return false;
        }
        if (!isDate(f.d.value, "yyyy-MM-dd")) {
            alert("請輸入正確的損益區間終止日期");
            f.d.focus();
            return false;
        }
        return true;
    }
</script>
<!--############# -->
<link rel="stylesheet" href="css/dhtmlwindow.css" type="text/css" />
<link href="ft02.css" rel=stylesheet type=text/css>
<script type="text/javascript" src="openWindow.js"></script> 
<script src="js/show_voucher.js"></script>
<!--############# -->
<!-- ####### below needed by vchr_search_tool.jsp ####-->
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

    <div class=es02>
    <br>
    &nbsp;&nbsp;&nbsp;<b>資產負債表 (Balance Sheet)</b>

    <% if (printPage==1) { %>
    <b>　　　　<%=title%>
    <br>　　　　損益區間: <%=sdf3.format(b)%> - <%=sdf3.format(d)%>
    </b>
    <% } %>
</div>
<ul class=es02>
    <form name="f" action="balance_sheet.jsp" method="get" onsubmit="return check_submit(this)">
<% if (printPage==0) { %>
    損益區間　
    從:
    <input type=text name="b" value="<%=sdf.format(b)%>" size=8>
    <a href="#" onclick="displayCalendar(document.f.b,'yyyy-mm-dd',this);return false"><img src="pic/blog4.gif" border=0></a>
    　
    至:
    <input type=text name="d" value="<%=sdf.format(d)%>" size=8>
    <a href="#" onclick="displayCalendar(document.f.d,'yyyy-mm-dd',this);return false"><img src="pic/blog4.gif" border=0></a>
    &nbsp;&nbsp;<input type=submit value="查詢">
<% } %>
    </form>
</ul>

<%
    if(printPage==0){
%>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table> 
    <br> 
    <div class=es02 align=right>
     <%  if(groupBy==0){ %>
        <a href="balance_sheet.jsp?b=<%=sdf.format(b)%>&d=<%=sdf.format(d)%>&groupBy=1">以次科目分類</a>          
        <%  }else{  %>
        <a href="balance_sheet.jsp?b=<%=sdf.format(b)%>&d=<%=sdf.format(d)%>&groupBy=0">以主科目分類</a>          
        <%  }   %>
         | <a href="balance_sheet_content.jsp?b=<%=sdf.format(b)%>&d=<%=sdf.format(d)%>&printPage=1&groupBy=<%=groupBy%>" target="_blank"><img src="pic/print.png" border=0>&nbsp;列印本頁</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>

<%  } %>
    <blockquote>
    <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
            <td bgcolor="#e9e3de">
            <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
                    <td></td><td align=middle>會計科目名稱</tD><td align=middle>金 額</td><td align=middle>小計</td><td align=middle> % </td><%=(printPage==0)?"<td></td>":""%>
                </tr>
                <%=sb.toString()%>
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
