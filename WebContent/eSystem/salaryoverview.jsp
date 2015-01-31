<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,300))
    {
        response.sendRedirect("authIndex.jsp?code=300");
    }
%>
<%@ include file="leftMenu5.jsp"%>
<%
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    JsfAdmin ja=JsfAdmin.getInstance();

    //##v2

    boolean showAll = false;
    try { showAll = request.getParameter("a").equals("1"); } catch (Exception e) {}

    BillRecordInfoMgr brmgr = BillRecordInfoMgr.getInstance();
    ArrayList<BillRecordInfo> allbrs = brmgr.retrieveListX("billType="+Bill.TYPE_SALARY + 
        " and privLevel>=" + ud2.getUserRole(), "order by month desc, billrecord.id asc", _ws.getBunitSpace("bill.bunitId"));
    java.text.DecimalFormat mf = new java.text.DecimalFormat("###,###,###,###.##");
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
    _ws.setBookmark(ud2, "薪資總覽 " + ((showAll)?"(全部)":"(最後三個月)"));
%>
<br> 
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;薪資總覽</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote> 
<%
    if(checkAuth(ud2,authHa,301)){
%>
<div class=es02>
<a href="javascript:openwindow_phm('list_salary_bills.jsp','新增薪資類型',700,500,true);">
<img src="pic/addbill2.gif" border=0>&nbsp;新增薪資</a>
</div>
<%  }   %>

<br>
<%
	if(allbrs.size()==0 && checkAuth(ud2,authHa,301))
	{
		out.println("<br><div class=es02>請按上面的開單連結</div>");
%>
		<%@ include file="bottom.jsp"%>	
<%
		return;
	}
    java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("yyyy-MM-dd");
    Map<Date, Vector<BillRecordInfo>> m = new SortingMap(allbrs).doSort("getMonth");
    MembrBillRecordMgr sbrmgr = MembrBillRecordMgr.getInstance();
    String billRecordIds = new RangeMaker().makeRange(allbrs, "getId");
    ArrayList<MembrBillRecord> allrecords = sbrmgr.retrieveList("billRecordId in (" + billRecordIds + ")","");
    Map<Integer,Vector<MembrBillRecord>> sbrmap = 
        new SortingMap(allrecords).doSort("getBillRecordId");

    Set keys = m.keySet();
    Iterator iter = keys.iterator();
    int iterNum = 0;
    boolean showTotal=false;
    while (iter.hasNext() && (showAll || iterNum<3)) {
        iterNum ++;
        Date month = (Date) iter.next();
        Vector v = (Vector) m.get(month);
%>
<table class=es02 border=0 width=88%>
    <%
    if(!showTotal){
    %>
        <tr align=right><td>
        <% if (showAll) { %>
            <a href="salaryoverview.jsp">只顯示最近三個月</a> | <b>顯示全部</b>
        <% } else { %>
            <b>只顯示最近三個月</b> | <a href="salaryoverview.jsp?a=1">顯示全部</a>
        <% } %>
        </td></tr>
    <%
           showTotal=true;        
    }
    %>
        <tr class=es02 bgcolor=ffffff height=20>
            <td align=left valign=middle>
                    <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr width=100%>
                        <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                        <td width=90%  bgcolor=#696a6e class=es02>
                            <font color=ffffff>&nbsp;&nbsp;<img src="img/flag.png" border=0>&nbsp;&nbsp;<b>月份:        <%=sdf.format(month)%></b></font>
                        </td>
                        <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>

<%
    if(AuthAdmin.authPage(ud2,3))
    {
%>
                            <a href="salaryrecord_chart.jsp?month=<%=sdf2.format(month)%>&type=0"><font color=white><img src="pic/re1.png" border=0>&nbsp;報表中心</font></a>
   <%   }   %>
                        </td>
                        <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                    </tr>
                </table>
            </tD>
        </tr>
           <tr class=es02  height=10>
            <td align=left valign=middle>
             
            </tD>
        </tr>
        <tr>
            <tD width=95%>
               
                <table border=0>
                <%
                    int totalreceivableNum = 0;
                    int totalreceivable = (int)0;
                    int totalreceivedNum = 0;
                    int totalreceived = (int)0;
                    int printoutNum = 0;

                    int xtr=0;

                    for (int i=0; i<v.size(); i++) {
                        BillRecord br = (BillRecord) v.get(i);
                        int privLevel = ((BillRecordInfo) br).getPrivLevel();
                        // Object[] objs2 = sbrmgr.retrieve("billrecordId=" + br.getId(), "");
                        Vector<MembrBillRecord> sbrvector = sbrmap.get(new Integer(br.getId()));
                        int receivableNum = 0;
                        int receivable = (int)0;
                        int receivedNum = 0;
                        int received = (int)0;
                        for (int j=0; sbrvector!=null && j<sbrvector.size(); j++) {
                            MembrBillRecord sbr = sbrvector.get(j);
                            receivableNum ++;
                            receivable += sbr.getReceivable();
                            if (sbr.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID || 
                                sbr.getPaidStatus()==MembrBillRecord.STATUS_PARTLY_PAID) 
                            {
                                receivedNum ++;
                                received += sbr.getReceived();
                            }
                            if (sbr.getPrintDate()>0)
                                printoutNum++;
                        }
                        totalreceivableNum += receivableNum;
                        totalreceivable += receivable;
                        totalreceivedNum += receivedNum;
                        totalreceived += received;
                        
                        xtr++;
                        if(xtr==1)
                            out.println("<tr>");
    
                        if(xtr>1 && (xtr%2)==1)
                            out.println("</tr><tr><td colspan=2><table width=\"100%\" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src=\"pic/h01.gif\" height=1 border=0></td></tr></table><br></td></tr><tr>");
                %>
                  
                <td width=400>
                    <table border=0 width=100% class=es02 cellpadding=0 cellspacing=0>
                    <tr>
                        <%
                        String linkString="<a href=\"salaryrecord_edit.jsp?recordId="+br.getId()+"\">";
                        String picString="sbill1.gif";

                        if(receivableNum !=0 && (receivableNum-receivedNum)==0){
                            linkString="<a href=\"searchsalaryrecord.jsp?brId="+br.getId()+"\">";
                            picString="sbill1p.gif";

                        }
                        %>
                        <td width=100 height=140 valign=top>
                            <%=linkString%>
                            <img src="pic/<%=picString%>" width=100 border=0>
                            </a>
                        </tD>
                        <td valign=top align=middle> 
                            <table border=0 width=85% class=es02 cellpadding=0 cellspacing=0>
                                <tr>
                                    <td colspan=2 class=es02>
                                        <b><%=br.getName()%></b>
                                    </tD>
                                </tr>
                                <tr><td colspan=2 height=5></td></tr>
                                <tr class=es02>    
                                    <td align=left valign=middle>編輯權限:</td>
                                    <td align=right><%
                                        switch(privLevel){
                                            case 5:
                                                out.println("經營者 , 會計 , 行政 , 老師");
                                                break;
                                            case 4:
                                                out.println("經營者 , 會計 , 行政");
                                                break;
                                            case 3:
                                                out.println("經營者 , 會計");
                                                break;
                                            case 2:
                                                out.println("僅限經營者");
                                                break;
                                        }

                                    %></tD>
                                </tr>                             
                                <tr><td colspan=2 height=5>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
                                </td></tr>
                                <tr class=es02>    
                                    <td align=left valign=middle>已付金額/應付金額:</td>
                                    <td align=right><%=receivedNum%>筆/<%=receivableNum%>筆</tD>
                                </tr>
                                <tr>
                                    <td colspan=2 align=right>
                                        <%=mnf.format(received)%>元/<%=mnf.format(receivable)%>元
                                    </td>
                                </tR>
                                <tr>
                                    <td colspan=2 align=right>
<a href="searchsalaryrecord.jsp?brId=<%=br.getId()%>">
                                        <img src="img/<%=ja.getBarImage(2,receivedNum,receivableNum)%>" border=0>
</a>
                                    </td>
                                </tR>
                                <tr><td colspan=2 height=10></td></tr>
                                <tr>
                                    <td colspan=2 align=middle nowrap>
<%    if(checkAuth(ud2,authHa,301)){   %>
                                        <a href="salaryrecord_edit.jsp?recordId=<%=br.getId()%>"><img src="pic/edit2.png" border=0>&nbsp;整批編輯</a> |
<%  }%>
                                      <% if (receivableNum!=0) { %>
                                        <a href="searchsalaryrecord.jsp?brId=<%=br.getId()%>">已開薪資列表</a>
                                        |
                                        <%  }   %>
                                      <% if (receivableNum==0) { %>
                                            尚無單據| 
<%    if(checkAuth(ud2,authHa,301)){   %>
                            <a href="billrecord_delete.jsp?brid=<%=br.getId()%>&p=1" onclick="if (confirm('確定刪除？')) {return true;} else {return false;}">刪除</a>
<%      }   %>            

                                      <% } else if ((receivableNum-receivedNum)>0) { %>
<%    if(checkAuth(ud2,authHa,302)){   %>
                                        <a href="javascript:do_pay(<%=br.getId()%>,'<%=br.getName()%> (<%=receivableNum-receivedNum%>筆)')">支付薪資</a> 
<%  }   %>    
                                      <% } else { %>
                                            已付清
                                      <% } %>
                                       
                                    </td>
                                </tr>
                            </table>
                    </td>
                    </tr>
                    </table>
                </td>
                <%
                    }
                %>
                </table>

                    <tr bgcolor="#f0f0f0">

                        <td align=right>

                        <br>
                        <b><%=sdf.format(month)%> </b>
                        &nbsp;
                        <b>應付小計:</b> <%=mnf.format(totalreceivable)%> 元&nbsp; (<%=totalreceivableNum%>筆) /  
                        <b>已付:</b>  <%=mnf.format(totalreceived)%> 元&nbsp;(<%=totalreceivedNum%>筆) /
                        <b>未付:</b>  <%=mnf.format(totalreceivable-totalreceived)%> 元&nbsp;(<%=totalreceivableNum-totalreceivedNum%>筆)
                        </td>
                        <!--<td align=right></td>-->
                    </tr>
                </table>            
        
<%
    }
%>
</blockquote>
</ul>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
var SDIV;
function do_pay(rid, title)
{    
        var url = "salary_batchpay_aux.jsp?rid="+rid +"&t=" + encodeURI(title) + "&r="+(new Date()).getTime();
        var req = new XMLHttpRequest();
    	SDIV = document.getElementById("ff");
        if (req) 
        {
            req.onreadystatechange = function() 
            {
                if (req.readyState == 4 && req.status == 200) 
                {
                    SDIV.innerHTML = req.responseText;
                    document.f1.submit();
                }
            }
        };
        req.open('GET', url);
        req.send(null);

}
</script>
<div id="ff"></div>
<%@ include file="bottom.jsp"%>	
