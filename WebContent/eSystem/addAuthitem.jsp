<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">

<%
    AuthitemMgr amm=AuthitemMgr.getInstance();

    String pagex=request.getParameter("page");
    int num=Integer.parseInt(request.getParameter("number"));
    int authId=Integer.parseInt(request.getParameter("authId"));

    Authitem au=new Authitem();
    au.setAuthId(authId);
    au.setNumber   	(num);
    au.setPagename  (pagex);
    amm.createWithIdReturned(au);
    response.sendRedirect("authitemIndex.jsp");
%>