<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");
    int tagId = Integer.parseInt(request.getParameter("tid"));
    boolean commit = false;
    int tran_id = 0;
    Tag tag = null;
    try {           
        tran_id = dbo.Manager.startTransaction();

        TagMgr tmgr = new TagMgr(tran_id);
        tag = tmgr.find("id=" + tagId);

        TagHelper th = TagHelper.getInstance(pd2, tran_id, _ws2.getSessionStudentBunitId());
        ArrayList<Tag> history = th.getHistory(tag);
        Tag newt = th.branchTag(tran_id, history.get(0)); // 用最新的去 branch
        
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
      %>@@<%=e.getMessage()%><%
        } else {
            e.printStackTrace();
      %>@@錯誤發生，加入沒有成功<%
        }
    } 
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
