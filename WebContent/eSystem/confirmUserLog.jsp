<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=8;
    int leftMenu=0;    
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    int userLog=0;
    try{
        userLog=Integer.parseInt(request.getParameter("userlogId"));
    }catch(Exception ex){}

    UserlogMgr umx=UserlogMgr.getInstance();

    Object[] objs = umx.retrieve("userConfirm='0' and id<='"+userLog+"' and UserlogUserId='"+ud2.getId()+"'", "");

    if (objs!=null && objs.length>0){

        Userlog[] u =new Userlog[objs.length];

        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Userlog)objs[i];
            u[i].setUserConfirm(1);
            umx.save(u[i]);
        }
    }

    response.sendRedirect("userIndex.jsp");
%>
