<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,203))
    {
        response.sendRedirect("authIndex.jsp?code=203");
    }
%>
<%@ include file="leftMenu2.jsp"%>
<%

int coId=Integer.parseInt(request.getParameter("ctId"));

CosttradeMgr ctm=CosttradeMgr.getInstance();
Costtrade ct=(Costtrade)ctm.find(coId);


if(ct==null)
{
	out.println("沒有此筆資料");
	return;
}
%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>&nbsp;<%=ct.getCosttradeName()%></b>
&nbsp;&nbsp;
<a href="listCosttradeX.jsp?ctId=<%=coId%>">基本資料</a>|
<b>匯款帳號</b> |  <a href="listCTBigItem.jsp?ctId=<%=coId%>">會計科目設定</a>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<div class=es02 align=right><a href="listCosttrade.jsp"><img src="pic/last.gif" border=0 width=15>&nbsp;回廠商列表</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<br>

<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="addClientAccount.jsp?ctId=<%=coId%>&backurl=<%=java.net.URLEncoder.encode("listCTClientAccount.jsp?ctId="+coId)%>"><img src="pic/add.gif" border=0 width=15>&nbsp;<font color=blue>新增匯款交易帳號</font></a>
</div>

<%
    JsfAdmin ja=JsfAdmin.getInstance();
    ClientAccount[] ca=ja.getClientAccountByCosttrade(coId,false);

    for(int i=0;ca !=null && i<ca.length;i++){
%>
    <blockquote>
	<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td><b>帳戶(<%=i+1%>)</b></td>
		<td bgcolor=#ffffff><%=ca[i].getClientAccountBankOwner()%></td>
		<td>使用狀態</td>
		<td bgcolor=#ffffff>
                <%=(ca[i].getClientAccountActive()==1)?"使用中":"停用"%>
		</td>
	</tR>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>銀行名稱</td>
		<td  bgcolor=#ffffff>
            <%=ca[i].getClientAccountBankName()%>
			代號:<%=ca[i].getClientAccountBankNum()%>
		</td>
		<td>分行名稱</td>
		<td bgcolor=#ffffff><%=ca[i].getClientAccountBankBranchName()%></td>
	</tR>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>帳號</td>
		<td colspan=3 bgcolor=#ffffff><%=ca[i].getClientAccountAccountNum()%></td>
	</tR>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>戶名</td>
		<td colspan=3 bgcolor=#ffffff><%=ca[i].getClientAccountAccountName()%></td>
	</tR>	
	<tr bgcolor=#f0f0f0 class=es02>
		<td>備註</td>
		<td colspan=2 bgcolor=#ffffff><%=ca[i].getClientAccountBankIdPs()%>
        <td bgcolor=ffffff align=middle>
            <a href="modifyClientAccount.jsp?caId=<%=ca[i].getId()%>&backurl=<%=java.net.URLEncoder.encode("listCTClientAccount.jsp?ctId="+coId)%>"><img src="pic/fix.gif" border=0>&nbsp;修改</a>
		</td>
	</tR>	
	</table>
	</td>
	</tR>
	</table>
    </blockquote>

    <%
        }

        if(ca==null){
    %>
            <blockquote>
               <div class=es02> 目前沒有設定.</div>

                <a href="addClientAccount.jsp"></a>
            </blockquote>
    <%
        }
    %>

    <BR>
    <BR>
<%@ include file="bottom.jsp"%>