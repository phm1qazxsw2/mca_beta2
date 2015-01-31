<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2

    request.setCharacterEncoding("UTF-8");
    if(!checkAuth(ud2,authHa,602))
    {
        response.sendRedirect("authIndex.jsp?code=602");
    }
    String backurl = request.getParameter("backurl");
    System.out.println("## in tagtype_add.jsp backurl=" + backurl);
%>
<script>
function doSubmit(f)
{
    if (f.name.value.length==0) {
        alert("名稱不可空白");
        f.name.focus();
        return false;
    }
    return true;
}
</script>
<body>

<table border=0 width=100%>
<tr>
    <td align=middle valign=top class=es02>
        <img src="images/spacer.gif" width=40 border=0>
    </td>
    <td>
        <form name="f1" action="tagtype_add2.jsp" method="post" onsubmit="return doSubmit(this);">
        <input type=hidden name=backurl value="<%=backurl%>">
        <table width="200" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    名稱：
                </td>
                <td>
                    <input type=text name="name">
                </td>
            </tr>
            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=submit value="新增標籤類型">
                &nbsp;<a href="javascript:history.go(-1)">回上一頁</a>
                </td>
            </tr>
        </table>
        </form>
    </td>
    </tr>
    </table>
</body>
