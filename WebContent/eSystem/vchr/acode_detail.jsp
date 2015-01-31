<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    String srctype = request.getParameter("t");
    // String b = request.getParameter("b");
    String p = request.getParameter("p");

    boolean show_main_only = request.getParameter("m").equals("main");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###.#");
    Date start = sdf.parse(request.getParameter("s"));
    Date end = sdf.parse(request.getParameter("e"));
    Calendar cal = Calendar.getInstance();
    cal.setTime(end);
    cal.add(Calendar.DATE, 1);
    Date nextEndDay = cal.getTime();    
    
    out.println("<title>明細分類帳</title>");       
        
    // int acodeId = Integer.parseInt(request.getParameter("a"));
    String[] acodeIds = request.getParameterValues("a");

    if (acodeIds==null) {
        %><script>alert("沒有指定會計科目");history.go(-1)</script><%
        return;
    }

    for (int ith=0; ith<acodeIds.length; ith++) {
        String q = "registerDate>='" + sdf.format(start) + "' and registerDate<'" + sdf.format(nextEndDay) + "' and vchr_holder.type="+VchrHolder.TYPE_INSTANCE;
        String title = "分類帳-";
        AcodeMgr amgr = AcodeMgr.getInstance();
        Acode a = amgr.find("id=" + acodeIds[ith]);
        AcodeInfo ainfo = AcodeInfo.getInstance(a);
        if (show_main_only) {
            q += " and main='" + a.getMain() + "'"; // 所有子科目都要找出
            title = a.getMain() + " " + ainfo.getName(a) + "(含子科目)";
        }
        else {
            if (a.getSub()==null || a.getSub().length()==0) {
                q += " and main='" + a.getMain() + "' and sub=''";
                title += a.getMain() + a.getSub() + " " + ainfo.getName(a) + "(不含子科目)";
            }
            else {
                q += " and " + Acode.makeSearchKey(a.getMain(), a.getSub(), null); // 只找主科目
                title += a.getMain() + a.getSub() + " " + ainfo.getName(a);
            }
        }

        if (srctype!=null&&srctype.length()>0) {
            q += " and vchr_thread.srcType in ("+srctype+")";
        }

        //if (b!=null&&b.length()>0) 
        //    q += " and bunitId=" + b;
        //if (p!=null&&p.length()>0) 
        //    q += " and prjId=" + p;

System.out.println("q=" + q);        
        ArrayList<VchrItemInfo> vitems =VchrItemInfoMgr.getInstance().retrieveListX
            (q, "order by registerDate asc, vchrId asc, vchr_item.id asc", _ws2.getBunitSpace("vchr_holder.buId"));
        {
%>
<div class=es_title>
<b><%=title%></b>
</div>
<br>
<%@ include file="vitem_list_content.jsp"%>
<%
        }
        out.println("<br><br><br>");
    }
%>
