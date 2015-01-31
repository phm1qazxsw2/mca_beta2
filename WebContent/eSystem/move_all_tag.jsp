<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=4;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>

<%
   //##v2
    int fromtag = Integer.parseInt(request.getParameter("fromtag"));
    int totag = Integer.parseInt(request.getParameter("totag"));

System.out.println("## frimtag="+fromtag+"  totag="+totag);

    String q = null;
    if (fromtag==0) {
        q = "tag.id is NULL";
    }
    else {
        q = " tagId=" + fromtag;
    }

    ArrayList<TagMembrStudent> tagstudents = TagMembrStudentMgr.getInstance().retrieveList("studentStatus in (3,4) and "+q,"");

        boolean commit = false;
        int tran_id = 0;
        try {
            tran_id = dbo.Manager.startTransaction();
            TagMembrMgr tmmgr = new TagMembrMgr(tran_id);      
    
            Iterator<TagMembrStudent> iter = tagstudents.iterator();
            while (iter.hasNext())
            {
                TagMembrStudent ts = iter.next();
                int membrId = ts.getMembrId();
                if (totag>0 && tmmgr.numOfRows("tagId=" + totag + " and membrId=" + membrId)==0) {

    
                    TagMembr tm = new TagMembr();                
                    tm.setTagId(totag);
                    tm.setMembrId(membrId);
                    tmmgr.create(tm);
                }
                if (fromtag>0) { // move or delete
                    TagMembr[] oldtms = { tmmgr.find("tagId=" + fromtag + " and membrId=" + membrId) };
                    tmmgr.remove(oldtms); // remove from original tag
                }
            }
            dbo.Manager.commit(tran_id);
            commit = true;
        }catch(Exception e){
            e.printStackTrace();
        }
        finally {
            if (!commit)
                dbo.Manager.rollback(tran_id);
        }
               
        response.sendRedirect("studentoverview.jsp?m=2");
%>