<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<script>
//##v2
function doCheck(f)
{
    if (f.n.value.length==0) {
        alert("薪資類型不可空白");
        f.n.focus();
        return false;
    }

    if (confirm("確定新增: " + f.n.value))
        return true;
    return false;
}
<%PaySystem pSystem = (PaySystem) ObjectService.find("jsf.PaySystem", "id=1");%>
var designated_ok = <%=((pSystem.getPaySystemATMActive()==1) || (pSystem.getPaySystemATMActive()==0))?"true":"false"%>;
</script>
<body>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;<font color=blue>設定新的薪資類型</font>&nbsp;&nbsp;&nbsp;&nbsp;<a href="list_salary_bills.jsp"><img src="pic/last.gif" border=0 width=12>&nbsp;回上一頁</a>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0>
	<tr bgcolor=#ffffff align=left valign=middle> 
        <td valign=top width=30 align=middle>
        </td>            
        <td valign=top width=120 align=middle>
            <img src="pic/s7.gif" border=0>
        </td>
        <td valign=top>

<form name="f1" action="add_salary_bill2.jsp" method="post" onsubmit="return doCheck(this);">
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff align=left valign=middle class=es02>
                    <td bgcolor=f0f0f0>
                        薪資類型的名稱：
                    </td>
                    <td>
                    <input type=text name="n" size=15>
                    </td>
                </tr>
                <tr bgcolor=#ffffff align=left valign=middle class=es02>
                    <td bgcolor=f0f0f0>可編輯權限：</tD>
                    <td>                
                            <% if (ud2.getUserRole()<=2) { %>
                                <input type=radio name="priv" value="2" checked>僅限經營者<br> <% } %>
                            <% if (ud2.getUserRole()<=3) { %>
                                <input type=radio name="priv" value="3" <%=(ud2.getUserRole()==3)?"checked":""%>>經營者 + 會計 <br><% } %>
                            <% if (ud2.getUserRole()<=4) { %>
                                <input type=radio name="priv" value="4" <%=(ud2.getUserRole()==4)?"checked":""%>>經營者 + 會計 + 行政 <br><% } %>
                            <% if (ud2.getUserRole()<=5) { %>
                                <input type=radio name="priv" value="5" <%=(ud2.getUserRole()==5)?"checked":""%>>經營者 + 會計 + 行政 + 老師
                            <%  }   %>

                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan=2 align=middle>
                    <input type=submit value="新增"> &nbsp; <input type=button value="回上一頁" onclick="history.go(-1)"> 
                    </td>
                </tr>
            </table>
            </td>
            </tr>
            </table>
            </form>
    </td>
    </tr>
    </table>
</body>