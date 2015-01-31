<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
    Date month = sdf.parse(request.getParameter("month"));
    String name = request.getParameter("name");
    String startHr = request.getParameter("startHr");
    String endHr = request.getParameter("endHr");
    int offMin = 0;
    try { offMin=Integer.parseInt(request.getParameter("offMin")); } catch (Exception e) {}
    String[] days = request.getParameterValues("day");
    String note = request.getParameter("note");
    int copyId = Integer.parseInt(request.getParameter("copyId"));

    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();
        SchMembrMgr smmgr = new SchMembrMgr(tran_id);
        SchDefMgr smgr = new SchDefMgr(tran_id);
        SchDef sdef = new SchDef();
        sdef.setMonth(month);
        sdef.setName(name);
        sdef.setStartHr(startHr);
        sdef.setEndHr(endHr);
        sdef.setOffMin(offMin);
        sdef.setNote(note);
        StringBuffer sb = new StringBuffer();
        for (int i=0; days!=null&&i<days.length; i++) {
            String[] tokens = days[i].split("@");
            int dayofMonth = Integer.parseInt(tokens[0]);
            if (sb.length()>0) sb.append(",");
            sb.append(dayofMonth);
        }
        sdef.setDays(sb.toString());
        smgr.create(sdef);

        ArrayList<SchMembr> membrs = smmgr.retrieveList("schdefId=" + copyId, "");
        Iterator<SchMembr> iter = membrs.iterator();
        while (iter.hasNext()) {
            SchMembr sm = iter.next();
            sm.setSchdefId(sdef.getId());
            sm.setNote("");
            sm.setDays("");
            smmgr.create(sm);
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
        if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1)</script><%
        }
    }    
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<blockquote>
複製成功!
</blockquote>

<script>
    parent.do_reload = true;
</script>


