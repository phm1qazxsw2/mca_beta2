<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    String xbirth=request.getParameter("xbirth");

    if(xbirth !=null){

        xbirth=xbirth.trim();
    }        


    pd2.setPaySystemBirthWord(xbirth);

    pmx2.save(pd2);
%>

<br>
<br>
<blockquote>
    <div class=es02>
        修改完成.
    </div>
</blockquote>
