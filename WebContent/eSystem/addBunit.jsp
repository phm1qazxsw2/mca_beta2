<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<body>
<div class=es02 align=left>
&nbsp;&nbsp;&nbsp;<img src="pic/tag1.png" border=0>&nbsp;新增考勤部門
</div>

    <center>
        <form name="f1" action="addBunit2.jsp" method="post">
        <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    考勤部門名稱：
                </td>
                <td>
                    <input type=text name="name">
                </td>
            </tr>
            <input type=hidden name="flag" value="0">
<!--
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    傳票類別：
                </td>
                <td>
                    <input type=radio name="flag" value="1" checked>會計系統
                    <input type=radio name="flag" value="0">考勤系統

                </td>
            </tr>
-->
            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                    <input type=submit value="新增" onClick="return(confirm('確認新增考勤部門?'))">
                </td>
            </tr>
        </table>

    </td>
    </tr>
    </table>
    </center>

    </form>
</body>
