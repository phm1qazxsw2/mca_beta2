<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.lang.reflect.*,phm.importing.*" 
    contentType="text/html;charset=UTF-8"%>
<%          
    String data = request.getParameter("data");
    int oldS = 0;
    int newS = 0;

    Student2 s = new Student2();
    Class c = s.getClass();
    Method[] methods = c.getDeclaredMethods();

    Vector<Method> getMethods = new Vector<Method>();            
    out.println("<table border=1><tr>");
    out.println("<th>班級</th>");
    for (int i=0; i<methods.length; i++) {
        if (methods[i].getName().indexOf("get")>=0) {
            getMethods.addElement(methods[i]);
            out.println("<th>" + methods[i].getName() + "</th>");
        }
    }
    System.out.println("</tr>");

    boolean commit = false;
    int tran_id = dbo.Manager.startTransaction();
    try {            
        Student2Mgr smgr = new Student2Mgr(tran_id);
        TagMgr tmgr = new TagMgr(tran_id);
        MembrMgr mmgr = new MembrMgr(tran_id);
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);

        Tag yoyoC = tmgr.find("name='幼幼班'");
        if (yoyoC==null) {
            yoyoC = new Tag();
            yoyoC.setName("幼幼班");
            tmgr.create(yoyoC);
        }

        Tag midC = tmgr.find("name='中班'");
        if (midC==null) {
            midC = new Tag();
            midC.setName("中班");
            tmgr.create(midC);
        }
        Tag bigC = tmgr.find("name='大班'");
        if (bigC==null) {
            bigC = new Tag();
            bigC.setName("大班");
            tmgr.create(bigC);
        }
        Tag smallC = tmgr.find("name='小班'");
        if (smallC==null) {
            smallC = new Tag();
            smallC.setName("小班");
            tmgr.create(smallC);
        }


        String line = null;
        String[] lines = data.split("\n");
        for (int i=0; i<lines.length; i++) {
            line = lines[i];
            if (line.trim().length()==0)
                continue;
            String[] tokens = line.split("\t");
            
            String className = tokens[0];
            Tag t = tmgr.find("name='" + className + "'");
            if (t==null) {
                t = new Tag();
                t.setName(className);
                tmgr.create(t);
            }

            String studentName = tokens[1];
            Student2 student = smgr.find("studentName='" + studentName + "'");
            Membr membr = null;
            boolean exist = true;
            if (student!=null) {
                ImportStudent.parseJianShengTainan(tokens, student);
                smgr.save(student);
                membr = mmgr.find("surrogateId=" + student.getId());
                exist = true;
                System.out.println("## found=" + student.getStudentName() + " id=" + student.getId());
            }
            else {
                student = new Student2();
                student.setStudentStatus(4);
                ImportStudent.parseJianShengTainan(tokens, student);
                smgr.create(student);

                //## add to connect student and membr
                membr = new phm.ezcounting.Membr();
                membr.setName(student.getStudentName());
                membr.setActive(1);
                membr.setType(phm.ezcounting.Membr.TYPE_STUDENT);
                membr.setSurrogateId(student.getId());
                membr.setBirth(student.getStudentBirth());
                mmgr.create(membr);

                exist = false;
            }

            if (tmmgr.numOfRows("tagId=" + t.getId() + " and membrId=" + membr.getId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(t.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }

            Map<String,Object> m = ImportStudent.printObj(student, getMethods);
            out.println("<tr bgcolor="+((exist)?"lightyellow":"white")+">");
            out.println("<td>" + t.getName() + "</td>");
            for (int j=0; j<getMethods.size(); j++) {
                Object o = m.get(getMethods.get(j).getName());
                out.println("<td>" + ((o==null)?"":o.toString()) + "</td>");
            }
            out.println("</tr>");
        }
        out.println("</table>");

        //dbo.Manager.commit(tran_id);
        //commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>