<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=4;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>

<%
    String[] listS=request.getParameterValues("list");

    PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");    
%>
<br>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/mobile.gif" border=0>&nbsp;<b>發送簡訊</b></div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<%
    if(listS==null || listS.length<=0)
    {
%>
        <blockquote>
            <div class=es02>
                沒有可發送簡訊的名單
            </div>
        </blockquote>
        <%@ include file="bottom.jsp"%>
<%
        return;
    }

    EzCountingService svc = EzCountingService.getInstance();

    for(int i=0;listS !=null && i<listS.length;i++)
    {
        String[] list=listS[i].split("##");

        String sendContent=request.getParameter("send"+list[0]);

        if(sendContent !=null && sendContent.length()>0)
        {
            //out.println(list[1]+","+sendContent+"<br>");
            try {
                   svc.sendSms(ps, list[1], sendContent);
             }catch(Exception e2){}
        }
    }
%>
    <br>
    <br>
    <blockquote>
        <div class=es02>
            發送成功!
        </div>
    </blockquote>

<%@ include file="bottom.jsp"%>