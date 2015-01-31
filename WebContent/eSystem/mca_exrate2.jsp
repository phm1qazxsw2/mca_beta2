<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
try {
    double rate = Double.parseDouble(request.getParameter("rate"));

    McaExRate r = new McaExRate();
    r.setRate(rate);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date d = sdf.parse(sdf.format(new Date()));
    r.setStart(d);
    McaExRateMgr.getInstance().create(r);

    response.sendRedirect("mca_exrate.jsp");
}
catch (Exception e) {
    if (e.getMessage()!=null) {
  %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
    } else {
      e.printStackTrace();
  %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
    }
}
%>
