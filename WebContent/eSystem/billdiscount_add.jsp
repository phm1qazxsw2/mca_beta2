<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    int cid = -1, sid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    try { sid = Integer.parseInt(request.getParameter("sid")); } catch (Exception e) {}

    ChargeItemMembr ci = ChargeItemMembrMgr.getInstance().find("chargeItemId=" + cid + 
        " and membr.id=" + sid);
        
    ChargeMembr cs = ChargeMembrMgr.getInstance().find("chargeItemId=" + cid + " and membrId=" + sid);
    DecimalFormat mnf = new DecimalFormat("########0");

    JsfAdmin jadm = JsfAdmin.getInstance();
    DiscountType[] types = jadm.getAactiveDiscountType();
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
    if (!IsNumeric(f.damount.value)) {
        alert("請輸入正確金額");
        f.damount.focus();
        return false;
    }
    return true;
}


</script>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<br> 
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>新增調整 for <%=cs.getMembrName()%> <%=ci.getChargeName()%></b>
 
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<form action="billdiscount_add2.jsp" method="post" onsubmit="return check_submit(this);">
 
<input type=hidden name=cid value="<%=cid%>">
<input type=hidden name=sid value="<%=sid%>">
<input type=hidden name="type" value='<%=types[0].getId()%>'>
<input type=hidden name=copystatus value='<%=Discount.COPY_NO%>'>

<center>
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>

		<tr bgcolor=#f0f0f0 class=es02>
			<td>金額</td>
			<td bgcolor="#ffffff">
			<input type=text name="damount" size=10 value="">
			</td>
		</tr>

		<tr bgcolor=#f0f0f0 class=es02>
			<td>原因:</td>
			<td bgcolor="#ffffff">
                (供內部記錄，不會出現在帳單上) <br>
				<textarea name="reason" cols=40 rows=2></textarea>
				<br>
			</td>
		</tr>
		

		<tr class=es02> 
			<td colspan=2 align=center>
				<input type=submit value="新增">
                &nbsp;&nbsp; <a href="javascript:history.go(-1)">回上一頁</a>
			</td>
		</tr>
		</table>
	
		</td>
		</tR>
		</table>

</form>
</center>