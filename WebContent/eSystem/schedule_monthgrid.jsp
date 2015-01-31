<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    String monstr = request.getParameter("month");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    Date month = sdf.parse(monstr);
    Calendar c = Calendar.getInstance();
    c.setTime(month);
    int thisMonth = c.getTime().getMonth();
    int dayofWeek = c.get(Calendar.DAY_OF_WEEK);
    StringBuffer sb = new StringBuffer();
    sb.append("<table><tr><th>日</th><th>一</th><th>二</th><th>三</th><th>四</th><th>五</th><th>六</th></tr><tr>");
    for (int i=0; i<dayofWeek-1; i++)
        sb.append("<td>　</td>");
    while (c.getTime().getMonth()==thisMonth) {
        sb.append("<td nowrap><input type=checkbox name=day value='"+
            c.get(Calendar.DAY_OF_MONTH)+"@"+ c.get(Calendar.DAY_OF_WEEK)+
            "'>"+ c.get(Calendar.DAY_OF_MONTH)+"</td>");
        dayofWeek = c.get(Calendar.DAY_OF_WEEK);
        if (dayofWeek==7)
            sb.append("</tr><tr>");
        c.add(Calendar.DATE, 1);
    }
    sb.append("</tr></table>");
%>
<table>
    <tr>
        <td>
            <%=sb.toString()%>
        </td>
        <td width=1 bgcolor="#f0f0f0"></td>
        <td valign=top>
        <div id="gridinfo">
            周一到周五 <input type=checkbox onclick="setupNormalWeekday(this)">
        </div>
        </td>
    </tr>
</table>

