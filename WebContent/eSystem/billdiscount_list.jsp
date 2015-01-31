<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int cid = -1, sid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    try { sid = Integer.parseInt(request.getParameter("sid")); } catch (Exception e) {}
    boolean readonly = false;
    try { readonly = (Integer.parseInt(request.getParameter("ro"))==1); } catch (Exception e) {}

    ChargeItemMembr ci = ChargeItemMembrMgr.getInstance().findX("chargeItemId=" + cid + 
        " and membr.id=" + sid, _ws2.getAcrossBillBunitSpace("bill.bunitId"));
        // 要能編 cover 單位的帳單

    if (ci==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

    ArrayList<DiscountInfo> dinfos = DiscountInfoMgr.getInstance().
        retrieveList("chargeItemId="+cid + " and membrId=" + sid, "");
    Iterator<DiscountInfo> diter = dinfos.iterator();

    ChargeMembr cs = ChargeMembrMgr.getInstance().find("chargeItemId=" + cid + " and membrId=" + sid);
    DecimalFormat mnf = new DecimalFormat("###,###,##0");

    Object[] users2 = UserMgr.getInstance().retrieve("", "");
    Map<Integer, Vector<User>> userMap = new SortingMap().doSort(users2, new ArrayList<User>(), "getUserLoginId");

    
%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
function do_delete(id)
{
    if (!confirm("確定刪除此調整項目？")) {
        return;
    }

    var url = "billdiscount_delete.jsp?did=" + id + "&r="+(new Date()).getTime();
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
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>編輯調整 for <%=cs.getMembrName()%> <%=ci.getChargeName()%></b>
</div> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>

<% if (dinfos.size()==0) { %>
<div class=es02>
目前沒有任何調整設定
</div>
<% } else { %>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
        <td>金額</td>
        <td>登入人</td>
        <td>附註</td>
<% if (!readonly) { %>
        <td></td>
        <td></td>
<% } %>
    </tr>
<%  while (diter.hasNext()) { 
        DiscountInfo di = diter.next(); %>
    <tr bgcolor=ffffff class=es02 valign=top>
        <td align=right><%=mnf.format(0-di.getAmount())%></td>
        <td align=middle><%=getUserName(di.getUserLoginId(), userMap)%></td>
        <td><%=di.getNote()%></td>
<%
        if(checkAuth(ud2,authHa,102)){
%>
<% if (!readonly) { %>
        <td nowrap><a href="billdiscount_modify.jsp?cid=<%=cid%>&sid=<%=sid%>&did=<%=di.getId()%>">修改</a></td>
        <td nowrap><a href="javascript:do_delete(<%=di.getId()%>)">刪除</a></td>
<% } %>
<%      }else{  %>

        <td colspan=2></td>
<%
        }
%>

    </tr>
<%  }
}
%>  
    </table>
    </td>
    </tr>
</table>
<br>
<%
        if(checkAuth(ud2,authHa,102)){
%>
<% if (!readonly) { %>
<div class=es02>
<a href="billdiscount_add.jsp?cid=<%=cid%>&sid=<%=sid%>">
<img src="pic/add.gif" border=0>&nbsp;新增調整</a>
</div>
<% } 
    }
%>
<br>

</blockquote>

<%!
    public String getUserName(String uid, Map<Integer,Vector<User>> userMap)
    {
        Vector<User> vu = userMap.get(uid);
        if (vu==null)
            return "###";

        if(vu.get(0).getUserFullname().length()>0)
            return vu.get(0).getUserFullname();
        else
            return vu.get(0).getUserLoginId();
    }

%>