<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="org.apache.poi.hssf.usermodel.*" %>
<%@ page import="org.apache.poi.hssf.util.HSSFColor" %>
<%@ page import="org.apache.poi.hssf.util.Region" %>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,302))
    {
        response.sendRedirect("authIndex.jsp?code=302");
    }
%>
<%
    int pid = Integer.parseInt(request.getParameter("pid"));
    BillPayInfo bpay = BillPayInfoMgr.getInstance().find("billpay.id=" + pid);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd HH:mm");
%>
<br>

<div class=es02>
<b>&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/excel2.gif" border=0>&nbsp薪資匯款檔案</b> 
&nbsp;&nbsp;

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<center>

<form action="salary_excel.jsp" method="post">
<table width="58%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>上次產生記錄</td>
        <td bgcolor=ffffff>
        <%
            if (bpay.getExportDate()>0) {
                User u = (User) ObjectService.find("jsf.User", "id=" + bpay.getExportUserId());
                out.println(sdf2.format(new Date(bpay.getExportDate())) + "-" + u.getUserLoginId());
            }
            else {
                out.println("無");//沒有產生記錄
            }
       %>
        </td>
	</tr>
    <tr bgcolor=#f0f0f0 class=es02>
		<td>匯款日期</td>
        <td bgcolor=ffffff nowrap>
            <input type=text name="payDate" value="<%=sdf.format(new Date())%>" size=10>
            <br>格式說明: 西元年/月份/日期
        </td>
	</tr>
    <tr bgcolor=ffffff class=es02>
        <td colspan=2 align=middle>
            <input type=hidden name="pid" value="<%=pid%>">
            <input type=submit value="確認產生">
        </td>
    </tr>
    </table>
</td>
</tr>
</table>
</form>

</center>
