<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%!
    boolean isSame(ArrayList<McaStudentInfo> a1, ArrayList<McaStudentInfo> a2)
    {
        if (a1==null || a2==null || (a1.size()!=a2.size()))
            return false;
        for (int i=0; i<a1.size(); i++) {
            if (a1.get(i).getId()!=a2.get(i).getId())
                return false;
        }
        return true;
    }
%>
<%
    int topMenu=4;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,602))
    {
        response.sendRedirect("authIndex.jsp?code=602");
    }
%>
<%@ include file="leftMenu4.jsp"%>
<br>

&nbsp;&nbsp;&nbsp;
<img src="pic/tagtype.png" border=0>&nbsp; 
<b> Families </b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
<div class=es02>
The following listings are students of the same parent, father or mother. They will be used for "Family Discount" calculation. Please make sure the informations are correct before generating bills.
<br>
<br>
</div>

<%
    ArrayList<McaStudentInfo> msts = McaStudentInfoMgr.getInstance().retrieveList("studentStatus in (3,4)", "");
    Map<String, ArrayList<McaStudentInfo>> samefatherMap = new SortingMap(msts).doSortA("getFatherName");
    Map<String, ArrayList<McaStudentInfo>> samemotherMap = new SortingMap(msts).doSortA("getMotherName");
    Iterator<String> iter = samefatherMap.keySet().iterator();

    out.println("<H2>Same Parents:</H2>");
    while (iter.hasNext()) {
        String name = iter.next();
        if (name.trim().length()==0)
            continue;
        ArrayList<McaStudentInfo> samefather = samefatherMap.get(name);
        if (samefather.size()>1) {
            String mothername = samefather.get(0).getMotherName();
            ArrayList<McaStudentInfo> samemother = samemotherMap.get(mothername);
            if (samemother==null||samemother.size()==0)
                continue;

            out.println(name + " and " + mothername);
            if (!isSame(samefather, samemother)) {
                out.println("<font color=red><b>(Warning** father=" + samefather.size() + " mother=" + samemother.size() + ")</b></font>");
            }
            out.println("<ul>");
            ArrayList<McaStudentInfo> tmp = (samefather.size()>samemother.size())?samefather:samemother;
            for (int i=0; i<tmp.size(); i++) {
                McaStudent ms = tmp.get(i);
                out.println("<li><a href=\"javascript:openwindow_phm2('modify_mca_student.jsp?studentId="+tmp.get(i).getStudId()+"','基本資料',700,700,'mcastudentwin');\">" + ms.getFullName() + "</a> (" + ms.getCampus() + " " + ms.getGrade() + ")");
            }

            out.println("</ul>");
            samefatherMap.put(name, null);
            samemotherMap.put(mothername, null);
        }
    }
    
    out.println("<H2>Same Father:</H2>");
    iter = samefatherMap.keySet().iterator();
    while (iter.hasNext()) {
        String name = iter.next();
        if (name.trim().length()==0)
            continue;
        ArrayList<McaStudentInfo> samefather = samefatherMap.get(name);
        if (samefather==null)
            continue;
        if (samefather.size()>1) {
            out.println(name + "<ul>");
            for (int i=0; i<samefather.size(); i++) {
                McaStudent ms = samefather.get(i);
                out.println("<li><a href=\"javascript:openwindow_phm2('modify_mca_student.jsp?studentId="+samefather.get(i).getStudId()+"','基本資料',700,700,'mcastudentwin');\">" + ms.getFullName() + "</a> (" + ms.getCampus() + " " + ms.getGrade() + ")");
            }
            out.println("</ul>");
        }
    }

    out.println("<H2>Same Mother:</H2>");
    iter = samemotherMap.keySet().iterator();
    while (iter.hasNext()) {
        String name = iter.next();
        if (name.trim().length()==0)
            continue;
        ArrayList<McaStudentInfo> samemother = samemotherMap.get(name);
        if (samemother==null)
            continue;
        if (samemother.size()>1) {
            out.println(name + "<ul>");
            for (int i=0; i<samemother.size(); i++) {
                McaStudent ms = samemother.get(i);
                out.println("<li><a href=\"javascript:openwindow_phm2('modify_mca_student.jsp?studentId="+samemother.get(i).getStudId()+"','基本資料',700,700,'mcastudentwin');\">" + ms.getFullName() + "</a> (" + ms.getCampus() + " " + ms.getGrade() + ")");
            }
            out.println("</ul>");
        }
    }

%>

</blockquote>

<!--- end 主內容 --->
<%@ include file="bottom.jsp"%>	