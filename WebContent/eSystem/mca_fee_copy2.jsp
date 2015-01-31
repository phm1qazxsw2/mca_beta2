<%@ page language="java" buffer="32kb"  import="web.*,jsf.*,phm.ezcounting.*,mca.*,java.lang.reflect.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>	
<%
boolean commit = false;
int tran_id = 0;
String do_action = "";
try {           
    tran_id = dbo.Manager.startTransaction();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");

    Enumeration names = request.getParameterNames();
    McaFee fee = new McaFee();

    Class c = fee.getClass();
    Method[] methods = c.getDeclaredMethods();
    Map<String, Method> methodMap = new SortingMap(methods).doSortSingleton("getName");

    Object[] params = new Object[1];
    while(names.hasMoreElements()) {
        String name=(String)names.nextElement();
        if (name.equals("title") || name.equals("month") || name.equals("billDate") || name.equals("do_action") ||
            name.equals("feeType") || name.equals("noname") || name.equals("regPrepayDeadline"))
            continue;
        String methodName = "set" + name.substring(0,1).toUpperCase() + name.substring(1);
        Method m = methodMap.get(methodName);
        int v = Integer.parseInt(request.getParameter(name));
        params[0] = new Integer(v);
        Object ret = m.invoke(fee, params);
    }
    
    fee.setTitle(request.getParameter("title"));
    String month = request.getParameter("month");
    fee.setMonth(sdf.parse(month));
    String billDate = request.getParameter("billDate");
    fee.setBillDate(sdf1.parse(billDate));
    String feeType = request.getParameter("feeType");
    try {   
        fee.setFeeType((feeType.equals("1"))?McaFee.FALL:(feeType.equals("2"))? McaFee.SPRING:McaFee.REGISTRATION_ONLY); 
    } catch (Exception e) {}
    if (fee.getFeeType()==McaFee.FALL) {
        int checkFeeId = 0;
        try { checkFeeId = Integer.parseInt(request.getParameter("checkFeeId")); } catch (Exception e) {}
        fee.setCheckFeeId(checkFeeId);
    }
    try {
        String regPrepayDeadline = request.getParameter("regPrepayDeadline");
        fee.setRegPrepayDeadline(sdf1.parse(regPrepayDeadline));
    }
    catch (Exception e) 
    {
    }
    try {
        fee.setRegPenalty(Integer.parseInt(request.getParameter("regPenalty")));
    }
    catch (Exception e)
    {
        e.printStackTrace();
    }
        
    McaFeeMgr feemgr = new McaFeeMgr(tran_id);
    feemgr.create(fee);
    McaTagHelper th = new mca.McaTagHelper(tran_id);
    th.getFeeTags(fee);

    dbo.Manager.commit(tran_id);
    commit = true;
    response.sendRedirect("mca_fee.jsp?id=" + fee.getId());
}
catch (Exception e) {
    e.printStackTrace();
    if (e.getMessage()!=null) {
  %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
    } else {
  %><script>alert('錯誤發生，設定沒有寫入');history.go(-1);</script><%
    }
}
finally {
    if (!commit)
        dbo.Manager.rollback(tran_id);
}
%>

