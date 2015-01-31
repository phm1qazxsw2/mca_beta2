<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        ArrayList<McaStudent> mcs = new McaStudentMgr(tran_id).retrieveList("","");
        Map<Integer, McaStudent> mcsMap = new SortingMap(mcs).doSortSingleton("getStudId");
        String studentIds = new RangeMaker().makeRange(mcs, "getStudId");
        Student2Mgr smgr = new Student2Mgr(tran_id);
        ArrayList<Student2> students = smgr.retrieveList("id in (" + studentIds + ")", "");
        for (int i=0; i<students.size(); i++) {
            Student2 s = students.get(i);
            McaStudent ms = mcsMap.get(s.getId());
            s.setStudentIDNumber(ms.getCoopID());
            smgr.save(s);
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>done!