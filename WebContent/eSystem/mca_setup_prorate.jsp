<%@ page language="java" buffer="32kb" import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%
    McaFee fee = McaFeeMgr.getInstance().find("id=" + request.getParameter("id"));
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String start = (fee.getStartDay()==null)?"":sdf.format(fee.getStartDay());
    String end = (fee.getEndDay()==null)?"":sdf.format(fee.getEndDay());
    String prorate = (fee.getProrateDay()==null)?"":sdf.format(fee.getProrateDay());
%>

<body>

<blockquote>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<form name="f1" action="mca_setup_prorate2.jsp" method=post>
<input type=hidden name="id" value="<%=fee.getId()%>">
Semester school days:
<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    Semester Start
                </td>
                <td>
                    <input name="start" value="<%=start%>" size=8>
                    <a href="#" onclick="displayCalendar(document.f1.start,'yyyy-mm-dd',this);return false"><img src="pic/blog4.gif" border=0></a>                
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    Pro-rate Start
                </td>
                <td>
                    <input name="prorate" value="<%=prorate%>" size=8>
                    <a href="#" onclick="displayCalendar(document.f1.prorate,'yyyy-mm-dd',this);return false"><img src="pic/blog4.gif" border=0></a>
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    Semester End
                </td>
                <td>
                    <input name="end" value="<%=end%>" size=8>
                    <a href="#" onclick="displayCalendar(document.f1.end,'yyyy-mm-dd',this);return false"><img src="pic/blog4.gif" border=0></a>
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    Excludes
                </td>
                <td>
                    <textarea name="excludes" rows=3 cols=40><%= (fee.getExcludeDays()==null)?"":fee.getExcludeDays()%></textarea>
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    Includes
                </td>
                <td>
                    <textarea name="includes" rows=3 cols=40><%= (fee.getIncludeDays()==null)?"":fee.getIncludeDays()%></textarea>
                </td>
            </tr>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 colspan=2 align=center>                    
                    <input type=submit value="儲存">
                </td>
            </tr>
        </table>

    </td>
    </tr>
</table>


</form>
</blockquote>
