<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    //##v2

    int brid = Integer.parseInt(request.getParameter("brid"));
    int mid = Integer.parseInt(request.getParameter("mid"));

    String backurl = request.getParameter("backurl");
    Membr m = MembrMgr.getInstance().find("id=" + mid);
    BillRecord record = BillRecordMgr.getInstance().find("id="+brid);
    ArrayList<BillChargeItem> bitems = BillChargeItemMgr.getInstance().
        retrieveList("billrecord.id=" + brid + " and billitem.status=" + BillItem.STATUS_ACTIVE,"order by pos asc");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
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
function calc_subtotal(bid)
{
    var str = "document.f1.unit_" + bid + ".value * document.f1.quant_" + bid + ".value";
    var v = eval(str);
    document.getElementById("subtotal_" + bid).innerHTML = v;
}
</script>
<br>
<img src="pic/fix.gif" border=0>&nbsp; 
<b><%=record.getName()%>-進階新增帳單 for <%=m.getName()%></b>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="<%=backurl%>"><img src="pic/last.gif" border=0>&nbsp;回前一頁</a></b>
<br><br>
<form name="f1" action="membrbillrecord_add_adv2.jsp" method="post" onsubmit="return check();">
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
                <td nowrap>日期</td>
                <td nowrap>單價</td>
                <td>x</td>
                <td nowrap>數量</td>
                <td>=</td>
                <td nowrap>&nbsp;&nbsp;&nbsp;小計&nbsp;&nbsp;&nbsp;<a href="membrbillrecord_add.jsp?brid=<%=brid%>&mid=<%=mid%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>">一般設定<a>
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
                <td nowrap><%=bi.getName()%></td>
                <td nowrap>
                    <input type=text size=7 name="date_<%=bi.getBillItemId()%>" value="<%=sdf.format(new Date())%>">
                </td>                        
                <td>
                    <input type=text name="unit_<%=bi.getBillItemId()%>" value="<%=bi.getChargeAmount()%>" size=3 onblur="calc_subtotal(<%=bi.getBillItemId()%>)">
                </td>
                <td>x</td>
                <td>
                    <input type=text name="quant_<%=bi.getBillItemId()%>" value="1" size=2 onblur="calc_subtotal(<%=bi.getBillItemId()%>)">
                </td>
                <td>=</td>
                <td>
                    <div id="subtotal_<%=bi.getBillItemId()%>"><%=bi.getChargeAmount()%></div>
                </td>
       
            </tr>
        <%  
            }
        %>
        <tr bgcolor=#f0f0f0 class=es02>
            <td nowrap colspan=9><a href="javascript:openwindow_phm('addBillItem.jsp?billId=<%=record.getBillId()%>','新增收費項目',560,350,true);"><img src="pic/add.gif" border=0>&nbsp;新增收費項目</a></td>
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