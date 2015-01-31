<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    AcodeMgr amgr = AcodeMgr.getInstance();
    Acode parent = amgr.findX("id=" + request.getParameter("a"), _ws2.getAcodeBunitSpace("bunitId"));

    if (parent==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

    AcodeInfo ainfo = AcodeInfo.getInstance(parent);
%>
<script src="js/string.js"></script>
<script src="js/formcheck.js"></script>
<script>
    function checkCode(thisForm){        
        if(trim(thisForm.subcode.value).length!=3 || !IsNumeric(thisForm.subcode.value, true)) {
            alert('次科目限定為三位數字');
            thisForm.subcode.focus();
            return false;
        }
        if (trim(thisForm.name.value).length==0) {
            alert('請輸入次科目的名稱');
            thisForm.name.focus();
            return false;
        }
        return true;    
    }
</script>

<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0 width=14>&nbsp;新增會計次科目</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  	
<center>

<form action="acode_add_sub2.jsp" method="post" onsubmit="return checkCode(this)">
<input type=hidden name=parentId value="<%=parent.getId()%>">
<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

    <table width="100%" border=0 cellpadding=4 cellspacing=1 class=es02>
    <tr bgcolor="#f0f0f0">
        <td>主科目</td>
	    <td bgcolor="white">
            <%=ainfo.getName(parent)%>
        </tD>
    </tr>
	<tr bgcolor="#f0f0f0">
		<td>次科目序號</td>
        <td bgcolor="white">
    		<input type=text name=subcode size=4 maxlength=3 value="">
            <br>
             以三碼為限    
		</td>
	</tr>
	<tr bgcolor="#f0f0f0">
		<td>次科目名稱</td>
        <td bgcolor="white">
    		<input type=text name="name" value=""><br>說明:不含主科目的部分
		</td>
	</tr>

	<tr bgcolor="#f0f0f0">
		<td colspan=2 align=center>
			<input type=submit value="新增">
		</td>
	</tr>
    </table>

</td>
</tr>
</table>

</form> 	
</center>
