<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }

    String ticketIds = request.getParameter("o");
    ArrayList<MembrInfoBillRecord> bills = MembrInfoBillRecordMgr.getInstance().retrieveList("ticketId in (" + ticketIds + ")", "");
%>

<html>

<br>

<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>修改繳費截止日期和備註 </b> 
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<form> 
<input type=hidden name="ticketIds" value="<%=ticketIds%>">
<center>
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>繳款截止日 </td>
			<td bgcolor="#ffffff">
			<input type=text name="billDate" size=10 value="<%=sdf.format(bills.get(0).getMyBillDate())%>">
            (設定一律請打西元年，印帳單時會轉成民國年)
			</td>
		</tr>

		<tr bgcolor=#f0f0f0 class=es02>
			<td>備註攔:</td>
			<td bgcolor="#ffffff">
                <input type=checkbox name="overwrite"> 取代原有個別設定的備註
				<br><textarea name="comment" cols=40 rows=2></textarea>
				<br>ex:*逾時費收費日期: 4/9, 4/7
			</td>
		</tr>
		
		<tr class=es02> 
			<td colspan=2 align=center>
				<input type=button value="修改" onclick="save_bill_modifyall(this.form);">
			</td>
		</tr>
		</table>
	
		</td>
		</tR>
		</table>

</form>
</center>

