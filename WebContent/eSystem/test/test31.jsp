<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<%!
    String printStudent(McaStudent ms) {
        return ms.getId() + " " + ms.getStudentID() + " " + ms.getStudentSurname() + "," + ms.getStudentFirstName() + " " + ms.getBirthDate() + " " + ms.getStudentChineseName() + " " + ms.getFatherChineseName() + ms.getMotherChineseName();
    }

    void fixChineseNames(McaStudent ms)
    {
        ms.setStudentChineseName(ms.getStudentChineseName().replace(" ",""));
        ms.setFatherChineseName(ms.getFatherChineseName().replace(" ",""));
        ms.setMotherChineseName(ms.getMotherChineseName().replace(" ",""));
    }
%>
<%
        int tran_id = 0;

        McaStudentMgr msmgr = new McaStudentMgr(tran_id);
        ArrayList<McaStudent> mts = new McaStudentMgr(tran_id).retrieveList("", "");
        for (int i=0; i<mts.size(); i++) {
            McaStudent ms = mts.get(i);
            fixChineseNames(ms);
            if (ms.getStudentID()==0 || ms.getStudentID()>4000) {
                out.println("###" + printStudent(ms) + "<br>");
                continue;
            }
            if (ms.getBirthDate()==null || ms.getBirthDate().length()==0) {
                out.println("@@@" + printStudent(ms) + "<br>");
                continue;
            }
            if (ms.getStudentChineseName().length()>4) {
                out.println("xxx" + printStudent(ms) + "<br>");
                continue;
            }
            if (ms.getFatherChineseName().length()>4) {
                out.println("yyy" + printStudent(ms) + "<br>");
                continue;
            }
            if (ms.getMotherChineseName().length()>4) {
                out.println("zzz" + printStudent(ms) + "<br>");
                continue;
            }

            McaImEx.exportModifiedStudent(ms);
            ms.setStudentFirstName(McaImEx.doCapital(ms.getStudentFirstName()));
            ms.setStudentSurname(McaImEx.doCapital(ms.getStudentSurname()));
            msmgr.save(ms);
        }

%>done!