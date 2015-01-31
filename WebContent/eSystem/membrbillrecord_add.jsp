<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%!
    public String getItemName(BillChargeItem bi, Map<Integer, Vector<Alias>> aliasMap)
    {
        String ret = bi.getName();
        if (bi.getAliasId()>0) {
            Vector<Alias> va = aliasMap.get(new Integer(bi.getAliasId()));
            if (va!=null)
                ret = "【" + va.get(0).getName() + "】 <span class=es01>" + ret + "</span>";
        }
        return ret;
    }
%>
<%
    //##v2
    request.setCharacterEncoding("UTF-8");

    int brid = Integer.parseInt(request.getParameter("brid"));
    int mid = Integer.parseInt(request.getParameter("mid"));

    String backurl = request.getParameter("backurl");
    Membr m = MembrMgr.getInstance().find("id=" + mid);
    BillRecord record = BillRecordMgr.getInstance().find("id="+brid);
    ArrayList<BillChargeItem> bitems = BillChargeItemMgr.getInstance().
        retrieveList("billrecord.id=" + brid + " and billitem.status=" + BillItem.STATUS_ACTIVE,"order by pos asc");
    Map<Integer, Vector<Alias>> aliasMap = 
        new SortingMap(AliasMgr.getInstance().retrieveListX("","", _ws.getMetaBunitSpace("bunitId"))).doSort("getId");
%>
<script>
function check()
{
    if (typeof document.f1.bitemId=='undefined') {
        alert("沒有選則任何項目");
        return false;
    }
    if (typeof document.f1.bitemId.length=='undefined') {
     if (!document.f1.bitemId.checked) {
            alert("沒有選則任何項目");
            return false;
        }
    }
    else {
        for (var i=0; i<document.f1.bitemId.length; i++) {
            if (document.f1.bitemId[i].checked)
                return true;
        }
        alert("沒有選則任何項目");
        return false;
    }
}

function update_amount(bid, unitPrice)
{
    var n = eval(document.f1['num_' + bid].value * unitPrice)
    document.f1['amount_' + bid].value = n;
}
</script>
<br>
<img src="pic/fix.gif" border=0>&nbsp; 
<b><%=record.getName()%>-新增帳單 for <%=m.getName()%></b>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="<%=backurl%>"><img src="pic/last.gif" border=0>&nbsp;回前一頁</a></b>
<br><br>
<form name="f1" action="membrbillrecord_add2.jsp" method="post" onsubmit="return check();">
<input type=hidden name="backurl" value="<%=backurl%>">
<input type=hidden name="mid" value="<%=mid%>">
<input type=hidden name="brid" value="<%=brid%>">
<table width="750" height="" border="0" cellpadding="0" cellspacing="0">
<tr>
    <td align=middle valign=top width=150 class=es02>
        <img src="img/bbill.gif" border=0>
        <br>
        <br>
    
    </td>
    <td width=600 valign=top class=es02>

        <table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#f0f0f0 class=es02>
            	<td width="10">No.</td>
                <td nowrap nowrap>選擇</td>
                <td nowrap width=50%>收費項目</td>
                <td nowrap width=50%>
                    <table class=es02 width=100% cellpadding=0 cellspacing=0>
                    <tr>
                        <td>預設金額</td>
                        <td align=right><a href="membrbillrecord_add_adv.jsp?brid=<%=brid%>&mid=<%=mid%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>">進階設定</a></td>
                    </tr>
                    </table>                                
                </td>
            </tr>
        <%            
            int row = 1;
            Iterator<BillChargeItem> iter = bitems.iterator();
            while (iter.hasNext())
            {
                BillChargeItem bi = iter.next(); 
                String color = bi.getColor(); 
        %>
            <tr bgcolor=white class=es02 valign=center height=30>
            	<td width="10" <%=(color!=null&&color.length()>0)?"bgcolor="+color:""%>><%=row++%></td>
                <td><input type="checkbox" name="bitemId" value="<%=bi.getBillItemId()%>"></td>
                <td><%=getItemName(bi, aliasMap)%></td>
                <td nowrap>
                 <% if (bi.getPitemId()>0) { %>
                    <input type=text name="num_<%=bi.getBillItemId()%>" value="1" size=1 onblur="update_amount(<%=bi.getBillItemId()%>,<%=bi.getDefaultAmount()%>)">個共
                    <input type=text name="amount_<%=bi.getBillItemId()%>" value="<%=bi.getDefaultAmount()%>" size=2>元
                 <% } else { %>
                    <input type=text name="amount_<%=bi.getBillItemId()%>" value="<%=bi.getDefaultAmount()%>" size=7>
                 <% } %>                    
                </td>
            </tr>
        <%  
            }
        %>
        <tr bgcolor=#f0f0f0 class=es02>
            <td nowrap colspan=4><a href="javascript:openwindow_phm('addBillItem.jsp?billId=<%=record.getBillId()%>','新增收費項目',560,450,true);"><img src="pic/add.gif" border=0>&nbsp;新增收費項目</a></td>
            </td>
        </tr>
        <tr>
            <td align=middle colspan=4>
                <input type="submit" value="新增帳單">
            </td>
        </tr>
        </table>

        </td>
        </tr>
        </table>


    </td>
    </tr>
    </table>
</form>

</blockquote>


<!--- end 主內容 --->
<%@ include file="bottom.jsp"%>	