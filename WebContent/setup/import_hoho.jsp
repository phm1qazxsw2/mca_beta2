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

        Tag engTa = tmgr.find("name='英文A'");
        if (engTa==null) {
            engTa = new Tag();
            engTa.setName("英文A");
            tmgr.create(engTa);
        }

        Tag engTb = tmgr.find("name='英文B'");
        if (engTb==null) {
            engTb = new Tag();
            engTb.setName("英文B");
            tmgr.create(engTb);
        }
        Tag engTc = tmgr.find("name='英文C'");
        if (engTc==null) {
            engTc = new Tag();
            engTc.setName("英文C");
            tmgr.create(engTc);
        }
        Tag engTd = tmgr.find("name='英文D'");
        if (engTd==null) {
            engTd = new Tag();
            engTd.setName("英文D");
            tmgr.create(engTd);
        }


        Tag musicT = tmgr.find("name='音樂'");
        if (musicT==null) {
            musicT = new Tag();
            musicT.setName("音樂");
            tmgr.create(musicT);
        }
        Tag artT = tmgr.find("name='美術'");
        if (artT==null) {
            artT = new Tag();
            artT.setName("美術");
            tmgr.create(artT);
        }
        Tag leaderT = tmgr.find("name='領袖'");
        if (leaderT==null) {
            leaderT = new Tag();
            leaderT.setName("領袖");
            tmgr.create(leaderT);
        }
        Tag chessT = tmgr.find("name='圍棋'");
        if (chessT==null) {
            chessT = new Tag();
            chessT.setName("圍棋");
            tmgr.create(chessT);
        }
        Tag danceT = tmgr.find("name='舞蹈'");
        if (danceT==null) {
            danceT = new Tag();
            danceT.setName("舞蹈");
            tmgr.create(danceT);
        }
        Tag zhusuanT = tmgr.find("name='珠算'");
        if (zhusuanT==null) {
            zhusuanT = new Tag();
            zhusuanT.setName("珠算");
            tmgr.create(zhusuanT);
        }
        Tag goatmilkT1 = tmgr.find("name='羊奶(輪)'");
        if (goatmilkT1==null) {
            goatmilkT1 = new Tag();
            goatmilkT1.setName("羊奶(輪)");
            tmgr.create(goatmilkT1);
        }
        Tag goatmilkT2 = tmgr.find("name='羊奶(原)'");
        if (goatmilkT2==null) {
            goatmilkT2 = new Tag();
            goatmilkT2.setName("羊奶(原)");
            tmgr.create(goatmilkT2);
        }

        Tag lateT = tmgr.find("name='延托19'");
        if (lateT==null) {
            lateT = new Tag();
            lateT.setName("延托19");
            tmgr.create(lateT);
        }
        Tag snakeT = tmgr.find("name='夜點'");
        if (snakeT==null) {
            snakeT = new Tag();
            snakeT.setName("夜點");
            tmgr.create(snakeT);
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
                ImportStudent.parseHoho(tokens, student);
                smgr.save(student);
                membr = mmgr.find("surrogateId=" + student.getId());
                exist = true;
                System.out.println("## found=" + student.getStudentName() + " id=" + student.getId());
            }
            else {
                student = new Student2();
                student.setStudentStatus(4);
                ImportStudent.parseHoho(tokens, student);
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

            if (tokens[71].length()>0 && tokens[71].trim().equals("A")) {
                TagMembr tm = new TagMembr();
                tm.setTagId(engTa.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tokens[71].length()>0 && tokens[71].trim().equals("B")) {
                TagMembr tm = new TagMembr();
                tm.setTagId(engTb.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tokens[71].length()>0 && tokens[71].trim().equals("C")) {
                TagMembr tm = new TagMembr();
                tm.setTagId(engTc.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tokens[71].length()>0 && tokens[71].trim().equals("D")) {
                TagMembr tm = new TagMembr();
                tm.setTagId(engTd.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }

            if (tokens[72].trim().length()>0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(musicT.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tokens[73].trim().length()>0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(artT.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tokens[74].trim().length()>0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(leaderT.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tokens[75].trim().length()>0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(chessT.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tokens[76].trim().length()>0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(danceT.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tokens[77].trim().length()>0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(zhusuanT.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tokens[78].length()>0 && tokens[78].trim().equals("輪")) {
                TagMembr tm = new TagMembr();
                tm.setTagId(goatmilkT1.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tokens[78].length()>0 && tokens[78].trim().equals("原")) {
                TagMembr tm = new TagMembr();
                tm.setTagId(goatmilkT2.getId());
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            if (tokens[84].trim().length()>0) {
                TagMembr tm = new TagMembr();
                tm.setTagId(snakeT.getId());
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