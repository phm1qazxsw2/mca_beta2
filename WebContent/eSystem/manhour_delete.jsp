<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='/WEB-INF/jsp/security.jsp'%>
<%
    //##v2
    boolean commit = false;
    int tran_id = 0;
    try { 
        tran_id = Manager.startTransaction();
        int mhId = Integer.parseInt(request.getParameter("id"));

        ManHourMgr mhmgr = new ManHourMgr(tran_id);
        EzCountingService ezsvc = EzCountingService.getInstance();
        User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
        ArrayList<ManHour> manhours = mhmgr.retrieveList("id=" + mhId, "");
        // 這里面也要處理 voucher 的事
        ezsvc.removeManhours(tran_id, manhours, ud2);

        commit = true;
        Manager.commit(tran_id);
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
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
    }
%>