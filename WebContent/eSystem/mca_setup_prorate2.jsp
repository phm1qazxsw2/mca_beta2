<%@ page language="java" buffer="32kb" import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%
    McaFee fee = McaFeeMgr.getInstance().find("id=" + request.getParameter("id"));
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    try {
        fee.setStartDay(sdf.parse(request.getParameter("start")));
    }
    catch (Exception e) {}

    try {
        fee.setProrateDay(sdf.parse(request.getParameter("prorate")));
    }
    catch (Exception e) {}

    try {
        fee.setEndDay(sdf.parse(request.getParameter("end")));
    }
    catch (Exception e) {}

    String excludes = request.getParameter("excludes");
    Date start = fee.getStartDay();
    Date end = fee.getEndDay();
    if (excludes.trim().length()>0) {
        String[] exdays = null;
        if (excludes.indexOf(",")>0)
            exdays = excludes.split(",");
        else
            exdays = excludes.split("\n");
        for (int i=0; i<exdays.length; i++) {
            try {
                Date d = sdf.parse(exdays[i]);
                if (start!=null && end!=null && (d.compareTo(start)<0 || d.compareTo(end)>0)) {
                  %><script>alert('<%=sdf.format(d)%> not in range');history.go(-1)</script><%
                    return; 
                }
            }
            catch (Exception e) {
              %><script>alert('<%=exdays[i]%> format error');history.go(-1)</script><%
                return;
            }
        }
        fee.setExcludeDays(excludes);
    }
    else
        fee.setExcludeDays("");

    String includes = request.getParameter("includes");
    if (includes.trim().length()>0) {
        String[] indays = null;
        if (includes.indexOf(",")>0)
            indays = includes.split(",");
        else
            indays = includes.split("\n");
        for (int i=0; i<indays.length; i++) {
            try {
                Date d = sdf.parse(indays[i]);
                if (start!=null && end!=null && (d.compareTo(start)<0 || d.compareTo(end)>0)) {
                  %><script>alert('<%=sdf.format(d)%> not in range');history.go(-1)</script><%
                    return; 
                }
            }
            catch (Exception e) {
              %><script>alert('<%=indays[i]%> format error');history.go(-1)</script><%
                return;
            }
        }
        fee.setIncludeDays(includes);
    }
    else
        fee.setIncludeDays("");

    McaFeeMgr.getInstance().save(fee);
%>
<blockquote>
    done!
    <br>
    <br>
    <a href="mca_setup_prorate.jsp?id=<%=fee.getId()%>">keep editing</a>
</blockquote>
<script>
    parent.do_reload = true;
</script>
