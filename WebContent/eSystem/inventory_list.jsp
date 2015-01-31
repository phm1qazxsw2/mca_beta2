<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=9;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,800))
    {
        response.sendRedirect("authIndex.jsp?code=800");
    }
%>
<%@ include file="leftMenu9.jsp"%>
<%

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    ArrayList<PItem> items = PItemMgr.getInstance().retrieveListX("status=1", "", _ws.getBunitSpace("bunitId"));
    ArrayList<InvInfo> inv_infos = InvInfoMgr.getInstance().retrieveListX("", "group by pitemId", _ws.getBunitSpace("bunitId"));
    Map<Integer, Vector<InvInfo>> invMap = new SortingMap(inv_infos).doSort("getPitemId");

    String pitemIds = new RangeMaker().makeRange(items, "getId");
    ArrayList<PitemOut> pitemouts = PitemOutMgr.getInstance().retrieveList("pitemId in (" + pitemIds + ")", 
        "group by pitemId");
    Map<Integer, Vector<PitemOut>> pitemoutMap = new SortingMap(pitemouts).doSort("getPitemId");
%>
<script>
function show_out_history(pid)
{
    openwindow_phm2('pitem_out_history.jsp?id=' + pid, '出貨歷史', 600, 500, 'pitemwin');
}
</script>

<br>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<b>
<img src=pic/bag.png border=0>&nbsp;學用品與庫存
</b>


&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:history.go(-1)"><img src="pic/last2.png" border=0>&nbsp;回上一頁</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
<form action="inventory_add2.jsp" method=post name="xs" id="xs"  onsubmit="return(checkForm())">
<div class=es02>
&nbsp;<a href="javascript:openwindow_phm('add_product.jsp','新增學用品',400,350,true);"><img src="pic/addbag.png" border=0> &nbsp;新增學用品</a>
</div>
<br>
<table width="700" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
    <table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td align=middle width=200 class=es02>學用品名稱</td>
        <td align=middle width=100 class=es02>單價</td>
        <td align=middle width=100 class=es02>進貨</td>
        <td align=middle width=100 class=es02>出貨</td>
        <td align=middle width=100 class=es02 nowrap>庫存量/安全存量</td>
        <td align=middle width=100 class=es02 nowrap>成本/單價</td>
        <td width=100></td>
    </tr>
<%
    Iterator<PItem> iter = items.iterator();
    while (iter.hasNext()) {
        PItem pi = iter.next();
        Vector<InvInfo> vi = invMap.get(new Integer(pi.getId()));
        int quantity = 0;
        int cost = 0;
        if (vi!=null) {
            quantity = vi.get(0).getQuantity();
            cost = vi.get(0).getCost();
        }
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td align=left class=es02><%=pi.getName()%><a href="javascript:openwindow_phm('modify_product.jsp?id=<%=pi.getId()%>','修改產品資料',400,500,true)"><img src="pic/fix.gif" border=0  align=texttop width=12></a></td>
        <td align=right class=es02><%=pi.getSalePrice()%></td>
        <td  align=right class=es02><a href="javascript:openwindow_phm('inventory_history.jsp?id=<%=pi.getId()%>','歷史進貨',600,500,true)"><img src="pic/fix.gif" border=0  align=texttop width=12></a> </td>
        <td align=right class=es02>
        <%
            int o = 0;
            Vector<PitemOut> vpo = pitemoutMap.get(new Integer(pi.getId()));
            if (vpo!=null) o = vpo.get(0).getQuantity();
            out.println(o);
            if (o>0) {
                out.println("(<a href=\"javascript:show_out_history("+pi.getId()+");\">明細</a>)");   
            }
        %>
        </td>
        <td align=right class=es02>
        <%
            int nowQuantity=quantity-o;

            if(pi.getSafetyLevel()!=0 && pi.getSafetyLevel() >nowQuantity){
        %>
            <img src="pic/star2.png" border=0 alt="庫存不足">
        <%
            }
        %>
        <%=nowQuantity%>
        /
        <%
        if(pi.getSafetyLevel()==0)
            out.println("沒有設定");
        else
            out.println(pi.getSafetyLevel());            
        %>
        </td>
        <td align=right class=es02><%=cost%><%=(quantity>0)?("/"+cost/quantity):""%></td>
        <td align=middle class=es02><a href="inventory_add.jsp?pid=<%=pi.getId()%>">進貨</a></td>
    </tr>
<%  } %>
    </table>
</tD>
</tR>
</table>
</form>
</blockquote>


<%@ include file="bottom.jsp"%>
