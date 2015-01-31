<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu5.jsp"%>
<%
    //##v2
    int brid = Integer.parseInt(request.getParameter("brid"));
    int mid = Integer.parseInt(request.getParameter("mid"));

    String backurl = request.getParameter("backurl");
    Membr m = MembrMgr.getInstance().find("id=" + mid);
    BillRecord record = BillRecordMgr.getInstance().find("id="+brid);
    ArrayList<BillChargeItem> bitems = BillChargeItemMgr.getInstance().
        retrieveList("billrecord.id=" + brid + " and billitem.status=" + BillItem.STATUS_ACTIVE,"");
%>
<script>
function check()
{
    if (typeof document.f1.bitemId.length=='undefined') {
        if (document.f1.bitemId.checked == false) {
            alert("沒有選則任何項目");
            return false;
        }
    }
    else {
        for (var i=0; i<f1.bitemId.length; i++) {
            if (document.f1.bitemId[i].checked)
                return true;
        }
        alert("沒有選則任何項目");
        return false;
    }
    return true;
}
</script>
<br>
<img src="pic/fix.gif" border=0>&nbsp; 
<b><%=record.getName()%>-新增薪資 for <%=m.getName()%></b>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="<%=backurl%>"><img src="pic/last.gif" border=0>&nbsp;回前一頁</a></b>
<br><br>
<form name="f1" action="salarybillrecord_add2.jsp" method="post" onsubmit="return check();">
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

        <a href="salarybillrecord_add_adv.jsp?brid=<%=brid%>&mid=<%=mid%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>">進階(鐘點費設定)</a> 
        <table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#f0f0f0 class=es02>
                <td nowrap nowrap>選擇</td>
                <td nowrap width=50%>薪資項目</td>
                <td nowrap>形態</td>
                <td nowrap width=50%></td>
            </tr>
        <%            
            Iterator<BillChargeItem> iter = bitems.iterator();
            while (iter.hasNext())
            {
                BillChargeItem bi = iter.next(); %>
            <tr bgcolor=white class=es02 valign=center height=30>
                <td><input type="checkbox" name="bitemId" value="<%=bi.getBillItemId()%>"></td>
                <td><%=bi.getName()%></td>
                <td nowrap> 
                    <%
                        switch(bi.getSmallItemId()){
                            case BillItem.SALARY_PAY:
                                out.println("+ 應付薪資");                            
                                break;
                            case BillItem.SALARY_DEDUCT1:
                                out.println("- 代扣薪資");
                                break;
                            case BillItem.SALARY_DEDUCT2:
                                out.println("- 應扣薪資");
                                break;
                            default:
                                out.println(bi.getSmallItemId());        
                        }
                    %>
                </td>
                <td align=center>
                    <input type=text name="amount_<%=bi.getBillItemId()%>" value="<%=bi.getChargeAmount()%>" size=7>
                </td>
            </tr>
        <%  
            }
        %>
        <tr bgcolor=#f0f0f0 class=es02>
            <td nowrap colspan=4><a href="javascript:openwindow_phm('salarybillitem_add.jsp?billId=<%=record.getBillId()%>','新增薪資項目',560,350,true);"><img src="pic/add.gif" border=0>&nbsp;新增薪資項目</a></td>
            </td>
        </tr>

        <tr>
            <td align=middle colspan=3>
                    <input type="submit" value="新增薪資">
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