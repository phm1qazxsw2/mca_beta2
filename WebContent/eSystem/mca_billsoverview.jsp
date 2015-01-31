<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    JsfAdmin ja=JsfAdmin.getInstance();

    McaFee fee = McaFeeMgr.getInstance().find("id=" + request.getParameter("id"));
    java.text.DecimalFormat mf = new java.text.DecimalFormat("###,###,###,###.##");
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
    java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("yyyy-MM-dd");

    McaFeeRecordMgr brmgr = McaFeeRecordMgr.getInstance();
    ArrayList<McaFeeRecord> allbrs = brmgr.retrieveListX("mcaFeeId=" + fee.getId(), 
        "order by billrecord.id asc", _ws.getBunitSpace("bill.bunitId"));
    _ws.setBookmark(ud2, fee.getTitle());
%>
<br>
 
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<%=fee.getTitle()%></b>
</div> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<div style="position:relative;left:5px"> 
<%
    Map<Date, Vector<McaFeeRecord>> m = new SortingMap(allbrs).doSort("getMonth");
    MembrBillRecordMgr sbrmgr = MembrBillRecordMgr.getInstance();
    String billrecordIds = new RangeMaker().makeRange(allbrs, "getId");
    ArrayList<MembrBillRecord> allrecords = sbrmgr.retrieveList("billRecordId in (" + billrecordIds + ")","");
    Map<Integer,Vector<MembrBillRecord>> sbrmap = 
        new SortingMap(allrecords).doSort("getBillRecordId");

    Set keys = m.keySet();
    Iterator iter = keys.iterator();
    int iterNum = 0;

    boolean showTotal=false;
    while (iter.hasNext()) {
        iterNum ++;
        Date month = (Date) iter.next();
        Vector v = (Vector) m.get(month);
%>
<table class=es02 border=0 width=88%>
        <tr>
            <tD width=95%>
               
                <table border=0>
                <%
                    int totalreceivableNum = 0;
                    int totalreceivable = (int)0;
                    int totalreceivedNum = 0;
                    int totalreceived = (int)0;

                    int xtr=0;

                    for (int i=0; i<v.size(); i++) {
                        BillRecord br = (BillRecord) v.get(i);
                        // Object[] objs2 = sbrmgr.retrieve("billrecordId=" + br.getId(), "");
                        Vector<MembrBillRecord> sbrvector = sbrmap.get(new Integer(br.getId()));
                        int receivableNum = 0;
                        int receivable = (int)0;
                        int receivedNum = 0;
                        int received = (int)0;
                        int printoutNum = 0;
                        for (int j=0; sbrvector!=null && j<sbrvector.size(); j++) {
                            MembrBillRecord sbr = sbrvector.get(j);
                            receivableNum ++;
                            receivable += sbr.getReceivable();
                            received += sbr.getReceived();
                            if (sbr.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID) 
                            {
                                printoutNum ++; // 收過錢的也算印過的
                                receivedNum ++;
                            }
                            else if (sbr.getPrintDate()>0) {
                                printoutNum++;
                            }
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
                    <table border=0 width=100% class=es02 cellpadding=2 cellspacing=0>
                    <tr>
                        <td width=100 height=140 valign=top>
<a href="editBillRecord.jsp?recordId=<%=br.getId()%>"><img src="img/abill.gif" width=100 border=0 alt="Batch Edting <%=br.getName()%>"></a>
                    
                    <%
                    if(pZ2.getPagetype()==5 || pZ2.getPagetype()==7){ // 道禾&馬禮遜
                    %>
            <center>
            <a href="javascript:openwindow_phm('modifyBillInfo.jsp?billId=<%=br.getBillId()%>','Bill Header',600,400,true);">Bill Header</a>
            </center>
                    <%  }   %>

</tD>
                        <td valign=top align=middle>
    
                            <table border=0 width=85% class=es02 cellpadding=0 cellspacing=0>
                                <tr>
                                    <td colspan=2>
                                        <b><%=br.getName()%></b>
                                    </tD>
                                </tr>
                                 <tr>    
                                    <td align=left valign=middle>Published/Total:</td>
                                    <td align=right valign=middle>
                                        <%=printoutNum%>/<%=receivableNum%>
                                     </td>
                                </tr>
                                <tr>
                                    <td colspan=2 align=right>
<a href="javascript:preview(<%=br.getId()%>,'<%=br.getName()%> (<%=receivableNum-receivedNum%>筆)')">
                                       <img src="img/<%=ja.getBarImage(1,printoutNum,receivableNum)%>" border=0>   
</a>
                                    </td>    
                                </tr>
                                <tr>
                                    <td colspan=2 height=10>

                                           <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

                                    </td>
                                </tr>
                                <tr>    
                                    <td align=left valign=middle>Received/Total:</td>
                                    <td align=right><%=receivedNum%>/<%=receivableNum%>
                                </tD>

                                </tr>
                                <tr>
                                    <td colspan=2 align=right>

                                        $<%=mnf.format(received)%>/$<%=mnf.format(receivable)%>

                                    </td>
                                </tR>
                                <tr>
                                    <td colspan=2 align=right>
<a href="searchbillrecord.jsp?brId=<%=br.getId()%>">
                                        <img src="img/<%=ja.getBarImage(2,receivedNum,receivableNum)%>" border=0>
</a>
                                    </td>
                                </tR>
                                <tr><td colspan=2 height=30></td></tr>
                                <tr>
                                    <td colspan=2 align=middle nowrap>
<%
    if(checkAuth(ud2,authHa,102))
    {
%>
        <a href="editBillRecord.jsp?recordId=<%=br.getId()%>"><img src="pic/edit2.png" border=0>&nbsp;Batch Editing</a> |
<%
    }

    if(checkAuth(ud2,authHa,101))
    {
%>
        <a href="searchbillrecord.jsp?brId=<%=br.getId()%>">Bill Listing</a> | 
        <a href="javascript:preview(<%=br.getId()%>,'<%=br.getName()%> (<%=receivableNum-receivedNum%>)')">Printing</a>
<%  }  %>


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

                        <td align=center>

                        &nbsp;<b>Received Amount:</b>  $<%=mnf.format(totalreceived)%> &nbsp;(<%=totalreceivedNum%>) /
                        <b>Total Amount:</b> $<%=mnf.format(totalreceivable)%> &nbsp; (<%=totalreceivableNum%>) 
                        </td>
                        <!--<td align=right></td>-->
                    </tr>
                </table>            
        
<%
    }
%>
</div>
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
