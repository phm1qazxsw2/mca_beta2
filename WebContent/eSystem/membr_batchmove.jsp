<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
   //##v2
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();

    
    int act = Integer.parseInt(request.getParameter("act"));
    int fromtag = Integer.parseInt(request.getParameter("fromtag"));
    int totag = Integer.parseInt(request.getParameter("totag"));
    String[] targets = request.getParameterValues("target");

    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();
        TagMembrMgr tmmgr = new TagMembrMgr(tran_id);
        for (int i=0; i<targets.length; i++) {
            int membrId = Integer.parseInt(targets[i]);
            if (totag>0 && tmmgr.numOfRows("tagId=" + totag + " and membrId=" + membrId)==0) {
                TagMembr tm = new TagMembr();                
                tm.setTagId(totag);
                tm.setMembrId(membrId);
                tmmgr.create(tm);
            }
            if (act==1&& fromtag>0) { // move or delete
                TagMembr[] oldtms = { tmmgr.find("tagId=" + fromtag + " and membrId=" + membrId) };
                tmmgr.remove(oldtms); // remove from original tag
            }
        }
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
    String backurl = request.getParameter("backurl");
%>
<script>
    alert('<%=(act==1)?"move":"copy"%> success!');
    location.href = '<%=(backurl==null)?"studentoverview.jsp":backurl%>';
</script>