<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    void addMembrTags(int tran_id, Membr m, ArrayList<Tag> tags)
        throws Exception
    {
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        Date now = new Date();
        for (int i=0; i<tags.size(); i++) {
            TagMembr tm = new TagMembr();
            tm.setTagId(tags.get(i).getId());
            tm.setMembrId(m.getId());
            tm.setBindTime(now);
            tmmgr.create(tm);
        }
    }
%>
<%
boolean commit = false;
int tran_id = 0;
Bunit b = null;
try {           
    tran_id = dbo.Manager.startTransaction();

    MembrMgr mmgr = new MembrMgr(tran_id);
    Membr m = mmgr.find("id=" + request.getParameter("mid"));
    McaFee fee = new McaFeeMgr(tran_id).find("id=" + request.getParameter("feeId"));
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date prorateDate = sdf.parse(request.getParameter("prorateDate"));
    McaTagHelper th = new McaTagHelper(tran_id);
    ArrayList<Tag> tags = th.getFeeTags(fee, _ws2.getStudentBunitSpace("bunitId"));
    Map<Integer, Tag> tagMap = new SortingMap(tags).doSortSingleton("getId");

    Tag campustag = new TagMgr(tran_id).find("id=" + request.getParameter("campustag"));
    ArrayList<Tag> mytag = new ArrayList<Tag>();
    mytag.add(campustag);
    Enumeration names = request.getParameterNames();
    while (names.hasMoreElements()) {
        String name = (String) names.nextElement();
        if (name.charAt(0)!='_')
            continue;
        int tid = Integer.parseInt(request.getParameter(name));
        if (tid==0)
            continue;
        mytag.add(tagMap.get(tid));
    }

    addMembrTags(tran_id, m, mytag);

    McaProrate mp = new McaProrate();
    mp.setMcaFeeId(fee.getId());
    mp.setMembrId(m.getId());
    mp.setProrateDate(prorateDate);
    mp.setBunitId(_ws2.getSessionBunitId());
    new McaProrateMgr(tran_id).create(mp);

    // set student status = 4 if it's new admission
    Student2Mgr stmgr = new Student2Mgr(tran_id);
    Student2 st = stmgr.find("id=" + m.getSurrogateId());
    if (st.getStudentStatus()==1) {
        st.setStudentStatus(4);
        stmgr.save(st);
    }

    /*
    ArrayList<Charge> newcharges = new ArrayList<Charge>();
    ArrayList<Charge> modifiedcharges = new ArrayList<Charge>();
    ArrayList<Charge> deletedcharges = new ArrayList<Charge>();
    ArrayList<Charge> conflict_list = new ArrayList<Charge>();
    McaService mcasvc = new McaService(tran_id);
    mcasvc.generateBills(fee, _ws2.getSessionBunitId(), conflict_list, newcharges, modifiedcharges, deletedcharges);
    */

    dbo.Manager.commit(tran_id);
    commit = true;
}
catch (Exception e) {
    e.printStackTrace();
    if (e.getMessage()!=null) {
%><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
    }
    else {
%><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
    }
}
finally {
    if (!commit)
        try { Manager.rollback(tran_id); } catch (Exception ee) {}
}    
%>
<script>
   parent.do_reload = true;
</script>
<blockquote>
   <H2>success!</H2>
   <br>
   <br>
   <blink><H3>You won't see this bill until re-do generateBills</H3></blink>
</blockquote>

