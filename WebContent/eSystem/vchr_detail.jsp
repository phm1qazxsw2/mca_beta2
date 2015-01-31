<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2-new.jsp"%>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<!--############# -->
<link rel="stylesheet" href="css/dhtmlwindow.css" type="text/css" />
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="openWindow.js"></script> 
<script src="js/show_voucher.js"></script>
<!--############# -->
 
<script src="js/string.js"></script>
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

<div class=es02>
<b>&nbsp;&nbsp;&nbsp;日 記 帳</b>
</div>

<table border=0 width=90%>
<tr>
  <td width=10></td>
  <td valign=top>
    <%@ include file="vchr_detail_tool.jsp"%>
  </td>
</tr>

<tr>
  <td colspan=2 align=right valign=top>
      <div id="descdiv">
      </div>
  </td>
</tr>

<tr>
  <td width=10></td>
  <td width="*%" valign=top>
      <div id="displaydiv">
      </div>
  </td>
</tr>

<tr>
  <td width=10></td>
  <td width="*%" align=center>
      <div id="summarydiv">
      </div>
  </td>
</tr>

</table>

<br>
<br>

<script>
setup_display("displaydiv", "descdiv", "summarydiv");
</script>
<%@ include file="bottom.jsp"%>