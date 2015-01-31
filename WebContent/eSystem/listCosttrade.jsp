<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>
<%
JsfAdmin ja=JsfAdmin.getInstance();
Costtrade[] ct=ja.getAllCosttrade(_ws.getBunitSpace("bunitId")); 	
%> 
<br> 
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>廠商列表</b> 
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onClick="javascript:openwindow71();return false"><img src="pic/add.gif" width=15 border=0>&nbsp;新增廠商</a>
</div>
<br>
<%

if(ct==null)
{
%>
    <blockquote>
        <div class=es02>
            目前沒有資料.
        </div>
    </blockquote>
    <%@ include file="bottom.jsp"%>
<%
	return;
}
%>
<center>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

		<tr bgcolor=#ffffff align=left valign=middle>
			<td bgcolor=#f0f0f0 class=es02 align=middle width=150>狀態 / 廠商名稱</td>	
            <td bgcolor=#f0f0f0 class=es02 align=middle width=50>電話</td>	
            <td bgcolor=#f0f0f0 class=es02 align=middle width=50>傳真</td>
			<td bgcolor=#f0f0f0 class=es02 align=middle width=50>聯絡人</td>	
			<td bgcolor=#f0f0f0 class=es02 align=middle width=50>手機</td>
            <td bgcolor=#f0f0f0 class=es02 width=200 nowrap></td>		
		</tr>
		<%
			for(int i=0;i<ct.length;i++) 
			{ 
		 %>  
            <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		   		<td class=es02><%=(ct[i].getCosttradeActive()==1)?"<img src=\"pic/yes.gif\" border=0 width=15>":"<img src=\"pic/no.gif\" border=0  width=15>"%>
<%=ct[i].getCosttradeName()%></td>			
                <td class=es02><%=ct[i].getCosttradePhone1()%></td>
                <td class=es02><%=ct[i].getCosttradePhone2()%></td>
				<td class=es02 align=middle>
					<%=(ct[i].getCosttradeContacter()==null)?"":ct[i].getCosttradeContacter()%>
				</tD>
				<td class=es02>
					<%=(ct[i].getCosttradeMobile()==null)?"":ct[i].getCosttradeMobile()%>
				</td>		
				<td class=es02 align=middle>
					   <a href="listCosttradeX.jsp?ctId=<%=ct[i].getId()%>">詳細資料</a>
                        |
                       <a href="listCTClientAccount.jsp?ctId=<%=ct[i].getId()%>">匯款帳號</a>
                        |
                       <a href="listCTBigItem.jsp?ctId=<%=ct[i].getId()%>">會計科目設定</a>
				</td>  
				</tr>  				
		 <%
		 	}
		 %> 
 			</table>
           
        </td>
	    </tr>
	</table>
    </center>
    <BR>
    <BR>
<%@ include file="bottom.jsp"%>