<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    if(!checkAuth(ud2,authHa,301))
    {
        response.sendRedirect("authIndex.jsp?code=301");
    }
%>
<%
    //##v2

    int recordId = -1; try { recordId=Integer.parseInt(request.getParameter("rid")); } catch (Exception e) {}
    int bitemId = -1; try { bitemId=Integer.parseInt(request.getParameter("bid")); } catch (Exception e) {}
    int citemId = -1; try { citemId=Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}

    EzCountingService ezsvc = EzCountingService.getInstance();
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    BillChargeItem bcitem = null;
    
    WebSecurity _ws_ = WebSecurity.getInstance(pageContext);
    if (citemId<0)
        bcitem = BillChargeItemMgr.getInstance().findX("billrecord.id=" + recordId + " and billitem.id=" + bitemId, _ws_.getBunitSpace("bill.bunitId"));
    else
        bcitem = BillChargeItemMgr.getInstance().findX("chargeitem.id=" + citemId, _ws_.getBunitSpace("bill.bunitId"));

    if (bcitem==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

    int org_salarytype = bcitem.getSmallItemId();
    ArrayList<ChargeItemMembr> chargedmembrs = ChargeItemMembrMgr.getInstance().
        retrieveList("chargeItemId=" + bcitem.getId(), "");

%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<link rel="stylesheet" href="css/ajax-tooltip-billsearch.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
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

function check(f)
{
    var s = f.salarytype;
    if (s.options[s.selectedIndex].value==0) {
        alert("請選擇一個項目種類");
        s.focus();
        return false;
    }
    if (org_salarytype==1 && s.options[s.selectedIndex].value>1) {
        if (!confirm("薪資種類從正項變成負項,確定嗎？"))
            return false;
    }
    if ((org_salarytype==2 || org_salarytype==3)&& s.options[s.selectedIndex].value==1) {
        if (!confirm("薪資種類從負項變成正項,確定嗎？"))
            return false;
    }
    return true;
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
}

var changed = false;
function update_change(i, chargeKey, org_amount, f)
{
    if (f.value!=org_amount) {
        changed = true;
    }
}

function leaving()
{
    if (changed) {
        alert("金額有修改還沒存");
    }
}

function do_remove() {
    var target = document.f2.target;
    var something_selected = false;
    if (typeof target!='undefined') {
        if (typeof target.length=='undefined') {
            if (target.checked)
                something_selected = true;
        }
        else {
            for (var i=0; i<target.length; i++) {
                if (target[i].checked) {
                    something_selected = true;
                    break;
                }
            }
        }
    }
    if (!something_selected) {
        alert("請先選取要刪除的對象");
    }
    else {
        if (confirm("確定刪除？")) {
            document.f2.action = "chargeitem_batchremove.jsp";
            document.f2.submit();
        }
    }
}

function doSave()
{
    changed = false;
    document.f2.action = "salarychargeitem_setamount.jsp";
    document.f2.submit();
}

var org_salarytype = <%=org_salarytype%>;
</script>

<body onunload="leaving();">
<br> 
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp; 
<b>編輯<%=bcitem.getBillRecordName()%> - <%=bcitem.getName()%></b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%
    if(pageType==0){
%>
<a href="salaryrecord_edit.jsp?recordId=<%=bcitem.getBillRecordId()%>"><img src="pic/last2.png" border=0>&nbsp;回編輯薪資</a>
<%  }   %>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
<br>
<b>薪資項目設定</b>
  <table CELLPADDING=5 CELLSPACING=5 width=80% bgcolor="#f2f2f2">
  <tr>
    
    <td width=150 align=middle>
       <%
            if(org_salarytype==1){
        %>
            <img src="pic/s4.gif" border=0>
        <%  }else if(org_salarytype==2){    %>
            <img src="pic/s5.gif" border=0>
        <%  }else{   %>
            <img src="pic/s6.gif" border=0>
        <%  }   %>
    </td>
    <td>
        <table>
        <tr class=es02>
            <td><b>薪資類型: </b></td>
            <td>
            <%  if(org_salarytype==1){  %>
                應領薪資(+)
            <%  }else if(org_salarytype==2){    %>
                代扣(-)
            <%  }else{   %>
                應扣(-)
            <%  }   %>

            </td>            
        </tr>
        </table>
    </td>
    </tr>
  </table>
</form>

<br>
<img src="img/flag2.png" border=0>&nbsp;<b>已加入的薪資對象: (<%=chargedmembrs.size()%>筆) </b> 
 <a href="#" onclick="openwindow_phm('salary_chooser_detail.jsp?param=<%=java.net.URLEncoder.encode(recordId+"#"+bitemId+"#"+bcitem.getId())%>','加入薪資對象',600,400,true);return false;">
        <img src="pic/add.gif" border=0>&nbsp;加入薪資對象</a>
    <%
    if(chargedmembrs.size() !=0)
    {
    %>
    |
        <a href="javascript:do_remove()"><img src="pic/minus.gif" border=0>&nbsp;   將選取的對象移除</a>
        <input type=checkbox name="checkall" onclick="check_all(this)"> 全選
<%  }   %>

    
<br><br>
<form name="f2" method="post">
<input type=hidden name="cid" value="<%=bcitem.getId()%>">
<input type=hidden name="backurl" value="<%=backurl%>">

<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" cellpadding=4 cellspacing=1>
<%
    //### 拿所有這個 chargeitemId 的 feedetail 出來，等下若是要有 feedetail 編輯過的人就不能在這改數字
    Map<String, Vector<FeeDetail>> fdetailMap = new SortingMap(FeeDetailMgr.getInstance().
        retrieveList("chargeItemId=" + bcitem.getId(),"")).doSort("getChargeKey");
    //###############

    Iterator<ChargeItemMembr> iter = chargedmembrs.iterator();
    int i=0;
    int j=0;
    while (iter.hasNext())
    {
        ChargeItemMembr c = iter.next();
        if ((i%4)==0)
        {        
            j++;
            if((j%2)==1)
                out.println("<tr bgcolor=#f2f2f2>");
            else
                out.println("<tr bgcolor=#ffffff>");
        
        }
        out.println("<td nowrap>");
        boolean editable = false; 
        if (c.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID)
            out.println("<img src='images/lockfinish.gif' align=top width=15 height=15 alt='已付'>");
        else if (c.getPrintDate()>0)
            out.println("<img src='images/lockno.gif' align=top width=15 height=15 alt='已鎖'>");
        else {
            out.println("<input type=checkbox name='target' value='"+c.getMembrId()+"'>");
            if (fdetailMap.get(c.getMembrId()+"#"+c.getChargeItemId())==null)
                editable = true; // 有 feedetail, 在此不可直接改數字
        }

        out.println("<a href='salary_detail.jsp?rid=" + c.getBillRecordId()+"&sid="+c.getMembrId()+"&backurl="+java.net.URLEncoder.encode(backurl)+"' onmouseover=\"ajax_showTooltip('peek_salary.jsp?rid="+c.getBillRecordId()+"&sid="+c.getMembrId()+"',this);return false\" onmouseout=\"ajax_hideTooltip()\">" + c.getMembrName() + "</a>");
%> 
      &nbsp;&nbsp;
      <% if (editable) { %>      
      <input type=text size=6 name="_<%=c.getChargeKey()%>" value="<%=phm.util.TextUtil.abs(c.getAmount(), false)%>" onblur="update_change(<%=i%>,'<%=c.getChargeKey()%>',<%=phm.util.TextUtil.abs(c.getAmount(), false)%>,this)">
      <% } else { %>
      <%=mnf.format(c.getMyAmount())%>
      <% }  %>
    <%
        out.println("</td>");
        if ((i%4)==3)
            out.println("</tr>");
        i++;
    }
    if (chargedmembrs.size()>0) {
%>
<tr>
    <td colspan=4 bgcolor=ffffff align=middle>
        <input type="button" value="儲存金額" onclick="doSave();">
    </td>
</tr>        
<%  } %>

</table>
</td>
</tr>
</table>
</form>

<br>
<%
/*
%>
<a href="salaryrecord_edit.jsp?recordId=<%=bcitem.getBillRecordId()%>"><img src="pic/last.gif" border=0>回 <%=bcitem.getBillRecordName()%>-編輯帳單</a>

<%
*/
%>
</blockquote>
