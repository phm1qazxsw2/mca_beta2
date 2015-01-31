<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%
    String[] mids = request.getParameterValues("mid");
    // ## get membrId from request ##
    StringBuffer sb = new StringBuffer();
    for (int i=0; mids!=null&&i<mids.length; i++) {
        if (sb.length()>0) sb.append(",");
        sb.append(mids[i]);
    }
    if (sb.length()==0)
        sb.append("-1"); // put at least one thing in
    ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + sb.toString() + ")", "");
    Map<Integer, Vector<Membr>> membrMap = new SortingMap(membrs).doSort("getId");
    Map<Integer, Vector<TagMembr>> tagmembrMap = 
        new SortingMap(TagMembrMgr.getInstance().retrieveList("membrId in (" + sb.toString() + ")", "")).doSort("getMembrId");
    String ids = new RangeMaker().makeRange(membrs, "getSurrogateId");
    Map<Integer, Vector<Student2>> s2Map = new SortingMap(Student2Mgr.getInstance().
        retrieveList("id in (" + ids + ")", "")).doSort("getId");

    boolean commit = false;
    int tran_id = dbo.Manager.startTransaction();
    try {       
        Student2Mgr smgr = new Student2Mgr(tran_id);
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);

        for (int i=0; mids!=null&&i<mids.length; i++) {
            int mid = Integer.parseInt(mids[i]);
            int status = Integer.parseInt(request.getParameter("status_" + mids[i]));
            Membr m = membrMap.get(new Integer(mid)).get(0);
            Student2 s = s2Map.get(new Integer(m.getSurrogateId())).get(0);
            if (s.getStudentStatus()!=status) {
                s.setStudentStatus(status);
                smgr.save(s);
            }
            String[] tagids = request.getParameterValues("tm_" + mid); // new tags
            Vector<TagMembr> vt = tagmembrMap.get(new Integer(mid)); // existing tags
            Map<Integer, Vector<TagMembr>> _membrtags = new SortingMap(vt).doSort("getTagId");
            // ## 開始比對
            for (int j=0; tagids!=null&&j<tagids.length; j++) {
                Integer _tagid = new Integer(Integer.parseInt(tagids[j]));
                if (_membrtags.get(_tagid)!=null) { // 前后都有
                    _membrtags.remove(_tagid); 
                }
                else { // 新加的
                    TagMembr tm = new TagMembr();
                    tm.setTagId(_tagid.intValue());
                    tm.setMembrId(mid);
                    tmmgr.create(tm);
                    System.out.println("## adding " + tm.getMembrId() + "#" + tm.getTagId());    
                }
            }
            // 舊的有新的沒有, 要刪掉, 但要 check 是否 key 有定義(有的才在范圍內才要刪)
            Iterator<Integer> iter = _membrtags.keySet().iterator();
            while (iter.hasNext()) {
                TagMembr tm = _membrtags.get(iter.next()).get(0);
                if (request.getParameter("key_" + tm.getMembrId() + "#" + tm.getTagId())==null)
                    continue;
                Object[] objs = { tm };
                tmmgr.remove(objs);
                System.out.println("## removing " + tm.getMembrId() + "#" + tm.getTagId());
            }
        }
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<%@ include file="modify_student_tag.jsp"%>