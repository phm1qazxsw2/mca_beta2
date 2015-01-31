<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.lang.reflect.*,phm.importing.*,mca.*,phm.util.*" 
    contentType="text/html;charset=UTF-8"%>
<%          
    String data = request.getParameter("data");

    McaStudent s = new McaStudent();
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
        McaStudentMgr msmgr = new McaStudentMgr(tran_id);

        String line = null;
        String[] lines = data.split("\n");
        for (int i=0; i<lines.length; i++) {
            line = lines[i];
            if (line.trim().length()==0)
                continue;
            String[] tokens = line.split("\t");
            
            String campus   = TextUtil.trim(tokens[0], "\"");
            String str_studentId      = TextUtil.trim(tokens[1], "\"");
            int studentId = 0;
            try { studentId = Integer.parseInt(str_studentId); } catch (Exception e) {}
            String firstname = TextUtil.trim(tokens[2], "\"").toLowerCase();
            String lastname  = TextUtil.trim(tokens[3], "\"").toLowerCase();
            String chinesename = TextUtil.trim(tokens[4], "\"");
            String grade      = TextUtil.trim(tokens[5], "\"");
            String birthdate  = TextUtil.trim(tokens[6], "\"");
            String gender     = TextUtil.trim(tokens[7], "\"");
            String addr1      = TextUtil.trim(tokens[8], "\"");
            String district1  = TextUtil.trim(tokens[9], "\"");
            String city1      = TextUtil.trim(tokens[10], "\"");
            String county1    = TextUtil.trim(tokens[11], "\"");
            String country1   = TextUtil.trim(tokens[12], "\"");
            String postcode1  = TextUtil.trim(tokens[13], "\"");
            String c_addr      = TextUtil.trim(tokens[14], "\"");
            String c_district  = TextUtil.trim(tokens[15], "\"");
            String c_city      = TextUtil.trim(tokens[16], "\"");
            String c_county    = TextUtil.trim(tokens[17], "\"");
            String hphone      = TextUtil.trim(tokens[18], "\"");
            String mothersure = TextUtil.trim(tokens[19], "\"");
            String motherfirst  = TextUtil.trim(tokens[20], "\"");
            String fathersure = TextUtil.trim(tokens[21], "\"");
            String fatherfirst  = TextUtil.trim(tokens[22], "\"");
            String mothercell   = TextUtil.trim(tokens[23], "\"");
            String fathercell   = TextUtil.trim(tokens[24], "\"");
            String motheremail  = TextUtil.trim(tokens[25], "\"");
            String fatheremail  = TextUtil.trim(tokens[26], "\"");
            String motherchinese = TextUtil.trim(tokens[27], "\"");
            String fatherchinese = TextUtil.trim(tokens[28], "\"");

            boolean exist = false;
            McaStudent student = null;
            if (studentId>0) {
                student = msmgr.find("StudentID=" + studentId);
            }
            if (student==null)
                student = new McaStudent();
            else
                exist = true;

            student.setCampus(campus);
            student.setStudentID(studentId);
            student.setStudentFirstName(firstname);
            student.setStudentSurname(lastname);
            student.setStudentChineseName(chinesename);
            student.setBirthDate(birthdate);           
            //student.setPassportNumber(####);
            //student.setPassportCountry(####);
            student.setSex(gender);
            student.setHomePhone(hphone);
            student.setFatherFirstName(fatherfirst);
            student.setFatherSurname(fathersure);
            student.setFatherChineseName(fatherchinese);
            //student.setFatherPhone(####);
            student.setFatherCell(fathercell);
            student.setFatherEmail(fatheremail);
            //student.setFatherSendEmail(####);
            student.setMotherFirstName(motherfirst);
            student.setMotherSurname(mothersure);
            student.setMotherChineseName(motherchinese);
            //student.setMotherPhone(####);
            student.setMotherCell(mothercell);
            student.setMotherEmail(motheremail);
            //student.setMotherSendEmail(####);
            //student.setCountryID(####);
            //student.setCountyID(####);
            //student.setCityID(####);
            //student.setDistrictID(####);
            student.setChineseStreetAddress(c_addr);
            student.setEnglishStreetAddress(addr1);
            student.setPostalCode(postcode1);
            // ######3 admisstion
            //student.setFreeHandAddress(c_addr);
            //student.setSensitiveAddress(####);
            //student.setApplyForYear(####);
            //student.setApplyForGrade(####);
            // ######3 extra
            //student.setParents(####);
            student.setGrade(grade);
            //student.setCategory(####);
            //student.setArcID(####);
            //student.setDorm(####);
            //student.setTDisc(####);
            //student.setMDisc(####);
            //student.setEmergency(####);
            //student.setBillTo(####);
            //student.setBillAttention(####);
            //student.setBillCountryID(####);
            //student.setBillCountyID(####);
            //student.setBillCityID(####);
            //student.setBillDistrictID(####);
            //student.setBillChineseStreetAddress(####);
            //student.setBillEnglishStreetAddress(####);
            //student.setBillPostalCode(####);

            Map<String,Object> m = ImportStudent.printObj(student, getMethods);
            out.println("<tr bgcolor="+((exist)?"lightyellow":"white")+">");
            for (int j=0; j<getMethods.size(); j++) {
                Object o = m.get(getMethods.get(j).getName());
                out.println("<td>" + ((o==null)?"":o.toString()) + "</td>");
            }
            out.println("</tr>");        

            if (exist)
                msmgr.save(student);
            else
                msmgr.create(student);
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