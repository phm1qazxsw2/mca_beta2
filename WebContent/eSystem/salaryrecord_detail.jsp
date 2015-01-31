<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    static DecimalFormat mnf = new DecimalFormat("###,###,##0");
    public String pn(int n)
    {
        return (n<0)?"("+mnf.format(Math.abs(n))+")":mnf.format(n);
    }
%>
</td>
</table>
<script>
function doCheck(f)
{
    if (f.pWay[1].checked && <%=pd2.getPaySystemEmailServer()==null||pd2.getPaySystemEmailServer().length()==0%>) {
        alert("郵件服務器尚未設定無法 Email 帳單，請先設定或聯絡必亨客服");
        return false;
    }
    return true;
}
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td width="100%">
<%
    //##v2
    String o = request.getParameter("o");
    String t = request.getParameter("t");
    String str = request.getParameter("freshonly");
    boolean freshonly = (str!=null) && str.equals("true");
    if (o==null || o.length()==0) {
        out.println("<ul>沒有預覽資料.</ul>");
        return;
    }
    String[] pairs = o.split(",");
    HashMap m1 = new HashMap();
    HashMap m2 = new HashMap();
    StringBuffer sb1 = new StringBuffer();
    StringBuffer sb2 = new StringBuffer();
    for (int i=0; i<pairs.length; i++) {
        String[] tokens = pairs[i].split("#");
        if (m1.get(tokens[0])==null) {
            if (sb1.length()>0) sb1.append(",");
            sb1.append(tokens[0]);
            m1.put(tokens[0], "");
        }
        if (m2.get(tokens[1])==null) {
            if (sb2.length()>0) sb2.append(",");
            sb2.append(tokens[1]);
            m2.put(tokens[1], "");
        }
    }
    ChargeItemMembrMgr cismgr = ChargeItemMembrMgr.getInstance();
    ArrayList<ChargeItemMembr> items = cismgr.retrieveList(
        "charge.membrId in (" + sb1.toString() + ")" + 
        " and chargeitem.billRecordId in (" + sb2.toString() + ") and privLevel>=" + ud2.getUserRole(), "");

    Map<String, Vector<ChargeItemMembr>> m = new SortingMap(items).doSort("getTicketId");

    MembrInfoBillRecordMgr snbrmgr = MembrInfoBillRecordMgr.getInstance();
    String query = "membrbillrecord.membrId in (" + sb1.toString() + ")" + 
        " and membrbillrecord.billRecordId in (" + sb2.toString() + ")" + 
        " and billType=" + Bill.TYPE_SALARY +
        " and privLevel>=" + ud2.getUserRole();
    if (freshonly) 
        query += " and printDate=0";
    ArrayList<MembrInfoBillRecord> records = 
        snbrmgr.retrieveList(query, "");

    String chargeItemIds = new RangeMaker().makeRange(items, "getChargeItemId");

    ArrayList<FeeDetail> fees = FeeDetailMgr.getInstance().
        retrieveList("chargeItemId in (" + chargeItemIds + ")", "");
    // chargeKey
    Map<String, Vector<FeeDetail>> feeMap = new SortingMap(fees).doSort("getChargeKey");
    
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");    
%>
<br>

<div class=es02>
&nbsp;&nbsp;&nbsp;    <b>
<%

 if (t!=null) { %>
 <%= t %>
<% } %>
<% 
/*
if (!freshonly) { %>
    預覽全部
<% } else { %>
    預覽未列印帳單
<% } 

*/
%>
</b>
</div>
<center>
<table>
    <tr class=es02>
<form name=f1 action="salaryrecord_print.jsp" method=post onsubmit="return doCheck(this)">
        <td>

<% if (records.size()>0) { %>
<input type=radio name="pWay" value=0 checked>列印方式
<input type=radio name="pWay" value=1>Email方式
<input type="submit" value=" 發佈薪資條 ">
<% } %>
<input type="hidden" name="freshonly" value="<%=freshonly%>">
<input type="hidden" name="o" value="<%=o%>">
<% if (t!=null) { %>
<input type="hidden" name="t" value="<%=t%>">
<% } %>

        </td>
    </tR>
    </table>
</form>
</center>

<div class=es02 align=right>
    <a href="#" onClick="javascript:window.print();">友善列印本頁</a>&nbsp;&nbsp;&nbsp;&nbsp;
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<%
    if (records.size()==0) {
        out.println("<blockquote><div class=es02>沒有資料</div></blockquote>");
%>
    <script>
        function preview_fresh()
        {
            var f = document.f1;
            f.action = "billrecord_detail.jsp";
            f.freshonly.value = "true";
            f.submit();
        }
        function preview_all()
        {
            var f = document.f1;
            f.action = "billrecord_detail.jsp";
            f.freshonly.value = "false";
            f.submit();
        }
    </script>

        <%@ include file="bottom.jsp"%>	
<%
        return;
    }            
%> 
<div class=es02 align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;合計: <%= records.size() %>筆&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<center>
<table width="70%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#f0f0f0 class=es02>
            <td>姓名</td>
            <td>帳單流水號</td>
            <td width=200>應付金額</td>
            <td width=525>
                <table width=100% border="0" cellpadding="0" cellspacing="0">
                <tr class=es02>
                    <tD align=middle width=180>項目</td>        
                    <td align=middle width=55>金額</td>
                    <TD align=middle width=80>登入人</td>
                </tr> 
                </table>
            </td>
        </tr>

<%
    Iterator<MembrInfoBillRecord> iter2 = records.iterator();
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    while (iter2.hasNext()) {
        MembrInfoBillRecord sinfo = iter2.next();
        Vector v = (Vector) m.get(sinfo.getTicketId());
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td class=es02 align=left valign=middle width=80>
                <%=sinfo.getMembrName()%>
            </td>
            <td class=es02 align=left valign=middle>
                流水號:<a href="bill_detail.jsp?sid=<%=sinfo.getMembrId()%>&rid=<%=sinfo.getBillRecordId()%>&backurl=billrecord_detail.jsp"><font color=blue><%=sinfo.getTicketId()%></font></a><br>
            </tD>
            <%      
                int nowTotalX=sinfo.getReceivable()-sinfo.getReceived();
            %>
            <td valign=middle bgcolor=<%=(nowTotalX>0)?"4A7DBD":"F77510"%>>
                  <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width=100% class=es02>
                               <font color=white>
                                應付：<%=sinfo.getReceivable()%> - 已付：<%=sinfo.getReceived()%>
                                </font>
                            </td>
                        </tr>
                        <tr>
                            <td width=100% class=es02>
                               <a href="bill_detail.jsp?sid=<%=sinfo.getMembrId()%>&rid=<%=sinfo.getBillRecordId()%>&backurl=billrecord_detail.jsp">
                            <font color=white>

                            <%  if(nowTotalX >0){   %>
                            =未付金額：<%=mnf.format(nowTotalX)%>
                            <%  }else{  %>
                            =已付清
                            <%  }   %>
                            </font></a>
                            </td>
                        </tr>
                    </table>
            </tD>
            <tD width=525  class=es02 >
                <table border=0 width=100% class=es02>
                    <% 
                        double subtotal_1=0, subtotal_2=0;
                        for (int j=0; v!=null&&j<v.size(); j++) {
                            ChargeItemMembr item = (ChargeItemMembr) v.get(j);
                            subtotal_1 += item.getMyAmount();
                    %>
                    <tr class=es02>
                        <td nowrap width=180>
                            <img src="img/flag2.png" border=0>&nbsp;<%=item.getChargeName()%><% 
                                Vector<FeeDetail> fv = feeMap.get(item.getChargeKey());
                                for (int i=0; fv!=null && i<fv.size(); i++) {
                                    FeeDetail fd = fv.get(i);                                   
                                    out.println("<br>&nbsp;&nbsp;&nbsp;" + sdf2.format(fd.getFeeTime()) + " " + pn(fd.getUnitPrice()) + "x" + fd.getNum() + "=" + pn(fd.getUnitPrice() * fd.getNum()));
                                }
                      %></td>
                        <td width=55 align=right><%=pn(item.getMyAmount())%></td>
                        <tD width=80 align=middle><%=item.getUserLoginId()%></td>
                    </tr>              
                    <%
                        }
                    %>
                </table>            
            </td>
        </tr> 
        <tr bgcolor=ffffff>
            <td colspan=4 class=es02 align=middle valign=middle>
             ......................................................................................................................................................................................................   
            </td>
        </tr>
<%  } %>
 <tr bgcolor=ffffff>
            <td colspan=4 class=es02 align=middle valign=middle height=40>
                主管簽核:   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 日期:                
            </td>
        </tr>
        </table>
    </td>
    </tr>
    </table>
</center>
<br>
<br>
  <script>
        function preview_fresh()
        {
            var f = document.f1;
            f.action = "billrecord_detail.jsp";
            f.freshonly.value = "true";
            f.submit();
        }
        function preview_all()
        {
            var f = document.f1;
            f.action = "billrecord_detail.jsp";
            f.freshonly.value = "false";
            f.submit();
        }
    </script>