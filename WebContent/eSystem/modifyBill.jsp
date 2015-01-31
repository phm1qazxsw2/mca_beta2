<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<div class=es02>

&nbsp;&nbsp;&nbsp;<img src="pic/user.gif" border=0> <b>帳單類型修改</b>
&nbsp;&nbsp;&nbsp;
<a href="listBills.jsp"><img src="pic/last.gif" border=0 width=12> &nbsp;回上一頁</a>

</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<%
    int billId=Integer.parseInt(request.getParameter("bId"));
    Bill b = BillMgr.getInstance().find("id="+billId +" and billType=" + Bill.TYPE_BILLING);

    if(b==null) 
    {
%>        
    <br>
    <br>
    <blockquote>    
        <div class=es02>
            沒有此帳單資料. <br><br>

            <a href="#" onClick="history.go(-1)">回上一頁</a>
        </div>
    </blockquote>
<%
        return;
    }        
%>
<br>
<br>
<center>

<form action="modifyBill2.jsp" border=0>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff class=es02 valign=top>
        <td bgcolor=f0f0f0>
            內部作業名稱 
        </td>
        <td>
            <input type=text name="name" value="<%=b.getName()%>">
        </tD>
    </tr>
	<tr bgcolor=#ffffff class=es02 valign=top>
        <td bgcolor=f0f0f0>
            實際帳單抬頭 
        </td>
        <td>
            <input type=text name="prettyName" value="<%=b.getPrettyName()%>">
        </tD>
    </tr>
    <tr bgcolor=#ffffff class=es02 valign=top>
        <td bgcolor=f0f0f0>
            銷帳方式 
        </td>
        <td>
            <input type=radio name="w" value="1" <%=(b.getBalanceWay()==1)?"checked":""%>> 舊帳單先銷 &nbsp;<br> 
            <input type=radio name="w" value="0" <%=(b.getBalanceWay()==0)?"checked":""%>> 跳過未繳舊帳單
        </tD>
    </tr>
    <tr bgcolor=#ffffff class=es02 valign=top>
        <td bgcolor=f0f0f0>
            使用狀態 
        </td>
        <td>
            <input type=radio name="status" value="1" <%=(b.getStatus()==1)?"checked":""%>> 使用中<br> 
            <input type=radio name="status" value="0" <%=(b.getStatus()==0)?"checked":""%>> 停用
        </tD>
    </tr>
    <tr>
        <td colspan=2 align=middle>
            <input type=hidden name="bid" value="<%=b.getId()%>">
            <input type=submit value="確認修改">
        </td>
</form>
    </tr>
    </table>


        </td>
        </tr>
        </table>
    </center>

    

