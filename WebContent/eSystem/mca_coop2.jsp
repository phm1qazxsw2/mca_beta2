<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%
StringBuffer skip = new StringBuffer();
StringBuffer done = new StringBuffer();
StringBuffer error = new StringBuffer();
int done_num = 0;
int skip_num = 0;
int error_num = 0;
try
{
    String data = request.getParameter("data");
    if (data==null)
        return;        
    PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
    EzCountingService ezsvc = EzCountingService.getInstance();

    String[] lines = data.split("\n");
    String acctprefix = "1852765";

    for (int i=0; i<lines.length; i++) {
        if (lines[i].trim().length()==0)
            continue;
        String[] tokens = lines[i].trim().split(" ");
        int c = tokens[0].indexOf(acctprefix);
        if (c<0)
            continue; // 帳號 交易日 摘要 提款金額 存款金額 餘額 交易行庫 備註 支票號碼 
        
        ArrayList<MembrInfoBillRecord> fully_paid = new ArrayList<MembrInfoBillRecord>();

        try {
            BillPay bpay = ezsvc.doMcaBalance(lines[i], fully_paid);
            if (bpay==null) {
                skip_num ++;
                skip.append(lines[i] + "\n");
            }
            else {
                done_num ++;
                done.append(lines[i] + "\n");
            }
        }
        catch (Exception ee) {
System.out.println("### msg=" + ee.getMessage());
            ee.printStackTrace();
            error_num ++;
            error.append("\n" + lines[i]);
            error.append("\nerror:" + ee.getMessage());
        }
    }
}
catch(Exception e)
{
    e.printStackTrace();
}
%>


<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
 
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;Upload Co-operation Bank Data</b>
</div> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>
<% if (done_num>0) { %>
   <br>
   <br>
   <%=done_num%> record(s) accepted<br>
   <ul>
      <%=done.toString().replace("\n", "<br>")%>
   </ul>
   <br>
<% } %>
<% if (skip_num>0) { %>
   <%=skip_num%> record(s) duplicated<br>
   <ul>
      <%=skip.toString().replace("\n", "<br>")%>
   </ul>
<% } %>
<% if (error_num>0) { %>
   <%=error_num%> record(s) error<br>
   <ul>
      <%=error.toString().replace("\n", "<br>")%>
   </ul>
<% } %>
</blockquote>


<%@ include file="bottom.jsp"%>	
