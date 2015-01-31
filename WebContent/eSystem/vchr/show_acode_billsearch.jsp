<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    String o = request.getParameter("o");
    int acodeId = Integer.parseInt(request.getParameter("a"));
    boolean show_main_only = request.getParameter("m").equals("main");

    StringBuffer sb1 = new StringBuffer();
    String[] tickets = o.split(",");
    for (int i=0; i<tickets.length; i++) {
        if (sb1.length()>0) sb1.append(",");
        sb1.append("'");
        sb1.append(tickets[i]);
        sb1.append("'");
    }

    ArrayList<MembrInfoBillRecord> bills = MembrInfoBillRecordMgr.getInstance().retrieveList(
        "ticketId in (" + sb1.toString() + ")", "");
    String all_threadIds = new VoucherService(0, _ws2.getSessionBunitId()).getBillRelatedThreadIds(bills);
    
    DecimalFormat mnf = new DecimalFormat("###,###.#");    
    
    String title = "";
    AcodeMgr amgr = AcodeMgr.getInstance();
    Acode a = amgr.find("id=" + acodeId);
    AcodeInfo ai = AcodeInfo.getInstance(a);
    String q = "vchr_item.threadId in (" + all_threadIds + ")";
    if (show_main_only) {
        q += " and main='" + a.getMain() + "'";
        title = ai.getMainSub(a) + " " + ai.getName(a) + "(含子科目)";
    }
    else {
        if (a.getSub()==null || a.getSub().length()==0)
            q += " and main='" + a.getMain() + "' and sub=''";
        else
            q += " and " + Acode.makeSearchKey(a.getMain(), a.getSub(), null); // 只找主科目
        title += ai.getMainSub(a) + " " + ai.getName(a) + "(不含子科目)";
    }

    out.println("<title>"+title+"</title>");
   
    
    ArrayList<VchrItemInfo> vitems =VchrItemInfoMgr.getInstance().retrieveListX(
        q, "order by vchrId asc, vchr_item.id asc", _ws2.getBunitSpace("vchr_holder.buId"));

%>
<div class=es_title><b><%=title%></b></div>
<%@ include file="vitem_list_content.jsp"%>
