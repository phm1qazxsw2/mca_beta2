<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,203))
    {
        response.sendRedirect("authIndex.jsp?code=203");
    }
%>
<%@ include file="leftMenu2.jsp"%>
<br>


<%
    JsfAdmin ad=JsfAdmin.getInstance();
    String m=request.getParameter("m");

    if(m!=null)
    {
%>
        <script>
            alert('修改完成!');
        </script>

<%  }   

    int type=1;
    String typeS=request.getParameter("type");
    if(typeS !=null)
        type=Integer.parseInt(typeS);
%>
<br>  
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0 width=14>&nbsp;雜費會計主科目-
<%
    switch(type){
        case 1:
            out.println("雜費支出科目(5,6)");
            break;
        case 2:
            out.println("雜費收入科目(4,7)");
            break;
        case 3:
            out.println("資產(1)");
            break;
        case 4:
            out.println("負債(2)");
            break;
        case 5:
            out.println("業主權益(3)");
            break;
    }

    BigItem[] bis=ad.getAllBigItem2ByType(type);
%>

</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<%=(type==3)?"":"<a href=\"ListBigItem.jsp?type=3\">"%>資產(1)<%=(type==3)?"":"</a>"%> | 
<%=(type==4)?"":"<a href=\"ListBigItem.jsp?type=4\">"%>負債(2)<%=(type==4)?"":"</a>"%> | 
<%=(type==5)?"":"<a href=\"ListBigItem.jsp?type=5\">"%>業主權益(3)<%=(type==5)?"":"</a>"%> | 
<%=(type==2)?"":"<a href=\"ListBigItem.jsp?type=2\">"%>雜費收入科目(4,7)<%=(type==2)?"":"</a>"%> | 
<%=(type==1)?"":"<a href=\"ListBigItem.jsp?type=1\">"%>雜費支出科目(5,6)<%=(type==1)?"":"</a>"%> | 

 
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>

<blockquote>

<a href="javascript:openwindow_phm('addBigItemX.jsp?bi=0&type=<%=type%>','新增會計主科目',400,300,true);">
<img src="pic/add.gif" border=0 width=14>&nbsp;新增會計主科目</a>
<%
if(bis==null)
{
%>
    <div class=es02>
       <center>目前沒有會計科目</center>
    </div>
<%
    return;
}
%>

<form action="listBigItem2.jsp" method="post">

<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>		
		<tr bgcolor=#f0f0f0 class=es02>
 			<td>顯示狀態&nbsp;&nbsp;&nbsp;主科目編號 - 主科目名稱</td><td>顯示狀態&nbsp;&nbsp;&nbsp;次科目編號-次科目名稱</td>
 		</tr>
        <tr>
            <td colspan=2 align=middle>
                <input type=submit value="確認修改">

            </td>
        </tr>
<%
SmallItemMgr sim=SmallItemMgr.getInstance();

for(int i=0;i<bis.length;i++)
{
    int bitActive=bis[i].getBigItemActive();
%>	
	<tr bgcolor=A9B0F6>
		<td colspan=2 class=es02>
		 	<font color=red>*</font>
                <input type=checkbox name="bId" value="<%=bis[i].getId()%>" <%=(bitActive==1)?"checked":""%>>     
                <%=bis[i].getAcctCode()%>-<%=bis[i].getBigItemName()%>

<a href="javascript:openwindow_phm('addBigItemX.jsp?bi=<%=bis[i].getId()%>&type=<%=type%>','編輯會計主科目',500,300,true);">
<img src="pic/fix.gif" border=0 width=14>&nbsp;編輯主科目</a> |

<a href="javascript:openwindow_phm('modifyCTBiX.jsp?bi=<%=bis[i].getId()%>','編輯廠商名單',600,500,true);">
<img src="pic/fix.gif" border=0 width=14>&nbsp;編輯廠商名單</a>
        </td> 
	</tr>


<%
	SmallItem[] si=ad.getAllSmallItemByBID(bis[i].getId());
	
	if(si !=null)
	{
		for(int j=0;j<si.length;j++)
		{
			String isiName=si[j].getSmallItemName();
			int isiActive=si[j].getSmallItemActive();

            //run Accounting code...
            /*
            String xcode=String.valueOf(j+1);
            int neerun=3-xcode.length();
            for(int k=0;k<neerun;k++)
            {
                xcode="0"+xcode;
            }
            si[j].setAcctCode(xcode);
            sim.save(si[j]);
			*/
%>
			<tr bgcolor=#ffffff class=es02>
			<td width=50%></td>
			<td width=50%>
                <input type=checkbox name="sid" value="<%=si[j].getId()%>" <%=(isiActive==1)?"checked":""%>>
                <%=si[j].getAcctCode()%>-<%=isiName%>
                <a href="javascript:openwindow_phm('modifySmallItem2.jsp?sid=<%=si[j].getId()%>','編輯會計次科目',400,300,true);"><img src="pic/fix.gif" border=0 width=14>&nbsp;編輯</a>
			</td> 
			</tr>
<%		
		
		}	
	}
%>
	<tr bgcolor=ffffff>
    <td></td>
	<td class=es02>
                &nbsp;<a href="javascript:openwindow_phm('modifySmallItem2.jsp?sid=0&bid=<%=bis[i].getId()%>','編輯會計主科目',400,300,true);"><img src="pic/add.gif" border=0 width=12>&nbsp;新增次項目</a>
	</td> 
	</tr>
<%
}
%>	
    <tr>
        <td colspan=2 align=middle>

            <input type="hidden" name="type" value="<%=type%>">
            <input type=submit value="確認修改">

        </td>
    </tr>
    
    </form>

</table>  
	 </td>
	  </tr>
	   </table>

</blockquote>
<br>
<br>
<%@ include file="bottom.jsp"%>

 

