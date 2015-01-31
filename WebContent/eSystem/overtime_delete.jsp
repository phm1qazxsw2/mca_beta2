<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    
    int otId=0;
    try{
        otId=Integer.parseInt(request.getParameter("otId"));
    }catch(Exception ex){}        
        
    OvertimeMgr om=OvertimeMgr.getInstance();
    Overtime ot=(Overtime)om.find("id='"+otId+"'");
    Object[] objs = { ot };
    om.remove(objs);
%>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>
&nbsp;覆核加班</b>
</div>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
    <br>

    <blockquote>
        刪除成功.
    </blockquote>