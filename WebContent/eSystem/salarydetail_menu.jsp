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
                if(unpaid_total >0){
                    String backurl2 = "salary_detail.jsp?" + request.getQueryString();
                    String payurl = "salary_batchpay.jsp?via="+BillPay.SALARY_CASH+"&o=" + java.net.URLEncoder.encode(pay_sb.toString()) + "&p=1&t=" + java.net.URLEncoder.encode(title,"UTF-8") + "&backurl=" + java.net.URLEncoder.encode(backurl2);
               %> 
                  <a href="<%=payurl%>"><font color=5f5f5f>全部未付:<%=mnf3.format(unpaid_total)%>元</font></a>
                <%  }else{  %>
                  <font color=5f5f5f>全部未付金額:<%=unpaid_total%>元</font>
                <%  }%>
                 
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
                <a href="salary_detail2.jsp?sid=<%=membrId%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>&poId=-1">
                <font color="<%=(reportId==-1)?"#ffffff":"5F5F5F"%>">薪資統計</font></a>
            </td>
            </td>
        </tr>
        <!--
        <tr height=25>
            <td></td>
            <td colspan=2 align=left class=es02>
                 繳費資料設定
            </td>
        </tr>
        -->