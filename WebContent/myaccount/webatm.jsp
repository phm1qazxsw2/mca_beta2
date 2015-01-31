<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="../eSystem/style.css" type="text/css">
<%@ include file="topMenuAdvanced.jsp"%>
<%
    int sid =12; 
    String sidS=request.getParameter("sid");
    if(sidS!=null)
        sid=Integer.parseInt(sidS);
%>
 <BR>
<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;web ATM 設定</b>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<center>

<table cellpadding=0 cellspacing=0 border=0 width=800 height=700>
    <tr>
        <td valign=top>

                <table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td>
                            繳款銀行代號
                        </td>
                        <td class=es02 bgcolor=ffffff>
                            812 (台新銀行)
                        </td>
                    </tr>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td>
                            匯款帳號
                        </td>
                        <td class=es02 bgcolor=ffffff>
                            970500012-1
                        </td>
                    </tr>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td>
                            應繳金額
                        </td>
                        <td class=es02 bgcolor=ffffff>
                           12,000元
                        </td>
                    </tr>
                    <tr>
                        <td colspan=2 valign=middle align=middle bgcolor=ffffff>
                            <br>
                            <form action="http://tw.atm.money.yahoo.com/atm/" method="post" target="_blank">
                                <input type=submit value="前往Yahoo ATM">
                            </form>
                        </td>
                    </tr>
                    </table>
                </td>
                </tr>
                </table>
                <div class=es02 align=left>說明事項:再匯款完成後 銷帳作業預計需要半小時</div>

        </td>
    </tr>
</table>

</center>
<%@ include file="bottom.jsp"%>