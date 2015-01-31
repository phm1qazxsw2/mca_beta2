<%@ page language="java" 
    import="com.axiom.mgr.*,jsf.*,phm.ezcounting.*,dbo.*,java.util.*"
    contentType="text/html;charset=UTF-8"%>
<%

int tran_id1 = 0;
int tran_id2 = 0;
try {
    tran_id1 = com.axiom.mgr.Manager.startTransaction();
    tran_id2 = dbo.Manager.startTransaction();

    DepartMgr dmgr = new DepartMgr(tran_id1);
    StudentMgr smgr = new StudentMgr(tran_id1);
    TeacherMgr tcmgr = new TeacherMgr(tran_id1);
    LevelMgr lmgr = new LevelMgr(tran_id1);
    ClassesMgr cmgr = new ClassesMgr(tran_id1);

    TagMgr tmgr = new TagMgr(tran_id2);
    MembrMgr mmgr = new MembrMgr(tran_id2);
    TagMembrMgr tmmgr = new TagMembrMgr(tran_id2);

    // create membr for all students
    Map<Integer,Membr> studentMap = new HashMap<Integer,Membr>();
    Object[] objs = smgr.retrieve("", "");
    for (int i=0; objs!=null && i<objs.length; i++) {
        Student s = (Student) objs[i];
        Membr m = new Membr();
        m.setName(s.getStudentName());
        m.setActive(1);
        m.setType(Membr.TYPE_STUDENT);
        m.setSurrogateId(s.getId());
        mmgr.create(m);
        studentMap.put(new Integer(s.getId()), m);
    }

    // create membr for all teachers
    objs = tcmgr.retrieve("", "");
    for (int i=0; objs!=null && i<objs.length; i++) {
        Teacher tc = (Teacher) objs[i];
        Membr m = new Membr();
        m.setName(tc.getTeacherLastName() + " " + tc.getTeacherFirstName());
        m.setActive(1);
        m.setType(Membr.TYPE_TEACHER);
        m.setSurrogateId(tc.getId());
        mmgr.create(m);
    }
    

    // import depart stuff
    objs = dmgr.retrieve("departActive=1", "");
    for (int i=0; objs!=null&&i<objs.length; i++) {
        Depart d = (Depart) objs[i];
        Object[] objs2 = smgr.retrieve("studentDepart=" + d.getId(), "");
        System.out.println("## depart:" + d.getDepartName() + " student num=" + ((objs2==null)?0:objs2.length));
        Tag t = new Tag();
        t.setName(d.getDepartName()+"部");
        tmgr.create(t);
        for (int j=0; objs2!=null&&j<objs2.length; j++) {
            Student s = (Student) objs2[j];
            Membr m = studentMap.get(new Integer(s.getId()));
            TagMembr tm = new TagMembr();
            tm.setTagId(t.getId());
            tm.setMembrId(m.getId());
            tmmgr.create(tm);
        }
    }

    // import level stuff
    objs = lmgr.retrieve("levelActive=1", "");
    for (int i=0; objs!=null&&i<objs.length; i++) {
        Level l = (Level) objs[i];
        Object[] objs2 = smgr.retrieve("studentLevel=" + l.getId(), "");
        System.out.println("## level:" + l.getLevelName() + " student num=" + ((objs2==null)?0:objs2.length));
        Tag t = new Tag();
        t.setName(l.getLevelName()+"年級");
        tmgr.create(t);
        for (int j=0; objs2!=null&&j<objs2.length; j++) {
            Student s = (Student) objs2[j];
            Membr m = studentMap.get(new Integer(s.getId()));
            TagMembr tm = new TagMembr();
            tm.setTagId(t.getId());
            tm.setMembrId(m.getId());
            tmmgr.create(tm);
        }
    }

    // import class stuff
    objs = cmgr.retrieve("classesStatus=1", "");
    for (int i=0; objs!=null&&i<objs.length; i++) {
        Classes c = (Classes) objs[i];
        Object[] objs2 = smgr.retrieve("studentClassId=" + c.getId(), "");
        System.out.println("## class:" + c.getClassesName() + " student num=" + ((objs2==null)?0:objs2.length));
        Tag t = new Tag();
        t.setName(c.getClassesName());
        tmgr.create(t);
        for (int j=0; objs2!=null&&j<objs2.length; j++) {
            Student s = (Student) objs2[j];
            Membr m = studentMap.get(new Integer(s.getId()));
            TagMembr tm = new TagMembr();
            tm.setTagId(t.getId());
            tm.setMembrId(m.getId());
            tmmgr.create(tm);
        }
    }

    com.axiom.mgr.Manager.commit(tran_id1);
    dbo.Manager.commit(tran_id2);
}
catch (Exception e) {
    com.axiom.mgr.Manager.rollback(tran_id1);
    try { dbo.Manager.rollback(tran_id2); } catch (Exception ee) {}
}
%> 
done!




