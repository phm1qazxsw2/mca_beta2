<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">

<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    //##v2
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp");
    }
    BillRecordMgr brmgr = BillRecordMgr.getInstance();
    Object[] objs = brmgr.retrieve("", "order by month desc");
    java.text.DecimalFormat mf = new java.text.DecimalFormat("###,###,###,###.##");
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
%>
<br> 

<b>&nbsp;&nbsp;&nbsp;帳單總覽</b>
 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote> 
<a href="javascript:openwindow_phm('listBills.jsp','新增帳單類型',700,400,true);">
<img src="pic/add.gif" border=0>開單</a>
<br>
<br>
<%
	if(objs==null)
	{
		out.println("<br>請按上面的開單連結");
%>
		<%@ include file="bottom.jsp"%>	
<%
		return;
	}

    LinkedHashMap m = new LinkedHashMap();
    for (int i=0; i<objs.length; i++) {
        BillRecord br = (BillRecord) objs[i];
        Date month = br.getMonth();
        Vector v = (Vector) m.get(month);
        if (v==null) {
            v = new Vector();
            m.put(month, v);
        }
        v.addElement(br);
    }

    MembrBillRecordMgr sbrmgr = MembrBillRecordMgr.getInstance();
    ArrayList<MembrBillRecord> allrecords = sbrmgr.retrieveList("","");
    Map<Integer,Vector<MembrBillRecord>> sbrmap = 
        new SortingMap(allrecords).doSort("getBillRecordId");

    Set keys = m.keySet();
    Iterator iter = keys.iterator();
    while (iter.hasNext()) {
        Date month = (Date) iter.next();
        Vector v = (Vector) m.get(month);
%>
<table class=es02 border=0 width=88%>
        <tr class=es02>
            <td align=left valign=middle>
                <%=sdf.format(month)%>
            </tD>
            <tD width=95%>
                <table border=0 width=100% class=es02>
                    <tr>
                        <tD>開單記錄</td><td align=right>應收金額</td><TD align=right>已收金額</td><td width=60></td>
                    </tr> 
                <%
                    int totalreceivableNum = 0;
                    int totalreceivable = (int)0;
                    int totalreceivedNum = 0;
                    int totalreceived = (int)0;
                    for (int i=0; i<v.size(); i++) {
                        BillRecord br = (BillRecord) v.get(i);
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
                        }
                        totalreceivableNum += receivableNum;
                        totalreceivable += receivable;
                        totalreceivedNum += receivedNum;
                        totalreceived += received;

                %>
                    <tr>
                        <td><%=br.getName()%> 
                            <% if (receivedNum==0) { %>
                            (<a href="editBillRecord.jsp?recordId=<%=br.getId()%>">設定</a>)
                            <% } else { %>
                            <!--<a href="#" onclick="alert('已有付款記錄不可整批修改！\n可至查詢處個別修改'); return false;">
                            (已開始繳費)-->
                            <% } %>
                        </td>
                        <td align=right><a href="searchbillrecord.jsp?brId=<%=br.getId()%>">(<%=receivableNum%>筆)</a>&nbsp; <%=receivable%></td>
                        <td align=right>(<%=receivedNum%>筆) &nbsp; <%=received%></td>
                        <td align=right>
                          <% if (receivableNum==0) { %>
                                尚無單據
                          <% } else if ((receivableNum-receivedNum)>0) { %>
                            <a href="javascript:preview(<%=br.getId()%>,'<%=br.getName()%> (<%=receivableNum-receivedNum%>筆)')">未繳</a> 
                          <% } else { %>
                                已繳清
                          <% } %>
                        </td>
                    </tr>              
                <%
                    }
                %>
                    <tr bgcolor="#f0f0f0">
                        <td>總計</td>
                        <td align=right>(<%=totalreceivableNum%>筆) &nbsp; <%=totalreceivable%></td>
                        <td align=right>(<%=totalreceivedNum%>筆) &nbsp; <%=totalreceived%></td>
                        <!--<td align=right></td>-->
                    </tr>
                </table>            
            </td>

        </tr>

        <tr>
            <td colspan=8>
                --------------------------------------------------------------------------------------------------------------------------------
            </td>
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
<script>
var SDIV;
function preview(rid, title)
{
    
        var url = "billrecord_detail_aux.jsp?rid="+rid +"&t=" + encodeURI(title) + "&r="+(new Date()).getTime();
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
