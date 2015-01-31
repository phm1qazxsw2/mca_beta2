<%@ page language="java" buffer="32k" import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=4;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>
<%
    //##v2


    int tid=Integer.parseInt(request.getParameter("tagid"));
    int status=Integer.parseInt(request.getParameter("status"));
    String tagName = "";
    String q = null;
    if (tid==0) {
        tagName = "未定";
        q = "tag.id is NULL";
    }
    else {
        Tag tag = TagMgr.getInstance().find("id=" + tid);
        tagName = tag.getName();
        q = " tagId=" + tid;
    }
    ArrayList<TagMembrStudent> tagstudents = TagMembrStudentMgr.getInstance().
        retrieveList("studentStatus in (3,4) and " + q,"");

    StudentMgr sm=StudentMgr.getInstance();

    Iterator<TagMembrStudent> iter = tagstudents.iterator();
    while (iter.hasNext())
    {
        TagMembrStudent ts = iter.next();

        int stuId=ts.getStudentId();
        Student stu=(Student)sm.find(stuId);  
        stu.setStudentStatus(status);
        sm.save(stu);
    }

    response.sendRedirect("studentoverview.jsp?m=1");
%>    