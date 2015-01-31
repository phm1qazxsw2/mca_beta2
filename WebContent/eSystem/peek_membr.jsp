<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    int membrId = Integer.parseInt(request.getParameter("id"));
    Membr m = MembrMgr.getInstance().find("id=" + membrId);
    Student2 s = Student2Mgr.getInstance().find("id=" + m.getSurrogateId());
    ArrayList<TagMembrStudent> tms = TagMembrStudentMgr.getInstance().retrieveList("membr.id=" + membrId
      + " and tag.status=" + Tag.STATUS_CURRENT, "");

    out.println("<b>" + m.getName() + "</b>");
    if (s.getStudentNickname()!=null && s.getStudentNickname().length()>0) {
        out.println("(" + s.getStudentNickname() + ")");
    }

    out.println("<br>");
    if (tms.size()>0) {
        out.println("<table class=es02>");
        Iterator<TagMembrStudent> iter = tms.iterator();
        while (iter.hasNext()) {
            TagMembrStudent ts = iter.next();
            if (ts.getTagName()!=null)
                out.println("<tr><td nowrap>" + ts.getTagFullname() + "</td></tr>");
        }
        out.println("</table>");
    }
    
%>