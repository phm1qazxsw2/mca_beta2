<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,phm.accounting.*" contentType="text/javascript;charset=UTF-8"%>
<%
    String[] t = request.getParameterValues("t");
    String q = "";
    if (t!=null) {
        for (int i=0; i<t.length; i++) {
            if (q.length()>0) q += " or ";
            q += "main like '" + t[i] + "%'";
        }
    }
    if (q.length()>0)
        q = "(" + q + ") and ";
    q += "active=" + Acode.ACTIVE_YES;
    // ### 2009/2/4 added by peter, 學生帳戶不用傳回
    q += " and not (main='" + VoucherService.STUDENT_ACCOUNT + "' and sub like '#%')";
    // ########

    WebSecurity _ws2 = WebSecurity.getInstance(pageContext); // 沒辦法 include justHeader.jsp, complain about contenttype mismatch
    new VoucherService(0, _ws2.getSessionBunitId()).setupAcodeCashAccounts();
    StringBuffer sb = new StringBuffer();
    ArrayList<Acode> acodes = AcodeMgr.getInstance().retrieveListX(q, "order by main,sub asc", _ws2.getAcodeBunitSpace("bunitId"));
    AcodeInfo ainfo = new AcodeInfo(acodes);
    ArrayList<Acode> mains = ainfo.getMainAcodes();
    for(int i=0; mains!=null && i<mains.size(); i++)
    {
        if (sb.length()>0)
            sb.append(",\n");
        Acode main = mains.get(i);
        sb.append('"');
        sb.append(ainfo.getMainSub(main));
        sb.append('"');
        sb.append(',');
        sb.append('"');
        sb.append(ainfo.getName(main));
        sb.append('"');

        ArrayList<Acode> subs = ainfo.getSubAcode(main);
        if (subs!=null) {
            for(int j=0; subs!=null&&j<subs.size(); j++)
            {
                Acode sub = subs.get(j);
                sb.append(",\n");
                sb.append('"');
                sb.append(ainfo.getMainSub(sub,false));
                sb.append('"');
                sb.append(',');
                sb.append('"');
                sb.append(ainfo.getName(sub));
                sb.append('"');
            }
        }
    }
%>
var aNames = [
<%=sb.toString()%>
];
