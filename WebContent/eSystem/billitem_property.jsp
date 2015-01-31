<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    BillItem bi = BillItemMgr.getInstance().find("id=" + request.getParameter("bid"));
    String color = bi.getColor();
%>
<script src="201a.js" type="text/javascript"></script>
<script src="js/formcheck.js"></script>
<script src="js/string.js"></script>
<script>
    function do_submit(f)
    {
        var s = trim(f.pos.value);
        if (!IsNumeric(s,true)) {
            alert("請輸入正確的數字");
            f.pos.focus();
            return false;
        }
        return true;
    }
</script>

<body onload="document.getElementById('sample_1').style.background = '<%=color%>';">

<div class=es02 align=left>
&nbsp;&nbsp;&nbsp;<img src="pic/tag1.png" border=0>&nbsp;設定收費項目順序顏色
</div>

    <center>
        <form name="f1" action="billitem_property2.jsp" method="post" onsubmit="return do_submit(this)">
        <input type=hidden name="bid" value="<%=bi.getId()%>">
        <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    順序(第幾個)
                </td>
                <td>
                    <input type=text name="pos" value="<%=bi.getPos()/10%>" size=2>
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    顏色
                </td>
                <td>
                    <div id="colorpicker201" class="colorpicker201"></div>
                    <input type="button" onclick="showColorGrid2('color','sample_1');" value="...">&nbsp;<input type="text" ID="color" name="color" size="4" value="<%=color%>">&nbsp;<input type="text" ID="sample_1" size="1" value="">
                </td>
            </tr>
            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=submit value="儲存">
                </td>
            </tr>
        </table>

    </td>
    </tr>
    </table>
    </center>

    </form>
</body>
