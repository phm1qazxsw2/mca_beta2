<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.*,java.io.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=10;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,503))
    {
        response.sendRedirect("authIndex.jsp?code=503");
    }
%>
<%@ include file="leftMenu10.jsp"%>
<%
    //##v2

    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf3=new SimpleDateFormat("yyyy/MM/dd");

    int type=-1;
    try { type=Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}

    Calendar c = Calendar.getInstance();
    c.add(Calendar.MONTH, -1);
    Date start = c.getTime();
    try { start = sdf3.parse(request.getParameter("start")); } catch (Exception e) {}

    c.setTime(start);
    c.add(Calendar.MONTH, 1);
    Date end = c.getTime();
    try { end = sdf3.parse(request.getParameter("end")); } catch (Exception e) {}

%>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<br>
<div class=es02>
    &nbsp;&nbsp;&nbsp;<img src="pic/lane.gif">&nbsp;&nbsp;<b>雜費統計</b>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="spending_list.jsp?type=<%=type%>&start=<%=sdf3.format(start)%>&end=<%=sdf3.format(end)%>&userId=-1&paidstatus=0&verifystatus=-1"><img src="pic/last2.png" border=0>&nbsp;回雜費收支明細</a>
</div>
<blockquote>
<form action="spending_analysis.jsp" name="xs" id="xs"> 
<div class=es02>
形式:
<select name="type">
<option value="-1" <%=(type==-1)?"selected":""%>>全部</option>
<option value="0" <%=(type==0)?"selected":""%>>支出</option>
<option value="1" <%=(type==1)?"selected":""%>>收入</option>
</select>

<a href="#" onclick="displayCalendar(document.xs.start,'yyyy/mm/dd',this);return false">開始日期:</a>
<input type=text name="start" value="<%=sdf3.format(start)%>" size=7>
<a href="#" onclick="displayCalendar(document.xs.end,'yyyy/mm/dd',this);return false">結束日期:</a>
<input type=text name="end" value="<%=sdf3.format(end)%>" size=7>
<input type=submit>
</div>
</form>
</blockquote>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>

<%
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");    
    Reporting r = new Reporting(_ws.getSessionBunitId(), start, end);
        
    Map<String/*acctcode*/, Vector<Vitem>> vitemMap = r.getIncomeDetails();
    Map<String/*acctcode*/, Vector<Vitem>> vitemMap2 = r.getCostDetails();
    DecimalFormat nf = new DecimalFormat("###,##0");

    if(type==-1 || type==1){
%>
    <div class=es02>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/incometicket.png" border=0>&nbsp;<b>雜費收入統計</b>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        合計金額:<%=mnf.format(r.getIncomeTotal())%> 元
        &nbsp;&nbsp;&nbsp;
        已付金額:<%=mnf.format(r.getIncomeReceived())%> 元
    </div>
    <blockquote>
<table border=0 class=es02>
<%    
    for (int i=0; objs1!=null && i<objs1.length; i++) {
    
        int nowtotal=0;
        boolean show=false;
        BigItem b = (BigItem) objs1[i];
        Vector<Vitem> vv = vitemMap.get(b.getAcctCode());
        vitemMap.remove(b.getAcctCode());
        int nn = 0;
        for (int k=0; vv!=null && k<vv.size(); k++)
            nn += vv.get(k).getTotal();
        StringBuffer sbtitle=new StringBuffer("");               
        StringBuffer sb=new StringBuffer("");   
        if (nn>0){
            nowtotal+=nn;
            sb.append("<tD align=right width=66>"+mnf.format(nn)+"</tD>");
            sbtitle.append("<tD width=66>"+b.getAcctCode()+"<br>主科目</tD>");
            show=true;
        }

        Vector<SmallItem> vs = smallitemMap.get(new Integer(b.getId()));
        for (int j=0; vs!=null&&j<vs.size(); j++) {
            String acctCode = b.getAcctCode();
            SmallItem si = vs.get(j);
            acctCode += si.getAcctCode();
            vv = vitemMap.get(acctCode);
            vitemMap.remove(acctCode); // 移掉這項
            int n = 0;
            for (int k=0; vv!=null && k<vv.size(); k++)
                n += vv.get(k).getTotal();
            if (n>0){
                nowtotal+=n;
                sbtitle.append("<td width=66>"+acctCode+"<br>"+si.getSmallItemName()+"</tD>");
                sb.append("<tD align=right width=66>"+mnf.format(n)+"</tD>");  
                show=true;                
            }
        }
        
    if(show){
%>
    <tr>
        <td>
            <table height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
                    <td rowspan=2 width=80 bgcolor=ffffff>
                        <b><%=b.getAcctCode()%></b>
                        <br>
<a href="spending_list.jsp?type=<%=type%>&start=<%=sdf3.format(start)%>&end=<%=sdf3.format(end)%>&userId=-1&paidstatus=0&verifystatus=-1&ac=<%=b.getAcctCode()%>"><%=b.getBigItemName()%></a>
                    </tD>
                    <%=sbtitle.toString()%>
                    <td bgcolor="#e9e3de" width=66 align=middle>小計</td>
                    <td bgcolor="#e9e3de" align=middle width=33>%</td>
                </tR>
                <tr bgcolor=#ffffff align=left valign=middle class=es02>
                    <%=sb.toString()%>
                    <td align=right><%=mnf.format(nowtotal)%></td>
                    <td align=right><%=changePercent(nowtotal,r.getIncomeTotal())%></td>
                </tr>
            </table>
            </td>
            </tr>
            </table>
        </td>
    </tr>  
<%
        }
    }

    Iterator<String> iter2 = vitemMap.keySet().iterator();
    while (iter2.hasNext()) {
        String acctCode = iter2.next();
        BigItem b = null;
        Vector<BigItem> vb = bigitemMap.get(acctCode);
        if (vb!=null)
            b = vb.get(0);
        Vector<Vitem> vv = vitemMap.get(acctCode);
        int n = 0;
        for (int k=0; k<vv.size(); k++) {
            n += vv.get(k).getTotal();
            System.out.println("          " + vv.get(k).getTitle());
        }
        if (n>0){
%>
    <tr>
        <td>
            <table height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
                    <td rowspan=2 width=80 bgcolor=ffffff>
                        <b><%=acctCode%></b>
                        <br>
<a href="spending_list.jsp?type=<%=type%>&start=<%=sdf3.format(start)%>&end=<%=sdf3.format(end)%>&userId=-1&paidstatus=0&verifystatus=-1&ac=<%=acctCode%>">沒有此科目</a>
                    </tD>
                    <td width=66>其它</tD>
                    <td bgcolor="#e9e3de" width=66 align=middle>小計</td>
                    <td bgcolor="#e9e3de" align=middle width=33>%</td>
                </tR>
                <tr bgcolor=#ffffff align=left valign=middle class=es02>
                    <td align=right><%=mnf.format(n)%></td>
                    <td align=right><%=mnf.format(n)%></td>
                    <td align=right><%=changePercent(n,r.getSpendingTotal())%></td>
                </tr>
            </table>
            </td>
            </tr>
            </table>
        </td>
    </tr>      
<%
        }
    }
%>
    </table>
    </blockquote>
    <br>
    <br>

    
<%
    }

    if(type==-1 || type==0){
%>


    <div class=es02>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/costticket.png" border=0>&nbsp;<b>雜費支出統計</b>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        合計金額:<%=mnf.format(r.getSpendingTotal())%> 元
        &nbsp;&nbsp;&nbsp;
        已付金額:<%=mnf.format(r.getSpendingPaid())%> 元
    </div>
    <blockquote>
    <table border=0 class=es02>      
<%
    
    for (int i=0; objs1!=null && i<objs1.length; i++) {
    
        int nowtotal=0;
        boolean show=false;
        BigItem b = (BigItem) objs1[i];
        Vector<Vitem> vv = vitemMap2.get(b.getAcctCode());
        vitemMap2.remove(b.getAcctCode());
        int nn = 0;
        for (int k=0; vv!=null && k<vv.size(); k++)
            nn += vv.get(k).getTotal();
        StringBuffer sbtitle=new StringBuffer("");               
        StringBuffer sb=new StringBuffer("");   
        if (nn>0){
            nowtotal+=nn;
            sb.append("<tD align=right width=66>"+mnf.format(nn)+"</tD>");
            sbtitle.append("<tD width=66>"+b.getAcctCode()+"<br>主科目</tD>");
            show=true;
        }

        Vector<SmallItem> vs = smallitemMap.get(new Integer(b.getId()));
        for (int j=0; vs!=null&&j<vs.size(); j++) {
            String acctCode = b.getAcctCode();
            SmallItem si = vs.get(j);
            acctCode += si.getAcctCode();
            vv = vitemMap2.get(acctCode);
            vitemMap2.remove(acctCode); // 移掉這項
            int n = 0;
            for (int k=0; vv!=null && k<vv.size(); k++)
                n += vv.get(k).getTotal();
            if (n>0){
                nowtotal+=n;
                sbtitle.append("<td width=66>"+acctCode+"<br>"+si.getSmallItemName()+"</tD>");
                sb.append("<tD align=right width=66>"+mnf.format(n)+"</tD>");  
                show=true;                
            }
        }
        
    if(show){
%>
    <tr>
        <td>
            <table height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
                    <td rowspan=2 width=80 bgcolor=ffffff>
                        <b><%=b.getAcctCode()%></b>
                        <br>
<a href="spending_list.jsp?type=<%=type%>&start=<%=sdf3.format(start)%>&end=<%=sdf3.format(end)%>&userId=-1&paidstatus=0&verifystatus=-1&ac=<%=b.getAcctCode()%>"><%=b.getBigItemName()%></a>                        
                    </tD>
                    <%=sbtitle.toString()%>
                    <td bgcolor="#e9e3de" width=66 align=middle>小計</td>
                    <td bgcolor="#e9e3de" align=middle width=33>%</td>
                </tR>
                <tr bgcolor=#ffffff align=left valign=middle class=es02>
                    <%=sb.toString()%>
                    <td align=right><%=mnf.format(nowtotal)%></td>
                    <td align=right><%=changePercent(nowtotal,r.getSpendingTotal())%></td>
                </tr>
            </table>
            </td>
            </tr>
            </table>
        </td>
    </tr>  
<%
        }
    }

    Iterator<String> iter2 = vitemMap2.keySet().iterator();
    while (iter2.hasNext()) {
        String acctCode = iter2.next();
        BigItem b = null;
        Vector<BigItem> vb = bigitemMap.get(acctCode);
        if (vb!=null)
            b = vb.get(0);
        Vector<Vitem> vv = vitemMap2.get(acctCode);
        int n = 0;
        for (int k=0; k<vv.size(); k++) {
            n += vv.get(k).getTotal();
            System.out.println("          " + vv.get(k).getTitle());
        }
        if (n>0){
%>
    <tr>
        <td>
            <table height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
                    <td rowspan=2 width=80 bgcolor=ffffff>
                        <b><%=acctCode%></b>
                        <br>
<a href="spending_list.jsp?type=<%=type%>&start=<%=sdf3.format(start)%>&end=<%=sdf3.format(end)%>&userId=-1&paidstatus=0&verifystatus=-1&ac=<%=acctCode%>">沒有資料</a>
                    </tD>
                    <td width=66>其它</tD>
                    <td bgcolor="#e9e3de" width=66 align=middle>小計</td>
                    <td bgcolor="#e9e3de" align=middle width=33>%</td>
                </tR>
                <tr bgcolor=#ffffff align=left valign=middle class=es02>
                    <td align=right><%=mnf.format(n)%></td>
                    <td align=right><%=mnf.format(n)%></td>
                    <td align=right><%=changePercent(n,r.getSpendingTotal())%></td>
                </tr>
            </table>
            </td>
            </tr>
            </table>
        </td>
    </tr>      
<%
        }
    }
%>
    </table>
    </blockquote>
    <br>
    <br>

<%
    }
%>
<br>
<%@ include file="bottom.jsp"%>
<%!
 DecimalFormat nf = new DecimalFormat("###,##0");
 public String changePercent(int number,int total){

        if(number==0 ||total==0)
        {
            return "-";
        }

        if(number >0){
            return nf.format(((float)number/(float)total*100));
        }

        if(number <0){
            int abs=Math.abs(number);
            return "("+nf.format(((float)abs/(float)total*100))+")";
        }

        return "";
    }
%>

