<%@ page import="java.io.*" isErrorPage="true" contentType="text/html;charset=UTF-8"%>
<center>
<font color=red>
<a href="javascript:history.go(-1);"><img src="images/oops.gif" border=0></a>
<form>
    <input type=button value="回上一頁" onclick="history.go(-1)">
</form>
</center>
<%
    exception.printStackTrace();
    for (int i=0; i<100; i++)
        out.println("     ");
    String host = request.getServerName();
    String qstr = request.getQueryString();
    String uri = request.getRequestURI();
    String errstr = "##error##  " + host + uri + "?" + qstr + "  :" + exception.getMessage();
    System.out.println(errstr);

    String msg = exception.getMessage();
    if (msg!=null && msg.indexOf("部分或付清")>=0) {
        out.println("<script>alert('系統偵測到修改的項目影響付過的帳單！剛才的動作沒有執行。'); history.go(-1);</script>");
        return;
    }

    try {
        ByteArrayOutputStream bout = new ByteArrayOutputStream();
        PrintWriter pr = new PrintWriter(new OutputStreamWriter(bout));
        exception.printStackTrace(pr);
        pr.flush();
        bout.flush();
        String str = new String(bout.toByteArray());
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String notify_str = sdf.format(new java.util.Date())+"\n"+str+"\n" + errstr;
        String urlstr = "http://60.251.12.19:8080/a/notify-peter.jsp?msg=" + java.net.URLEncoder.encode(notify_str, "UTF-8");
        bout.close();
        pr.close();
        phm.util.URLConnector.getContent(urlstr, 1000, "UTF-8");
    }
    catch (Exception e)
    {}
%>
