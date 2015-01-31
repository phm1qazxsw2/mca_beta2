<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
	String m=request.getParameter("m");
	
	PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem e=(PaySystem)em.find(1);
	
	SalaryAdmin sa=SalaryAdmin.getInstance();

	if(m !=null)
	{
		out.println("<font color=red>修改完成!!</font><br><br>");
	}
%>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>編輯帳單資訊</b> 
<center>

<form action="modifyBillSetup2.jsp" method="post"> 

<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr align=left valign=middle>
<td colspan=2 class=es02 align=middle><b>付款方式設定</b></td>
</tr>


<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>便利商店繳款</td><td class=es02>
<%
    if(e.getPaySystemStoreActive()==9)
    {
%>
        系統尚未開啟
        <input type=hidden name="paySystemStoreActive" value="9">
<%
    }else{
%>
    <input type=radio name="paySystemStoreActive" value="1" <%=(e.getPaySystemStoreActive()==1)?"checked":""%>>使用中
    <input type=radio name="paySystemStoreActive" value="0" <%=(e.getPaySystemStoreActive()==0)?"checked":""%>>停用
<%
    }
%>
</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>其他繳費方式</td><td class=es02>

<%
    if(e.getPaySystemATMActive()==9)
    {
%>    
        系統尚未開啟(僅顯示貼心叮嚀)
        <input type=hidden name="paySystemATMActive" value="9">
<%
    }else{
%>

    <input type=radio name="paySystemATMActive" value="3" <%=(e.getPaySystemATMActive()==3)?"checked":""%>>固定虛擬帳號
    <input type=radio name="paySystemATMActive" value="1" <%=(e.getPaySystemATMActive()==1)?"checked":""%>>浮動虛擬帳號
    <input type=radio name="paySystemATMActive" value="2" <%=(e.getPaySystemATMActive()==2)?"checked":""%>>指定帳戶轉帳
    <input type=radio name="paySystemATMActive" value="0" <%=(e.getPaySystemATMActive()==0)?"checked":""%>>無(僅顯示貼心叮嚀)

<%
    }
%>
</td>
</tr>


<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>貼心叮嚀文案</td>
	<td class=es02>
	<textarea rows=4 cols=30 name="paySystemReplaceWord">
	<%=(e.getPaySystemReplaceWord()==null)?"":e.getPaySystemReplaceWord()%></textarea>
	</td>
</tr>

<tr align=left valign=middle>
<td colspan=2 class=es02 align=middle><b>生日祝福</b></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>狀態</td><td class=es02>
<input type=radio name="paySystemBirthActive" value="1" <%=(e.getPaySystemBirthActive()==1)?"checked":""%>>使用中
<input type=radio name="paySystemBirthActive" value="0" <%=(e.getPaySystemBirthActive()==0)?"checked":""%>>停用
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>顯示內容</td>
<td class=es02>
	<textarea rows=2 cols=60 name="paySystemBirthWord">
<%=(e.getPaySystemBirthWord()!=null)?e.getPaySystemBirthWord():""%></textarea> 
	<br>說明: XXX=生日日期
 YYY=學生姓名    <br>ex: YYY寶貝於XXX要生日囉,<%=e.getPaySystemCompanyName()%>祝你生日快樂!

</td>
</tr>  
<tr align=left valign=middle>
<td colspan=2 class=es02 align=middle><b>延續未繳帳單</b></td>
</tr> 

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>合併前期未繳的帳單</td>
<td class=es02> 
        <input type=radio name="paySystemExtendNotpay" value="2" <%=(e.getPaySystemExtendNotpay()==2)?"checked":""%>>判斷是否超過繳費期限
		<input type=radio name="paySystemExtendNotpay" value="1" <%=(e.getPaySystemExtendNotpay()==1)?"checked":""%>>全部合併
		<input type=radio name="paySystemExtendNotpay" value="0" <%=(e.getPaySystemExtendNotpay()==0)?"checked":""%>>全部不合併
</td>
</tr>


<tr bgcolor=ffffff align=left valign=middle>
<td colspan=2 class=es02><center><input type=submit value="修改"></center></td>
</tr>
</table>
</td>
</tr>
</table>
</center>