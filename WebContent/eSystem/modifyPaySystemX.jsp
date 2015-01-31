<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu7.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,3))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }

	String m=request.getParameter("m");	
	PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem e=(PaySystem)em.find(1);	
%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>繳款資訊設定</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>
<br>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<form action="modifyPaySystemX2.jsp" method="post">
<tr bgcolor=4A7DBD class=es02>
<td colspan=2 align=middle class=es02><font color=ffffff><b>帳單基本資料</b></font></td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>機構名稱</td>
<td class=es02>
    <%=e.getPaySystemCompanyName()%>
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>機構地址</td>
<td class=es02>
    <%=e.getPaySystemCompanyAddress()%>
    <input type=hidden name="cAddress" size=30 value="<%=e.getPaySystemCompanyAddress()%>">
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>機構電話</td>
<td class=es02><%=e.getPaySystemCompanyPhone()%><input type=hidden name="cPhone" value="<%=e.getPaySystemCompanyPhone()%>"></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>每月繳款截止日</td>
    <td><input type=text name="limitDate" value="<%=e.getPaySystemLimitDate()%>" size=3> （顯示於帳單上的期限）
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>便利商店寬限天數</td><td class=es02> 每月繳款截止日 + <input type=text name="showlimitDate" value="<%=e.getPaySystemBeforeLimitDate()%>" size=3> 天</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>每張繳款單金額上限</td><td class=es02><%=e.getPaySystemLimitMoney()%> 元</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>統一編號</td><td class=es02>
    <%=e.getPaySystemCompanyUniteId()%></td>
</tr>
<% 

SalaryAdmin sa=SalaryAdmin.getInstance();
BankAccount[] ba=sa.getAllBankAccount(_ws.getBunitSpace("bunitId")); 

if(ba==null)
{ 
	out.println("<b>尚未登入銀行資料</b>");
 
 
%>
	<br>
	<a href="salaryBankAccount.jsp">新增銀行帳戶</a>
	<br>
    <%@ include file="bottom.jsp"%>
    
<%	
	return;
} 

%>
<tr bgcolor=4A7DBD class=es02>
<td colspan=2 align=middle class=es02><font color=ffffff><b>收款方式設定</b></font></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>便利商店繳款</td><td class=es02>
    <%
     if(e.getPaySystemStoreActive()!=9)
     {
     %>   
        <%=(e.getPaySystemStoreActive()==1)?"<font color=blue>使用中</font>":"<font color=red>停用</font>"%>
        <input type="hidden" name="paySystemStoreActive" value="<%=e.getPaySystemStoreActive()%>">
	 <%
     }
     else{
     %>
        系統尚未開啟
        <input type="hidden" name="paySystemStoreActive" value="9">
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
            系統尚未開啟 
            <input type="hidden" name="paySystemATMActive" value=9>            
    <%
        }
        else {
            if (e.getPaySystemATMActive()==3)
                out.println("固定虛擬轉帳(約定帳號)");
            else if (e.getPaySystemATMActive()==1)
                out.println("浮動虛擬轉帳(每張單子不同號碼)");
            else if (e.getPaySystemATMActive()==2)
                out.println("指定帳戶轉帳");
            else 
                out.println("無(僅顯示貼心叮嚀)");
    %>
           <input type="hidden" name="paySystemATMActive" value="<%=e.getPaySystemATMActive()%>"> 
    <%
        }
    %>

</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>收款銀行帳戶</td>
<td class=es02> 
    <%
        if(e.getPaySystemBankAccountId()==0)
        {
            out.println("系統尚未開啟");
        }else{
            BankAccountMgr bam=BankAccountMgr.getInstance();
        
            BankAccount ba2=(BankAccount)bam.find(e.getPaySystemBankAccountId());
            
            if(ba2 !=null)
                out.println("<font color=blue>"+ba2.getBankAccountName()+"</font>");
        }
    %>
    <br>
	<font color=red>*</font>本帳戶為便利商店代收及虛擬帳號的合作銀行帳戶
	
</td>
</tr>

<!--
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>合併前期未繳的帳單</td>
<td class=es02> 
		<input type=radio name="paySystemExtendNotpay" value="2" <%=(e.getPaySystemExtendNotpay()==2)?"checked":""%>>判斷是否超過繳費期限
    	<input type=radio name="paySystemExtendNotpay" value="1" <%=(e.getPaySystemExtendNotpay()==1)?"checked":""%>>全部合併
        <input type=radio name="paySystemExtendNotpay" value="0" <%=(e.getPaySystemExtendNotpay()==0)?"checked":""%>>全部不合併
</td>
</tr>
-->
<input type=hidden name="paySystemExtendNotpay" value="<%=e.getPaySystemExtendNotpay()%>">

<tr bgcolor=4A7DBD class=es02>
<td colspan=2 align=middle class=es02><font color=ffffff><b>便利商店繳款設定</b></font></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>銀行代號</td><td class=es02>
        <font color=blue><%=(e.getPaySystemBankStoreNickName().length()<=0)?"尚未設定":e.getPaySystemBankStoreNickName()%></font>
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>銀行授權碼</td><td class=es02>
        <font color=blue><%=(e.getPaySystemCompanyStoreNickName().length()<=0)?"尚未設定":e.getPaySystemCompanyStoreNickName()%></font><br>
	    <FONT COLOR=RED>*</FONT>說明:此為銀行合約書所給予的代碼
</tr>


<tr bgcolor=4A7DBD class=es02>
<td colspan=2 align=middle class=es02><font color=ffffff><b>虛擬帳號設定</b></font></td>
</tr>
 

 <tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>帳單顯示銀行名稱</td><td>
        <font color=blue><%=e.getPaySystemBankName()%></font></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>銀行代號</td>
    <td>    
    <font color=blue><%=e.getPaySystemBankId()%></font>
</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
    <td bgcolor=#f0f0f0 class=es02>虛擬帳號授權前五碼</td>
    <td class=es02>
        <font color=blue><%=(e.getPaySystemFirst5().length()<=0)?"尚未設定":e.getPaySystemFirst5()%></font>
        <BR>
        
	    <FONT COLOR=RED>*</FONT>說明:此為銀行合約書所給予的號碼
</td>
</tr>
 

<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>固定虛擬帳號</td>
	<td class=es02>
		固定碼:<font color=blue><%=e.getPaySystemFixATMAccount()%></font> <input type=hidden name="paySystemFixATMAccount" value="<%=(e.getPaySystemFixATMAccount()==null)?"":e.getPaySystemFixATMAccount()%>">
		固定碼後位數: <font color=blue><%=e.getPaySystemFixATMNum()%></font><input type=hidden name="paySystemFixATMNum" value="<%=e.getPaySystemFixATMNum()%>"> <br>
		固定虛擬帳號產生方式為:  帳號前五碼 +  固定碼  + 學生ID (不足的位數自動向左補0)
</td>
</tr>

<input type=hidden name="paySystemATMAccountId" value="<%=e.getPaySystemATMAccountId()%>">
<!--
<tr align=left valign=middle>
<td align=middle class=es02 colspan=2><b>其他繳費方式設定</b></td>
</tr>

<input type=hidden name="paySystemATMAccountId" value="<%=e.getPaySystemATMAccountId()%>">
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>指定轉帳帳號</td>
<td class=es02>
	<%
		BankAccount[] baATM=sa.getATMBankAccount();
		
		if(baATM==null)
 
		{ 
	%>
				尚未設定可ATM轉入的帳戶!
		<br>
	  	<a href="salaryBankAccount.jsp"><img src="pic/fix.gif" border=0>前往設定銀行帳戶</a>
		<input type=hidden name="paySystemATMAccountId" value="0">
	<%					
		}else{ 
	%>
			<select name="paySystemATMAccountId" size=1>	
				<option value="0" <%=(e.getPaySystemATMAccountId()==0)?"selected":""%>>未定</option>	
 
				<%
					for(int i=0;i<baATM.length;i++)
 
					{ 
				%>
					<option value="<%=baATM[i].getId()%>"  <%=(e.getPaySystemATMAccountId()==baATM[i].getId())?"selected":""%>><%=baATM[i].getBankAccountName()%></option>				
				<%
					}
				%>
			</select>
	<%
		}
	%>
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>貼心叮嚀文案</td>
<td>
<textarea rows=4 cols=30 name="paySystemReplaceWord">
<%=(e.getPaySystemReplaceWord()==null)?"":e.getPaySystemReplaceWord()%></textarea>
</td>
</tr>
-->
<input type=hidden name="paySystemReplaceWord" value="">

<tr bgcolor=4A7DBD class=es02>
<td colspan=2 align=middle class=es02><font color=ffffff><b>帳單生日祝福</b></font></td>
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
 YYY=學生姓名    <br>ex: YYY寶貝於XXX要生日囉,祝你生日快樂!

</td>
</tr>

<tr bgcolor=4A7DBD class=es02>
<td colspan=2 align=middle class=es02><font color=ffffff><b>學費繳款確認簡訊設定</b></font></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>使用狀態</td><td class=es02>
    <%
    if(e.getPaySystemMessageActive()==9)
    {
    %>
        <font color=blue>系統尚未開啟</font>
        <input type="hidden" name="paySystemMessageActive" value="9">
    <%
    }else{
    %>
	<input type=radio name="paySystemMessageActive" value="1" <%=(e.getPaySystemMessageActive()==1)?"checked":""%>>使用中
	<input type=radio name="paySystemMessageActive" value="0" <%=(e.getPaySystemMessageActive()==0)?"checked":""%>>停用
    <%
    }
    %>
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>發送對象</td>
<td class=es02>
<input type=radio name="paySystemMessageTo" value="0" <%=(e.getPaySystemMessageTo()==0)?"checked":""%>>預設聯絡人
<input type=radio name="paySystemMessageTo" value="1" <%=(e.getPaySystemMessageTo()==1)?"checked":""%>>父母皆發送
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>發送簡訊內容</td><td class=es02>
 
<textarea name="paySystemMessageText" cols=40 rows=4><%=(e.getPaySystemMessageText()!=null)?e.getPaySystemMessageText():""%></textarea>
<br>1 實際簡訊發送文字總數為取代代碼後之字數，合計超過70個中文字(140個英文字),將自動傳送為第二則簡訊。 
<br>2 代碼規則：XXX=學童姓名, YYY=繳款日期, ZZZ=繳款方式, MMM=繳款金額, FFF=銷單名稱.<br>
3.<b>範例:</b> 親愛的XXX家長:我們已收到你於YYY使用ZZZ繳交學費<br>MMM元(FFF),謝謝. 啟

</td>
</tr>

<input type=hidden name="paySystemEmailActive" value="0">
<input type=hidden name="paySystemEmailTo" value="0">
<input type=hidden name="paySystemEmailText" value="">
<!--
<tr align=left valign=middle>
<td colspan=2 class=es02 align=middle><b>收款確認Email設定</b></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>使用狀態</td><td>
	<input type=radio name="paySystemEmailActive" value="1" <%=(e.getPaySystemEmailActive()==1)?"checked":""%>>使用中
	<input type=radio name="paySystemEmailActive" value="0" <%=(e.getPaySystemEmailActive()==0)?"checked":""%>>停用
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>發送對象</td>
<td>
<input type=radio name="paySystemEmailTo" value="0" <%=(e.getPaySystemEmailTo()==0)?"checked":""%>>預設聯絡人
<input type=radio name="paySystemEmailTo" value="1" <%=(e.getPaySystemEmailTo()==1)?"checked":""%>>父母皆發送

</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>發送Email內容</td><td class=es02>
 
<textarea name="paySystemEmailText" cols=40 rows=4><%=(e.getPaySystemEmailText()!=null)?e.getPaySystemEmailText():""%></textarea>
<br>
說明:  
1  以 XXX=學童姓名  YYY=繳款日期 ZZZ=繳款方式 MMM=繳款金額 FFF=帳單編號<br>
2.<b>範例:</b> 親愛的XXX家長:我們已收到你於YYY使用ZZZ繳交學費<br>MMM元(FFF),謝謝. 啟
</td>
</tr>
-->

<tr bgcolor=#ffffff align=left valign=middle>
<td colspan=2 bgcolor=#f0f0f0 class=es02><center><input type=submit value="修改"></center></td>
</tr>
 

</form>
</table>

</td></tr></table>
</blockquote>

<%
	if(m !=null)
	{
%>
	<script>
		alert('修改完成!');
	</script>		
<%	
	}
%>

<%@ include file="bottom.jsp"%>