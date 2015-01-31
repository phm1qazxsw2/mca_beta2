<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%
    JsfAdmin ja=JsfAdmin.getInstance();

    Authitem[] au=ja.getAllAuthitem();

    if(au ==null){
%>
        <br>
        <br>
        <blockquote>
            <div class=es02>
            系統尚未設定!
            </div>
        </blockquote>
        <%@ include file="bottom.jsp"%>        
<%
        return;
    }
%>
<br>
<br>
<b>&nbsp;&nbsp;&nbsp;&nbsp; 授權清單 </b>
<blockquote>
<table>
    <tr>
        <td></td>
        <td></td>
        <tD></td>
        <tD></td>
    </tr>
    <%
    for(int i=0;i<au.length;i++){

        int xnum=au[i].getNumber()%100;

        if(xnum==0){
    %>
    <tr>
        <form action="modifyAuthitem.jsp" method="post">
        <td colspan=2>
            <b><%=au[i].getAuthId()%></b>-
            <input type=text name="number" value="<%=au[i].getNumber()%>" size=5> - 
            <input type=text name="page" value="<%=au[i].getPagename()%>" size=8>
        </td>
        
        <tD>

            <input type=hidden name="id" value="<%=au[i].getId()%>">
            <input type=submit value="修改"></td>
        </form>
    </tr>
    <%  }else{   %>
    <tr>
        <form action="modifyAuthitem.jsp" method="post">
        <td width=50></td>
        <td>
            <b><%=au[i].getAuthId()%></b>-
            <input type=text name="number" value="<%=au[i].getNumber()%>" size=5> - 
            <input type=text name="page" value="<%=au[i].getPagename()%>" size=15>
        </td>
        <input type=hidden name="id" value="<%=au[i].getId()%>">
        <tD><input type=submit value="修改"></td>
        </form>
    </tr>
    <%  
        }   
    }                    
    %>
</table>
</blockquote>
---------------------------------------------------------------------
    <br>
    <b>新增授權項目:</b>
    <form action="addAuthitem.jsp" method="post">
    id <input type=text name="authId" value="" size=5>
    <input type=text name="number" value="" size=5> - 
    <input type=text name="page" value="" size=15>
    <input type=submit value="新增">    
    </form>




<%@ include file="bottom.jsp"%>