<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='/WEB-INF/jsp/security.jsp'%>
<%
    //##v2
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
    JsfAdmin jadm = JsfAdmin.getInstance();
    DiscountType[] types = jadm.getAactiveDiscountType();
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

    var c = f.membr;
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

<html>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    Discount d = DiscountMgr.getInstance().find("id=" + id);
%>

<link rel="stylesheet" href="style.css" type="text/css">
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table bgcolor=#ff0000 background=pic/bg01.gif width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02><img src=pic/bg01.gif border=0></td>
</tr>
</table>


<!--- start 水平列書籤式按鈕 01 --->
<table bgcolor=#696A6E width="100%" height="24" border="0" cellpadding="4" cellspacing="0">
<tr align=left valign=middle>
<td class=es02r align=right></td>
</tr>
</table>
 
<br> 
 

<center>
<form name="f1" action="discount_modify2.jsp" method="post" onsubmit="return doCheck(this);">
<input type=hidden name="id" value="<%=id%>">
<input type=hidden name="type" value="<%=types[0].getId()%>">
<input type=hidden name=copystatus value='<%=Discount.COPY_NO%>'>

<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
 	<table width="100%" border=0 cellpadding=4 cellspacing=1>
<!--
    <tr bgcolor=ffffff class=es02>
            <td bgcolor="#f0f0f0">
                調整原因
            </TD>
            <TD>
                <select name="type">
                    <option value="0">--請選擇一個調整的理由--</option>
             <% for (int i=0; i<types.length; i++) {
System.out.println("## " + types[i].getId() + " # " + d.getType());
                   %><option value="<%=types[i].getId()%>"  <%=(types[i].getId()==d.getType())?"selected":""%>>
                   <%=types[i].getDiscountTypeName()%></option>
             <% } %>
                </select> (供統計用，不會出現在帳單上)
            </TD>
        </TR>
-->
    <tr bgcolor=ffffff class=es02>
            <td bgcolor="#f0f0f0">
                調整金額：
            </td>
            <td>
                <input type=text name=amount value="<%=0-d.getAmount()%>" size=10>

            </tD>
        </tr>
    <tr bgcolor=ffffff class=es02>
            <td bgcolor="#f0f0f0">註記：</td>
            <td>
                <textarea name=note rows=3 cols=30><%=d.getNote()%></textarea>
                <br>(供內部記錄，不會出現在帳單上) 
            </td>
        </tr>
        
        <tr bgcolor=ffffff class=es02>
            <td colspan=2 align=middle>
                <input type=submit value="儲存">
            </td>
        </tr>
        </table>
        
        </td>
        </tr>
        </table>
</form>

</center>