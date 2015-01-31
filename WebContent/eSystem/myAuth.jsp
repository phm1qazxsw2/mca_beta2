<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%


    int userId=ud2.getId();

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

    int code=0;

    String codeS=request.getParameter("code");
    
    if(codeS !=null)
    {
        try{

            code=Integer.parseInt(codeS);
        }catch(Exception ex){}        
    }

%>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;<img src="pic/key2.png" border=0> <b><%=u.getUserFullname()%> 授權清單</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  登入身份: <font color=blue><%=ja.getChineseRole(u.getUserRole())%></font>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<br>
<blockquote>
<%
        if(code !=0){
%>
            <div class=es02>
            <b>授權代碼 <font color=blue> <%=code%></font> : <%=(ha.get((Integer)code)!=null)?"有獲得授權.":"<font color=red>尚未獲得授權.</font>"%></b>
            </div>
            <br>
<%  }   %>

<div class=es02>
說明: <img  src="img/flag2.png" border=0>&nbsp; 為已獲得授權的部份;如需變更,請洽經營者修改.
</div>
<table width="70%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
        <td align=middle>主選單</td>
        <td align=middle>權限清單</td>
    </tr>
    
    <%
    for(int i=0;i<au.length;i++){

        int xnum=au[i].getNumber()%100;

        if(xnum==0){
    %>
        <tr bgcolor=4A7DBD class=es02>
            <td colspan=2>
                    <%=(ha.get((Integer)au[i].getAuthId())!=null)?"<img  src=\"img/flag.png\" border=0>":"&nbsp;&nbsp;&nbsp;"%>
                    <font color=white><%=au[i].getNumber()%>-<%=au[i].getPagename()%></font>
            </td>
        </tr>
    <%  }else{   %>
        <tr bgcolor=ffffff class=es02>
            <td width=50></td>
            <td>
                    <%=(ha.get((Integer)au[i].getAuthId())!=null)?"<img  src=\"img/flag2.png\" border=0>":"&nbsp;&nbsp;&nbsp;"%>
                    <%=au[i].getNumber()%>-<%=au[i].getPagename()%>
            </td>
        </tr>
    <%  
        }   
    }                    
    %>
    </table>
    </td>
    </tr>
    </table>

</form>
</blockquote>

<%@ include file="bottom.jsp"%>