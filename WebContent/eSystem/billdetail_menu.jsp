<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    DecimalFormat mnf3 = new DecimalFormat("###,###,##0");
%>

        <tr height=25>
            <td></td>
            <td colspan=2>
                <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
            </td>
        </tr> 

        <tr height=25>
            <td></td>
            <td colspan=2 align=left class=es02>
               <%
                if(unpaid_total >0 && checkAuth(ud2,authHa,103)){
               %> 


                  <a href="javascript:openwindow_phm('otc_pay_all.jsp?sid=<%=membrId%>','臨櫃繳款',500,500,true);"><font color=5f5f5f>全部未繳:<%=mnf3.format(unpaid_total)%>&nbsp;元</font></a>
                <%  }else{  %>
                  <font color=5f5f5f>全部未繳金額:<%=mnf3.format(unpaid_total)%>元</font>
                <%  }%>
                 
            </td>
        </tr>

<%
    if(pageType==0){
%>
        <tr height=25>
                 <%
                    if(reportId==-2)
                    {
                %>
                    <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                <%  
                  }else{
                        out.println("<td width=8></td>");
                    }
                %>
            <td bgcolor="<%=(reportId==-2)?"#6B696B":""%>" colspan=2 align=left class=es02>
                <a href="bill_detail2.jsp?sid=<%=membrId%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>&poId=-2">                <font color="<%=(reportId==-2)?"#ffffff":"5F5F5F"%>">帳戶餘額:<%=account_remain%>&nbsp;元</font></a>
            </td>
        </tr>



        <tr height=25>
            
                 <%
                    if(reportId==-1)
                    {
                %>
                    <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                <%  
                  }else{
                        out.println("<td width=8></td>");
                    }
                %>
            
            <td bgcolor="<%=(reportId==-1)?"#6B696B":""%>" colspan=2 align=left class=es02>
                <a href="bill_detail2.jsp?sid=<%=membrId%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>&poId=-1">
                <font color="<%=(reportId==-1)?"#ffffff":"5F5F5F"%>">繳費統計</font></a>
            </td>
            </td>
        </tr>
<%
    }

if(checkAuth(ud2,authHa,102)){
%>

     <tr height=25>
            <td></td>
            <td width=8></td>
            <td align=left class=es02>
<!--                 &nbsp;<a href="javascript:openwindow_phm('otc_prepay.jsp?sid=<%=membrId%>','預收',500,400,true)">預收 </a>-->
            </td>
        </tr>
<%
    }
    /*
            <tr height=25>
            <td></td>
            <td colspan=2 align=left class=es02>
                 繳費資料設定
            </td>
        </tr>
    */
    


%>

