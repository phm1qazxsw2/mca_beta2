<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=13;
    int leftMenu=0;
    boolean showall = true;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu6.jsp"%>
<%
    ArrayList<BillRecordInfo> brs = BillRecordInfoMgr.getInstance().retrieveList("billType=" + 
        Bill.TYPE_BILLING, "order by billrecord.id desc");
    if (brs.size()==0) {
        out.println("<br><blockquote>請先產生帳單和薪資記錄</blockquote>");
        return;
    }

    // build query for ManHour
    int brId = brs.get(0).getId();
    try {
        String brstr = request.getParameter("brId");
        if (brstr!=null) {
            brId = Integer.parseInt(brstr);
            pageContext.setAttribute("brId", brstr, pageContext.SESSION_SCOPE);
        }
        else if ((brstr=(String)pageContext.getAttribute("brId", pageContext.SESSION_SCOPE))!=null) {
            brId = Integer.parseInt(brstr);
        }
    }
    catch (Exception e) {}

    ArrayList<ChargeItem> chargeitems = ChargeItemMgr.getInstance().retrieveList("billRecordId=" + brId, "");
    String chargeitemIds = new RangeMaker().makeRange(chargeitems, "getId");
    ArrayList<FeeDetail> fds = FeeDetailMgr.getInstance().retrieveList("chargeItemId in (" + chargeitemIds + ")", "");
    String manhourIds = new RangeMaker().makeRange(fds, "getManhourId");
    
    String q = "id in (" + manhourIds + ")";

    int sortby = 0;
    try { 
        String sstr = request.getParameter("sortby");
        if (sstr!=null) {
            sortby = Integer.parseInt(sstr); 
            pageContext.setAttribute("sortby", sstr, pageContext.SESSION_SCOPE);
        }
        else if ((sstr=(String)pageContext.getAttribute("sortby", pageContext.SESSION_SCOPE))!=null) {
            sortby = Integer.parseInt(sstr);
        }    
    } catch (Exception e) {};

    String orderby = "";
    String url = "outsourcing_overview.jsp?brId=" + brId;
    switch (sortby) {
        case 0: orderby = "order by occurDate asc"; break;
        case 1: orderby = "order by recordTime asc, occurDate asc"; break;
        case 2: orderby = "order by clientMembrId asc, occurDate asc"; break;
        case 3: orderby = "order by executeMembrId asc, occurDate asc"; break;
    }

    SimpleDateFormat monthsdf = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    ArrayList<ManHour> manhours = ManHourMgr.getInstance().retrieveList(q, orderby);
%>

<br>
<b>&nbsp;&nbsp;&nbsp;派遣記錄</b>
 
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<div class=es02>
<form name="f1" action="outsourcing_overview.jsp" method="get">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<select name="brId">
<% for (int i=0; i<brs.size(); i++) { 
       BillRecord br = brs.get(i);  %>
      <option value="<%=br.getId()%>" <%=(br.getId()==brId)?"selected":""%>><%=monthsdf.format(br.getMonth())%>
<% } %>
</select>
    &nbsp;&nbsp;
    <input type=submit value="查詢"> 　　　　　　　　　　
    <!--<a target="_blank" href="manhour_recalculate.jsp?brId=<%=brId%>">重整資料</a>-->
    <a href="javascript:recalculate()">重整資料</a>(暫時功能)
</form>
</div>

<%@ include file="outsourcing_list.jsp"%>


<script>
function recalculate()
{
    if (confirm("重整會重算并修正產生帳單和薪資單錯誤,不會影響以下的派遣資料,確定重整"))
        openwindow_phm2('manhour_recalculate.jsp?brId=<%=brId%>','重整資料',300,200,'recalwin');
}
</script>




<%
// ###################### for now , 每次 load 就重整下 ################
    if (brId<13) {
      %><script>alert("此功能只適用於2008-12月以後的資料");history.go(-1);</script><%
        return;
    }
    ArrayList<ChargeItem> chargeitems2 = ChargeItemMgr.getInstance().retrieveList("billRecordId=" + brId, "");
    String chargeitemIds2 = new RangeMaker().makeRange(chargeitems2, "getId");
    ArrayList<FeeDetail> fds2 = FeeDetailMgr.getInstance().retrieveList("chargeItemId in (" + chargeitemIds2 + ")", "");
    String manhourIds2 = new RangeMaker().makeRange(fds2, "getManhourId");
    
    q = "id in (" + manhourIds2 + ")";
    
    boolean commit = false;
    int tran_id = 0;
    try {        
        tran_id = dbo.Manager.startTransaction();
        ArrayList<ManHour> manhours2 = new ManHourMgr(tran_id).retrieveList(q, "");

        // 從這以下的 fd 和 charges 有包括帳單和薪資的部分可是只有和 manhour 有關的

        ArrayList<FeeDetail> mh_fds = new FeeDetailMgr(tran_id).retrieveList("manhourId in (" + manhourIds2 + ")", "");
        Map<String, ArrayList<FeeDetail>> mh_feedetailMap = new SortingMap(mh_fds).doSortA("getChargeKey");

        chargeitemIds2 = new RangeMaker().makeRange(mh_fds, "getChargeItemId");
        ArrayList<ChargeItemMembr> mh_charges = new ChargeItemMembrMgr(tran_id).
            retrieveList("chargeItemId in (" + chargeitemIds2 + ")", "");

        // 找出 feedetail 和 charge 不 match 的記錄
        ArrayList<String> needfix = new ArrayList<String>();
        for (int i=0; i<mh_charges.size(); i++) {
            ChargeItemMembr ci = mh_charges.get(i);
            ArrayList<FeeDetail> myfds = mh_feedetailMap.get(ci.getMembrId()+"#"+ci.getChargeItemId());
            if (ci.getMyAmount()!=getFdAmount(myfds)) {
                out.println("<br>##1## " + ci.getTicketId());
                needfix.add(ci.getTicketId());
            }
        }

        // 找出 ticket 和 charge 不 match 的記錄
        String ticketIds = new RangeMaker().makeRange(mh_charges, "getTicketIdAsString");
        ArrayList<MembrInfoBillRecord> mbrs = new MembrInfoBillRecordMgr(tran_id).retrieveList("ticketId in (" + ticketIds + ")","");
        ArrayList<ChargeItemMembr> bill_charges = new ChargeItemMembrMgr(tran_id).
            retrieveList("ticketId in (" + ticketIds + ")", "");
        Map<String, ArrayList<ChargeItemMembr>> billchargeMap = new SortingMap(bill_charges).doSortA("getTicketId");

        for (int i=0; i<mbrs.size(); i++) {
            MembrInfoBillRecord mbr = mbrs.get(i);
            ArrayList<ChargeItemMembr> billcharges = billchargeMap.get(mbr.getTicketId());
            if (mbr.getReceivable()!=getChargeTotal(billcharges)) {
                out.println("<br>##2## " + mbr.getTicketId());
                needfix.add(mbr.getTicketId());
            }
        }

        // 重新計算 membrbillrecord
        MembrBillRecordMgr mbrmgr = new MembrBillRecordMgr(tran_id);
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        for (int i=0; i<needfix.size(); i++) {
            MembrBillRecord mbr = mbrmgr.find("ticketId='" + needfix.get(i) + "'");
            ArrayList<ChargeItemMembr> mycharges = billchargeMap.get(mbr.getTicketId());
            int total = 0;
            for (int j=0; j<mycharges.size(); j++) {
                ChargeItemMembr ci = mycharges.get(j);
                ArrayList<FeeDetail> myfds = mh_feedetailMap.get(ci.getMembrId()+"#"+ci.getChargeItemId());
                if (myfds==null) { // 這個不是 manhour 來的 charge
                    total += ci.getMyAmount();
                }
                else {
                    int charge_total = getFdAmount(myfds);
                    if (ci.getMyAmount()!=charge_total) {
                        if (mbr.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID)
                            throw new Exception("已付款不可修改");
                        Charge cc = cmgr.find("membrId=" + ci.getMembrId() + " and chargeItemId=" + ci.getChargeItemId());
                        cc.setAmount(charge_total);
                        cmgr.save(cc);
                    }
                    total += charge_total;
                }
            }
            if (total!=mbr.getReceivable()) {
                if (mbr.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID)
                    throw new Exception("已付款不可修改");
                mbr.setReceivable(total);
                mbrmgr.save(mbr);
            }
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
        if (e.getMessage()!=null) { 
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>'); history.go(-1);</script><%
        } else { 
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            e.printStackTrace();
        }
        return;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<%!
    int getFdAmount(ArrayList<FeeDetail> fds)
    {
        int ret = 0;
        if (fds==null)
            return 0;
        for (int i=0; i<fds.size(); i++) {
            FeeDetail fd = fds.get(i);
            ret += fd.getUnitPrice()*fd.getNum();
        }
        return ret;
    }

    int getChargeTotal(ArrayList<ChargeItemMembr> charges)
    {
        int ret = 0;
        if (charges==null)
            return 0;
        for (int i=0; i<charges.size(); i++) {
            ChargeItemMembr ci = charges.get(i);
            ret += ci.getMyAmount();
        }
        return ret;
    }
%>
