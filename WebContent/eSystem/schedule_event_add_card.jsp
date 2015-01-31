<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%


    SimpleDateFormat sdfXX=new SimpleDateFormat("yyyyMMddHHmm");
    SimpleDateFormat sdf1xx = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdfxx= new SimpleDateFormat("yyyyMMdd");

    String d1String=request.getParameter("d1");
    String d2String=request.getParameter("d2");

    //Date d1 = c.getTime();
    Date d1=sdfXX.parse(d1String);
    Date d2 =new Date();
    
    if(d2String !=null)
        d2=sdfXX.parse(d2String);

    String note = "";

    int orgmins=Integer.parseInt(request.getParameter("mins"));    


    int hours=orgmins/60;
    int mins=orgmins-(hours*60);

    String membrId=request.getParameter("membrId");
    Membr mb=MembrMgr.getInstance().find("id = "+membrId);    
    int type=Integer.parseInt(request.getParameter("type"));

%>
<form name="f1" action="schedule_event_add2.jsp" method="post" onsubmit="return doCheck(this);">
<%@ include file="schedule_event_inner.jsp"%>
</form>
<script>
setTarget_<%=field%>(<%=membrId%>,'<%=mb.getName()%>');
</script>