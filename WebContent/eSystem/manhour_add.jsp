<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String note = "";
%>

<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="pic/add.gif" border=0>&nbsp;新增派遣
</div>

<form name="f1" action="manhour_add2.jsp" method="post" onsubmit="return doCheck(this);">
<%@ include file="manhour_edit_inner.jsp"%>
</form>

<script>
    document.getElementById("submit").innerHTML = "<input type=submit name=\"submit\" value=\"新增\">";
</script>