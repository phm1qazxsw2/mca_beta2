<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu7.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,1))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
	String m=request.getParameter("m");
	PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem e=(PaySystem)em.find(1);
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

function doCheck(f)
{
    if (!IsNumeric(f.limitDate.value)) {
        alert("每月繳款截止日 不是正確的數字");
        f.limitDate.focus();
        return false;
    }
    if (!IsNumeric(f.showlimitDate.value)) {
        alert("顯示寬限前天數 不是正確的數字");
        f.showlimitDate.focus();
        return false;
    }
    if (!IsNumeric(f.limitNumber.value)) {
        alert("每張繳款單上限 不是正確的數字");
        f.limitNumber.focus();
        return false;
    }
    if (!IsNumeric(f.paySystemFixATMNum.value)) {
        alert("固定碼後位數 不是正確的數字");
        f.paySystemFixATMNum.focus();
        return false;
    }

    var address = f.cAddress.value;
    var len = 0;
    for (var i=0; i<address.length; i++) {
        var c = address.charAt(i);
        if (c>'z') len += 2;
        else len += 1;
    }
    if (len>32) {
        alert("地址太長帳單印不下,英文算一單位，中文兩單位，總長不可超過32單位");
        f.cAddress.focus();
        return false;
    }
    return true;
}

</script>
<br>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>繳款資訊設定</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
<br>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<form action="modifyPaySystem2.jsp" method="post" onsubmit="return doCheck(this);">
<tr align=left valign=middle>
<td colspan=2 align=middle class=es02><b>帳單基本資料</b></td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>機構名稱</td>
<td><input type=text name="cName" value="<%=e.getPaySystemCompanyName()%>"></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>機構地址</td><td><input type=text name="cAddress" size=30 value="<%=e.getPaySystemCompanyAddress()%>"></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>機構電話</td><td><input type=text name="cPhone" value="<%=e.getPaySystemCompanyPhone()%>"></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>每月繳款截止日</td><td><input type=text name="limitDate" value="<%=e.getPaySystemLimitDate()%>" size=5></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>顯示寬限前天數</td><td><input type=text name="showlimitDate" value="<%=e.getPaySystemBeforeLimitDate()%>" size=5></td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>每張繳款單上限</td><td><input type=text name="limitNumber" value="<%=e.getPaySystemLimitMoney()%>"></td>
</tr>



<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>統一編號</td><td><input type=text name="uniteId" value="<%=e.getPaySystemCompanyUniteId()%>"></td>
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
<%	
	return;
} 

%>

<tr>
<td colspan=2 align=middle class=es02><b>收款方式設定</b></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>便利商店繳款</td><td class=es02> 
		
        <input type=radio name="paySystemStoreActive" value="9" <%=(e.getPaySystemStoreActive()==9)?"checked":""%>>尚未開啟
        <input type=radio name="paySystemStoreActive" value="1" <%=(e.getPaySystemStoreActive()==1)?"checked":""%>>使用中
		<input type=radio name="paySystemStoreActive" value="0" <%=(e.getPaySystemStoreActive()==0)?"checked":""%>>停用
	</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>其他繳費方式</td><td class=es02>
<input type=radio name="paySystemATMActive" value="9" <%=(e.getPaySystemATMActive()==9)?"checked":""%>>(9)尚未開啟
<br><input type=radio name="paySystemATMActive" value="3" <%=(e.getPaySystemATMActive()==3)?"checked":""%>>(3)固定虛擬轉帳 [五碼 + 固定碼(4) + 學生ID(4) + 檢核碼(1), 可約定轉帳,建議]
<br><input type=radio name="paySystemATMActive" value="1" <%=(e.getPaySystemATMActive()==1)?"checked":""%>>(1)浮動虛擬轉帳[五碼 + 帳單號碼(8) + 檢核碼(1), <b>聯邦D類只能選這個</b>)
<br><input type=radio name="paySystemATMActive" value="2" <%=(e.getPaySystemATMActive()==2)?"checked":""%>>(2)指定帳戶轉帳
<br><input type=radio name="paySystemATMActive" value="0" <%=(e.getPaySystemATMActive()==0)?"checked":""%>>(0)無(僅顯示貼心叮嚀
)
</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>收款銀行</td>
<td class=es02> 
	<select size=1 name="bankAccountId"> 
		<option value="0" <%=(e.getPaySystemBankAccountId()==0)?"selected":""%>>未定</option>
	<% 
		
	
		for(int i=0;i<ba.length;i++)
		{ 
	 %> 
	  		<option value="<%=ba[i].getId()%>" <%=(e.getPaySystemBankAccountId()==ba[i].getId())?"selected":""%>><%=ba[i].getBankAccountName()%></option> 
	  		
	 <% 
		}
	%>
	</select>	
	<br><br>
	說明:<font color=red>*</font>本帳戶指便利商店代收及虛擬帳號的合作銀行帳戶
	
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>合併前期未繳的帳單</td>
<td class=es02> 
		<input type=radio name="paySystemExtendNotpay" value="2" <%=(e.getPaySystemExtendNotpay()==2)?"checked":""%>>判斷是否超過繳費期限
		<input type=radio name="paySystemExtendNotpay" value="1" <%=(e.getPaySystemExtendNotpay()==1)?"checked":""%>>全部合併
        <input type=radio name="paySystemExtendNotpay" value="0" <%=(e.getPaySystemExtendNotpay()==0)?"checked":""%>>全部不合併
</td>
</tr>


<tr align=left valign=middle>
<td align=middle class=es02 colspan=2><b>便利商店繳款設定</b></td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>
    <font color=red>*</font>合作代收銀行</td>
    <td class=es02>
        <select name=banktype>
            <option value=1 <%=(e.getBanktype()==1)?"selected":""%>>台新銀行</option>
            <option value=2 <%=(e.getBanktype()==2)?"selected":""%>>聯邦銀行C類(<80000,檢核不加金額)</option>
            <option value=3 <%=(e.getBanktype()==3)?"selected":""%>>聯邦銀行D類(>80000,檢核加金額)</option>
        </select>
        不同的銀行,條碼及虛擬帳號會有不同的編碼方式
    </td>   
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
    <td bgcolor=#f0f0f0 class=es02><font color=red>*</font>銀行代號(3碼)</td>
    <td class=es02>
    <input type=text name="BankStoreNickName" value="<%=e.getPaySystemBankStoreNickName()%>" size=5>
     台新學費代收: <font color=blue>669</font>   聯邦學費代收: <font color=blue>626</font>  聯邦一般代收:<font color=blue>62F</font></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
    <td bgcolor=#f0f0f0 class=es02><font color=red>*</font>銀行授權碼</td>
    <td class=es02>
    <input type=text name="CompanyStoreNickName" value="<%=e.getPaySystemCompanyStoreNickName()%>" size=8>台新為3~6碼 ex: <font color=blue>JSM or PHM001</font>  聯邦為7碼數字 ex: <font color=blue>3387100</font></td>
</tr>


<tr valign=middle>
	<td colspan=2 align=middle class=es02><b>虛擬帳號設定</b></td>
</tr> 

 <tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>帳單顯示銀行名稱</td><td><input type=text name="bankName" value="<%=e.getPaySystemBankName()%>"></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>轉帳額外說明</td><td><input type=text name="extraBankInfo" value="<%=(e.getExtraBankInfo()==null)?"":e.getExtraBankInfo()%>" size=30> ex:戶名:臺北市XXXX幼稚園 分行:建北分行</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>銀行代號</td>
<td class=es02>
    <input type=text name="bankId" value="<%=e.getPaySystemBankId()%>" size=4>
	 台新國際商業銀行:<font color=blue>812</font>
 聯邦商業銀行:<font color=blue>803</font> </td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>帳號前五碼</td><td class=es02><input type=text name="first5code" value="<%=e.getPaySystemFirst5()%>" size=5>
	說明:此為銀行合約書所給予的號碼
</td>
</tr> 

<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>固定虛擬帳號</td>
	<td class=es02>
		固定碼<input type=text name="paySystemFixATMAccount" value="<%=(e.getPaySystemFixATMAccount()==null)?"":e.getPaySystemFixATMAccount()%>" size=5>建議4個數字 Ex:<font color=blue>8888</font>
		固定碼後位數<input type=text name="paySystemFixATMNum" value="<%=e.getPaySystemFixATMNum()%>" size=2>(建議:<font color=blue>4</font> 依銀行設定為準<br>
		固定虛擬帳號產生方式為:  帳號前五碼 +  固定碼(4)  + 學生ID(4) (不足的位數自動向左補0)
 + 檢核碼(1)		
</td>
</tr>


<tr align=left valign=middle>
<td align=middle class=es02 colspan=2><b>其他繳費方式設定</b></td>
</tr>

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


<tr align=left valign=middle>
<td align=middle class=es02 colspan=2><b>帳單生日祝福</b></td>
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
	<textarea rows=2 cols=60 name="paySystemBirthWord"><%=(e.getPaySystemBirthWord()!=null)?e.getPaySystemBirthWord():""%></textarea> 
	<br>說明: XXX=生日日期 YYY=學生姓名    <br>ex: YYY寶貝於XXX要生日囉,祝你生日快樂!

</td>
</tr>

<tr align=left valign=middle>
<td colspan=2 class=es02 align=middle><b>學費繳款確認簡訊設定</b></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>使用狀態</td><td>
    <input type=radio name="paySystemMessageActive" value="9" <%=(e.getPaySystemMessageActive()==9)?"checked":""%>>尚未開啟
	<input type=radio name="paySystemMessageActive" value="1" <%=(e.getPaySystemMessageActive()==1)?"checked":""%>>使用中
	<input type=radio name="paySystemMessageActive" value="0" <%=(e.getPaySystemMessageActive()==0)?"checked":""%>>停用
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>發送對象</td>
<td>
<input type=radio name="paySystemMessageTo" value="0" <%=(e.getPaySystemMessageTo()==0)?"checked":""%>>預設聯絡人
<input type=radio name="paySystemMessageTo" value="1" <%=(e.getPaySystemMessageTo()==1)?"checked":""%>>父母皆發送
</td>
</tr>

<!--
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>簡訊網址</td><td>
<input type=text name="paySystemMessageURL" value="<%=(e.getPaySystemMessageURL()!=null)?e.getPaySystemMessageURL():""%>" size=50>
<br>ex:http://api.bizmm.com/SendSMS.php
</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>帳號</td><td>
<input type=text name="paySystemMessageUser" value="<%=(e.getPaySystemMessageUser()!=null)?e.getPaySystemMessageUser():""%>" size=20></td>
</tr> 
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02><font color=red>*</font>密碼</td><td>
<input type=text name="paySystemMessagePass" value="<%=(e.getPaySystemMessagePass()!=null)?e.getPaySystemMessagePass():""%>" size=20></td>
</tr> 
-->
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>發送簡訊內容</td><td class=es02> 
<textarea name="paySystemMessageText" cols=40 rows=4><%=(e.getPaySystemMessageText()!=null)?e.getPaySystemMessageText():""%></textarea>
<br>
說明: <br>
1 字數盡量精簡，一通簡訊可容70個中文字,超過會拆成兩通 <br>
2 XXX=學童姓名,YYY=繳款日期,ZZZ=繳款方式,MMM=繳款金額,FFF=銷單內容 <br>

3.<b>範例:</b> 親愛的XXX家長:我們已收到你於YYY使用ZZZ繳交學費MMM元(FFF),謝謝<br> 
&lt;您的機構名稱&gt;啟

</td>
</tr>


<tr align=left valign=middle>
<td colspan=2 class=es02 align=middle><b>收款確認Email設定</b></td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>使用狀態</td><td class=es02>
	<input type=radio name="paySystemEmailActive" value="1" <%=(e.getPaySystemEmailActive()==1)?"checked":""%>>使用中
	<input type=radio name="paySystemEmailActive" value="0" <%=(e.getPaySystemEmailActive()==0)?"checked":""%>>停用
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>發送對象</td>
<td class=es02>
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


<tr align=left valign=middle>
<td colspan=2 class=es02 align=middle><b>Logo設定 (管理員 only)</b></td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>topLogoHtml</td><td class=es02>
 <textarea name="topLogoHtml" cols=40 rows=4><%=(e.getTopLogoHtml()!=null)?e.getTopLogoHtml():""%></textarea>
</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>billLogoPath</td><td>
	<input type=text name="billLogoPath" value="<%=(e.getBillLogoPath()!=null)?e.getBillLogoPath():""%>" size=40>
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>billWaterMarkPath</td><td>
	<input type=text name="billWaterMarkPath" value="<%=(e.getBillWaterMarkPath()!=null)?e.getBillWaterMarkPath():""%>" size=40>
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>website</td><td>
	<input type=text name="website" value="<%=(e.getWebsite()!=null)?e.getWebsite():""%>" size=40>
</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>useChecksum</td><td>
	<input type=radio name="useChecksum" value="1" <%=(e.getUseChecksum()==1)?"checked":""%>> Yes <br>
	<input type=radio name="useChecksum" value="0" <%=(e.getUseChecksum()==0)?"checked":""%>> No
</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>版本</td><td class=es02>
	<input type=radio name="version" value="0" <%=(e.getVersion()==0)?"checked":""%>> 標準版 <br>
	<input type=radio name="version" value="1" <%=(e.getVersion()==1)?"checked":""%>> 專業版
</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>客戶類別</td><td class=es02>
	<input type=radio name="customerType" value="0" <%=(e.getCustomerType()==0)?"checked":""%>> 學校 <br>
	<input type=radio name="customerType" value="1" <%=(e.getCustomerType()==1)?"checked":""%>> 公司
</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>帳單套印類型</td><td class=es02>
	<input type=radio name="pagetype" value="0" <%=(e.getPagetype()==0)?"checked":""%>> 原味 <br>
	<input type=radio name="pagetype" value="1" <%=(e.getPagetype()==1)?"checked":""%>> 光仁集團 KJF <br>
	<input type=radio name="pagetype" value="2" <%=(e.getPagetype()==2)?"checked":""%>> 傳統三聯式 <br>
	<input type=radio name="pagetype" value="3" <%=(e.getPagetype()==3)?"checked":""%>> 有廣告2的帳單<br>
	<input type=radio name="pagetype" value="4" <%=(e.getPagetype()==4)?"checked":""%>> 牛耳的商業帳單<br>
	<input type=radio name="pagetype" value="5" <%=(e.getPagetype()==5)?"checked":""%>> 道禾的1/3帳單<br>
	<input type=radio name="pagetype" value="6" <%=(e.getPagetype()==6)?"checked":""%>> 通泉草不要印櫃臺繳款<br>
	<input type=radio name="pagetype" value="7" <%=(e.getPagetype()==7)?"checked":""%>> 馬禮遜帳單收據
</td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>特殊的 workflow<br>(一定要 2 的次方)</td><td class=es02>
	<input type=radio name="workflow" value="0" <%=(e.getWorkflow()==0)?"checked":""%>> 正常 <br>
	<input type=radio name="workflow" value="1" <%=(e.getWorkflow()==1)?"checked":""%>> 須先 email 信用卡銷帳檔才能印帳單 <br>
	<input type=radio name="workflow" value="2" <%=(e.getWorkflow()==2)?"checked":""%>> 派遣登記時數(enable老師登入和指定開單客戶)<br>
	<input type=radio name="workflow" value="4" <%=(e.getWorkflow()==4)?"checked":""%>> 支票不管兌現用傳票來做<br>
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>考勤系統</td><td class=es02>
    <input type=radio name="eventAuto" value="1" <%=(e.getEventAuto()==1)?"checked":""%>>使用中
    <input type=radio name="eventAuto" value="0" <%=(e.getEventAuto()==0)?"checked":""%>>停用      
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>感應卡設定</td><td class=es02>
	<input type=radio name="cardread" value="0" <%=(e.getCardread()==0)?"checked":""%>> 停用<br>
	<input type=radio name="cardread" value="1" <%=(e.getCardread()==1)?"checked":""%>> 使用中<br>
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>感應卡機器代號</td><td class=es02>
    <input type=text name="cardmachine" value="<%=(e.getCardmachine()!=null)?e.getCardmachine():""%>" size=20>
    <br>
    如為多台機器,請以 # 號區隔 ex: 21#22#101
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
    <td bgcolor=#f0f0f0 class=es02>客服系統</td><td class=es02>
        <input type=radio name="membrService" value="1" <%=(e.getMembrService()==1)?"checked":""%>>使用中
        <input type=radio name="membrService" value="0" <%=(e.getMembrService()==0)?"checked":""%>>停用      
    </td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td colspan=2 bgcolor=#f0f0f0 class=es02><center><input type=submit value="修改"></center></td>
</tr> 

</form>
</table>

</td></tr></table>
<font color=red>*</font>為系統管理員代設的項目.
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