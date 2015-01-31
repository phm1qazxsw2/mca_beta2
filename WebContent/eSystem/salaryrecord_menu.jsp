<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    String frameWidth=request.getParameter("frameWidth");
%>
<%@ include file="jumpTopExpress.jsp"%>
<%
    //##v2
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    int recordId = Integer.parseInt(request.getParameter("recordId"));


    EzCountingService ezsvc = EzCountingService.getInstance();
    BillRecord record = BillRecordMgr.getInstance().find("id="+recordId);
    Bill b = BillMgr.getInstance().find("id="+record.getBillId());
    ArrayList<BillItem> bitems = BillItemMgr.getInstance().retrieveList("billId=" + b.getId(),"");
    Iterator<BillItem> iter = bitems.iterator();
    String backurl = "salaryrecord_edit.jsp?" + request.getQueryString();
        
    Map m = new HashMap();
    for (int i=0; iter.hasNext(); i++) {
        BillItem bi = iter.next();
        m.put(new Integer(bi.getId()), bi);
    }
    ArrayList<ChargeItem> citems = 
        ChargeItemMgr.getInstance().retrieveList("billRecordId=" + record.getId(), "");

    MembrBillRecordMgr sbrmgr = MembrBillRecordMgr.getInstance();
    Object[] objs = sbrmgr.retrieve("billrecordId=" + record.getId(), "");
    int receivableNum = 0;
    int receivable = (int)0;
    int receivedNum = 0;
    int received = (int)0;
    if (objs!=null) {
        for (int j=0; j<objs.length; j++) {
            MembrBillRecord sbr = (MembrBillRecord) objs[j];
            receivableNum ++;
            receivable += sbr.getReceivable();
            if (sbr.getReceived()>=sbr.getReceivable()) {
                receivedNum ++;
                received += sbr.getReceived();
            }
        }
    }
%>
<br>
<div class=es02>
&nbsp; 
<b><%=record.getName()%></b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<div class=es02>
        <%
            ChargeMgr cmgr = ChargeMgr.getInstance();
        
            Map<Integer, Vector<ChargeItem>> chiMap = new SortingMap(citems).doSort("getSmallItemId");
            Set chikey = chiMap.keySet();
            Iterator<Integer> chiiter = chikey.iterator();
            while (chiiter.hasNext()) {
                Integer ciId = chiiter.next();
                Vector<ChargeItem> chv = chiMap.get(ciId);

                switch(ciId){
                    case 1:
                        out.println("&nbsp;&nbsp;<b>+ 應付薪資</b>");                            
                        break;
                    case 2:
                        out.println("<br><br>&nbsp;&nbsp;<b>- 代扣薪資</b>");
                        break;
                    case 3:
                        out.println("<br><br>&nbsp;&nbsp;<b>- 應扣薪資</b>");
                        break;        
                }
        %>
        <br>    
        <br>
        <%
                for(int k=0;chv !=null &&k<chv.size();k++)
                {
                    ChargeItem ci =(ChargeItem)chv.get(k);
                    int num = cmgr.numOfRows("chargeItemId=" + ci.getId());
                    if (num==0)
                        continue;
                    BillItem bi = (BillItem) m.remove(new Integer(ci.getBillItemId()));
                    if (bi==null) {
                        System.out.println("## chargeItemId=" + ci.getId());
                        throw new Exception("BillItem is not supposed to be null");
                    }
                    int sub_total = ezsvc.calcAmountForChargeItem(ci);                 
        %>          
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=bi.getName()%> (<%=num%>筆) 
                    &nbsp;<img src="pic/fix.gif" border=0 width=12><a href="salarychargeitem_edit_express.jsp?rid=<%=recordId%>&bid=<%=bi.getId()%>&cid=<%=ci.getId()%>" target="mainFrame">編輯</a>  <br>
        <%
                }
            }
        %>

        <br><br>&nbsp;&nbsp;<b>尚未加入:</b>
        <br><br>    
        <%
            iter = bitems.iterator();
            while (iter.hasNext())
            {
                BillItem bi = iter.next();
                if (bi.getStatus()!=BillItem.STATUS_ACTIVE)
                    continue;
                if (m.get(new Integer(bi.getId()))!=null) {
                %>

                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <%
                    if (bi.getSmallItemId()==1) out.println("+ 應付");
                    else if (bi.getSmallItemId()==2) out.println("- 代扣");
                    else if (bi.getSmallItemId()==3) out.println("- 應扣");
                    %>
                    <%=bi.getName()%>
                    &nbsp;<img src="pic/fix.gif" border=0 width=12>
                    <a href="salarychargeitem_edit_express.jsp?rid=<%=recordId%>&bid=<%=bi.getId()%>&cid=-1" target="mainFrame">編輯</a>
                    <br>

        <%  
                }
            }
        %>

</div>
      