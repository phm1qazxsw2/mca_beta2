<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=11;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,403))
    {
        response.sendRedirect("authIndex.jsp?code=403");
    }
%>
<%@ include file="leftMenu11.jsp"%>
<%
JsfAdmin ja=JsfAdmin.getInstance();

User[] u=ja.getAccountUsers(_ws.getBunitSpace("userBunitAccounting"));

if(u==null)
{
	out.println("尚未設定使用者,無法連接新帳戶至使用者!!<br><br>");
    out.println("請至<a href=\"addUser.jsp\">新增使用者</a>產生");
	return;
}
%>

<br>
<script>
	function goAlert()
	{
		window.location.reload();
	}

</script>

<%
JsfPay jp=JsfPay.getInstance();
Tradeaccount[] ct=jp.getAllTradeaccount(_ws.getBunitSpace("bunitId"));

%>
 
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>零用金帳號列表 </b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:openwindow_phm('addTradeaccount.jsp','新增零用金帳號',350,400,true);"><img src="pic/add.gif" width=13 border=0>&nbsp;新增零用金帳號</a> 
<br><br>
<% 

if(ct==null)
{
	out.println("<blockquote>目前沒有資料</blockquote>");
	return;
}

%>

<center>
	
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>編號</td>
			<td>名稱</td>	
			<td>排序</td>	
			<td>使用人</td>				
			<td>狀態</td>	
			<td></td>		
		</tr>
		<% 
			UserMgr um=UserMgr.getInstance();
			for(int i=0;i<ct.length;i++)
			{ 
		 %>  
		  	<form action="modifyTradeaccount.jsp" method="post">
		   	<tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td>
		<%
		   		
		   	String filePath2 = request.getRealPath("./")+"accountAlbum/"+ct[i].getId();
		 	File FileDic2 = new File(filePath2);
			File files2[]=FileDic2.listFiles();

			File xF2=null; 
		
			if(files2 !=null)
			{ 
				for(int j2=0;j2<files2.length;j2++)
				{ 
					if(!files2[j2].isHidden())
						xF2 =files2[j2] ;
				} 
			}
		
			if(xF2 !=null && xF2.exists())
			{
%>
			<img src="accountAlbum/<%=ct[i].getId()%>/<%=xF2.getName()%>" width=150 border=0>   
			<br>
			<a href="deleteTradeAlbum.jsp?ctId=<%=ct[i].getId()%>" onClick="javascript:return(confirm('確認刪除此照片?'))"><img src="pic/delete.gif" border=0>刪除此照片</a>
<%	
		   	}else{
%> 
			[尚未上傳]<br>  
			<a href="#" onClick="javascript:openwindow72a('<%=ct[i].getId()%>');return false">上傳</a>
			
<%		   		
		   	}
		   		
		   		%></td>		
		   		<td><input type=text name="tradename" value="<%=ct[i].getTradeaccountName()%>"  size=10></td>			

				<td>
					<input type=text name="tradeAccountOrder" value="<%=ct[i].getTradeAccountOrder()%>" size=3>
				</td>	
		   		<td>
		   				<%
		   				if(ct[i].getTradeaccountUserId()!= ud2.getId() && ud2.getUserRole()!=2)
						{		   						
							User ux=(User)um.find(ct[i].getTradeaccountUserId());
							out.println(ux.getUserFullname()+"("+ux.getUserLoginId()+")");
		   				%>
		   					<input type=hidden name="authId" value="<%=ct[i].getTradeaccountUserId()%>">
		   				<%
		   				}else{			
		   				%>
		   					<select name="authId" size=1>
		   				<%
		    				for(int j=0;j<u.length ;j++)
		    				{
		    			%>	
								
                        <option value="<%=u[j].getId()%>" <%=(u[j].getId()==ct[i].getTradeaccountUserId())?"selected":""%>><%=u[j].getUserFullname()%>(<%=u[j].getUserLoginId()%>)</option>
		   				<%				
		   					}		
		   				%>
		   					</select>		
		   				<%
		   				}
		   				%>
		   		</td>
				<td>
					<input type=radio name="active" value="1" <%=(ct[i].getTradeaccountActive()==1)?"checked":""%>>使用中
					<input type=radio name="active" value="0" <%=(ct[i].getTradeaccountActive()==0)?"checked":""%>>停用
 
					<input type=hidden name="ctId" value="<%=ct[i].getId()%>">		
					 <input type=submit value="修改">
				</form>		
					 
				</td> 
				<tD> 
					<a href="deleteCT.jsp?ctId=<%=ct[i].getId()%>" onClick="javascript:return(confirm('確認刪除?'))"><img src="pic/delete.gif" border=0>刪除此帳戶</a>
				</tD>
				</tr>  				
			
		 <%
		 	}
		 %> 
 	</table>
		
	</td>
	</tr>
	</table> 
	<div align=center>註: 排序數字越大,位置越前面.</div>
	
    </center> 
    <br>
    <br>


<%@ include file="bottom.jsp"%>