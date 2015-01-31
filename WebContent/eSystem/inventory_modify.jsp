<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>

<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?page=6&info=1");
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    ArrayList<PItem> items = PItemMgr.getInstance().retrieveList("status=1", "");
    int id = Integer.parseInt(request.getParameter("id"));
    Inventory inv = InventoryMgr.getInstance().find("id=" + id);
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

        if(typeof document.xs.pitemId=='undefined' || !IsNumeric(document.xs.pitemId.value))
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
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<b>
<img src=pic/costAdd.png border=0>&nbsp;進貨修改
</b>

&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:history.go(-1)"><img src="pic/last.gif" border=0 width=14>&nbsp;回上一頁</a>
</div>

<center>
<form action="inventory_modify2.jsp" method=post name="xs" id="xs"  onsubmit="return(checkForm())">
<input type=hidden name="id" value="<%=id%>">;
<table width="500" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>進貨日期：</td>
        <td bgcolor=#ffffff colspan=2>
            <input type=text name="orderDate" size=10 value="<%=sdf.format(inv.getOrderDate())%>">
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
            <input type=text name="quantity" size=5 value="<%=inv.getQuantity()%>">
        </td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>金額合計:</td>
        <td bgcolor=#ffffff colspan=2>
            <input type=text name="total" size=7 value="<%=inv.getTotalPrice()%>">
            <font color=red>*</font>(若無成本或不考慮成本請輸入0)
        </td>
    </tr>
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
            <input type=submit value="修改">
        </td>
    </tr>
    </table>
    </tD>
    </tR>
    </table>
</form>
</center>

<script>
<%
    if (inv!=null) {
        PItem pi = PItemMgr.getInstance().find("id=" + inv.getPitemId());
        Costtrade c = (Costtrade) CosttradeMgr.getInstance().find(inv.getTraderId());
      %>setPitem(<%=inv.getPitemId()%>, '<%=phm.util.TextUtil.escapeJSString(pi.getName())%>');<%
      if (c!=null) { 
      %>setCostTradeId(<%=c.getId()%>, '<%=phm.util.TextUtil.escapeJSString(c.getCosttradeName())%>');<%
      }
    }
%>
</script>

