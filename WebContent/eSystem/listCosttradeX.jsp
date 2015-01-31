<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>
<%

int coId=Integer.parseInt(request.getParameter("ctId"));

CosttradeMgr ctm=CosttradeMgr.getInstance();
Costtrade ct=(Costtrade)ctm.findX(coId, _ws.getBunitSpace("bunitId"));

if(ct==null)
{
    %><script>alert("資料不存在");history.go(-1)</script><%
    return;
}
%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>&nbsp;<%=ct.getCosttradeName()%></b>
&nbsp;&nbsp;
<b>基本資料</b>|
<a href="listCTClientAccount.jsp?ctId=<%=coId%>">匯款帳號</a> |  
<a href="listCTBigItem.jsp?ctId=<%=coId%>">會計科目設定</a>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<div class=es02 align=right><a href="listCosttrade.jsp"><img src="pic/last2.png" border=0 width=12>&nbsp;回廠商列表</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<br>
<blockquote>
<form action="modifyCosttradeDetail.jsp" method="post"> 


	<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>	
		<td>廠商名稱</td>
		<td bgcolor=ffffff>
            <input type="text" name="cname" size="20" value="<%=(ct.getCosttradeName()==null)?"":ct.getCosttradeName()%>"></tD>
	    </tr>
		<tr bgcolor=#f0f0f0 class=es02>	
		<td>狀態</td>
		<td bgcolor=ffffff>
                    <input type="radio" name="active" value="1" <%=(ct.getCosttradeActive()==1)?"checked":""%>>使用中
                    <input type="radio" name="active" value="0" <%=(ct.getCosttradeActive()==0)?"checked":""%>>停用
        </tD>
	    </tr>
        <tr bgcolor=#f0f0f0 class=es02>	
            <td>統一編號</td>
            <td bgcolor=ffffff><input type="text" name="uNumber" size="10" value="<%=(ct.getCosttradeUnitnumber()==null)?"":ct.getCosttradeUnitnumber()%>"></tD>
        </tr>
        <tr bgcolor=#f0f0f0 class=es02>	
            <td>電話</td>
            <td bgcolor=ffffff><input type="text" name="phone1" size="10" value="<%=(ct.getCosttradePhone1()==null)?"":ct.getCosttradePhone1()%>"></tD>
        </tr>
        <tr bgcolor=#f0f0f0 class=es02>	
            <td>傳真</td>
            <td bgcolor=ffffff><input type="text" name="phone2" size="10" value="<%=(ct.getCosttradePhone2()==null)?"":ct.getCosttradePhone2()%>"></tD>
        </tr>
        <tr bgcolor=#f0f0f0 class=es02>	
            <td>地址</td>
            <td bgcolor=ffffff><input type="text" name="address" size="40" value="<%=(ct.getCosttradeAddress()==null)?"":ct.getCosttradeAddress()%>"></tD>
        </tr>
 
             
		<tr bgcolor=#f0f0f0 class=es02>	
		<td>聯絡人</td>
		<td bgcolor=ffffff><input type="text" name="contactor" size="10" value="<%=(ct.getCosttradeContacter()==null)?"":ct.getCosttradeContacter()%>"></tD>
	</tr> 
	<tr bgcolor=#f0f0f0 class=es02>	
		<td>手機</td>
		<td bgcolor=ffffff><input type="text" name="mobile" size="20" value="<%=(ct.getCosttradeMobile()==null)?"":ct.getCosttradeMobile()%>"></tD>
	</tr> 

	<tr bgcolor=#f0f0f0 class=es02>	
		<td>備註</td>
		<td bgcolor=ffffff>
			<textarea name="ps" rows=3 cols=35><%=(ct.getCosttradePs()==null)?"":ct.getCosttradePs()%></textarea>
		</tD>
	</tr>
  	<tr class=es02>	
  		<td colspan=2>
  			<center>
			<input type="hidden" name="ctId" value="<%=coId%>">    			
			<input type=submit value="修改">
			</center>	
		</td>
  	</tr>
 </table>
	</td>
	</tR>
	</table>
</form>

</blockquote> 
<%@ include file="bottom.jsp"%>