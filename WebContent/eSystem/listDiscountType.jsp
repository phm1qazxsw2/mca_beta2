<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<body onload="doinit();">
<%

    int topMenu=1;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,105))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=7");
    }

%>
<%@ include file="leftMenu1.jsp"%> 

<br>
<script>
<% 
	String m=request.getParameter("m");
	
	if(m!=null && m.equals("1"))
 
	{ 
%>
		alert('修改成功!');
<%
	}else if(m!=null && m.equals("2"))
 
	{ 
%>		
		alert('新增完成!');
<%
	}
%>	
</script>

<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0 width=12>&nbsp;<b>新增折扣項目</b></div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
<form name=f1 action="addDiscountType.jsp" method="post">

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr bgcolor=#f0f0f0 align=left valign=middle class=es02> 
	<td>折扣項目</td>
	<td bgcolor=ffffff><input type=text name="typeName" size=15></td>
</tr>

<%
    // ####### 會計科目東東 #######
    VoucherService vsvc = new VoucherService(0, _ws.getSessionBunitId());
    String cond = "t=4";
%>
<link rel="stylesheet" href="css/auto_complete.css" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/auto_complete.js"></script>
<script type="text/javascript" src="js/string.js"></script>
<script src="acode_data.jsp?<%=cond%>"></script>
<script src="js/billitem_acctcode.js"></script>
<script>
function doinit()
{
    new AutoComplete(aNames, 
        document.getElementById('acctcode'), 
        document.getElementById('codetip'), 
        -1,
        ajax_get_name
    );	    
}
</script>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    列帳科目(借方)
                </td>
                <td bgcolor=#ffffff colspan=2>
                    <div style="position:relative;overflow:visible;">
                        <input type=text id="acctcode" name="acctcode" size=7 autocomplete=off>
                        <div id="codetip" style="position:absolute;left:0px;top:21px;visibility:hidden;border:solid green 2px;background-color:white;z-index:1"></div>
                        <span onclick="find_acctcode('<%=cond%>')"><img src="pic/mirror.png" width=10></span>
                        <span id="acodename"></span>
                    </div>
                </td>
            </tr>
<%  // ####### end of 會計科目東東 ####### %>


<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
<td valign=top>註解</td>
<td bgcolor=ffffff><textarea name="typePs" rows=2 cols=25></textarea></td>
</tr>
<tr class=es02>
	<td colspan=2 align=middle>
		<input type=submit value="新增" onClick="javascript:confirm('確認新增?')">
	</td>
</tr>
</table> 
</td>
</tr>
</table>

</form>
</blockquote>

<%

JsfAdmin ja=JsfAdmin.getInstance();	
DiscountType[] dt=ja.getAllDiscountType(_ws.getMetaBunitSpace("bunitId"));
%>
<br>
<div class=es02> 
<B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0 width=12>&nbsp;管理折扣項目</b>
</div>

<%
if(dt ==null)
{
	out.println("<br><br><blockquote>目前沒有資料</blockquote><br>");
	return;
}
%>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>



<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#f0f0f0 align=left valign=middle>
<td class=es02><b>名稱</b></td> 
<td class=es02><b>科目</b></td> 
<td class=es02><b>註解</b></td> 
<td class=es02><b>狀態</b></td> 
<td class=es02></tD>

</tr>

<%
for(int i=0;i<dt.length;i++)
{
    String acctcode = (dt[i].getAcctcode()==null)?"":dt[i].getAcctcode();
%>

<form action="modifyDiscountType.jsp" method="post">

<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
<td class=es02>
	<input type=text name="typeName" value="<%=dt[i].getDiscountTypeName()%>" size=10>
</td>
<td class=es02>
	<input type=text name="acctcode" value="<%=acctcode%>" size=7>
</td>
<td class=es02>
	<textarea name="typePs" rows=2 cols=20><%=dt[i].getDiscountTypePs()%></textarea>
</td>
<td class=es02>
<input type="radio" name="typeActive" value=1 <%=(dt[i].getDiscountTypeActive()==1)?"checked":""%>>使用中
<input type="radio" name="typeActive" value=0 <%=(dt[i].getDiscountTypeActive()==0)?"checked":""%>>停用
</td>
<td class=es02>
<input type=hidden name="typeid" value="<%=dt[i].getId()%>">
<input type=submit value="修改" onClick="javascript:confirm('確認修改?')">
</td>
</tr>

</form>
<%
}
%>
</table>
</td>
</tr>
</table>

</blockquote>
</body>
<!--- end 主內容 --->


<%@ include file="bottom.jsp"%>
