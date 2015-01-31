<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    static SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
    String gd(FeeDetail fd)
    {
        return "sDate=" + java.net.URLEncoder.encode(sdf1.format(fd.getFeeTime())) + 
            "&eDate=" + java.net.URLEncoder.encode(sdf1.format(fd.getFeeTime()));
    }
%>
<%
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

    boolean outsourcing = (pd2.getWorkflow()==2);
    FeeDetailHandler fdhandler = new FeeDetailHandler(details, outsourcing);
%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<script>
function do_modify(fid)
{
    var t = document.getElementById("t_" + fid);
    var u = document.getElementById("u_" + fid);
    var n = document.getElementById("n_" + fid);
    var a = document.getElementById("a_" + fid);
    var tv = t.innerHTML;
    var uv = u.innerHTML;
    var nv = n.innerHTML;
    var org = tv + '|' + uv + '|' + nv;

    t.innerHTML = '<input type=text size=8 name="tv_'+fid+'" id="tv_'+fid+'" value="' + t.innerHTML + '"> <a href="#" onclick="displayCalendar(document.f1.tv_'+fid+',\'yyyy-mm-dd\',this);return false"><img src="pic/redfix.png" border=0></a>';    
    u.innerHTML = '<input type=text size=1 name=u id="uv_'+fid+'" value="' + u.innerHTML + '">';    
    n.innerHTML = '<input type=text size=1 name=n id="nv_'+fid+'" value="' + n.innerHTML + '">';    
    a.innerHTML = '<a href="javascript:do_save('+fid+')">儲存</a> | <a href="javascript:do_cancel('+fid+',\''+org+'\')">取消</a>';
}

function do_save(fid)
{
    var tv = document.getElementById("tv_" + fid).value;
    var uv = document.getElementById("uv_" + fid).value;
    var nv = document.getElementById("nv_" + fid).value;

    uv = uv.replace(',', '');
    var url = "feedetail_save.jsp?fid=" + fid + "&t=" + encodeURI(tv) + "&u=" + uv + "&n=" + nv + "&r="+(new Date()).getTime();
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
                    // on success
                    do_cancel(fid, tv+'|'+uv+'|'+nv);
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

function do_cancel(fid, org)
{
    var t = document.getElementById("t_" + fid);
    var u = document.getElementById("u_" + fid);
    var n = document.getElementById("n_" + fid);
    var a = document.getElementById("a_" + fid);
    var tokens = org.split('|');
    t.innerHTML = tokens[0];
    u.innerHTML = tokens[1];
    n.innerHTML = tokens[2];
    a.innerHTML = '<a href="javascript:do_modify('+fid+')">修改</a>';
}

function do_delete(id)
{
    if (!confirm("確定刪除此明細？")) {
        return;
    }

    var url = "feedetail_delete.jsp?fid=" + id + "&r="+(new Date()).getTime();
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
                else
                    location.reload();
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
<b>&nbsp;&nbsp;&nbsp;<img src="pic/redfix.png" border=0>&nbsp;編輯收費明細-<%=ci.getChargeName()%> for <%=ci.getMembrName()%> </b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</div>

 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>
<% if (details.size()==0) { %>
目前沒有任何收費細目
<br>
<% } else { %>
<form name=f1>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
    	<td>日期</td>
        <td>單價</td>
        <td>數量</td>
        <td>總額</td>
<% if (outsourcing) { %>
        <td>派員</td>
<% } %>
        <td>附註</td>
        <td></td>
        <td></td>
    </tr>
<%  while (fiter.hasNext()) { 
        FeeDetail f = fiter.next();
        subtotal += f.getUnitPrice()*f.getNum(); %>
    <tr bgcolor=ffffff class=es02 valign=top>
        <td nowrap id="t_<%=f.getId()%>"><%=sdf.format(f.getFeeTime())%></td>
        <td align=right nowrap id="u_<%=f.getId()%>"><%=mnf.format(f.getUnitPrice())%></td>
        <td align=right id="n_<%=f.getId()%>"><%=f.getNum()%></td>
        <td align=right id="s_<%=f.getId()%>"><%=mnf.format(f.getUnitPrice()*f.getNum())%></td>
<% if (outsourcing) { %>
        <td><%=fdhandler.getPayrollMembrName(f)%></td>
<% } %>
        <td><%=f.getNote()%></td>
<%
        if(checkAuth(ud2,authHa,102)){
%>
        <td nowrap align=middle id="a_<%=f.getId()%>"><a href="javascript:do_modify(<%=f.getId()%>)">修改</a></td>
        <td nowrap align=middle><a href="javascript:do_delete(<%=f.getId()%>)">刪除</a></td>
<%
        }else{
%>
        <td colspan=2></td>
<%      }   %>

    </tr>
<%  } %>
    <tr class=es02>
        <td></td>
        <td>小計</td>
        <td colspan=2 align=right><b><%=mnf.format(subtotal)%></b></td>
        <td colspan=2></td>
    </tr>
<%
  }
%>  
    </table>
    </td>
    </tr>
</table>
</form>
</center>

<%
    if(checkAuth(ud2,authHa,102)){
%>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="feedetail_add.jsp?cid=<%=cid%>&sid=<%=sid%>"><img src="pic/add.gif" border=0>&nbsp;新增明細</a>
</div>
<br>
<%
    }
%>

