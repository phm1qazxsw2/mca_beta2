<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,2))
    {
        response.sendRedirect("authIndex.jsp?page=9&info=1");
    }
%>
<%@ include file="leftMenu8.jsp"%>
<%

    int userId=Integer.parseInt(request.getParameter("userId"));
    User uu = (User) UserMgr.getInstance().findX(userId, _ws.getBunitSpace("userBunitAccounting"));

    if(uu==null)
    {
        out.println("沒有此筆資料");
        return;
    }

    JsfAdmin ja=JsfAdmin.getInstance();
    Authitem[] au=ja.getAllAuthitem();
    Authuser[] auu=ja.getAuthuserByUserId(userId);
    
    Hashtable ha=new Hashtable();
    
    for(int i=0;auu !=null && i<auu.length ; i++)
    {
       ha.put((Integer)auu[i].getAuthitemId(),"1");        
       //ha.put((Integer)auu[i].getId(),"1");        
    }

    UserMgr umm=UserMgr.getInstance();

    User u=(User)umm.find(userId);
    if(u ==null){
%>
        <br>
        <br>
        <blockquote>
        <div class=es02>
            找不到此使用者.
        </div>
        </blockquote>

<%
        return;
    }
%>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;<img src="pic/key2.png" border=0> <b><%=u.getUserFullname()%> 權限編輯</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  登入身份: <font color=blue><%=ja.getChineseRole(u.getUserRole())%></font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <a href="listAuthUser.jsp"><img src="pic/last2.png" border=0>&nbsp;回權限管理</a>

</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<br>
<blockquote>

<form action="modifyAuthuser.jsp" method="post">
<table width="70%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
        <td align=middle>主選單</td>
        <td align=middle>權限清單</td>
    </tr>
    
    <%
    for(int i=0;au !=null && i<au.length;i++){

        int xnum=au[i].getNumber()%100;

        if(xnum==0){
    %>
        <tr bgcolor=4A7DBD class=es02>
            <td colspan=2>
                <img src="img/flag.png" border=0><input type=checkbox name="authId" value="<%=au[i].getAuthId()%>"                   
                <%=(ha.get((Integer)au[i].getAuthId())!=null)?"checked":""%>>
                    <font color=white><%=au[i].getNumber()%>-<%=au[i].getPagename()%></font>
            </td>
        </tr>
    <%  }else{   %>
        <tr bgcolor=ffffff class=es02>
            <td width=50></td>
            <td>
                <input type=checkbox name="authId" value="<%=au[i].getAuthId()%>" <%=(ha.get((Integer)au[i].getAuthId())!=null)?"checked":""%>>
                    <%=au[i].getNumber()%>-<%=au[i].getPagename()%>
            </td>
        </tr>
    <%  
        }   
    }                    
    %>
    <tr>
        <td colspan=2 align=middle>
            <input type=hidden name="userId" value="<%=userId%>">
            <input type=submit value="修改">
        </td>
    </tR>
    </table>
    </td>
    </tr>
    </table>

</form>
</blockquote>

<%@ include file="bottom.jsp"%>