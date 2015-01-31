<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    Acode a = null;
    AcodeMgr amgr = AcodeMgr.getInstance();
    try {
        a = amgr.find("id=" + request.getParameter("a"));
    }
    catch (Exception e) {}
    boolean isMain = (a==null);
%>
<script src="js/string.js"></script>
<script src="js/formcheck.js"></script>
<script>
    function checkCode(thisForm){        
        if(trim(thisForm.acctCode.value).length!=3) {
            alert('後三碼限定為三位數字');
            thisForm.acctCode.focus();
            return false;
        }
        if (trim(thisForm.name.value).length==0) {
            alert('請輸入主科目的名稱');
            thisForm.name.focus();
            return false;
        }
        return true;    
    }
</script>

<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0 width=14>&nbsp;新增會計主科目</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  	
<center>

<form action="acode_add2.jsp" method="post" onsubmit="return checkCode(this)">

<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>
            主科目編號:
        </td>
        <td bgcolor=ffffff>
            <table class=es02>
                <tr border=0 class=es02>        
                <td>第一碼</td>
                <td>
                <select name="firstCode">
                    <option value="1">1 資產</option>
                    <option value="2">2 負債</option>
                    <option value="3">3 業主權益</option>
                    <option value="4">4 營業收入</option>
                    <option value="5">5 營業成本</option>
                    <option value="6">6 營業費用</option>
                    <option value="7">7 業外收益及費損</option>
                </select>
                </td>
                <td>
                    後三碼
                </td>
                <td>
                    <input type=text name="acctCode" value="" size=6 maxlength=3>
                </td>
            </tr>
            </table>
        </td>
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
        <td>        
        主科目名稱:
        </td>
        <td bgcolor=ffffff>
        <input type=text name="name" value="">
        </td>
    </tr>
    <tr bgcolor=#f0f0f0 class=es02>
        <td colspan=2 align=middle>
            <input type=submit value="新增">
        </td>
    </tr>
    </table>
    </td>
    </tr>
    </table>

</form> 	
</center>
