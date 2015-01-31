<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu7.jsp"%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>單位設定</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br> 
<blockquote>
<div class=es02>
<a href="javascript:openwindow_phm('company_bunit_add.jsp','新增單位',500,600,true);"><img src="pic/add.gif" border=0 width=15>&nbsp;新增單位</a>
</div>
<%
    BunitMgr bm = BunitMgr.getInstance();
    
    ArrayList<Bunit> b = bm.retrieveList("flag=" + Bunit.FLAG_BIZ,"");

    if(b ==null || b.size()<=0){
%>
    <blockquote>
        <div class=es02>   
            尚未單位.
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
        名稱
        </td>
        <td align=middle>
        代收 Info
        </td>
        <td align=middle>
        共用 Info
        </td>
        <td align=middle>
        帳單資訊
        </td>
        <td align=middle>
        狀態
        </td>
        <td>        
        </td>
    </tr>        
    <%
    BunitHelper bh = new BunitHelper();
    for(int i=0;i<b.size();i++){                
        Bunit bbx = b.get(i);
    %>
    <tr bgcolor=ffffff class=es02>
        <td align=left class=es02 nowrap>
            <%=bbx.getLabel()%>
        </td>
        <td align=left nowrap valign=top>
            <%=bh.getBankBalancingInfo(bbx).replace("\n","<br>")%>
        </td>
        <td align=left nowrap valign=top>
            <%=bh.getSharingInfo(bbx).replace("\n","<br>")%>
        </td>
        <td align=left nowrap valign=top>
            <%=bh.getBillingInfo(bbx).replace("\n","<br>")%>
        </td>
        <td align=left nowrap>
            <%=(bbx.getStatus()==1)?"使用中":"停用"%>
        </td>
        <td align=middle nowrap>
            <a href="javascript:openwindow_phm('company_bunit_modify.jsp?bid=<%=bbx.getId()%>','修改單位',400,400,true);">修改</a>
        </td>
    </tr>     

    <%  }   %>
    </table>
    </td>
    </tr>
    </table>
    <%@ include file="bottom.jsp"%>