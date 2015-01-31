<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = dbo.Manager.startTransaction();
    try {     
        McaStudentMgr msmgr = new McaStudentMgr(tran_id);
        McaService mcasvc = new McaService(tran_id);
        
        McaStudent ms = new McaStudent();
        ms.setStudentFirstName("New Student");
        ms.setSex("");
        ms.setCampus(_ws2.getSessionBunit().getLabel());

        msmgr.create(ms);
        ArrayList<McaStudent> tmp = new ArrayList<McaStudent>();
        tmp.add(ms);
        mcasvc.updateStudents(tmp);    

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
    response.sendRedirect("mca_new_student.jsp");
%>