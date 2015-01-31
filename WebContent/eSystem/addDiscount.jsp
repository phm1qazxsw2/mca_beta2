<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
     if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    int cid = Integer.parseInt(request.getParameter("cid"));
    EzCountingService ezsvc = EzCountingService.getInstance();
    BillChargeItem bcitem = BillChargeItemMgr.getInstance().find("chargeitem.id=" + cid);
    JsfAdmin jadm = JsfAdmin.getInstance();
    DiscountType[] types = jadm.getAactiveDiscountType();
    ArrayList<ChargeItemMembr> chargedmembrs = ChargeItemMembrMgr.getInstance().
        retrieveList("chargeItemId=" + bcitem.getId(), "order by membr.name asc");
%>

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

function check_all(c) {
    var target = document.f1.membr;
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

function doCheck(f)
{
    var c = f.membr;
    if (typeof c=='undefined') {
        alert("沒有可選的人");
        return false;
    }
    /*
    var s = f.type;
    if (s.options[s.selectedIndex].value==0) {
        alert("請選擇一個調整的理由");
        s.focus();
        return false;
    }
    */
    if (!IsNumeric(f.amount.value)) {
        alert("請填入正確的金額");
        f.amount.focus();
        return false;
    }

    var i;
    for (i=0; typeof(c.length)!='undefined' && i<c.length; i++) {
        if (c[i].checked)
            break;
    }

    if (i==c.length) {
        alert("沒有選任何一個人");
        return false;
    }

    if (f.note.value.length>0) {
        var len = 0;
        for (var i=0; i<f.note.value.length; i++) {
            var c = f.note.value.charAt(i);
            if (c<256)
                len += 1;
            else
                len += 2;
        }
        if (len>60) {
            alert("附註太長，最多30個中文字");
            f.note.focus();
            return false;
        }
    }
    
    return true;
}
</script>

<body>

&nbsp;&nbsp;&nbsp;&nbsp;<b>新增調整項目:</b>
<center>
<form name="f1" action="addDiscount2.jsp" method="post" onsubmit="return doCheck(this);">
<input type=hidden name="cid" value="<%=cid%>">
<input type=hidden name="type" value="<%=types[0].getId()%>">
<input type=hidden name=copystatus value='<%=Discount.COPY_NO%>'>

<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=ffffff class=es02>
        <td bgcolor="#f0f0f0" nowrap>
            調整名單:<br>
            <input type=checkbox name="checkall" onclick="check_all(this);"> 全選
        </td>
        <td>
            <table border=0>
                <%
                    DiscountMgr dmgr = DiscountMgr.getInstance();
                    Iterator<ChargeItemMembr> iter = chargedmembrs.iterator();
                    int j=0;
                    while (iter.hasNext()) {
                        ChargeItemMembr c = iter.next();
                        if (dmgr.numOfRows("chargeItemId=" + cid + " and membrId=" + c.getMembrId())>0) {
                            continue;
                        }
                        if ((j%6)==0)
                            out.println("<tr>");
                        out.println("<td width='16%' class=es02 nowrap>");
                        
                        if (c.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID)
                            out.println("<img src='images/lockfinish.gif' align=top width=15 height=15 alt='已付'>&nbsp;");
                        else if (c.getPrintDate()>0) 
                            out.println("<img src='images/lockno.gif' align=top width=15 height=15 alt='已鎖'>&nbsp;");
                        else 
                            out.println("<input type=checkbox name=membr value='"+c.getMembrId()+"'>");
                        
                        out.println(c.getMembrName() +"</td>");
                        if ((j%6)==5)
                            out.println("</tr>");
                        j++;
                    }
                %>
                </table>
            </td>
        </tr>
<!--
    <tr bgcolor=ffffff class=es02>
            <td bgcolor="#f0f0f0" nowrap>
                調整原因
            </TD>
            <TD>
                <select name="type">
                    <option value="0">--請選擇一個折扣的理由--</option>
                <%
                for (int i=0; i<types.length; i++)
                    out.println("    <option value='" + types[i].getId() + "'>" + types[i].getDiscountTypeName() + "</option>");
                %>
                </select> (供統計用，不會出現在帳單上)
            </TD>
        </TR>
-->
    <tr bgcolor=ffffff class=es02>
            <td bgcolor="#f0f0f0" nowrap>
                調整金額：
            </td>
            <td>
                <input type=text name=amount size=10>

            </tD>
        </tr>
    <tr bgcolor=ffffff class=es02>
            <td bgcolor="#f0f0f0" nowrap>註記：</td>
            <td>
                <textarea name=note rows=3 cols=30></textarea>
                 (供內部記錄，不會出現在帳單上) 
            </td>
        </tr>
<!--
    <tr bgcolor=ffffff class=es02>
            <td bgcolor="#f0f0f0">延續折扣</td>
            <td>
                <input type=radio name=copystatus value='<%=Discount.COPY_YES%>' checked>延續                
                <input type=radio name=copystatus value='<%=Discount.COPY_NO%>'>不延續
            </td>
        </tr>
-->
    <tr bgcolor=ffffff class=es02>
            <td colspan=2 align=middle>
                <input type=submit value="新增折扣">
            </td>
        </tr>
        </table>
        
        </td>
        </tr>
        </table>
</form>
</center>
</body>
