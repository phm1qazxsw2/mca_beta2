<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
    int fid = Integer.parseInt(request.getParameter("fid")); 

    FeeDetail fd = FeeDetailMgr.getInstance().find("feedetail.id=" + fid);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    ChargeItemMembr ci = ChargeItemMembrMgr.getInstance().find("chargeItemId=" + fd.getChargeItemId() + 
        " and membr.id=" + fd.getMembrId());
    DecimalFormat mnf = new DecimalFormat("########0");
%>
<script>
function checkDate(d) {
    var tokens = d.split("-");
    if (tokens.length!=3)
        return false;
    for (var i=0; i<tokens.length; i++) {
        if (!IsNumeric(tokens[i])) {
            return false;
        }
    }    
    if (tokens[0].length!=4 || tokens[1].length!=2 || tokens[2].length!=2) {
        return false;
    }
    
    return true;
}

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
    if (!checkDate(f.feeTime.value)) {
        alert("請輸入正確的日期");
        f.feeTime.focus();
        return false;
    }
    if (!IsNumeric(f.unitPrice.value)) {
        alert("請輸入正確金額");
        f.unitPrice.focus();
        return false;
    }
    if (!IsNumeric(f.quant.value)) {
        alert("請輸入正確數量");
        f.quant.focus();
        return false;
    }
    return true;
}
</script>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<br>
<div class=es02> 
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>設定薪資明細-<%=ci.getChargeName()%> for <%=ci.getMembrName()%> </b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="javascript:history.go(-1)"><img src="pic/last.gif" border=0>回上一頁</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<form action="salaryfeedetail_modify2.jsp" method="post" onsubmit="return check_submit(this);">
<input type=hidden name=fid value="<%=fid%>">
<center>
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>

		<tr bgcolor=#f0f0f0 class=es02>
			<td>日期</td>
			<td bgcolor="#ffffff">
                <input type=text name="feeTime" value="<%=sdf.format(fd.getFeeTime())%>">
			</td>
		</tr>


		<tr bgcolor=#f0f0f0 class=es02>
			<td>單價</td>
			<td bgcolor="#ffffff">
			<input type=text name="unitPrice" size=5 value="<%=mnf.format(Math.abs(fd.getUnitPrice()))%>">
			</td>
		</tr>

		<tr bgcolor=#f0f0f0 class=es02>
			<td>數量:</td>
			<td bgcolor="#ffffff">
			<input type=text name="quant" size=5 value="<%=fd.getNum()%>">
			</td>
		</tr>
        
		<tr bgcolor=#f0f0f0 class=es02>
			<td>附註:</td>
			<td bgcolor="#ffffff">
				<textarea name="note" cols=40 rows=2></textarea>
				<br>
			</td>
		</tr>

		<tr class=es02> 
			<td colspan=2 align=center>
				<input type=submit value="修改">
                &nbsp;&nbsp; 
			</td>
		</tr>
		</table>
	
		</td>
		</tR>
		</table>

</form>
</center>