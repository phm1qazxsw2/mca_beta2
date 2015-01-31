<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=4;
    boolean showall = true;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    ArrayList<BillRecordInfo> brs = BillRecordInfoMgr.getInstance().retrieveList("billType=" + 
        Bill.TYPE_BILLING, "order by billrecord.id desc");
    if (brs.size()==0) {
        out.println("<br><blockquote>請先產生帳單和薪資記錄</blockquote>");
        return;
    }
    SimpleDateFormat monthsdf = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
%>

<br>
<b>&nbsp;&nbsp;&nbsp;派遣記錄</b>
 
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<div class=es02>
<form target=_blank name="f1" action="ticketFrame.jsp" method="get">
<input type=hidden name="pstat" value="-1">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<select name="month">
<% for (int i=0; i<brs.size(); i++) { 
       BillRecord br = brs.get(i);  %>
      <option value="<%=monthsdf.format(br.getMonth())%>"><%=monthsdf.format(br.getMonth())%>
<% } %>
</select>
    &nbsp;&nbsp;
    <input type=submit value="編輯">
</form>
</div>

