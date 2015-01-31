<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%
     JsfAdmin ja=JsfAdmin.getInstance();
     String m=request.getParameter("m");
 
    
 SimpleDateFormat sdfLog=new SimpleDateFormat("MM/dd HH:mm");

%>
<br>

&nbsp;&nbsp;&nbsp;<img src="pic/user.gif" border=0> <b>修改密碼</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<%
    String oldPa=request.getParameter("oldPa");
    String newPa=request.getParameter("newPa");

    UserMgr um=UserMgr.getInstance();
    if(oldPa.equals(ud2.getUserPassword())){
        ud2.setUserPassword(newPa);
        um.save(ud2);

%>
        <blockquote>
            <div class=es02>
                修改完成.
            </div>
        </blockquote>
<%
    }else{
%>
        <blockquote>
            <div class=es02>
                修改失敗,與原密碼不符.
            </div>
        </blockquote>
<%
    }
%>
<%@ include file="bottom.jsp"%>