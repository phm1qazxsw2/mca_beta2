<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
SchDef sd = null;
try {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SchDefMgr sdmgr = SchDefMgr.getInstance();
    String name = request.getParameter("name");
    Date startDate = sdf.parse(request.getParameter("startDate"));
    Date endDate = sdf.parse(request.getParameter("endDate"));
    int type = Integer.parseInt(request.getParameter("type"));
    int autoRun = Integer.parseInt(request.getParameter("autoRun"));
    String content = request.getParameter("content");
    String color = request.getParameter("color");
    String nowString=sdf.format(new Date());
    Date xdate=sdf.parse(nowString);

    int bunit = Integer.parseInt(request.getParameter("bunit"));

    Calendar c=Calendar.getInstance();
    c.setTime(xdate);
    c.add(Calendar.DATE,1);
    Date nextDate=c.getTime();

    if(autoRun==1 && startDate.compareTo(nextDate)<0){
%>        
        <blockquote>
            <div class=es02>
                <font color=blue>新增失敗.</font><br><br> 

               開始日期必須在今日之後. <A href="schedule_new.jsp">重新登入</a>
            </div>
        </blockquote>
<%
        return;
    }
    sd = new SchDef();
    sd.setName(name);
    sd.setStartDate(startDate);
    sd.setEndDate(endDate);
    sd.setType(type);
    sd.setContent(content.trim());
    sd.setColor(color);
    sd.setAutoRun(autoRun);
    sd.setBunitId(bunit);
    sd.parse();
    sdmgr.create(sd);
}
catch (Exception e) {
    if (e.getMessage()!=null) {
     %><script>alert("<%=e.getMessage()%>");history.go(-1);</script><%
    }
    else {
        e.printStackTrace();
     %><script>alert("發生錯誤,資料沒有寫入");history.go(-1);</script><%
    }
    return;
}
%>
<script>
   parent.do_reload = true;
</script>
<%
    response.sendRedirect("schedule_detail.jsp?id="+sd.getId()+"&m=2");
%>
