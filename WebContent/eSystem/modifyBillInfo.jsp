<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    String billS=request.getParameter("billId");

    String m=request.getParameter("m");
    int billId=Integer.parseInt(billS);

    Bill bill=BillMgr.getInstance().find("id='"+billId+"'");

    if(m !=null){
%>
    <script>
        alert('修改完成.');
    </script>
<%  }   %>

<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>帳單資訊:</b></div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>

<form action="modifyBillInfo2.jsp" method="post">
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
    	<td valign=middle>機構名稱</td>
        <td bgcolor=ffffff valign=middle>
            <input type=text name="comName" value="<%=(bill.getComName()!=null)?bill.getComName():""%>" size=30>
        </td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
    	<td valign=middle>機構地址</td>
        <td bgcolor=ffffff valign=middle>
            <input type=text name="comAddr" value="<%=(bill.getComAddr()!=null)?bill.getComAddr():""%>" size=45>
        </td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
    	<td valign=middle>匯款資訊</td>
        <td bgcolor=ffffff valign=middle>
            <textarea name="payNote" rows=2 cols=45><%=(bill.getPayNote()!=null)?bill.getPayNote():""%></textarea>
        </td>
    </tr>

	<tr bgcolor=#f0f0f0 class=es02 valign=top>
    	<td valign=middle>立案字號</td>
        <td bgcolor=ffffff valign=middle>
            <input type="test" name="regInfo" value="<%=(bill.getRegInfo()!=null)?bill.getRegInfo():""%>" size=30>
        </td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
        <td bgcolor=ffffff align=middle colspan=2>
            <input type=hidden name="billId" value="<%=billId%>" >
            <input type=submit value="修改">
        </td>
    </tr>
</table>
</td></tr></table> 

</form>
</center>
