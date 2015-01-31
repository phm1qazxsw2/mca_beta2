<%@ page language="java" buffer="32kb" import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>
<%
    int tagId = Integer.parseInt(request.getParameter("tid"));
    boolean commit = false;
    int tran_id = 0;
    Tag tag = null;
    try {           
        tran_id = dbo.Manager.startTransaction();

        TagHelper th = TagHelper.getInstance(pd2, tran_id, _ws2.getSessionStudentBunitId());
        Tag t = new TagMgr(tran_id).findX("id=" + tagId, _ws.getStudentBunitSpace("bunitId"));
        th.setup(t);
        th.doGraduate(tran_id, t);
        
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
