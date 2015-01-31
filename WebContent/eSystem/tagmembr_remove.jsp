<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='justHeader.jsp'%>
<%
    //##v2
    int tid = Integer.parseInt(request.getParameter("tid"));
    String ids = request.getParameter("mid");

    boolean commit = false;
    int tran_id = 0;
    try { 
        tran_id = Manager.startTransaction();
    
        TagHelper th = TagHelper.getInstance(pd2, tran_id, _ws2.getSessionStudentBunitId());
        th.removeTagMembr(tran_id, tid, ids, ud2);

        commit = true;
        Manager.commit(tran_id);
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("z")) {
      %>@@刪除項目為最後一筆，欲刪除整張單據請用"刪除單據"，刪除沒有成功<%
        } else if (e.getMessage()!=null) {
      %>@@<%=e.getMessage()%><%
        } else {
            e.printStackTrace();
      %>@@錯誤發生，刪除沒有成功<%
        }
    }    
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
    }
%>