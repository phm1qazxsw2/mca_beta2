<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>

</td>
</tr>
</table>

<blockquote>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02 class=es02>

授權截止日期:<%=JsfAuth.getInstance().getAuthDate()%>

<br>
<br>
必亨商業軟體股份有限公司 (統編:28853612)

<br>
地址: 臺北市大安區羅斯福路二段93號19樓

<br>
電話: (02) 23693566
<br>

email: contact@phm.com.tw
<br>


</td></tr></table>

</blockquote>
<%
    for (int i=0; i<15; i++)
        out.println("<br>");
%>
<!--- end 表單01 --->



<!--- end 主內容 --->


<%@ include file="bottom.jsp"%>	