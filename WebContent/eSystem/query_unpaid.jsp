<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=2;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(!checkAuth(ud2,authHa,104))
    {
        response.sendRedirect("authIndex.jsp?code=104");
    }
%>
<%@ include file="leftMenu1.jsp"%>
<link rel="stylesheet" href="css/ajax-tooltip-billsearch.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<%
    //######## 日期 ###########
    SimpleDateFormat sdfx = new SimpleDateFormat("yyyy/MM/dd");
    ArrayList<BillRecordInfo> brs = BillRecordInfoMgr.getInstance().retrieveListX(
        "billType="+Bill.TYPE_BILLING, "order by month asc", _ws.getBunitSpace("bill.bunitId"));
    Date d1 = brs.get(0).getMonth();
    Date d2 = brs.get(brs.size()-1).getMonth();
    try { d1 = sdfx.parse(request.getParameter("sDate")); } catch (Exception e) {}
    try { d2 = sdfx.parse(request.getParameter("eDate")); } catch (Exception e) {}
    Calendar c = Calendar.getInstance();
    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();
    //######## 日期 ###########

    //##v2
    ArrayList<MembrInfoBillRecord> all_unpaid_bills = MembrInfoBillRecordMgr.getInstance().
        retrieveListX("bill.billType=" + Bill.TYPE_BILLING + " and paidStatus!=" + MembrBillRecord.STATUS_FULLY_PAID +
            " and billrecord.month>='" + sdfx.format(d1) + "' and billrecord.month<'" + sdfx.format(nextEndDay) + 
            "' and receivable>received", 
            "order by membr.name asc", _ws.getBunitSpace("bill.bunitId"));
    String backurl = "query_unpaid.jsp";
    _ws.setBookmark(ud2, "帳單未繳查詢");
%>
<br>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;帳單未繳查詢</b> 
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>
<center>
<%
    _ws.setBookmark(ud2, "未繳查詢");
    if (all_unpaid_bills.size()==0) {
        out.println("<br>區間內沒有未繳帳單");
%>
        <%@ include file="bottom.jsp"%>
<%
        return;
    }
    
    // 把未繳的帳單按人頭擺在一起
    // 再找出預設的標籤,按人頭弄好查詢 Map
    // 這樣就可在按人排下來的時候看看有沒有預設的標籤來印出標籤名了
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    Map<Integer/*membrId*/, Vector<MembrInfoBillRecord>> billMap = new SortingMap(all_unpaid_bills).doSort("getMembrId");
    String membrIds = new RangeMaker().makeRange(all_unpaid_bills, "getMembrId");
    EzCountingService ezsvc = EzCountingService.getInstance();
    ArrayList<Tag> mainTags = ezsvc.getMainTags(_ws.getStudentBunitSpace("bunitId"));
    ArrayList<TagMembrInfo> taginfos = null;
    if (mainTags!=null && mainTags.size()>0) {
        String tagIds = new RangeMaker().makeRange(mainTags, "getId");
        taginfos = TagMembrInfoMgr.getInstance().
            //retrieveList("membrId in (" + membrIds + ") and tagId in (" + tagIds + ")", "");
			retrieveList("membrId in (" + membrIds + ") and tagId in (" + tagIds + ") and status>=0", "order by status asc");
    }
    else {
        taginfos = new ArrayList<TagMembrInfo>();
    }
    Map<Integer/*membrId*/, Vector<TagMembrInfo>> tagMap = new SortingMap(taginfos).doSort("getMembrId");

    Set<Integer> keys = billMap.keySet();
    Iterator<Integer> iter = keys.iterator();
%>

<form action="" method="get" name="xs" id="xs">
<TABLE border=0>
    <TR class=es02>
        
        <td align=right nowrap>
            <b>帳單日期 &nbsp;&nbsp;&nbsp;<a href="#" onclick="displayCalendar(document.xs.sDate,'yyyy/mm/dd',this);return false">從</a>:</b>
        </td>
        <td nowrap>
            <input type=text name="sDate" value="<%=sdfx.format(d1)%>" size=7>
            &nbsp;&nbsp;&nbsp;
            <b><a href="#" onclick="displayCalendar(document.xs.eDate,'yyyy/mm/dd',this);return false">至</a>:</b>
            <input type=text name="eDate" value="<%=sdfx.format(d2)%>" size=7>
        </td>

        <tD width=20% align=left>
            <input type=submit value="搜尋">    
        </td>

        <td nowrap>
            <div class=es02 align=right>合計:<b><%=keys.size()%></b> 筆 | <a target=_blank href="query_unpaid_little.jsp?<%=request.getQueryString()%>"><img src="pic/print.png" border=0>&nbsp;可列印版本</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div> 
        </td>
        
    </tr>
</table>       
</form>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td align=middle width=80>姓名</td>
        <td>流水號/帳單/月份</tD>
        <td align=middle width=80>應繳金額</td>
        <td align=middle width=80>已繳金額</td>
        <td align=middle width=80>未繳金額</td>
        <td align=middle width=80></td>
	</tr>
<%
    SimpleDateFormat sdf=new SimpleDateFormat("yy/MM");
    int totalShould=0;
    int totalPay=0;
    while (iter.hasNext()) {
        Integer membrId = iter.next();
        Vector<MembrInfoBillRecord> bv = billMap.get(membrId);
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td  bgcolor=ffffff nowrap rowspan="<%=bv.size()+1%>" class=es02>
            <%
                Vector<TagMembrInfo> tv = tagMap.get(membrId);
                if (tv!=null)
                    out.println(tv.get(0).getTagName()+ "-<br><br>");
            %>
                &nbsp;&nbsp;&nbsp;<%=bv.get(0).getMembrName()%>
            </td>
            <%
                int thisShould=0;
                int thisPay=0;

                for (int i=0; i<bv.size(); i++) {
                    MembrInfoBillRecord r = bv.get(i);

                    if (i==0){
                        out.print("<td class=es02>");
                    }else{

                        out.print("<tr bgcolor=#ffffff align=left  onmouseover=\"this.className='highlight'\"  onmouseout=\"this.className='normal2'\" valign=middle><td class=es02>");
                    }

                    thisShould+=r.getReceivable();
                    thisPay+=r.getReceived();
                  %>
<a target=_blank href='bill_detail.jsp?rid=<%=r.getBillRecordId()%>&sid=<%=r.getMembrId()%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>' onmouseover="ajax_showTooltip('peek_bill.jsp?rid=<%=r.getBillRecordId()%>&sid=<%=r.getMembrId()%>',this);return false"
                    onmouseout="ajax_hideTooltip()"><%=r.getTicketId()%> <%=r.getBillPrettyName()%> <%=sdf.format(PaymentPrinter.convertToTaiwanDate(r.getBillMonth()))%></a>
</td>        
                <td align=right class=es02><%=mnf.format(r.getReceivable())%></tD>
                <td align=right class=es02><%=mnf.format(r.getReceived())%></td>
                <td align=right class=es02><%=mnf.format(r.getReceivable()-r.getReceived())%></td>
                <td align=middle class=es02> 
<a target=_blank href="bill_detail.jsp?rid=<%=r.getBillRecordId()%>&sid=<%=r.getMembrId()%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>">詳細資料</a> </td>
                </tr>
            <%  
         
                    
                    if(i==(bv.size()-1))
                    {

                        totalShould+=thisShould;
                        totalPay+=thisPay;
%>
                <tr align=milddle class=es02>
                    <tD align=middle>小&nbsp;&nbsp;&nbsp;計</tD>
                    <td align=right><b><%=mnf.format(thisShould)%></b></td>
                    <td align=right><b><%=mnf.format(thisPay)%></b></tD>
                    <td align=right <%=((thisShould-thisPay)>0)?"bgcolor='#4A7DBD'":""%>>
                        <font color=white><%=mnf.format(thisShould-thisPay)%></font>
                    </td>
                </tr>
<%                        
                    }
                }
            } 
%>
    <tr class=es02 bgcolor=ffffff>
        <td align=middle colspan=6>
            ---------------------------------------------------------------------------------------------------------
        </td>  
    </tr>
    <tr class=es02>
        <td colspan=2 align=middle>
            <b>全 部 合 計</b>
        </td>  
        <td align=right><b><%=mnf.format(totalShould)%></b></tD>
        <tD align=right><b><%=mnf.format(totalPay)%></b></tD>
        <tD align=right <%=((totalShould-totalPay)>0)?"bgcolor='#4A7DBD'":""%>><b><font color=white><%=mnf.format(totalShould-totalPay)%></font></b></tD>   
    </tr>
    </table>
    </td></tr></table>
    </center>
    <br>
    <br>
<%@ include file="bottom.jsp"%>
