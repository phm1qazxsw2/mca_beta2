<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%!
    String makeLink(String name, int which, boolean current, String url)
    {
        if (current)
            return name;
        return "<a href='" + url + "&sortby=" + which + "'>" + name + "</a>";
    }

    String getTableHeader(String url, int sortby)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("<td align=middle nowrap>No.</td>");
        sb.append("<td align=middle nowrap>"+makeLink("上課日期", 0, (sortby==0), url)+"</a></td>");
        sb.append("<td align=middle nowrap>"+makeLink("登入日期", 1, (sortby==1), url)+"</a></td>");
        sb.append("<td align=middle nowrap>"+makeLink("對象", 2, (sortby==2), url)+"</a></td>");
        sb.append("<td align=middle nowrap>"+makeLink("上課人員", 3, (sortby==3), url)+"</a></td>");
        sb.append("<td align=middle nowrap>費用名目</td>");
        sb.append("<td align=middle nowrap>單價</td>");
        sb.append("<td align=middle nowrap>數量</td>");
        sb.append("<td align=middle nowrap>小計</td>");
        sb.append("<td align=middle nowrap>備註</td>");
        sb.append("<td align=middle></td>");
        sb.append("</tr>");
        return sb.toString();
    }
%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>
    function do_delete(mhId) {
        if (!confirm("確定刪除此筆記錄?"))
            return;
        var url ="manhour_delete.jsp?id=" + mhId +  "&r=" + new Date().getTime();
        var req = new XMLHttpRequest();

        if (req) 
        {
            req.onreadystatechange = function() 
            {
                if (req.readyState == 4 && req.status == 200) 
                {
                    var t = req.responseText.indexOf("@@");
                    if (t>0)
                        alert(req.responseText.substring(t+2));
                    else
                        location.reload();
                }
            }
        };
        req.open('GET', url);
        req.send(null);        
    }
</script>

<form name="f">
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:openwindow_phm2('manhour_add.jsp', '新增上課記錄', 600, 700, 'addmanhour');"><img src="pic/costAdd.png" border=0>&nbsp;新增上課記錄</a>
</div>

<br>

<%
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
%>
<blockquote>

<% if (manhours.size()==0) { %>
    
    區段內沒有上課記錄

<% } else { %>

<table height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <%=getTableHeader(url, sortby)%>
<%
    int k = 0;
    ManHourDescription desc = new ManHourDescription(manhours);
    for (int i=0; i<manhours.size(); i++) {
        ManHour mh = manhours.get(i);
        //if (k%7==6)
        //    out.println(getTableHeader());
        k++;
    %>

    <tr bgcolor=#ffffff  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'"  align=center valign=middle>
        <td class=es02><%=mh.getId()%></td>
        <td class=es02><%=sdf.format(mh.getOccurDate())%></td>
        <td class=es02><%=sdf.format(mh.getRecordTime())%></td>
        <td class=es02 nowrap><%=desc.getClientLink(mh)%></td>
        <td class=es02 nowrap><%=desc.getSalaryLink(mh)%></td>
        <td class=es02 align=left nowrap><%=desc.getChargeName(mh)%></td>
        <td class=es02 align=right><%=mnf.format(desc.getChargeUnitPrice(mh))%></td>
        <td class=es02 align=right><%=desc.getChargeNum(mh)%></td>
        <td class=es02 align=right><%=mnf.format(desc.getChargeSubtotal(mh))%></td>
        <td class=es02 width=100 nowrap><%=desc.getNote(mh)%></td>

        <td class=es02 nowrap><a href="javascript:openwindow_phm2('manhour_detail.jsp?id=<%=mh.getId()%>', '上課記錄內容', 600, 700, 'addmanhour');">複製</a> 
        | <a href="javascript:openwindow_phm2('manhour_detail.jsp?id=<%=mh.getId()%>&m=1', '上課記錄內容', 600, 700, 'addmanhour');">修改</a>
        | <a href="javascript:do_delete(<%=mh.getId()%>)">刪除</a></td>
    </tr>	
<%
    }
%>
    </table> 

</td>
</tr>
</table>
</form>

<% } %>

</blockquote>
<br>
<br>
<%@ include file="bottom.jsp"%>
