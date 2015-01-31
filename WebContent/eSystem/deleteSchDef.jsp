<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    SchDefMgr smm=SchDefMgr.getInstance();
    SchDef sd =smm.find("id=" + id);
    Object[] o={sd};
    smm.remove(o);
   

    SchMembrMgr smm2=SchMembrMgr.getInstance();
    ArrayList<SchMembr> asd =smm2.retrieveList("schdefId='"+id+"'","");

    for(int i=0;asd!=null && i<asd.size();i++){
        SchMembr sm=asd.get(i);
        Object[] o2={sm};
        smm2.remove(o2);
    }
%>

<blockquote>
    <div class=es02>
        本班表已刪除.
    </div>
</blockquote>