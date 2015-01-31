<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<br>
<br>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/feeIn.png" border=0>學費銷帳-便利商店繳款</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<%
         DecimalFormat mnf = new DecimalFormat("###,###,##0");
         HttpSession session2=request.getSession();
            
         Vector status90=(Vector)session2.getAttribute("status90");
         Vector status2=(Vector)session2.getAttribute("status2");
%>
<blockquote>
<%
    if(status90 !=null && status90.size()>0){
%>
       <div class=es02>匯入<font color=blue>成功</font>的資料:</div>
        <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
        <td bgcolor="#e9e3de">
        
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=#f0f0f0 align=left valign=middle>
        <td>繳款人</td><td>繳款日期</td><td>繳款代號</td><td>金額</td><td>銷單編號</td><td>銷單金額</td><td></td>
        </tr>
        <%
        
        for(int i=0;i<status90.size();i++)
        {
            out.println((String)status90.get(i));
         } 
           
        
        %>
        </table>
        </td>
        </tr>
        </table>
        <BR>
        <BR>
      <%
        }else{
            out.println("<br><div class=es02><font color=blue>沒有匯入成功的資料</font></div><br><br>");
        }
            
        
        if(status2 !=null && status2.size()>0)
        {
    %>
            <div class=es02>匯入<font color=red>失敗</font>的資料:</div>
            <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
            
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#f0f0f0 align=left valign=middle>
                <td>原始資料</td><td>例外資訊</td><td></td>
                </tr>

                <%
                for(int i=0;i<status2.size();i++)
                {
                    out.println(status2.get(i));
                }
                %>
                </table>
            </tD>
            </tr>
            </table>
<%
        }else{
            out.println("<br><div class=es02><font color=blue>沒有匯入失敗資料</font></div><br>");
        }
%>

</blockquote>
<%@ include file="bottom.jsp"%>