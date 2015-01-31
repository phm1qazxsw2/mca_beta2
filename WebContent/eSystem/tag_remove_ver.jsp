<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");
    int tagId = Integer.parseInt(request.getParameter("tid"));
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        TagHelper th = TagHelper.getInstance(pd2, tran_id, _ws2.getSessionStudentBunitId());
        Tag tag = new TagMgr(tran_id).findX("id=" + tagId, _ws2.getStudentBunitSpace("bunitId"));
        th.removeVersion(tag);
        
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
      %>@@<%=e.getMessage()%><%
        } else {
            e.printStackTrace();
      %>@@錯誤發生，刪除沒有成功<%
        }
    } 
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
