﻿<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,301))
    {
        response.sendRedirect("authIndex.jsp?code=301");
    }
    int cid = -1, sid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    try { sid = Integer.parseInt(request.getParameter("sid")); } catch (Exception e) {}

    ChargeItemMembr ci = ChargeItemMembrMgr.getInstance().find("chargeItemId=" + cid + 
        " and membr.id=" + sid);

    String chargeNote = ci.getNote();
    if (chargeNote==null)
        chargeNote = "";

    ChargeMembr cs = ChargeMembrMgr.getInstance().find("chargeItemId=" + cid + " and membrId=" + sid);
    DecimalFormat mnf = new DecimalFormat("########0");
%>
<script>
function IsNumeric(sText)

{
    var ValidChars = "0123456789.";
    var IsNumber=true;
    var Char; 
    if (sText.length==0)
        return false;
    var i = 0;
    if (sText.length>0 && sText.charAt(0)=='-')
        i = 1;
    for (; i < sText.length && IsNumber == true; i++) 
    { 
        Char = sText.charAt(i); 
        if (ValidChars.indexOf(Char) == -1) 
        {
            IsNumber = false;
        }
    }
    return IsNumber;

}

function check_submit(f)
{
    if (!IsNumeric(f.amount.value)) {
        alert("請輸入正確金額");
        f.amount.focus();
        return false;
    }
    return true;
}


</script>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>修改<%=ci.getChargeName()%>金額 for <%=cs.getMembrName()%></b>
<div class=es02 align=right><a href="salaryfeedetail_list.jsp?cid=<%=cid%>&sid=<%=sid%>">進階(鐘點費設定)</a></div>
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<form action="salarycharge_modify2.jsp" method="post" onsubmit="return check_submit(this);">
 
<input type=hidden name=cid value="<%=cid%>">
<input type=hidden name=sid value="<%=sid%>">
<center>
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>金額</td>
			<td bgcolor="#ffffff" nowrap>
			    &nbsp;&nbsp;<input type=text name="amount" size=10 value="<%=mnf.format(Math.abs(ci.getMyAmount()))%>"> 
			</td>
		</tr>

		<tr bgcolor=#f0f0f0 class=es02>
			<td>原因:</td>
			<td bgcolor="#ffffff">
                (供內部記錄，不會出現在薪資單上) <br>
				<textarea name="reason" cols=40 rows=2><%=chargeNote%></textarea>
				<br>
			</td>
		</tr>
		
		<tr class=es02> 
			<td colspan=2 align=center>
				<input type=submit value="修改">
			</td>
		</tr>
		</table>
	
		</td>
		</tR>
		</table>

</form>
</center>