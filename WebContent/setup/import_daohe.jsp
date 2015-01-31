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
    out.println("<th>年級</th>");
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
        TagTypeMgr ttmgr = new TagTypeMgr(tran_id);
        MembrMgr mmgr = new MembrMgr(tran_id);
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);

        TagType tt1 = ttmgr.find("name='年級'");
        if (tt1==null) {
            tt1 = new TagType();
            tt1.setName("年級");
            ttmgr.create(tt1);
        }
        TagType tt2 = ttmgr.find("name='班級'");
        if (tt2==null) {
            tt2 = new TagType();
            tt2.setName("班級");
            ttmgr.create(tt2);
        }

        String line = null;
        String[] lines = data.split("\n");
        for (int i=0; i<lines.length; i++) {
            line = lines[i];
            if (line.trim().length()==0)
                continue;
            String[] tokens = line.split("\t");
            
            String gradeName = tokens[0];
            Tag g = tmgr.find("name='" + gradeName + "'");
            if (g==null) {
                g = new Tag();
                g.setName(gradeName);
                g.setTypeId(tt1.getId());
                tmgr.create(g);
            }

            String className = tokens[1];
            Tag t = tmgr.find("name='" + className + "'");
            if (t==null) {
                t = new Tag();
                t.setName(className);
                t.setTypeId(tt2.getId());
                tmgr.create(t);
            }

            String studentName = tokens[3]; // 學號
            Student2 student = smgr.find("studentName='" + studentName + "'"); 
            Membr membr = null;
            boolean exist = true;
            if (student!=null) {
                ImportStudent.parseDaoHe(tokens, student);
                smgr.save(student);
                membr = mmgr.find("surrogateId=" + student.getId());
                exist = true;
                System.out.println("## found=" + student.getStudentName() + " id=" + student.getId());
            }
            else {
                student = new Student2();
                student.setStudentStatus(4);
                ImportStudent.parseDaoHe(tokens, student);
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

            if (tmmgr.numOfRows("tagId=" + g.getId() + " and membrId=" + membr.getId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(g.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tmmgr.numOfRows("tagId=" + t.getId() + " and membrId=" + membr.getId())==0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(t.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }

            Map<String,Object> m = ImportStudent.printObj(student, getMethods);
            out.println("<tr bgcolor="+((exist)?"lightyellow":"white")+">");
            out.println("<td>" + g.getName() + "</td>");
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