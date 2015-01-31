<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    Calendar c = Calendar.getInstance();
    SimpleDateFormat sdfRequest=new SimpleDateFormat("yyyyMMdd");
    String requestDate=request.getParameter("d1");
    int bunit=-1;
    try{
        bunit=Integer.parseInt(request.getParameter("bunit"));
    }catch(Exception ex){}

    Date d1 = new Date(); //c.getTime();

    if(requestDate !=null)
        d1=sdfRequest.parse(requestDate);

    c.set(Calendar.HOUR_OF_DAY, 18);
    Date d2 = c.getTime();

    String note = "";
    int type = -2;
    int hours = 0;
    int mins = 0;

    int membrId=-1;
    String membrIdS=request.getParameter("membrId");

    if(membrIdS !=null)
        membrId=Integer.parseInt(membrIdS);
%>

<form name="f1" action="schedule_event_add2.jsp" method="post" onsubmit="return doCheck(this);">
<%@ include file="schedule_event_inner.jsp"%>
</form>

<%
    if(membrId != -1){

        Membr memX=MembrMgr.getInstance().find(" id= '"+membrId+"'");
%>
    <script>
            setTarget_<%=field%>('<%=membrId%>','<%=memX.getName()%>');
    </script>

<%  }   %>