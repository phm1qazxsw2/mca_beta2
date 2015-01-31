<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu7.jsp"%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>考勤部門設定</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br> 
<blockquote>
<div class=es02>
<a href="javascript:openwindow_phm('addBunit.jsp','新增部門',400,300,true);"><img src="pic/add.gif" border=0 width=15>&nbsp;新增部門</a>
</div>
<%
    BunitMgr bm = BunitMgr.getInstance();
    
    ArrayList<Bunit> b = bm.retrieveListX("flag=" + Bunit.FLAG_SCH,"", _ws.getBunitSpace("buId"));

    if(b ==null || b.size()<=0){
%>
    <blockquote>
        <div class=es02>   
            尚未新增部門.
        </div>
    </blockquote>
    <%@ include file="bottom.jsp"%>
<%
        
        return;
    }
%>
<table width="50%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

    <table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=f0f0f0 class=es02>
        <td align=middle class=es02>
        部門名稱
        </td>
        <td align=middle class=es02>
        應用類別
        </td>
        <td align=middle>
        狀態
        </td>
        <td>
        
        </td>
    </tr>        
    <%
    for(int i=0;i<b.size();i++){                
        Bunit bbx=b.get(i);
    %>
    <tr bgcolor=ffffff class=es02>
        <td align=left class=es02>
            <%=bbx.getLabel()%>
        </td>
        <td align=left class=es02>
            <%=(bbx.getFlag()==1)?"會計系統":"考勤系統"%>
        </td>
        <td align=left>
            <%=(bbx.getStatus()==1)?"使用中":"停用"%>
        </td>
        <td align=middle>
            <a href="javascript:openwindow_phm('midifyBunit.jsp?bid=<%=bbx.getId()%>','修改部門',400,300,true);">修改</a>
        </td>
    </tr>     

    <%  }   %>
    </table>
    </td>
    </tr>
    </table>
    <%@ include file="bottom.jsp"%>