<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=11;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(!checkAuth(ud2,authHa,404))
    {
        response.sendRedirect("authIndex.jsp?code=404");
    }
%>
<%@ include file="leftMenu11.jsp"%>
<%
    //##v2    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    int total = (int)0;

    // 找出未兌現支票 (cashed is NULl or 0000-00-00)
    ArrayList<Cheque> income_cheques = ChequeMgr.getInstance().
        retrieveListX("(cashed is NULL or cashed<'0000-00-01') and type in (1,2)", "order by cashDate asc", _ws.getBunitSpace("bunitId"));
    ArrayList<Cheque> pay_cheques = ChequeMgr.getInstance().
        retrieveListX("(cashed is NULL or cashed<'0000-00-01') and type in (3,4)", "order by cashDate asc", _ws.getBunitSpace("bunitId"));

    String title = "未兌現支票查詢";
    _ws.setBookmark(ud2, title);
%>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/cheque.png" border=0>&nbsp;未兌現支票查詢</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>

<form name="f1" id="f1">
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;未兌現-收款支票</b>
</div>
<center>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
    <table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
         <td align=middle nowrap width=15%>登入日期</td>
         <td align=middle nowrap width=20%>兌現日期</td>
         <td align=middle nowrap width=15%>支票號碼</td>
         <td align=middle nowrap width=25%>支票內容</td>
         <td align=middle nowrap width=10%>金額</td>
         <td></td>
      </tr>

<%     
    ChequeDescription cd = new ChequeDescription(income_cheques);
    Date now = new Date();
    Iterator<Cheque> iter = income_cheques.iterator();
    while (iter.hasNext()) {
        Cheque ch = iter.next();        
        boolean in = (ch.getType()==Cheque.TYPE_INCOME_TUITION) || (ch.getType()==Cheque.TYPE_SPENDING_INCOME);
%>
		<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>    
            <td class=es02>
                <%=(ch.getRecordTime() !=null)?sdf.format(ch.getRecordTime()):""%>
            </td>
            <td class=es02>
                <%=(ch.getCashDate().compareTo(now)<0)?"<img src=\"pic/star2.png\" border=0>":"&nbsp;&nbsp;&nbsp;"%>
                <%=sdf.format(ch.getCashDate())%>
                <input type=hidden name="aa<%=ch.getId()%>" value="<%=(ch.getCashDate() !=null)?sdf.format(ch.getCashDate()):""%>">
        <a href="#" onclick="displayCalendar(document.f1.aa<%=ch.getId()%>,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
            </td>
            <td class=es02><%=ch.getChequeId()%></td>
            <td class=es02><%=cd.getDescription(ch)%></td>
            <td class=es02 align=right><%=mnf.format(ch.getInAmount())%></td>
            <td class=es02 align=middle><a href="javascript:openwindow_phm('cheque_realize.jsp?id=<%=ch.getId()%>','支票兌現',500,400,true)"><img src="pic/type23.png" border=0>&nbsp;兌現存入</a></td>
        </tr>
<%
    }
%>

</table>
</td>
</tr>
</table>
</center>
<br>
<br>
<!-- ############### 付款 below ################ -->
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;未兌現-付款支票</b>
</div>
<center>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
    <table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
         <td align=middle nowrap width=15%>登入日期</td>
         <td align=middle nowrap width=20%>兌現日期</td>
         <td align=middle nowrap width=15%>支票號碼</td>
         <td align=middle nowrap width=25%>支票內容</td>
         <td align=middle nowrap width=10%>金額</td>
         <td></td>
      </tr>

<%     
    cd = new ChequeDescription(pay_cheques);
    iter = pay_cheques.iterator();
    while (iter.hasNext()) {
        Cheque ch = iter.next();        
        boolean in = (ch.getType()==Cheque.TYPE_INCOME_TUITION) || (ch.getType()==Cheque.TYPE_SPENDING_INCOME);
%>
		<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td class=es02>
                <%=(ch.getRecordTime() !=null)?sdf.format(ch.getRecordTime()):""%>
            </td>
            <td class=es02>
                <%=(ch.getCashDate().compareTo(now)<0)?"<img src=\"pic/star2.png\" border=0>":"&nbsp;&nbsp;&nbsp;"%>
                <%=sdf.format(ch.getCashDate())%>
                <input type=hidden name="bb<%=ch.getId()%>" value="<%=(ch.getCashDate() !=null)?sdf.format(ch.getCashDate()):""%>">
                <a href="#" onclick="displayCalendar(document.f1.bb<%=ch.getId()%>,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
            </td>
            <td class=es02><%=ch.getChequeId()%></td>
            <td class=es02><%=cd.getDescription(ch)%></td>
            <% int amount = (in)?ch.getInAmount():ch.getOutAmount(); %>
            <td class=es02 align=right><%=mnf.format(amount)%></td>
            <td class=es02 align=middle><a href="javascript:openwindow_phm('cheque_realize.jsp?id=<%=ch.getId()%>','支票兌現',500,400,true)"><img src="pic/type23.png" border=0>&nbsp;兌現提出</a></td>
        </tr>
<%
    }
%>

</table>
</td>
</tr>
</table>

</form>
</center>
<br>
<br>

<%@ include file="bottom.jsp"%>