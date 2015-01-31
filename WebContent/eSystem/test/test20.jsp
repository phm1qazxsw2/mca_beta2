<%@ page language="java" import="web.*,jsf.*,mca.*,dbo.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        ArrayList<McaStudent> mts = new McaStudentMgr(tran_id).retrieveList("","");
        ArrayList<Membr> mbrs = new MembrMgr(tran_id).retrieveList("","");
        ArrayList<Student2> studs = new Student2Mgr(tran_id).retrieveList("","");
        Map<Integer, Membr> membrMap = new SortingMap(mbrs).doSortSingleton("getId");
        Map<Integer, Student2> studentMap = new SortingMap(studs).doSortSingleton("getId");

        MembrMgr mmgr = new MembrMgr(tran_id);
        Student2Mgr smgr = new Student2Mgr(tran_id);

        for (int i=0; i<mts.size(); i++) {
            McaStudent ms = mts.get(i);
            Membr m = membrMap.get(ms.getMembrId());
            Student2 s = studentMap.get(ms.getStudId());
            m.setName(ms.getFullName());
            s.setStudentName(ms.getFullName());
            mmgr.save(m);
            smgr.save(s);
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit) {
            dbo.Manager.rollback(tran_id);
        }
    }    
        
%>done!