<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    Tag getCampusTag(ArrayList<Tag> tags, int bunitId)
        throws Exception
    {
        Bunit bu = BunitMgr.getInstance().find("id=" + bunitId);
        Map<String, Tag> tagnameMap = new SortingMap(tags).doSortSingleton("getName");
        return tagnameMap.get(bu.getLabel());
    }
%>
<%
    Membr m = MembrMgr.getInstance().find("id=" + request.getParameter("mid"));
    McaStudent ms = McaStudentMgr.getInstance().find("membrId=" + m.getId());
    int gradeId = new McaService().getGradeProgId(ms.getGrade());

    McaFee fee = McaFeeMgr.getInstance().find("id=" + request.getParameter("feeId"));
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date prorateDate = sdf.parse(request.getParameter("prorateDate"));
    McaTagHelper th = new McaTagHelper();
    ArrayList<Tag> tags = th.getFeeTags(fee, _ws2.getStudentBunitSpace("bunitId"));
    th.setup_tags(tags);
    Tag campustag = getCampusTag(tags, _ws2.getSessionBunitId());
    Map<Integer, ArrayList<Tag>> typedtagMap = new SortingMap(tags).doSortA("getTypeId");
%>


<blockquote>
<H3><%=fee.getTitle()%></H3>
<form name="f1" action="mca_addsingle4.jsp" method=post>
<input type=hidden name="mid" value="<%=m.getId()%>">
<input type=hidden name="feeId" value="<%=fee.getId()%>">
<input type=hidden name="campustag" value="<%=campustag.getId()%>">
<input type=hidden name="prorateDate" value="<%=sdf.format(prorateDate)%>">
<%
    Iterator<Integer> iter = typedtagMap.keySet().iterator();
    while (iter.hasNext()) {
        Integer typeId = iter.next();
        int ttId = typeId.intValue();
        ArrayList<Tag> typetags = typedtagMap.get(typeId);
        String typename = th.getTypeName(ttId);
        if (typename.equals("Campus"))
            continue;
        out.println("<ul>" + typename);
        if (!typename.equals("Grade")) {
            %><br><input type=radio name="_<%=ttId%>" value="0">None<%
        }
        for (int i=0; i<typetags.size(); i++) {
            Tag t = typetags.get(i);
%>
    <br><input type=radio name="_<%=ttId%>" value="<%=t.getId()%>" <%=(t.getProgId()==gradeId)?"checked":""%>> <%=th.getTagFullname(t)%>
<% 
        }
        out.println("</ul>");
    }
%>
<br>
<input type=submit value="&nbsp;Next&nbsp;">
</form>
</blockquote>
