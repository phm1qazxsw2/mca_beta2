<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        McaStudentMgr msmgr = new McaStudentMgr(tran_id);
        MembrMgr mmgr = new MembrMgr(tran_id);
        Student2Mgr smgr = new Student2Mgr(tran_id);

        String id = request.getParameter("id");
        McaStudent s = msmgr.find("id=" + id);
        Membr membr = mmgr.find("id=" + s.getMembrId());
        Student2 st = smgr.find("id=" + s.getStudId());
        int campus = Integer.parseInt(request.getParameter("campus"));
        if (campus!=membr.getBunitId()) {
            McaService mcasvc = new McaService(tran_id);
            mcasvc.leaveCurrentCampus(s, membr.getBunitId());
            // mcasvc.addCurrentCampus(s, campus); still off school
            membr.setBunitId(campus);
            mmgr.save(membr);
            st.setBunitId(campus);
            st.setStudentStatus(1); // 如此才會到 new admissions
            smgr.save(st);
        }
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
          %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
              return;
        }        
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<blockquote>
done!
<blockquote>
<script>
    parent.do_reload = true;
    parent.parent.do_reload = true;
</script>