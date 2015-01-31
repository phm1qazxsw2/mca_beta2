<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*,phm.util.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%!
    public static String exactLeft(String str, int size)
    {
        String s = TextUtil.makePrecise(str, size, true, ' ');
        return s.replace(" ", "&nbsp;");
    }
    public static String exactRight(String str, int size)
    {
        String s = TextUtil.makePrecise(str, size, false, ' ');
        return s.replace(" ", "&nbsp;");
    }
    public ArrayList<VchrItem> SortDebitFirst(ArrayList<VchrItem> items)
        throws Exception
    {
        Map<Integer, ArrayList<VchrItem>> itemMap = new SortingMap(items).doSortA("getFlag");
        PArrayList<VchrItem> ret = new PArrayList<VchrItem>(itemMap.get(VchrItem.FLAG_DEBIT));
        ret.concate(itemMap.get(VchrItem.FLAG_CREDIT));
        return ret;
    }
   
%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,###.#");
    EzCountingService ezsvc = EzCountingService.getInstance();

    VchrHolder v = VchrHolderMgr.getInstance().find("id=" + request.getParameter("id"));
    if (v==null) {
        v = VchrHolderMgr.getInstance().find("serial='" + request.getParameter("s")+"'");
    }
    String compName = new BunitHelper().getCompanyNameTitle(_ws2.getSessionBunitId());
    ArrayList<VchrItem> items = VchrItemMgr.getInstance().retrieveList("vchrId=" + v.getId(), "");
    items = SortDebitFirst(items);
    VchrInfo vinfo = new VchrInfo(items, 0);
%>

<link rel="stylesheet" href="table_grid.css" type="text/css">
<!--
    Samples:
        <table border=0 cellpadding=3 cellspacing=0 style="border:solid black 1px">
        <tr>
            <td class=type1>A</td><td class=type1>B</td><td class=type3>C</td>
        </tr>
        <tr>
            <td class=type1>D</td><td class=type1>E</td><td class=type3>F</td>
        </tr>
        <tr>
            <td class=type2>X</td><td class=type2>Y</td><td class=type4>Z</td>
        </tr>
        </table>
-->

<table border=0 width=100%>
<tr align=center >
   <td colspan=3 style="font-size:26px">
       <%=compName%>
   </td>
</tr>
<tr align=left>
   <td style="font-size:16px">
       <%=(v.getSerial().indexOf("_my")==0)?"列印":"入帳"%>日期: <%=sdf.format(v.getRegisterDate())%>
   </td>
   <td style="font-size:16px">
       傳票編號: <%=v.getSerial()%>
   </td>
</tr>
<tr>
   <td colspan=2>
        <table border=0 cellpadding=3 cellspacing=0 style="border:solid black 1px" align=left valign=top width=100%>
        <tr align=center>
            <td class=type1>借 貸</td>
            <td class=type1>部門</td>
            <td class=type1>專案</td>
            <td class=type1>科目編號</td>
            <td class=type1>科目名稱</td>
            <td class=type1>摘要</td>
            <td class=type1>借方金額</td>
            <td class=type3>貸方金額</td>
        </tr>

<% 
    double debit_total = 0, credit_total = 0;
    int lines = (items.size()<16)?16:items.size();
    for (int i=0; i<lines; i++) {
        VchrItem vi = (i<items.size())?items.get(i):null;
        debit_total += (vi!=null)?vi.getDebit():0;
        credit_total += (vi!=null)?vi.getCredit():0;
        String c1 = (i!=(lines-1))?"type2":"type1";
        String c2 = (i!=(lines-1))?"type4":"type3";        

%>
        <tr>
            <td class=<%=c1%> nowrap><%=exactLeft(((vi!=null)?vinfo.getFlagForPrint(vi):""),5)%></td>
            <td class=<%=c1%> nowrap><%=exactLeft(((vi!=null)?vinfo.getBunitName(vi):""),8)%></td>
            <td class=<%=c1%> nowrap><%=exactLeft("",8)%></td>
            <td class=<%=c1%> nowrap><%=exactLeft(((vi!=null)?(vinfo.getMain(vi)+" "+vinfo.getSub(vi)):""),8)%></td>
            <td class=<%=c1%> nowrap><%=exactLeft(((vi!=null)?vinfo.getAcodeName(vi):""),22)%></td>
            <td class=<%=c1%> nowrap><%=exactLeft(((vi!=null)?vinfo.getNote(vi):""),40)%></td>
            <td class=<%=c1%> align=right nowrap><%=exactRight(((vi!=null)?vinfo.formatDebit(vi):""),10)%></td>
            <td class=<%=c2%> align=right nowrap><%=exactRight(((vi!=null)?vinfo.formatCredit(vi):""),10)%></td>
        </tr>
<%
    }
%>
        <tr>
            <td class=type3>　</td>
            <td class=type3>　</td>
            <td class=type3>　</td>
            <td class=type3>　</td>
            <td class=type3>　</td>
            <td class=type1 align=right>合計</td>
            <td class=type1 nowrap align=right><%=exactRight(mnf.format(debit_total),10)%></td>
            <td class=type3 nowrap align=right><%=exactRight(mnf.format(credit_total),10)%></td>
        </tr>
        <tr>
            <td colspan=8>
                <table border=0 cellpadding=3 cellspacing=0 style="border:solid black 1px" align=center width=100%>
                    <tr>
                        <td class=type2 width=10>核<br>準</td>
                        <td width="24%"></td>
                        <td class=type5 width=10>主<br>管</td>
                        <td width="24%"></td>
                        <td class=type5 width=10>會<br>計</td>
                        <td width="24%"></td>
                        <td class=type5 width=10>製<br>單</td>
                        <td width="24%" align=center><%=ezsvc.getUserName(v.getUserId())%></td>
                    </tr>
                </table>
            </td>
        </tr>
        </table>
   </td>
</tr>
</table>


