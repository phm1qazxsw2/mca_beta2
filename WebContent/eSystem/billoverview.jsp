<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
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


    boolean showAll = false;
    try { showAll = request.getParameter("a").equals("1"); } catch (Exception e) {}

    BillRecordInfoMgr brmgr = BillRecordInfoMgr.getInstance();
    ArrayList<BillRecordInfo> allbrs = brmgr.retrieveListX
        ("billType="+Bill.TYPE_BILLING, "order by month desc, billrecord.id asc", _ws.getBunitSpace("bill.bunitId"));
    java.text.DecimalFormat mf = new java.text.DecimalFormat("###,###,###,###.##");
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
    java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("yyyy-MM-dd");
    _ws.setBookmark(ud2, "帳單總覽 " + ((showAll)?"(全部)":"(最後三個月)"));
%>
<br> 
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;帳單總覽</b>
</div> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<div style="position:relative;left:5px"> 
<%
    if(checkAuth(ud2,authHa,102))
    {
%>
<div class=es02>
<a href="javascript:openwindow_phm('listBills.jsp','新增帳單',750,600,true);">
<img src="pic/23.png" border=0>&nbsp;新增帳單</a>
</div>
<%  }   %>
<br>
<%
	if(allbrs.size()==0)
	{
%>
        <blockquote>
        尚未開啟任何帳單!<br><br>請按<a href="javascript:openwindow_phm('listBills.jsp','新增帳單',750,600,true);">新增帳單</a>開始 .
        </blockquote>
		<%@ include file="bottom.jsp"%>	
<%
		return;
	}

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
            <a href="billoverview.jsp">只顯示最近三個月</a> | <b>顯示全部</b>
        <% } else { %>
            <b>只顯示最近三個月</b> | <a href="billoverview.jsp?a=1">顯示全部</a>
        <% } %>
        </td></tr>
    <%
           showTotal=true; 
        }
    %>
        <tr class=es02 height=20>
            <td align=left valign=middle>

                <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr width=100%>
                        <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                        <td width=90%  bgcolor=#696a6e class=es02>
                            <font color=ffffff>&nbsp;&nbsp;<img src="img/flag.png" border=0>&nbsp;&nbsp;<b>月份: <%=sdf.format(month)%></b></font>
                        </td>
                        <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
                            <a href="billrecord_chart.jsp?month=<%=sdf2.format(month)%>&type=0"><font color=white><img src="pic/re1.png" border=0>&nbsp;報表中心</font></a>
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
    
                        boolean closed = sbrvector!=null && sbrvector.size()>0 && ((receivableNum-receivedNum)==0);
                        if(xtr>1 && (xtr%2)==1)
                            out.println("</tr><tr><td colspan=2><table width=\"100%\" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src=\"pic/h01.gif\" height=1 border=0></td></tr></table><br></td></tr><tr>");
                %>
                  
                <td width=400>
                    <table border=0 width=100% class=es02 cellpadding=2 cellspacing=0>
                    <tr>
                        <td width=100 height=140 valign=top align=center>
                        <%
                        String imgString="abill.gif";
                        String linkString="<a href='editBillRecord.jsp?recordId="+br.getId()+"'>";
                        if(receivableNum!=0 && (receivableNum-receivedNum)==0){
                            imgString="abillp.gif";
                            linkString="<a href=\"searchbillrecord.jsp?brId="+br.getId()+"\">";
                        }else if(printoutNum!=0 &&(receivableNum-printoutNum)!=0){
                            imgString="abillprint.gif";
                            linkString="<a href=\"javascript:preview2("+br.getId()+",'"+br.getName()+"("+(receivableNum-receivedNum)+"筆)')\">";
                        }
                        %>

                    <%=linkString%>
                    <img src="img/<%=imgString%>" width=100 border=0 alt="整批編輯<%=br.getName()%>帳單"></a>
                    <a target=_blank href="vchr/modified_history.jsp?brId=<%=br.getId()%>">修改記錄</a>
                    <%
                    if(pZ2.getPagetype()==5 || pZ2.getPagetype()==7){ // 道禾&馬禮遜
                    %> | 
            <a href="javascript:openwindow_phm('modifyBillInfo.jsp?billId=<%=br.getBillId()%>','帳單資訊',600,400,true);">表頭</a>
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
                                    <td align=left valign=middle>已發佈/全部帳單:</td>
                                    <td align=right valign=middle>
                                        <%=printoutNum%>筆/<%=receivableNum%>筆
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
                                    <td align=left valign=middle>已收金額/應收金額:</td>
                                    <td align=right><%=receivedNum%>筆/<%=receivableNum%>筆
                                </tD>

                                </tr>
                                <tr>
                                    <td colspan=2 align=right>

                                        <%=mnf.format(received)%>元/<%=mnf.format(receivable)%>元

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
        <a href="editBillRecord.jsp?recordId=<%=br.getId()%>"><img src="pic/edit2.png" border=0>&nbsp;整批編輯</a> |
<%
    }

    if(checkAuth(ud2,authHa,101))
    {
%>
        <a href="searchbillrecord.jsp?brId=<%=br.getId()%>">已開帳單列表</a> | 

<%  }

    if(checkAuth(ud2,authHa,102))
    {
%>

  <% if (receivableNum==0) { %>
        尚無單據 | <a href="billrecord_delete.jsp?brid=<%=br.getId()%>" onclick="if (confirm('確定刪除？')) {return true;} else {return false;}">刪除</a>
  <% } else if ((receivableNum-receivedNum)>0) { %>
    <a href="javascript:preview(<%=br.getId()%>,'<%=br.getName()%> (<%=receivableNum-receivedNum%>筆)')">發佈帳單</a> 
  <% } else { %>
        已繳清
  <% } %>
<%
    }
%>                                       
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

                        <td align=right nowrap>
                        <br>
                        <b><%=sdf.format(month)%> </b>
                        &nbsp;
                        <b>應收小計:</b> <%=mnf.format(totalreceivable)%> 元&nbsp; (<%=totalreceivableNum%>筆) /  
                        <b>已收:</b>  <%=mnf.format(totalreceived)%> 元&nbsp;(<%=totalreceivedNum%>筆) /
                        <b>未收:</b>  <%=mnf.format(totalreceivable-totalreceived)%> 元&nbsp;(<%=totalreceivableNum-totalreceivedNum%>筆)
                         | 
                            <a href="billrecord_chart.jsp?month=<%=sdf2.format(month)%>">報表中心</a>&nbsp;&nbsp;&nbsp;
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

function preview2(rid, title)
{
        var url = "billrecord_detail_aux.jsp?rid="+rid +"&t=" + encodeURI(title) + "&freshonly=true&r="+(new Date()).getTime();
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
