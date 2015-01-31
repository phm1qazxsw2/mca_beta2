<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    int ctId=Integer.parseInt(request.getParameter("ctId"));

    CosttradeMgr ctm=CosttradeMgr.getInstance();
    Costtrade ct=(Costtrade)ctm.find(ctId);
    
    JsfAdmin ja=JsfAdmin.getInstance();
%>
<div class=es02>
&nbsp;&nbsp;<b><%=ct.getCosttradeName()%></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="listCosttradeX.jsp?ctId=<%=ctId%>" target="_top"><IMG src="pic/fix.gif" target="_top" border=0 width=12>修改資料</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>
<div class=es02 align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>基本資料</b></div>
	<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>	
            <td width=25%>廠商名稱</td>
            <td  width=25% bgcolor=ffffff>
            <%=(ct.getCosttradeName()==null)?"":ct.getCosttradeName()%></tD>
            <td width=25%>統一編號</td>
            <td  width=25% bgcolor=ffffff><%=(ct.getCosttradeUnitnumber()==null)?"":ct.getCosttradeUnitnumber()%></tD>
        </tr>
        <tr bgcolor=#f0f0f0 class=es02>	
            <td>電話</td>
            <td bgcolor=ffffff><%=(ct.getCosttradePhone1()==null)?"":ct.getCosttradePhone1()%></tD>
            <td>傳真</td>
            <td bgcolor=ffffff><%=(ct.getCosttradePhone2()==null)?"":ct.getCosttradePhone2()%></tD>
        </tr>
		<tr bgcolor=#f0f0f0 class=es02>	
		<td>聯絡人</td>
		<td bgcolor=ffffff><%=(ct.getCosttradeContacter()==null)?"":ct.getCosttradeContacter()%></tD>
		<td>手機</td>
		<td bgcolor=ffffff><%=(ct.getCosttradeMobile()==null)?"":ct.getCosttradeMobile()%></tD>
	    </tr> 
        <tr bgcolor=#f0f0f0 class=es02>	
            <td>地址</td>
            <td bgcolor=ffffff colspan=3><%=(ct.getCosttradeAddress()==null)?"":ct.getCosttradeAddress()%></tD>
        </tr>
    	<tr bgcolor=#f0f0f0 class=es02>	
		<td>備註</td>
		<td colspan=3 bgcolor=ffffff>
            <%=(ct.getCosttradePs()==null)?"":ct.getCosttradePs()%>
		</tD>
        </tr>
        </table>
        </td>
        </tR>
        </table>

        </center>

<br>
        <br>
        <div class=es02 align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>匯款資訊:</b></div>
<%
    ClientAccount[] ca=ja.getClientAccountByCosttrade(ctId,false);

    if(ca==null){
%>
        <blockquote>
        <div class=es02>目前沒有資料</div>
        </blockquote>
<%
    }
%>
<br>
    <div class=es02 align=left>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="addClientAccount.jsp?ctId=<%=ctId%>" target="_top"><img src="pic/add.gif" border=0 width=12>&nbsp;新增匯款交易帳號</a>
    </div>
</br>
<%
    for(int i=0;ca !=null && i<ca.length;i++){
%>

    <center>
	<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
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
            <a href="modifyClientAccount.jsp?caId=<%=ca[i].getId()%>&backurl=<%=java.net.URLEncoder.encode("listCTClientAccount.jsp?ctId="+ctId)%>"><img src="pic/fix.gif" border=0>&nbsp;修改</a>
		</td>
	</tR>	
	</table>
	</td>
	</tR>
	</table>
    </center>

<%
    }
%>