<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">

<%
    _ws.setBookmark(ud2, "繳費統計 - " + nowMonth);
    Set<Integer> keys5 = billMap.keySet();
    Iterator<Integer> kiter = keys5.iterator();
    ArrayList<MembrInfoBillRecord> bills = new ArrayList<MembrInfoBillRecord>();
    while (kiter.hasNext()) {
        Vector<MembrInfoBillRecord> v = billMap.get(kiter.next());
        for (int i=0; i<v.size(); i++)
            bills.add(v.get(i));
    }
    String ticketIds = new RangeMaker().makeRange(bills, "getTicketId");
    ArrayList<BillPaidInfo> paidinfos = BillPaidInfoMgr.getInstance().
        retrieveList("billpaid.ticketId in (" + ticketIds + ")", "");

    if(paidinfos==null || paidinfos.size()<=0)
    {
%>
        <br>
        <br>
        <blockquote>
            <div class=es02>本月沒有付款資料.</div>
        </blockquote>


<%
    }else{
%>
    <br>
    <br>
    <div class=es02>&nbsp;&nbsp;<b>繳款方式統計:</b></div><br>

    <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td width=20></td>
        <td width=70%>

            <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#f0f0f0 class=es02>
                    <td align=middle>付款方式</td>
                    <td align=middle>筆數</td>
                    <td align=middle>金額</td>
                    <tD align=middle>比例</td>
                    </tr> 
                </tr>

<%
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
    Iterator<BillPaidInfo> iter3 = paidinfos.iterator();
    while (iter3.hasNext()) {
        BillPaidInfo bp=iter3.next();

        String xPt=sdf.format(bp.getPaidTime());

        bp.setPaidTime(sdf.parse(xPt));
    }

    Map<Integer, Vector<BillPaidInfo>> viaMap = new SortingMap(paidinfos).doSort("getVia");
    Set viakey = viaMap.keySet();
    Iterator<Integer> viaiter = viakey.iterator();
    int startChard=64;
    int startDisd=0;                            
    String tString4="";
    String chlString4="";
    while (viaiter.hasNext()) {
        startChard++;
        startDisd++;
        if(startDisd !=1)
        {
            chlString4+="|";
            tString4+=",";
        }
        Integer via = viaiter.next();
        String vianame="";
        switch(via){
            case 0: vianame="櫃臺付款"; break;
            case 1: vianame="虛擬帳號轉帳"; break;
            case 2: vianame="便利商店代收"; break;
            case 3: vianame="支票付款"; break;
            case 4: vianame="匯款"; break;
            case 5: vianame="信用卡"; break;
        }
        
        Vector<BillPaidInfo> payv = viaMap.get(via);
        int totalVia=0;
        double percentX2=(double)payv.size()/(double)paidinfos.size();
        percentX2=percentX2*100;

        for(int p=0;payv !=null && p<payv.size();p++)
            totalVia+=payv.get(p).getPaidAmount();
%>
        <tr class=es02 bgcolor=ffffff>
            <td align=left><%=(char)startChard%>.&nbsp;<%=vianame%></tD>
            <td align=right><%=payv.size()%></td>
            <td align=right><%=mnf.format(totalVia)%></td>
            <td align=right><%=(int)percentX2%>%</td>
        </tr>
<%
        chlString4+=(char)startChard;
        tString4+=String.valueOf((int)percentX2);
    }
%>
        </table>
        </td>
        </tr>
        </table>
    </tD>
     <td align=middle valign=middle>
        <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=tString4%>&chs=120x60&chl=<%=chlString4%>&chco=F77510" border=0>
    </td>

    </tr>
    </table>

    <br>
    <br>
    <div class=es02>&nbsp;&nbsp;<b>繳款日期統計:</b></div><br>

<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
<tr>
    <td width=20></td>
    <td width=70%>

        <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
        <td bgcolor="#e9e3de">
            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#f0f0f0 class=es02>
                <td width=100>繳費日期</td>
                <tD width=30>筆數</td>
                <tD width=30>比例</td>
                <tD>繳費名單</td>
            </tr>
    <%
        Map<Date, Vector<BillPaidInfo>> dateMap = new SortingMap(paidinfos).doSort("getPaidTime");
        Set datekey=dateMap.keySet();
        Iterator<Date> dateiter=datekey.iterator();

        while (dateiter.hasNext()) {
            Date payDate =dateiter.next();
            Vector<BillPaidInfo> pInfo = dateMap.get(payDate);
            double percentX2=(double)pInfo.size()/(double)paidinfos.size();
            percentX2=percentX2*100;

    %>
            <tr bgcolor=#ffffff class=es02>
                <td align=left><%=sdf.format(payDate)%></td>
                <tD align=right><%=pInfo.size()%></td>
                <tD align=right><%=(int)percentX2%>%</td>
                <td>
                    <%
                    for(int v=0;pInfo !=null && v<pInfo.size();v++)
                    {
                        String xxString=java.net.URLEncoder.encode("billrecord_chart.jsp?month="+monstr+"&type=4");
                    %>
                        <a href="bill_detail.jsp?rid=<%=pInfo.get(v).getBillRecordId()%>&sid=<%=pInfo.get(v).getMembrId()%>&backurl=<%=xxString%>"><font color=blue><%=pInfo.get(v).getMembrName()%></font></a>,
                    <%  
                    }
                    %>
                </tD>

            </tr>
    <%        
        }
    %>
            </table>
        </td>
        </tr>
        </table>




    </td>
    <td>
        &nbsp;
    </td>   

    </tr>
    </table>

    <%  }   %>