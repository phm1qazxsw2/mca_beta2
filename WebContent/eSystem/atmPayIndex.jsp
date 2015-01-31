<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ page import="java.io.*" %>
<%@page import="org.apache.commons.fileupload.*" %>
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>

<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=7");
    }
%>

<br> 
<b>&nbsp;&nbsp;&nbsp;<img src="pic/feeIn.png" border=0> 學費銷帳-虛擬帳號</b>
<BR>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>

	<table width="50%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02> 
		<td>付款簡訊狀態</td>
 
		<td bgcolor=#ffffff class=es02> 
		<%
			PaySystemMgr em=PaySystemMgr.getInstance();
			PaySystem ps=(PaySystem)em.find(1);

			if(ps.getPaySystemMessageActive()==1) 
			{
		%>
				<img src="pic/yes.gif" border=0>
		<%
			}else{
		%>
				<img src="pic/no.gif" border=0>
		<%
			}
		%>	
		<a href="modifyPaySystem.jsp">(修改)</a>

		</tD>
	</tr>
	

	<tr bgcolor=#f0f0f0 class=es02> 
		<td>建議下載日期</td>
		<td bgcolor=#ffffff class=es02> 
<%

String filePath=application.getRealPath("/")+"eSystem/atmPay.txt";
String line="";
SimpleDateFormat sdf1=new SimpleDateFormat("yyyy/MM/dd");
Date now=new Date();
long nowTime=now.getTime();
long day1=(long)1000*60*60*24;
long beforeTime=nowTime-day1;
Date beforeDate=new Date(beforeTime);
try
{
    BufferedReader br = 
        new BufferedReader(new InputStreamReader(new FileInputStream(filePath)));
   
    while ((line=br.readLine())!=null)
    {
	Date startDate=sdf1.parse(line);
	
	
	if(startDate.getTime()>beforeDate.getTime())
	{
		out.println("<br><br><font color=red>目前已下載完最新的資料!!</font>");
		return;
	}
	out.println(line+" - "+sdf1.format(beforeDate));    
    }
}catch(Exception e)
{	}  

%>
		</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02> 
	<td>
	上傳檔案:
	</td>

<form name="form1" enctype="multipart/form-data" method="post" action="storeAtm.jsp">
	<td bgcolor=#ffffff class=es02> 
            <input type="file" name="File1" size="20" maxlength="20">
     </td>
     </tr>
     <tr>
     <td colspan=2>  
   	
     	 
            <center><input type="submit" value="上傳"></center>   
        </td>
    </tr>
		</table> 
	 </tD>
	  </tr>
	   </table>
	</form>		
	[查看 <a href="countStudentAccount.jsp">學生虛擬帳戶餘額</a>]    
	</blockquote>    
<br> 


<b>&nbsp;&nbsp;&nbsp;<img src="pic/feeIn.png" border=0> 學費銷帳-單筆虛擬帳號繳款</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<table>
<tr class=es02>	
<td>
&nbsp;&nbsp;&nbsp;&nbsp;單筆匯入:
</td>
<td>
<form action="payAtmSingle.jsp" method="post">
<textarea name="data" rows=5 cols=50></textarea>
<br>
<center><input type=submit value="上傳"></center>
</form>

</td>
</tr>
</table>
<%@ include file="bottom.jsp"%>