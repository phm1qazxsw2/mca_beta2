<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    McaProrateMgr mpmgr = McaProrateMgr.getInstance();
    McaProrate mp = mpmgr.find("mcaFeeId=" + request.getParameter("feeId") + 
        " and membrId=" + request.getParameter("membrId"));
    Object[] objs = { mp };
    mpmgr.remove( objs );
%>
<blockquote>
    done!
</blockquote>
<script>
    parent.do_reload = true;
</script>

