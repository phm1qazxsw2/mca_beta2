<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int membrId = Integer.parseInt(request.getParameter("sid"));
    int billRecordId = Integer.parseInt(request.getParameter("rid"));
    MembrBillRecordMgr sbrmgr = MembrBillRecordMgr.getInstance();
    MembrBillRecord sbr = sbrmgr.find("membrId=" + membrId + " and billRecordId=" + billRecordId);
    String datestr = request.getParameter("billDate");
    Date billdate = new SimpleDateFormat("yyyy-MM-dd").parse(datestr);
    sbr.setBillDate(billdate);
    sbrmgr.save(sbr);

    String comment = request.getParameter("comment");
    
    BillCommentMgr bmgr = BillCommentMgr.getInstance();
    BillComment bc = bmgr.find("membrId=" + membrId + " and billRecordId=" + billRecordId);
    if (bc!=null) {
        String orgcomment = bc.getComment();
        if (!orgcomment.equals(comment)) {
            bc.setComment(comment);
            bmgr.save(bc);
        }
    }
    else {
        if (comment.length()>0) {
            bc = new BillComment();
            bc.setMembrId(membrId);
            bc.setBillRecordId(billRecordId);
            bc.setComment(comment);
            bmgr.create(bc);
        }
    }
%>
<br>
<br>
<div class=es02>    
    <blockquote>
    設定成功.
    </blockquote>
</div>