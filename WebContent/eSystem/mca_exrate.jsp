<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=5;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<script src="js/string.js"></script>
<script src="js/formcheck.js"></script>
<script>
    function check_submit(f)
    {
        if (!IsPositive(trim(f.rate.value))) {
            alert("Please enter a valid exchange rate");
            f.rate.focus();
            return false;
        }
        return true;
    }
</script>
<%
    ArrayList<McaExRate> rates = McaExRateMgr.getInstance().retrieveList("", "order by id desc");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<br>
&nbsp;&nbsp;<b>匯率設定</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table> 

<blockquote>
<form action=mca_exrate2.jsp method=post onsubmit="return check_submit(this)">
<table width="450" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff align=center>
                <td bgcolor=f0f0f0>
                    USD to TWD 匯率
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td>
                    　　<input type=text size=10 name="rate" value="<%=""%>"> ex: 33.5
                        <br><br>　　　
                </td>
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

<% if (rates.size()>0) { %>

  <table width="300" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
        <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=f0f0f0>
                <td>
                    Date
                </td>
                <td>
                    Exchange Rate
                </td>
            </tr>
<%
    for (int i=0; i<rates.size(); i++) { 
        McaExRate r = rates.get(i);
%>
            <tr class=es02 bgcolor=ffffff>
                <td nowrap>
                    &nbsp;&nbsp;<%=sdf.format(r.getStart())%>
                </td>
                <td nowrap>
                    &nbsp;&nbsp;<%=r.getRate()%>
                </td>
            </tr>
<%
    }
%>
        </table>
    </td>
    </tr>
</table>

<% } %>                

</blockquote>

<%@ include file="bottom.jsp"%>