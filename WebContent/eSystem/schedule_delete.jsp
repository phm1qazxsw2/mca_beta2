<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));

    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        SchDefMgr smgr = new SchDefMgr(tran_id);
        SchMembrMgr smmgr = new SchMembrMgr(tran_id);
        SchDef s = smgr.find("id=" + id);
        smmgr.executeSQL("delete from schmembr where schdefId=" + s.getId());
        smgr.executeSQL("delete from schdef where id=" + s.getId());
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
      %><script>alert(e.getMessage());history.go(-1);</script><%
        } else {
            e.printStackTrace();
      %><script>alert("錯誤發生，刪除沒有寫入");history.go(-1);</script><%
        }
    }    
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
    response.sendRedirect("schedule.jsp");
%>