<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=11;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>

<%

request.setCharacterEncoding("UTF-8");
int moneyNum=Integer.parseInt(request.getParameter("moneyNum"));

if(moneyNum <=0)
{
%>
    <BR>
    <BR>
    <blockquote>
        <div class=es02>
            <font color=red>Error:</font> 轉出金額不得小於或等於0.
        </div>
    </blockquote>
<%
	return;
}

int paywayX=Integer.parseInt(request.getParameter("paywayX"));

String ps=request.getParameter("ps");

int fromtype=Integer.parseInt(request.getParameter("type"));

int fromId=0;

if(fromtype==1)
	fromId=Integer.parseInt(request.getParameter("tradeaccountId"));
else if (fromtype==2)
	fromId=Integer.parseInt(request.getParameter("bankName"));
	

int totype=Integer.parseInt(request.getParameter("Totype"));

int toId=0;

if(totype==1)
	toId=Integer.parseInt(request.getParameter("TotradeaccountId"));
else if (totype==2)
	toId=Integer.parseInt(request.getParameter("TobankName"));

java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 
String tradeDate=request.getParameter("tradeDate");

Insidetrade it=new Insidetrade();
it.setInsidetradeUserId   	(ud2.getId());
it.setInsidetradeUserPs   	(ps);
it.setInsidetradeNumber   	(moneyNum);
it.setInsidetradeWay(paywayX);
it.setInsidetradeDate   	(df.parse(tradeDate));
it.setInsidetradeFromType   	(fromtype);
it.setInsidetradeFromId   	(fromId);
it.setInsidetradeToType   	(totype);
it.setInsidetradeToId   	(toId);

JsfPay jp=JsfPay.getInstance();

try {
    jp.insertInsidetrade(it,ud2,_ws.getSessionBunitId());
    response.sendRedirect("listInsidetrade.jsp?m=1");
}
catch (Exception e) {
    if (e.getMessage()!=null&&e.getMessage().equals("x")) {
  %><script>alert("收費金額小於0");history.go(-1);</script><%
    } else {
            e.printStackTrace();
            if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
            }
    }
    return;
}    

%>