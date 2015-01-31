<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    static SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
    String gd(FeeDetail fd)
    {
        return "sDate=" + java.net.URLEncoder.encode(sdf1.format(fd.getFeeTime())) + 
            "&eDate=" + java.net.URLEncoder.encode(sdf1.format(fd.getFeeTime()));
    }
%><%
    //##v2

    int cid = -1, sid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    try { sid = Integer.parseInt(request.getParameter("sid")); } catch (Exception e) {}
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    ChargeItemMembr ci = ChargeItemMembrMgr.getInstance().find("chargeItemId=" + cid + 
        " and membr.id=" + sid);

    ArrayList<FeeDetail> details = FeeDetailMgr.getInstance().
        retrieveList("chargeItemId="+cid + " and membrId=" + sid, "order by feeTime asc");
    Iterator<FeeDetail> fiter = details.iterator();

    ChargeMembr cs = ChargeMembrMgr.getInstance().find("chargeItemId=" + cid + " and membrId=" + sid);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    int subtotal = 0;
%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
function do_delete(id)
{
    if (!confirm("確定刪除此明細？")) {
        return;
    }

    var url = "salaryfeedetail_delete.jsp?fid=" + id + "&r="+(new Date()).getTime();
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
                    location.reload();
                }                        
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("發生錯誤");
                return;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}
</script>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<br> 
<% if (ci==null) { %>
       資料不存在，可能已被刪除
<%     return;
   } %>
<div class=es02> 
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>設定薪資明細-<%=ci.getChargeName()%> for <%=ci.getMembrName()%> </b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</div>

 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>
<% if (details.size()==0) { %>
目前沒有任何薪資細目
<br>
<% } else { %>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
    	<td>日期</td>
        <td>單價</td>
        <td>數量</td>
        <td>總額</td>
        <td>附註</td>
        <td></td>
        <td></td>
    </tr>
<%  while (fiter.hasNext()) { 
        FeeDetail f = fiter.next();
        subtotal += f.getUnitPrice()*f.getNum(); %>
    <tr bgcolor=ffffff class=es02 valign=top>
        <td><%=sdf.format(f.getFeeTime())%></td>
        <td align=right nowrap><%=(f.getUnitPrice()<0)?"("+mnf.format(Math.abs(f.getUnitPrice()))+")":mnf.format(f.getUnitPrice())%></td>
        <td align=right><%=f.getNum()%></td>
        <td align=right><%=(f.getUnitPrice()<0)?"("+mnf.format(Math.abs(f.getUnitPrice())*f.getNum())+")":f.getUnitPrice()*f.getNum()%></td>
        <td><%=f.getNote()%></td>
<%
    if (f.getPayrollFdId()==0) {
%>
        <td nowrap align=middle><a href="salaryfeedetail_modify.jsp?cid=<%=cid%>&sid=<%=sid%>&fid=<%=f.getId()%>">修改</a></td>
        <td nowrap align=middle><a href="javascript:do_delete(<%=f.getId()%>)">刪除</a></td>
<%
    }
    else {
%>      <td colspan=2 align=middle nowrap>由帳單產生</td><%
    }
%>
    </tr>
<%  } %>
    <tr class=es02>
        <td></td>
        <td>小計</td>
        <td colspan=2 align=right><b><%=(subtotal<0)?"("+mnf.format(Math.abs(subtotal))+")":mnf.format(subtotal)%></b></td>
        <td colspan=2></td>
    </tr>
<%
  }
%>  
    </table>
    </td>
    </tr>
</table>
</center>

<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="salaryfeedetail_add.jsp?cid=<%=cid%>&sid=<%=sid%>"><img src="pic/add.gif" border=0>新增明細</a>
<br>

