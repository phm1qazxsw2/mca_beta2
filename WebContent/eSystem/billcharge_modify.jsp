<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int cid = -1, sid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    try { sid = Integer.parseInt(request.getParameter("sid")); } catch (Exception e) {}
    boolean readonly = false;
    try { readonly = request.getParameter("ro").equals("1"); } catch (Exception e) {}

    ChargeItemMembr ci = ChargeItemMembrMgr.getInstance().findX("chargeItemId=" + cid + 
        " and membr.id=" + sid, _ws2.getAcrossBillBunitSpace("bill.bunitId")); // 要能編 cover 單位的帳單

    if (ci==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

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
<% if (!readonly) { %>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>修改<%=ci.getChargeName()%>
金額 for <%=cs.getMembrName()%></b>
<div class=es02 align=right><a href="feedetail_list.jsp?cid=<%=cid%>&sid=<%=sid%>"><img src="pic/redfix.png" border=0>&nbsp;進階編輯</a></div>
<br>
<% } %>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<form action="billcharge_modify2.jsp" method="post" onsubmit="return check_submit(this);">
 
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
			    &nbsp;&nbsp;<input type=text name="amount" size=10 value="<%=mnf.format(ci.getMyAmount())%>"> 

			</td>
		</tr>
    <% if (ci.getPitemId()>0) { %>
        <tr bgcolor=#f0f0f0 class=es02>
			<td>數量</td>
			<td bgcolor="#ffffff" nowrap>
			    &nbsp;&nbsp;<input type=text name="pitemNum" size=10 value="<%=ci.getPitemNum()%>"> 
			</td>
		</tr>
    <% } %>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>原因:</td>
			<td bgcolor="#ffffff">
                (供內部記錄，不會出現在帳單上) <br>
<% if (ci.getChargeName_().equals("## Interest")) { %>
                <%=chargeNote%>
<% } else { %>
				<textarea name="reason" cols=40 rows=2><%=chargeNote%></textarea>
<% } %>
				<br>
			</td>
		</tr>
		
		<tr class=es02> 
			<td colspan=2 align=center>
<%
    if(checkAuth(ud2,authHa,102)) {
        if (!readonly) {
%>
				<input type=submit value="修改">
<%
        }
    }else{
%>
            權限不足,無法修改.

<%  }   %>


			</td>
		</tr>
		</table>
	
		</td>
		</tR>
		</table>

</form>
</center>