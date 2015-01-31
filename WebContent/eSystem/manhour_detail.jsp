<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String note = "";
    ArrayList<ManHour> tmp = ManHourMgr.getInstance().retrieveList("id=" + request.getParameter("id"), "");
    ManHour mh = tmp.get(0);
    ManHourDescription desc = new ManHourDescription(tmp);
    SimpleDateFormat sdf_ = new SimpleDateFormat("yyyy/MM/dd");
    boolean modify = false;
    try { modify = request.getParameter("m").equals("1"); } catch (Exception e) {}
System.out.println("## modify=" + modify);
%>

<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="pic/add.gif" border=0>&nbsp;上課內容
</div>

<form name="f1" action="manhour_add2.jsp" method="post" onsubmit="return doCheck(this);">
<input type=hidden name="id" value="<%=mh.getId()%>">
<input type=hidden name="m" value="<%=(modify)?1:0%>">
<%@ include file="manhour_edit_inner.jsp"%>
</form>

<script>
    if (typeof setSource_executeMembrId!='undefined')
        setSource_executeMembrId(<%=mh.getExecuteMembrId()%>, '<%=phm.util.TextUtil.escapeJSString(desc.getExecutorName(mh))%>');
    setTarget_target(<%=mh.getClientMembrId()%>, '<%=phm.util.TextUtil.escapeJSString(desc.getClientName(mh))%>');
    document.f1.occurDate.value = '<%=sdf_.format(mh.getOccurDate())%>';
    document.f1.quant.value = '<%=desc.getChargeNum(mh)%>';
    setChargeItemId(<%=desc.getChargeItemId(mh)%>);
    set_month('<%=desc.getMonth(mh)%>');
    check_chargeitems(document.f1.month);
    document.getElementById("submit").innerHTML = "<input type=submit name=\"submit\" value=\"<%=(!modify)?"複製":"修改"%>\">";
</script>
