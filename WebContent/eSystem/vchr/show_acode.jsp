<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    int t = Integer.parseInt(request.getParameter("t"));
    int acodeId = Integer.parseInt(request.getParameter("a"));
    boolean show_main_only = request.getParameter("m").equals("main");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###.#"); 
    Date start = sdf.parse(request.getParameter("s"));
    Date end = sdf.parse(request.getParameter("e"));
    Calendar cal = Calendar.getInstance();
    cal.setTime(end);
    cal.add(Calendar.DATE, 1);
    Date nextEndDay = cal.getTime();
    
    String q = "registerDate>='" + sdf.format(start) + "' and registerDate<'" + sdf.format(nextEndDay) + "' and vchr_holder.type="+VchrHolder.TYPE_INSTANCE;
    
    String title = "";
    AcodeMgr amgr = AcodeMgr.getInstance();
    Acode a = amgr.find("id=" + acodeId);
    if (show_main_only) {
        q += " and main='" + a.getMain() + "'"; // 所有子科目都要找出
        title = a.getMain() + "(含子科目)";
    }
    else {
        if (a.getSub()==null || a.getSub().length()==0)
            q += " and main='" + a.getMain() + "' and sub=''";
        else
            q += " and " + Acode.makeSearchKey(a.getMain(), a.getSub(), null); // 只找主科目
        title += a.getMain() + a.getSub() + "(不含子科目)";
    }

    out.println("<title>"+title+"</title>");
   
    if (t==1) {
        q += " and vchr_thread.srcType in (1,4,5)";
    }
    else if (t==2) {
        q += " and vchr_thread.srcType in (2,7,8)";
    }
    else if (t==3) {
        q += " and vchr_thread.srcType in (3,9,10)";
    }
    else if (t==4) {
        q += " and vchr_thread.srcType in (11)";
    }
    else if (t==5) {
        q += " and vchr_thread.srcType in (6,12,13)";
    }
    else if (t==6) {
        q += " and vchr_thread.srcType in (1)";
    }
    
    ArrayList<VchrItemInfo> vitems =VchrItemInfoMgr.getInstance().retrieveListX(q, "order by registerDate asc, vchrId asc, vchr_item.id asc", _ws2.getBunitSpace("vchr_holder.buId"));
%>
<%@ include file="vitem_list_content.jsp"%>
