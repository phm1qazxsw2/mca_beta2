<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<br>
<center>

<form action="bill_modify_birth.jsp" method="post">

    <textarea name="xbirth" cols=30 rows=5><%=pd2.getPaySystemBirthWord()%></textarea>

    <br>
    <input type=submit value="修改">
</form>

</center>