<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=9;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu9.jsp"%>

<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?page=6&info=1");
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    int pid = Integer.parseInt(request.getParameter("pid"));
    ArrayList<Inventory> invs = InventoryMgr.getInstance().
        retrieveList("pitemId=" + pid, "order by orderDate desc limit 1");
%>
<script src="js/formcheck.js"></script>
<script>

    function checkForm(){
        if(!checkDate(document.xs.orderDate.value,'/'))
        {
            alert('請填入正確的入帳日期');
            document.xs.orderDate.focus();
            return false;
        }

        if(typeof document.xs.pitemId=='undefined' ||  !IsNumeric(document.xs.pitemId.value))
        {
            alert('沒有產品資料');
            return false;
        }

        if(!IsNumeric(document.xs.quantity.value))
        {
            alert('請填入正確的金額');
            document.xs.quantity.focus();
            return false;
        }

        if(!IsNumeric(document.xs.total.value))
        {
            alert('請填入正確的金額');
            document.xs.total.focus();
            return false;
        }

        return true;

    }
  
</script>

<br>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<b>
<img src=pic/littlebag.png border=0>&nbsp;學用品進貨
</b>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:history.go(-1)"><img src="pic/last2.png" border=0>&nbsp;回上一頁</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
<form action="inventory_add2.jsp" method=post name="xs" id="xs"  onsubmit="return(checkForm())">

<table width="500" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>進貨日期：</td>
        <td bgcolor=#ffffff colspan=2>
            <input type=text name="orderDate" size=10 value="<%=sdf.format(new Date())%>">
            &nbsp;&nbsp;&nbsp;ex: 2008/10/22
        </td>
    </tr>        
	<tr bgcolor=#f0f0f0 class=es02>
        <td>產品:
            <br>
        </tD>
        <td bgcolor=#ffffff colspan=2>
        <%@ include file="setup_pitem.jsp"%>
      </td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>數量:</td>
        <td bgcolor=#ffffff colspan=2>
            <input type=text name="quantity" size=5>
        </td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>金額合計:</td>
        <td bgcolor=#ffffff colspan=2>
            <input type=text name="total" size=7 value="0">
            <font color=red>*</font>(若無成本或不考慮成本請輸入0)
        </td>
    </tr>
<%
    JsfAdmin ja=JsfAdmin.getInstance();
    Costtrade[] ct=ja.getActiveCosttrade();    
%>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>廠商:
            <br>
        </tD>
        <td bgcolor=#ffffff colspan=2>
        <%@ include file="setup_costtrade.jsp"%>
        </td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>備註:
            <br>
        </tD>
        <td bgcolor=#ffffff colspan=2>
            <textarea name=note rows=3 cols=40></textarea>
        </td>
    </tR>
    <tr class=es02>
        <td colspan=3 align=middle>
            <input type=submit value="新增">
        </td>
    </tr>
    </table>
    </tD>
    </tR>
    </table>
</form>
</blockquote>

<script>
<%
        PItem pi = PItemMgr.getInstance().find("id=" + pid);
      %>setPitem(<%=pid%>, '<%=phm.util.TextUtil.escapeJSString(pi.getName())%>');<%
        if (invs.size()!=0) {
            Inventory inv = invs.get(0);
            Costtrade c = (Costtrade) CosttradeMgr.getInstance().find(inv.getTraderId());
            if (c!=null) { 
      %>setCostTradeId(<%=c.getId()%>, '<%=phm.util.TextUtil.escapeJSString(c.getCosttradeName())%>');<%
            }
        }
%>
</script>

<%@ include file="bottom.jsp"%>
