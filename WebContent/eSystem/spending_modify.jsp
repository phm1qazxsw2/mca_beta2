<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,200))
    {
        response.sendRedirect("authIndex.jsp?code=200");
    }
%>
<%@ include file="leftMenu2-new.jsp"%>

<%
    Vitem vi = null;
    ArrayList<Vitem> vitems = null;
    try { 
        vitems = VitemMgr.getInstance().retrieveList("id=" + request.getParameter("id"), ""); 
        vi = vitems.get(0);
    } 
    catch (Exception e) {%><script>alert("參數不正確,找不到id");history.go(-1);</script><%}

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    EzCountingService ezsvc = EzCountingService.getInstance();
    ArrayList<Costpay2> costpays = ezsvc.getVpaidForVitems(vitems);
    Costtrade ctrade = (Costtrade) ObjectService.find("jsf.Costtrade", "id=" + vi.getCostTradeId());
    int cid = 0;
    String cname = "不指定廠商";
    if (ctrade!=null) {
        cid = ctrade.getId();
        cname = ctrade.getCosttradeName();
    }

    String backurl=request.getParameter("backurl");

    if(backurl ==null)
        backurl="spending_list.jsp";

    int tp =vi.getType();
    String cond = "";

    int scriptType=0;
    if(tp==1) {
        scriptType=2;
        cond = "t=4&t=7";
    }
    else if(tp==0) {
        scriptType=1;
        cond = "t=5&t=6&t=7";
    }
%>

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/formcheck.js"></script>
<script>
    function do_delete()
    {
        if (<%=vi.getPaidstatus()%>!=<%=Vitem.STATUS_NOT_PAID%>) {
            alert("已有收付款記錄不可刪除");
            return;
        }
        if (confirm('確定刪除此筆<%=(tp==Vitem.TYPE_SPENDING)?"支出":"收入"%>')) {
            document.xs.action = "spending_delete.jsp";
            document.xs.submit();
        }
    }
</script>

<br>
<br>

<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<b>
<%
    if(tp==0)
        out.println("<img src=pic/costticket.png border=0>&nbsp;修改支出");        
    else
        out.println("<img src=pic/incometicket.png border=0>&nbsp;修改收入");                
%>
</b>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="<%=backurl%>"><img src="pic/last.gif" border=0 width=14>&nbsp;回上一頁</a>
</div>

<%@ include file="spending_content.jsp"%>
<%@ include file="bottom.jsp"%>

<script>
document.xs.recordTime.value = '<%=sdf.format(vi.getRecordTime())%>';
document.xs.recordTime.disabled = true;
document.getElementById("timepopup").innerHTML = "";
document.xs.acctcode.value = '<%=vi.getAcctcode()%>';
document.xs.acctcode.onblur();
document.xs.title.value = '<%=phm.util.TextUtil.escapeJSString(vi.getTitle())%>';
document.xs.total.value = '<%=vi.getTotal()%>';
document.xs.note.value = '<%=phm.util.TextUtil.escapeJSString(vi.getNote())%>';
setAttachtype(<%=vi.getAttachtype()%>);
setCostTradeId(<%=cid%>, '<%=phm.util.TextUtil.escapeJSString(cname)%>');

<% 
    if (!checkAuth(ud2,authHa,201)) {
%>
        document.getElementById("buttons").innerHTML = "權限不足無法修改!";
        </script>
<%
        return;
    }
%>
<% if (ud2.getId()==vi.getUserId()) { %>
document.xs.action = 'spending_modify2.jsp';
var content = "<input type=hidden name='id' value='<%=vi.getId()%>'><input type=submit value='修改'>";
content += '<input type=hidden name="backurl" value="<%=backurl%>">';
    <% if (vi.getPaidstatus()==Vitem.STATUS_NOT_PAID) { %>
        content += '　　　　　　　　　　<input type=button value="刪除" onclick="do_delete()">';
    <% } else { %>
        content += '　　　　　　　　　　有收付款記錄不可刪除';
    <% } %>
<% } else { %>
var content = "非登入者不可修改";
<% } %>
document.getElementById("buttons").innerHTML = content;
</script>

