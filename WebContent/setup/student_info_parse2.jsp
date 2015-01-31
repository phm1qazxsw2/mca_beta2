<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    //##v2
    request.setCharacterEncoding("UTF-8");
    String info = request.getParameter("info");
    String sep = request.getParameter("sep");
    String[] lines = info.split("\n");

    int n = 0, tn = 0;

    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();
        TagMgr tmgr = new TagMgr(tran_id);
        Student2Mgr smgr = new Student2Mgr(tran_id);
        MembrMgr mmgr = new MembrMgr(tran_id);
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);

//<input type=checkbox name="field" value="studentName">中文姓名|
//<input type=checkbox name="field" value="studentMother">媽媽姓名|
//<input type=checkbox name="field" value="studentMotherMobile">媽媽手機|
//<input type=checkbox name="field" value="studentPhone">電話1|
//<input type=checkbox name="field" value="studentPhone2">電話2|
//<input type=checkbox name="field" value="studentPhone3

        for (int i=0; i<lines.length; i++) {
            if (lines[i].trim().length()==0)
                continue;
            String[] tokens = lines[i].split(sep);
            Student2 s = new Student2();

            s.setStudentName(tokens[0]);
            s.setStudentMother(tokens[1]);
            s.setStudentMotherMobile(tokens[2]);
            s.setStudentPhone(tokens[3]);
            s.setStudentPhone2(tokens[4]);
            s.setStudentPhone3(tokens[5]);

            s.setStudentStatus(4);
            smgr.create(s);

            Membr membr = new Membr();
            membr.setName(tokens[0]);
            membr.setActive(1);
            membr.setType(Membr.TYPE_STUDENT);
            membr.setSurrogateId(s.getId());
            mmgr.create(membr);

            n ++;
        }

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
產生<%=tn%> 筆學標籤資料， <%=n%> 筆學生資料