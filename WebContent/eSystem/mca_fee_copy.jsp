<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    McaFee fee = McaFeeMgr.getInstance().find("id=" + request.getParameter("id"));
    if (fee==null)
        fee = new McaFee();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
%>
<script>
function do_copy()
{
    if (!do_check()) 
        return;
    if (!confirm('Make sure the status of students no longer in school has been properly set to off-school so that they won\'t be copied to the new fee')) 
        return;
    document.f1.submit();
}
</script>

<br>
 
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;Create New Fee Schedule Settings</b>
</div> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>
<form name=f1 action="mca_fee_copy2.jsp" onsubmit="return do_check(f)" method=post>
<input type=hidden name=id value="<%=fee.getId()%>">

<% boolean create_new = true; %>
<%@ include file="mca_fee_content.jsp"%>

</form>
</blockquote>

<%@ include file="bottom.jsp"%>	

<script>
    document.getElementById("buttons").innerHTML = 
        '<input name=noname type=button value=" Create " onclick="do_copy()">';
</script>
