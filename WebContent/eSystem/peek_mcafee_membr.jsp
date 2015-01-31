<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,mca.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    String membrId = request.getParameter("id");
    int feeId = Integer.parseInt(request.getParameter("feeId"));
    // McaRecord mr = McaRecordMgr.getInstance().find("billRecordId=" + brId);
    McaFee fee = McaFeeMgr.getInstance().find("id=" + feeId);
    ArrayList<Tag> tags = new McaTagHelper().getFeeTags(fee);
    String tagIds = new RangeMaker().makeRange(tags, "getId");

    Membr m = MembrMgr.getInstance().find("id=" + membrId);
    ArrayList<TagMembrStudent> tms = TagMembrStudentMgr.getInstance().retrieveList("membr.id=" + membrId
      + " and tag.id in (" + tagIds + ")", "");

    out.println("<b>" + m.getName() + "</b>");

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