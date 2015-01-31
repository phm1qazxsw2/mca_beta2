<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int teaId = Integer.parseInt(request.getParameter("teacherId"));
    MembrMgr mmgr = MembrMgr.getInstance();
    Membr membr = mmgr.find("type=2 and surrogateId=" + teaId);

    Map<Integer, MembrMembr> membrmembrMap = new SortingMap(MembrMembrMgr.getInstance().
        retrieveList("m1Id=" + membr.getId(), "")).doSortSingleton("getM2Id");
    String[] targets = request.getParameterValues("target");
    boolean commit = false;
    int tran_id = 0;
    try {        
        tran_id = dbo.Manager.startTransaction();
        MembrMembrMgr mmmgr = new MembrMembrMgr(tran_id);
        for (int i=0; targets!=null&&i<targets.length; i++) {
            Integer target = new Integer(Integer.parseInt(targets[i]));
            if (membrmembrMap.get(target)!=null)
                membrmembrMap.remove(target);
            else { // 原來沒有后來有的加入
                MembrMembr mm = new MembrMembr();
                mm.setM1Id(membr.getId());
                mm.setM2Id(target.intValue());
                mmmgr.create(mm);
            }
        }
        if (membrmembrMap.size()>0) { // 這些是原來有后來沒的要刪掉
            Object[] objs = new Object[membrmembrMap.size()];
            Iterator<Integer> iter = membrmembrMap.keySet().iterator();
            int i = 0;
            while (iter.hasNext()) {
                objs[i++] = membrmembrMap.get(iter.next());
            }
            mmmgr.remove(objs);
        }        
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null) { 
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>'); history.go(-1);</script><%
        } else { 
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            e.printStackTrace();
            return;
        }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
    response.sendRedirect("modify_outsourcing.jsp?teacherId="+teaId);
%>

