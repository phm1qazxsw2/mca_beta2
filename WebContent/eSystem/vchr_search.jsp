<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2-new.jsp"%>
<!--############# -->
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<link rel="stylesheet" href="css/dhtmlwindow.css" type="text/css" />
<script type="text/javascript" src="openWindow.js"></script> 
<script src="js/show_voucher.js"></script>
<!--############# -->
 
<script src="js/formcheck.js"></script>
<script>
function doSubmit(f)
{
    if (!checkDate(f.start.value,'/')) {
        alert("請輸入正確的開始日期");
        f.start.focus();
        return false;
    }
    if (!checkDate(f.end.value,'/')) {
        alert("請輸入正確的結束日期");
        f.end.focus();
        return false;
    }
    return true;
}

</script>
<br>

<!-- ####### below needed by vchr_search_tool.jsp ####-->
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<script src="js/string.js"></script>
<script src="js/cookie.js"></script>
<!-- #################################################-->

<div class=es02>
<b>&nbsp;&nbsp;&nbsp;分 類 帳</b>
</div>

<table border=0 width=90%>
<tr>
  <td width=5></td>
  <td width=150 valign=top nowrap>
    <%@ include file="vchr_search_tool.jsp"%>
  </td>
  <td width=50></td>
  <td width="*%" valign=top>
  <div id="displaydiv">
  </div>
  <div id="descdiv">
  </div>
  </td>
</table>

<script>
setup_display("displaydiv", "descdiv");
</script>
<%@ include file="bottom.jsp"%>