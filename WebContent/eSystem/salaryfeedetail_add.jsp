<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2

    int cid = -1, sid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    try { sid = Integer.parseInt(request.getParameter("sid")); } catch (Exception e) {}

    ChargeItemMembr ci = ChargeItemMembrMgr.getInstance().find("chargeItemId=" + cid + 
        " and membr.id=" + sid);
        
    ChargeMembr cs = ChargeMembrMgr.getInstance().find("chargeItemId=" + cid + " and membrId=" + sid);
    DecimalFormat mnf = new DecimalFormat("########0");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
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
    if (!IsNumeric(f.num.value)) {
        alert("請輸入正確數量");
        f.num.focus();
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

 
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<form action="salaryfeedetail_add2.jsp" method="post" onsubmit="return check_submit(this);">
 
<input type=hidden name=cid value="<%=cid%>">
<input type=hidden name=sid value="<%=sid%>">
<center>
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>

		<tr bgcolor=#f0f0f0 class=es02>
			<td>日期</td>
			<td bgcolor="#ffffff">
                <input type="text" name="feeTime" size=10 value="<%=sdf.format(new Date())%>">
			</td>
		</tr>

		<tr bgcolor=#f0f0f0 class=es02>
			<td>單價</td>
			<td bgcolor="#ffffff">
			    <input type=text name="unitPrice" size=7 value="">
			</td>
		</tr>

		<tr bgcolor=#f0f0f0 class=es02>
			<td>數量</td>
			<td bgcolor="#ffffff">
			    <input type=text name="num" size=5 value="">
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
				<input type=submit value="新增">
			</td>
		</tr>
		</table>
	
		</td>
		</tR>
		</table>

</form>
</center>