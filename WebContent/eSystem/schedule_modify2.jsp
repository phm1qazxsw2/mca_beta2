<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    int id = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("name");
    Date startDate = sdf.parse(request.getParameter("startDate"));
    Date endDate = sdf.parse(request.getParameter("endDate"));
    int type = Integer.parseInt(request.getParameter("type"));
    String content = request.getParameter("content");
    String color = request.getParameter("color");
    int autoRun = Integer.parseInt(request.getParameter("autoRun"));
    int bunit = Integer.parseInt(request.getParameter("bunit"));

    boolean commit = false;
    int tran_id = 0;
    try {        
        tran_id = dbo.Manager.startTransaction();

        SchDefMgr sdmgr = new SchDefMgr(tran_id);
        SchDef sd = sdmgr.find("id=" + id);

        Date d = new Date();               
        if (d.compareTo(sd.getEndDate())>0) {
          %><script>alert("無法修改已成往事的班表");histor.go(-1);</script><%
            return;
        }    

        SchDef sdnew = sd.doSplitOrNot(tran_id);
        if (sdnew.getId()==sd.getId())
            sd.setStartDate(startDate);
        else
            sd = sdnew;
        
        sd.setName(name);
        sd.setEndDate(endDate);
        sd.setType(type);
        sd.setContent(content.trim());
        sd.setColor(color);
        sd.setAutoRun(autoRun);
        sd.setBunitId(bunit);
        sd.parse();
        sdmgr.save(sd);

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }

%>
<script>
   parent.do_reload = true;
</script>

<%

    response.sendRedirect("schedule_detail.jsp?id="+id);
%>

