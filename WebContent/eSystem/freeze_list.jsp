<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    ArrayList<Freeze> fs = FreezeMgr.getInstance().retrieveListX("", "order by id desc", _ws2.getBunitSpace("bunitId"));
    EzCountingService ezsvc = EzCountingService.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
%>

<center>  
  <table width="390" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
        <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=f0f0f0>
                <td>
                    關帳日期
                </td>
                <td>
                    by
                </td>
                <td>
                    設定時間
                </td>
            </tr>
<%
    for (int i=0; i<fs.size(); i++) {
        Freeze f = fs.get(i);
%>
            <tr class=es02 bgcolor=ffffff>
                <td>
                    <%=sdf.format(f.getFreezeTime())%>
                </td>
                <td>
                    <%=ezsvc.getUserName(f.getUserId())%>
                </td>
                <td>
                    <%=sdf2.format(f.getCreated())%>
                </td>
            </tr>
<%
    }
%>
        </table>
    </td>
    </tr>
</table>
</center>