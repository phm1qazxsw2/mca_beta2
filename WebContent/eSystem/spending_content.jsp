<script src="js/formcheck.js"></script>
<script src="js/string.js"></script>
<script src="mca_acode_data.jsp?<%=cond%>"></script>
<%!
    static SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    public String getAvailableAccounts(User user)
    {
        JsfPay jp=JsfPay.getInstance();
    	Tradeaccount[] tradeAccts = jp.getActiveTradeaccount(user.getId());
        SalarybankAuth[] bankAuths = jp.getSalarybankAuthByUserId(user); 
        BankAccountMgr bamgr = BankAccountMgr.getInstance();
        if (tradeAccts==null && bankAuths==null) {
            return "沒有任何可以收付款的帳戶";
        }
        StringBuffer sb = new StringBuffer();
        sb.append("<select name='acct' onchange=\"check_cheque(this)\">");
        sb.append("<option value=''>--請選擇一收款帳戶--");
        for (int i=0; tradeAccts!=null && i<tradeAccts.length; i++) {
            if(tradeAccts[i] !=null){
                sb.append("<option value='1,"+tradeAccts[i].getId()+"'>臺幣現金－" + tradeAccts[i].getTradeaccountName());
                sb.append("<option value='3,"+tradeAccts[i].getId()+"'>臺幣支票－" + tradeAccts[i].getTradeaccountName());
                sb.append("<option value='4,"+tradeAccts[i].getId()+"'>USD Cash－" + tradeAccts[i].getTradeaccountName());
                sb.append("<option value='5,"+tradeAccts[i].getId()+"'>USD Check－" + tradeAccts[i].getTradeaccountName());
            }
        }
        for (int i=0; bankAuths!=null && i<bankAuths.length; i++) {
            BankAccount bank = (BankAccount) bamgr.find(bankAuths[i].getSalarybankAuthId());
            if(bank !=null)            
                sb.append("<option value='2,"+bank.getId()+"'>匯款－" + bank.getBankAccountName());
        }

        sb.append("</select>");

        sb.append("<div id=\"chequeinfo\" style=\"visibility:hidden\">");
        sb.append("    Check Info:");
        sb.append("    <input type=text name=\"checkInfo\" value=\"\" size=20>");
        sb.append("</div>");

        return sb.toString();
    }
%>
<% // ######## 以下這一堆 is for 會計科目 ###### %>
<link rel="stylesheet" href="css/auto_complete.css" type="text/css">
<script type="text/javascript" src="js/dateformat.js"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/auto_complete.js"></script>
<script type="text/javascript" src="js/string.js"></script>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<% // ####################################################### %>

<script src="js/formcheck.js"></script>
<script>
function check_cheque(s)
{
    var v = s.options[s.selectedIndex].value.charAt(0);
    if (v=='3' || v=='5')
        document.getElementById('chequeinfo').style.visibility= 'visible';
    else 
        document.getElementById('chequeinfo').style.visibility= 'hidden';
}

function check(f)
{
    var a = f.acct;
    if (typeof a=='undefined') {
        alert("沒有可收付的帳戶");
        return false;
    }
    if (a.selectedIndex==0) {
        alert("請選擇一帳戶轉出");
        return false;
    }
    var v = f.amount.value;
    if (document.getElementById('chequeinfo').style.visibility=='visible') {
        if (f.chequeId.value.length==0) {
            alert("請輸入支票號碼");
            f.chequeId.focus();
            return false;
        }
    }
    if (typeof f.cashDate!='undefined') {
        if (!checkDate(f.cashDate.value, '/')) {
            alert("請輸入正確的兌現日期的格式");
            f.checkDate.focus();
            return false;
        }
    }
    return true;
}
</script>

<script>

    function setCode(acctcode) {
        document.xs.acctcode.value = acctcode;
        document.xs.acctcode.onblur();
    }

    function find_acctcode()
    {
        if (typeof parent.acctcodewin!='undefined' && !parent.acctcodewin.isClosed)
            parent.acctcodewin.show();
        else
            openwindow_phm2('mca_acode_tree_find.jsp?<%=cond%>','尋找會計科目',650,600,'acctcodewin');
    }

    function checkForm(){
        if(document.xs.recordTime.value.length >10 || document.xs.recordTime.value.length<8)
        {
            alert('請填入正確的入帳日期');
            document.xs.recordTime.focus();
            return false;
        }

        if(document.xs.acctcode.value.length < 4)
        {
            alert('請填入正確的會計科目');
            document.xs.acctcode.focus();
            return false;
        }

        if(document.xs.title.value.length <=0)
        {
            alert('請填入摘要內容');
            document.xs.title.focus();
            return false;
        }

        if (trim(document.xs.payerName.value)==0) {
            alert("請填入正確的收據抬頭(Payer Name)");
            document.xs.payerName.focus();
            return false;
        }

        var a = document.xs.acct;
        if (typeof a=='undefined') {
            alert("沒有可收付的帳戶");
            return false;
        }
        if (a.selectedIndex==0) {
            alert("請選擇一帳戶轉出");
            return false;
        }

        if(!IsNumeric(document.xs.total.value))
        {
            alert('請填入正確的金額');
            document.xs.total.focus();
            return false;
        }

        var ainfo = a.options[a.selectedIndex].value;
        var atype = eval(ainfo.split(',')[0]);
        if (document.xs.total.value.indexOf(".")>0 && (atype==1 || atype==3)) {
            alert("臺幣不可有小數點");
            return false;
        }
        var cc = document.xs.total.value.indexOf('.');
        if (cc>=0 && (document.xs.total.value.length-cc)>3) {
            alert("請輸入正確的美金金額, 小數點最多兩位");
            document.xs.total.focus();
            return false;
        }


        var hascheck = false;
        var at = document.xs.attachtype;
        for (var i=0; i<at.length; i++) {
            if (at[i].checked) {
                hascheck = true;
                break;
            }
        }
        if (!hascheck) {
            alert('請選擇收據類型');
            at[0].focus();
            return false;
        }

        return true;
    }

    function setAttachtype(atype)
    {
        document.xs.attachtype[atype].checked = true;
    }

</script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<blockquote>
<form method=post name="xs" id="xs"  onsubmit="return(checkForm())">
<table width="500" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td nowrap>入帳日期：</td>
        <td bgcolor=#ffffff colspan=2>
            <input type=text name="recordTime" size=10 value="<%=sdf.format(new Date())%>">
            <span id="timepopup">
            &nbsp;&nbsp;&nbsp;<a href="#" onclick="displayCalendar(document.xs.recordTime,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
            </span>
        </td>
    </tr>        
	<tr bgcolor=#f0f0f0 class=es02>
        <td height=40 nowrap>會計科目:</td>
        <td bgcolor=#ffffff colspan=2 nowrap>
            <div style="position:relative;overflow:visible;">
                <input type=text id="acctcode" name="acctcode" size=7 autocomplete=off>
                <div id="codetip" style="position:absolute;left:0px;top:21px;visibility:hidden;border:solid green 2px;background-color:white;z-index:1"></div>
                <span onclick="find_acctcode()"><img src="pic/mirror.png" width=10></span>
                <span id="acodename"></span>
            </div>
        </td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>摘要:</td>
        <td bgcolor=#ffffff colspan=2>
            <input type=text name="title" size=80>
        </td>
    </tr>

	<tr bgcolor=#f0f0f0 class=es02>
        <td>抬頭:</td>
        <td bgcolor=#ffffff colspan=2>
            <input type=text name="payerName" size=80>
        </td>
    </tr>

	<tr bgcolor=#f0f0f0 class=es02>
        <td>收款帳戶:</td>
        <td bgcolor=#ffffff colspan=2>
            <%=getAvailableAccounts(ud2)%>
        </td>
    </tr>


	<tr bgcolor=#f0f0f0 class=es02>
        <td>金額:</td>
        <td bgcolor=#ffffff colspan=2>
            <input type=text name="total" size=7>
        </td>
    </tr>

	<tr bgcolor=#f0f0f0 class=es02>
        <td nowrap>種類:</td>
        <td bgcolor=#ffffff colspan=2>
            <input type=radio name="attachtype" value=1>一般收據
            <input type=radio name="attachtype" value=2>捐贈
        </td>
    </tr>
<!--
	<tr bgcolor=#f0f0f0 class=es02 height=40>
        <td>廠商:
            <br>

        </tD>
        <td bgcolor=#ffffff colspan=2>
        <%@ include file="setup_costtrade.jsp"%>
      </td>
    </tr>
-->
	<tr bgcolor=#f0f0f0 class=es02>
        <td>備註:
            <br>
        </tD>
        <td bgcolor=#ffffff colspan=2>
            <textarea name=note rows=3 cols=40></textarea>
        </td>
    </tR>
    <input type="hidden" name="type" value="<%=tp%>">
    <tr class=es02>
        <td colspan=3 align=middle id="buttons">
        </td>
    </tr>
    </table>
    </tD>
    </tR>
    </table>
</form>
</blockquote>

<script>
    // ### 新會計科目 #####
    function ajax_get_name()
    {
        var code = document.xs.acctcode.value;
        var url = "mca_acode_getname.jsp?code=" + encodeURI(code) + "&r="+(new Date()).getTime();
        var req = new XMLHttpRequest();

        if (req) 
        {
            req.onreadystatechange = function() 
            {
                if (req.readyState == 4 && req.status == 200) 
                {
                    var t = req.responseText.indexOf("@@");
                    if (t>0)
                        alert(req.responseText.substring(t+2));
                    else {
                        var d = document.getElementById("acodename");
                        var name = req.responseText;
                        d.innerHTML = name;
                        document.xs.title.value = trim(name);
                    }                        
                }
                else if (req.readyState == 4 && req.status == 500) {
                    alert("查詢服務器時發生錯誤");
                    return;
                }
            }
        };
        req.open('GET', url);
        req.send(null);
    }

    new AutoComplete(aNames, 
        document.getElementById('acctcode'), 
        document.getElementById('codetip'), 
        -1,
        ajax_get_name
    );	    
    // ####################
</script>
