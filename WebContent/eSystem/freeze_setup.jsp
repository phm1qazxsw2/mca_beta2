<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=5;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2-new.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd HH:mm");

    Freeze fs = EzCountingService.getFreeze(_ws.getBunitSpace("bunitId"));
    String fzTime = (fs==null)?"":sdf.format(fs.getFreezeTime());
%>
<script src="js/dateformat.js"></script>
<script>
    function check_submit(f)
    {
        if (!isDate(f.freezeTime.value, "yyyy/MM/dd")) {
            alert("請輸入正確的關帳日期");
            f.freezeTime.focus();
            return false;
        }
        return true;
    }
</script>


<br>
&nbsp;&nbsp;<b>關帳設定</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table> 

<blockquote>
<form action=freeze_setup2.jsp method=post onsubmit="return check_submit(this)">
<table width="450" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff align=center>
                <td bgcolor=f0f0f0>
                    關帳日:
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td>
                    　　　<input type=text size=10 name="freezeTime" value="<%=fzTime%>"> ex: 2009/03/02 
                    <br><br>　　　關帳日之前的帳不會再被更動(損益及資產負債表)
                    <% if (fs!=null) { %>
                    <br>　　　<a href="javascript:openwindow_phm('freeze_list.jsp','關帳記錄',500,400,false)">關帳記錄</a>
                    <% } %>                </td>
            </tr>

            <tr>
                <td bgcolor=ffffff valign=bottom align=middle>
                <input type=submit value="儲存">
                </td>
            </tr>
        </table>
    </td>
    </tr>
</table>
</form>
</blockquote>

<%@ include file="bottom.jsp"%>