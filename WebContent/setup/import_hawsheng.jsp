<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.lang.reflect.*,phm.importing.*" 
    contentType="text/html;charset=UTF-8"%>
<%!
    static SimpleDateFormat tw_sdf = new SimpleDateFormat("yyMMdd");
    static SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd");
    public static Date getTaiwanDate(String dateStr, Date d)
    {
        try {
            Date twd = tw_sdf.parse(dateStr);
            int year = twd.getYear();
            twd.setYear(year + 11);
            return twd;
        }
        catch (Exception e) {}
        return d;
    }
%>
<%          
    String data = request.getParameter("data");
    int oldS = 0;
    int newS = 0;

    Student2 s = new Student2();
    Class c = s.getClass();
    Method[] methods = c.getDeclaredMethods();

    Vector<Method> getMethods = new Vector<Method>();            
    out.println("<table border=1><tr>");
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

        String line = null;
        String[] lines = data.split("\n");
        for (int i=0; i<lines.length; i++) {
            line = lines[i];
            if (line.trim().length()==0)
                continue;
            String[] tokens = line.split("\t");
            
            String studentName = tokens[0];
            int studentSex = ImportStudent.getGendar(tokens[1]);
            String studentIDNumber = tokens[2];
            String studentNumber = tokens[3];
            String studentFatherName = tokens[4];
            String studentMotherName = tokens[5];            
            Date studentBirth = getTaiwanDate(tokens[6], null);
            String studentAddress = tokens[7];
            String studentPhone = tokens[8];

            Student2 student = smgr.find("studentName='" + studentName + "' and studentStatus in (3,4)");
            Membr membr = null;
            boolean exist = true;
            if (student!=null) {
                student.setStudentName(studentName);
                student.setStudentSex(studentSex);
                student.setStudentIDNumber(studentIDNumber);
                student.setStudentAddress(studentAddress);
                student.setStudentPhone(studentPhone);
                student.setStudentBirth(studentBirth);
System.out.println("## studentBirth=" + sdf2.format(studentBirth));
                student.setStudentFather(studentFatherName);
                student.setStudentMother(studentMotherName);
                student.setStudentNumber(studentNumber);
                smgr.save(student);
                
                membr = mmgr.find("type=" + Membr.TYPE_STUDENT + " and surrogateId=" + student.getId());
                membr.setName(student.getStudentName());
                membr.setBirth(student.getStudentBirth());
                mmgr.save(membr);

                exist = true;
                System.out.println("## found=" + student.getStudentName() + " id=" + student.getId());
            }
            else {
                student = new Student2();
                student.setStudentStatus(4);
                student.setStudentName(studentName);
                student.setStudentSex(studentSex);
                student.setStudentIDNumber(studentIDNumber);
                student.setStudentAddress(studentAddress);
                student.setStudentPhone(studentPhone);
                student.setStudentBirth(studentBirth);
                student.setStudentFather(studentFatherName);
                student.setStudentMother(studentMotherName);
                student.setStudentNumber(studentNumber);

                // ImportStudent.parseShiRen(tokens, student);
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

            Map<String,Object> m = ImportStudent.printObj(student, getMethods);
            out.println("<tr bgcolor="+((exist)?"lightyellow":"white")+">");
            for (int j=0; j<getMethods.size(); j++) {
                Object o = m.get(getMethods.get(j).getName());
                out.println("<td>" + ((o==null)?"":o.toString()) + "</td>");
            }
            out.println("</tr>");
        }
        out.println("</table>");

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>