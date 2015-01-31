<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,302))
    {
        response.sendRedirect("authIndex.jsp?code=302");
    }
%>
<%@ include file="leftMenu5.jsp"%>

<%
    //##v2

    String o =  request.getParameter("o");
    String t = request.getParameter("t");
    String via = request.getParameter("via");
    String backurl = request.getParameter("backurl");
System.out.println("#o=" + o + " t=" + t + " via=" + via + " backurl=" + backurl);
    int v = 0;
    if (via!=null)
        v = Integer.parseInt(via);

    System.out.println("####1");
try{

    JsfPay jp=JsfPay.getInstance();
	Tradeaccount[] tradeAccts = jp.getActiveTradeaccount(ud2.getId());
    SalarybankAuth[] bankAuths = jp.getSalarybankAuthByUserId(ud2); 
    BankAccountMgr bamgr = BankAccountMgr.getInstance();
    DecimalFormat mnf = new DecimalFormat("###,###,##0");

    System.out.println("####2");
%>
<link rel="stylesheet" href="css/ajax-tooltip-billsearch.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
<script>
function checkSubmit()
{
    var f = document.f1;
    if (f.via.options[f.via.selectedIndex].value==0) {
        alert("請選擇一支付方式");
        f.via.focus();
        return;
    }
    f.submit();
}

function check_all(c) {
    var target = document.f2.target;
    if (typeof target!='undefined') {
        if (typeof target.length=='undefined')
            target.checked = c.checked;
        else {
            for (var i=0; i<target.length; i++) {
                target[i].checked = c.checked;
            }
        }
    }
    show_subtotal();
}
function calc_subtotal()
{
    var subtotal = 0;
    var target = document.f2.target;
    if (typeof target!='undefined') {
        if (typeof target.length=='undefined') {
            var n = "amt_" + target.value;
            var v = eval(eval("document.f2." + n + ".value"));
            subtotal += v;
        }
        else {
            for (var i=0; i<target.length; i++) {
                if (target[i].checked) {
                    var n = "amt_" + target[i].value;
                    var v = eval(eval("document.f2." + n + ".value"));
                    subtotal += v;
                }
            }
        }
    }
    return subtotal;
}

function show_subtotal()
{
    var sdiv = document.getElementById("subtotal");
    var num = calc_subtotal();
    sdiv.innerHTML = num;
    document.f2.amount.value = num;
}

function doSubmit(f)
{
    var sum = calc_subtotal();
    if (sum==0) {
        alert("金額為 0");
        return false;
    }
    if (typeof f.acctId=='undefined') {
        alert("沒有可付款的帳戶");
        return false;
    }
    if (f.acctId.options[f.acctId.selectedIndex].value==0) {
        alert("請選擇支付的帳戶");
        f.acctId.focus();
        return false;
    }
    if (f.amount.value!=sum) {
        if (!confirm("輸入的金額["+f.amount.value+"]和勾選的金額總額["+sum+"]不同,確定？"))
            return false;
    }
    return true;
}
</script>

<body onload="show_subtotal();">
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;支付薪資 -- <%=t%></b>
   &nbsp;&nbsp;&nbsp;&nbsp;<a href="<%=backurl%>"><img src="pic/last2.png" border=0> &nbsp;回上一頁</a>
 <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
</div>

<table border=0 width=720>
<tr>
    <td width=20>
        &nbsp;
    </td>
    <td>
        <br>
<form name=f1 action="salary_batchpay.jsp" method="post">
<input type=hidden name="o" value="<%=o%>">
<input type=hidden name="t" value="<%=t%>">
<input type=hidden name="backurl" value="<%=backurl%>">

<table width="700" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
    	<td><font color=blue>*</font><b>1. 請選擇支付方式：</b></td>
        <td bgcolor=ffffff>
        <select name="via" onchange="checkSubmit();">
            <option value="0">--- 請選擇 ---
            <option value="<%=BillPay.SALARY_CASH%>" <%=(v==BillPay.SALARY_CASH)?"selected":""%>>現金
            <option value="<%=BillPay.SALARY_WIRE%>" <%=(v==BillPay.SALARY_WIRE)?"selected":""%>>匯款
            <!--<option value="<%=BillPay.SALARY_CHECK%>" <%=(v==BillPay.SALARY_CHECK)?"selected":""%>>支票 -->
        </select>
        </td>
    </tr>
</form>
   
<%
    if (via==null) {
        return;
    }

    BillRecordMgr bmgr = BillRecordMgr.getInstance();
    String[] pairs = o.split(",");
    HashMap m1 = new HashMap(); // member map
    HashMap m2 = new HashMap(); // billrecord map

    StringBuffer sb1 = new StringBuffer(); // membr ids
    StringBuffer sb2 = new StringBuffer(); // billrecord ids
    for (int i=0; i<pairs.length; i++) {

        String[] tokens = pairs[i].split("#");
        if (m1.get(tokens[0])==null) {
            if (sb1.length()>0) sb1.append(",");
            sb1.append(tokens[0]);
            m1.put(tokens[0], "");
        }

        if (tokens.length>=2 && m2.get(tokens[1])==null) {
            if (sb2.length()>0) sb2.append(",");
            sb2.append(tokens[1]);
            m2.put(tokens[1], "");
        }
    }

    String query = "membrbillrecord.membrId in (" + sb1.toString() + ")"; 

    if(sb2.toString() !=null && sb2.toString().length()>0)
            query+=" and membrbillrecord.billRecordId in (" + sb2.toString() + ")";

    query+=" and billType=" + Bill.TYPE_SALARY +" and privLevel>=" + ud2.getUserRole();

    MembrInfoBillRecordMgr snbrmgr = MembrInfoBillRecordMgr.getInstance();
    ArrayList<MembrInfoBillRecord> records = 
        snbrmgr.retrieveList(query, "");

    if (records.size()==0) {
       out.println("沒有薪資資料");
       return;
    }

    ArrayList<MembrTeacher> payable_teachers = MembrTeacherMgr.getInstance().
        retrieveList("membr.id in (" + sb1.toString() + ")", "");

    Map<Integer,Vector<MembrTeacher>> teacherMap = 
        new SortingMap(payable_teachers).doSort("getMembrId");
    System.out.println("####5");
%>

<form name="f2" action="salary_batchpay2.jsp" onsubmit="return doSubmit(this);">
<tr class=es02 bgcolor=f0f0f0>
    <td>
        <font color=blue>*</font><b>2. 請選擇付款帳戶:</b>
    </td>
    <tD bgcolor=ffffff>

<input type=hidden name="v" value="<%=v%>">
<input type=hidden name="backurl" value="<%=backurl%>">
<% 
    if (v==BillPay.SALARY_CASH) { 
        if (tradeAccts==null) { %>
          您還沒有設定可支付現金的零用金帳戶
<%      } else {    %>
    <select size=1 name="acctId"">
        <option value="0">-- 請選擇轉出的零用金帳戶 -- </option>
<%          for(int i=0; i<tradeAccts.length; i++) { %>
        <option value="<%=tradeAccts[i].getId()%>"><%=tradeAccts[i].getTradeaccountName()%></option> 
<%          } 
        } %>		
    </select><br>
<%  } else { 
        if (bankAuths==null) { %>
          您還沒有設定可管理的銀行帳戶，目前不能選用這種付款方式
<%      } else {    %>
    <select size=1 name="acctId"">
        <option value="0">-- 請選擇轉出的銀行帳戶 -- </option>
<%          for (int i=0; i<bankAuths.length; i++) {
                BankAccount bank = (BankAccount) bamgr.find(bankAuths[i].getSalarybankAuthId()); %>
        <option value="<%=bank.getId()%>"><%=bank.getBankAccountName()%></option>                
<%          } 
        } %>		
    </select><br>
<%  }  %>

        </td>
    </tr>
    <tr class=es02 bgcolor=f0f0f0>
        <td>
            已選取金額小計
        </td>    
        <td bgcolor=ffffff>
            <span id="subtotal"></span></b><br>            
        </td>
    </tr>
    <tr class=es02 bgcolor=f0f0f0>
        <td>本次支付金額</tD>
        <td bgcolor=ffffff>
            <input type=text name="amount" size=7> (若小於勾選金額則依先後次序付款)
        </td>
    </tr>
    </table>
    </td>
    </tr>
    </table>

<br>
<br>
<div class=es02><font color=blue>*</font><b>3. 選擇付款對象</b> &nbsp;(請選取本批支付的對象,<b>灰色無法勾選者為已付清或資料不全</b>)</div> 
<table width="700" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
  
  <table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
        <td bgcolor=#f0f0f0 class=es02 nowrap>	
            姓名 <input type="checkbox" name="checkall" onClick="check_all(this)"> <font color=blue>全選</font>
        </td>
        <td bgcolor=#f0f0f0 class=es02>月份</td>
        <td bgcolor=#f0f0f0 class=es02>狀態</td>
        <td bgcolor=#f0f0f0 class=es02 align=right>應發金額</td>
        <td bgcolor=#f0f0f0 class=es02 align=right>已付金額</td>
        <td bgcolor=#f0f0f0 class=es02 align=right>應付餘額</td>
        <td bgcolor=#f0f0f0 class=es02 align=left>身份證號</td>    
        <td bgcolor=#f0f0f0 class=es02 align=left>銀行代碼</td>
        <td bgcolor=#f0f0f0 class=es02 align=middle>帳號</td>
        <td bgcolor=#f0f0f0 class=es02 align=left>戶名</td>
    </tr>
<%
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
    Iterator<MembrInfoBillRecord> iter = records.iterator();

    TeacherMgr tmm=TeacherMgr.getInstance();

    while (iter.hasNext()) {
        MembrInfoBillRecord sinfo = iter.next();
        MembrTeacher teachr = teacherMap.get(new Integer(sinfo.getMembrId())).get(0);
        Teacher tea=(Teacher)tmm.find(teachr.getTeacherId());
        
        String salaryReason="";
        Boolean wireWork=false;

        if(tea.getTeacherIdNumber() ==null ||tea.getTeacherIdNumber().length()<10)    
            salaryReason="身份証字號不完整";
        else if(tea.getTeacherBank1() ==null ||tea.getTeacherBank1().length()<3)
            salaryReason="匯款銀行代號有誤";
        else if(tea.getTeacherAccountNumber1() ==null ||tea.getTeacherAccountNumber1().length()<3)
            salaryReason="匯款帳號有誤";
        else 
            wireWork=true;


  %><tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
    <% 
        String bgcolor = "";
        String checkbox = "<input type=checkbox name=\"target\" value=\""+sinfo.getTicketId()+"\" onclick=\"show_subtotal()\"";

        //if(v==BillPay.SALARY_WIRE && !wireWork)
        //    checkbox+=" disabled ";
        checkbox+=">";
                
        String space = "";
        if (sinfo.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID) {
            bgcolor = "bgcolor='#f2f2f2'";
            checkbox = "";
            space = "&nbsp;&nbsp;&nbsp;&nbsp;";
        }
        //else if (v==BillPay.SALARY_WIRE && !canWire(sinfo,teachr)) { 
        //    bgcolor = "bgcolor='#f2f2f2'";
        //    checkbox = "";
        //    space = "&nbsp;&nbsp;&nbsp;&nbsp;";
        //} 

        if((sinfo.getReceivable()-sinfo.getReceived())<=0)
        {
            bgcolor = "bgcolor='#f2f2f2'";
            checkbox = "";
            space = "&nbsp;&nbsp;&nbsp;&nbsp;";            
        }
        %>
        <td class=es02 <%=bgcolor%>>
                <%=checkbox%> <%=space%>             <a href="javascript:openwindow_phm('modifyTeacher.jsp?teacherId=<%=tea.getId()%>','教職員基本資料',800,550,true);"><%=sinfo.getMembrName()%></a>
                <input type=hidden name="amt_<%=sinfo.getTicketId()%>" value="<%=sinfo.getReceivable()-sinfo.getReceived()%>">
            <%
                if(v==BillPay.SALARY_WIRE && !wireWork)
                    out.println("<br>&nbsp;&nbsp;&nbsp;"+salaryReason);
            %>
        </td>
        <td class=es02 <%=bgcolor%>><%=sdf.format(sinfo.getBillMonth())%></td>
        <td class=es02 <%=bgcolor%>>
        <% if (sinfo.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID) out.println("已付清");
           else if (sinfo.getPaidStatus()==MembrBillRecord.STATUS_PARTLY_PAID) out.println("部分付清");
           else out.println("未付");
        %>
        </td>
        <td class=es02 <%=bgcolor%> align=right><%=mnf.format(sinfo.getReceivable())%></td>
        <td class=es02 <%=bgcolor%> align=right><%=mnf.format(sinfo.getReceived())%></td>
        <td class=es02 <%=bgcolor%> align=right>
            <b><%=mnf.format(sinfo.getReceivable()-sinfo.getReceived())%></b>
        </td>
        <td class=es02 <%=bgcolor%>><%=teachr.getTeacherIdNumber()%></td>
        <td class=es02 <%=bgcolor%>><%=teachr.getTeacherBank1()%></td>
        <td class=es02 <%=bgcolor%>><%=teachr.getTeacherAccountNumber1()%></td>
        <td class=es02 <%=bgcolor%>><%=teachr.getTeacherAccountName1()%></td>
    </tr><%
    }
%>
    <tr>
        <td class=es02 colspan=9 align=middle>
            <input type="submit" value="付款">
        </td>
    </tr>
    </table>
</td>
</tr>
</table>
</form>
</blockquote>

    </td>
    </tr>
    </table>
    

<br>
<br>
<br>
<%
    String p = request.getParameter("p");    
    if (p!=null && p.equals("1")) {
%>
<script>
    document.f2.checkall.checked = true;
    check_all(document.f2.checkall);
</script>
<%  } 


}catch(Exception e){

    e.printStackTrace();
    System.out.println("error:"+e.getMessage());
}

%>
<%@ include file="bottom.jsp"%>	
</body>
