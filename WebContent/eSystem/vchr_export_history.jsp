<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<blockquote>
<div class=es02b>我的匯出歷史</div>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    ArrayList<VchrHolder> vchrs = VchrHolderMgr.getInstance().retrieveList("type=" + VchrHolder.TYPE_EXPORT + 
        " and userId=" + ud2.getId(), "order by created desc");
    if (vchrs.size()==0) {
        out.println("沒有匯出資料");
        return;
    }

    VchrInfo vinfo = VchrInfo.getVchrInfoV(vchrs, 0);
    for (int i=0; i<vchrs.size(); i++) {
        VchrHolder v = vchrs.get(i); 
      %><a class="an01" href="javascript:parent.show_export(<%=v.getId()%>)"> <%=vinfo.getVchrNote(v)%> (<%=sdf.format(v.getCreated())%>) <br> <%
    }
%>
</blockquote>