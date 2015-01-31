<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopNotLogin.jsp"%>
<%
    String r=request.getParameter("r");
    
    if(r !=null){

        if(r.equals("1")){
%>
        <script>
            alert('請輸入五位數字.');
        </script>
<%
        }

        if(r.equals("2")){
%>
        <script>
            alert('沒有此教職員.');
        </script>
<%
        }
    }
%>
<br>
<br>
<%
    PaySystemMgr psm=PaySystemMgr.getInstance();
    PaySystem pZ2=(PaySystem)psm.find(1);
%>
<center>
    <form action="loginEvent2.jsp" method="post">
    <table>
    <tr>
        <td colspan=2 align=middle>
        <%=pZ2.getTopLogoHtml()%> <br><br><b>教職員線上考勤系統</b>
        　　<a href="javascript:parent.sch_qa(1);">Q&A</a>
        <br><br>
        </td>
    </tr>  

  <tr>
        <td class=es02>身份証後五碼: </td>
        <td><input type=text name="indexId"></td>
    </tr>
    <tr>
        <td colspan=2 align=middle>
            <input type=submit value="登入">
        </td>
    </tr>
    </table>
    </form>
</center>