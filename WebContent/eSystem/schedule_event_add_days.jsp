<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    Calendar c = Calendar.getInstance();
    c.setTime(new Date());
    c.add(Calendar.DATE, 7);
    Date d1 = new Date(); //c.getTime();
    Date d2 = c.getTime();

    String note = "";
    int type = -2;
    int hours = 0;
    int mins = 0;

    int membrId=-1;
    String membrIdS=request.getParameter("membrId");

    if(membrIdS !=null)
        membrId=Integer.parseInt(membrIdS);
    
    int bunit=-1;
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS);
%>

<form name="f1" action="schedule_event_add2_days.jsp" method="post" onsubmit="return doCheck(this);">
<%@ include file="schedule_event_inner_days.jsp"%>
</form>

<%
    if(membrId != -1){

        Membr memX=MembrMgr.getInstance().find(" id= '"+membrId+"'");
%>
    <script>
            setTarget_<%=field%>('<%=membrId%>','<%=memX.getName()%>');
    </script>

<%  }   %>