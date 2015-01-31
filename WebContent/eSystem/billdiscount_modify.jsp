<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    int did = Integer.parseInt(request.getParameter("did")); 

    int dType = -1;
    int damount = (int) 0;
    String discountNote = "";
    int copystatus = Discount.COPY_YES;

    DiscountInfo d = DiscountInfoMgr.getInstance().find("discount.id=" + did);
    if (d!=null) {
        dType = d.getType();
        damount = d.getAmount();
        discountNote = d.getNote();
        if (discountNote==null)
            discountNote = "";
        copystatus = d.getCopy();
    }

    ChargeItemMembr ci = ChargeItemMembrMgr.getInstance().find("chargeItemId=" + d.getChargeItemId() + 
        " and membr.id=" + d.getMembrId());
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
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>編輯調整 for <%=ci.getMembrName()%> <%=ci.getChargeName()%></b>
 
<br>
<div class=es02 align=right>
                &nbsp;&nbsp; <a href="javascript:history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上一頁</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<form action="billdiscount_modify2.jsp" method="post" onsubmit="return check_submit(this);">
<input type=hidden name=cid value="<%=d.getChargeItemId()%>">
<input type=hidden name=sid value="<%=d.getMembrId()%>">
<input type=hidden name=did value="<%=did%>">
<input type=hidden name="type" value="<%=types[0].getId()%>">
<input type=hidden name=copystatus value='<%=Discount.COPY_NO%>'>
<center>
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>


		<tr bgcolor=#f0f0f0 class=es02>
			<td>金額</td>
			<td bgcolor="#ffffff">
			<input type=text name="damount" size=10 value="<%=mnf.format(0-damount)%>">
			</td>
		</tr>

		<tr bgcolor=#f0f0f0 class=es02>
			<td>原因:</td>
			<td bgcolor="#ffffff">
                (供內部記錄，不會出現在帳單上) <br>
				<textarea name="reason" cols=40 rows=2><%=discountNote%></textarea>
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