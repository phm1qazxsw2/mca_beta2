<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,phm.util.*,java.io.*" contentType="text/html;charset=UTF-8"%>
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
    
    String title=request.getParameter("title");
%>
<br>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/email.png" border=0>&nbsp;<b>發送Email</b></div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<%
    if(listS==null || listS.length<=0)
    {
%>
        <br>
        <br>
        <blockquote>
            <div class=es02>
                沒有可發送Email的名單.
            </div>
        </blockquote>
        <%@ include file="bottom.jsp"%>
<%
        return;
    }

	EmailTool et = new EmailTool(ps.getPaySystemEmailServer(), false);
	File[] attachments = null;

	String senderEmail=ps.getPaySystemEmailSenderAddress();
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");	
	SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	String dateString=sdf.format(new Date());

    for(int i=0;listS !=null && i<listS.length;i++)
    {
        String[] list=listS[i].split("##");

        String sendContent=request.getParameter("send"+list[0]);

        sendContent=java.net.URLDecoder.decode(sendContent);           
        if(sendContent !=null && sendContent.length()>0)
        {

            StringBuffer sb=new StringBuffer();

/*
"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
            sb.append("<style type=\"text/css\"> <!--.es02{font-size: 12px; line-height:120% ; color: #3c3c3c }--> </style>"); 
            sb.append("</head><body>");
                
            String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
                sb.append(xString);
                sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
                sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
                sb.append("<td>");
*/               

                String contentEmail=sendContent.replace("\n","<br>");
                sb.append(contentEmail);
/*
                sb.append("</td></tr>");	 
                sb.append("</table></td></tr></table>");
                sb.append("</center>");	
*/              
                
            try{
                et.send(list[1],null,null,ps.getPaySystemEmailSenderAddress(),ps.getPaySystemCompanyName(),title,sb.toString(),true,ps.getPaySystemEmailCode(),attachments);

            }catch(Exception exce){

                System.out.println(exce.getMessage());
            } 
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