<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=10;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu10.jsp"%>

<%
     
 	if(!AuthAdmin.authPage(ud2,3))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=8");
    }    

	DecimalFormat mnf = new DecimalFormat("###,###,##0");
	DecimalFormat nf = new DecimalFormat("###,##0.00");

	JsfPay jp=JsfPay.getInstance();
	Owner[] ow=jp.getAllOwner(_ws.getBunitSpace("bunitId"));

	if(ow==null)
	{
		out.println("<br><br><blockquote>目前沒有股東帳戶</blockquote>");
%>
		<%@ include file="bottom.jsp"%>	
<%
		return;
	}

	Ownertrade[] ot=jp.getAllOwnertrade(_ws.getBunitSpace("bunitId"));
	
	if(ot==null)
	{
		out.println("<br><br><blockquote>沒有交易資料</blockquote>"); 
%>
		<%@ include file="bottom.jsp"%>	
<%
		return;
	}

	Hashtable ha=new Hashtable();
	
	int totalAll=0;
	for(int i=0;i<ot.length;i++)
	{
		String otIdS=String.valueOf(ot[i].getOwnertradeOwnerId());
		String total=(String)ha.get(otIdS);
		
		
		int nowNum=0;
		if(ot[i].getOwnertradeInOut()==1)
			nowNum=ot[i].getOwnertradeNumber();
		else if(ot[i].getOwnertradeInOut()==0)
			nowNum=ot[i].getOwnertradeNumber()*-1;
		
		totalAll += nowNum ;
		
		if(total==null)
		{
			ha.put(otIdS,String.valueOf(nowNum));
		}else{
		
			int oldTotal=Integer.parseInt(total);
			int nowTotal=oldTotal+nowNum;
			ha.put(otIdS,String.valueOf(nowTotal));
		}
	}
%> 
<br>
<br>

<b>&nbsp;&nbsp;&nbsp;股東權益結算</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02 width=150>帳戶名稱</tD>
		<td bgcolor=#f0f0f0 class=es02 width=80>提取總額</td>
		<td bgcolor=#f0f0f0 class=es02 width=80>比例</td>
		<td bgcolor=#f0f0f0 class=es02 width=80></td>
	</tr>
	<%
        int nowtotal=0;
		for(int i=0;i<ow.length;i++)
		{
			int accountNum=0;
			
			String numS=(String)ha.get(String.valueOf(ow[i].getId()));
			
			if(numS!=null)
				accountNum=Integer.parseInt(numS); 
				
			float percentX=(float)0.00;	
			if(accountNum !=0 && totalAll!=0)		
				percentX=(float)accountNum/(float)totalAll*(float)100;

			
	%>
	<tr bgcolor=#ffffff >
		<td class=es02 width=150><%=ow[i].getOwnerName()%></tD>
		<td class=es02 width=80 align=right><%=mnf.format(accountNum)%></td>
		<td class=es02 width=80 align=right><%=nf.format(percentX)%>%</td>
		<td class=es02 width=80 align=middle><a href="listOwnerPerson.jsp?otId=<%=ow[i].getId()%>">交易明細</a></td>
	</tr>
	
	<%
            nowtotal+=accountNum;
		}
	%>
    <tr bgcolor=f0f0f0 class=es02>
       <td align=middle>小計</tD>
       <td align=right><b><%=mnf.format(nowtotal)%></b></td>
        <td colspan=2></tD>
    </tr>
	</table>
	
	</tD>
	</tR>
	</table>	
</blockquote>


<%@ include file="bottom.jsp"%>
	