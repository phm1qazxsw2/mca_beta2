<%@ page language="java"  
    import="web.*,jsf.*,phm.ezcounting.*,phm.util.*,java.io.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String[] list=request.getParameterValues("list");
    TeacherMgr tm=TeacherMgr.getInstance();
    PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");    
    String realpath=request.getRealPath("/");
	EmailTool et = new EmailTool(ps.getPaySystemEmailServer(), false);

    EsystemMgr cm=EsystemMgr.getInstance();
    Esystem es=(Esystem)cm.find(1);   



    for(int i=0;list !=null && i<list.length;i++){

        String[] xinfo=list[i].split("##");

        if(xinfo!=null && xinfo.length==2){

            int teaId=Integer.parseInt(xinfo[0]);
            Teacher tea=(Teacher)tm.find(teaId);

            String titleS=es.getEsystememailTitle();
            String contentS=es.getEsystemEmailContent();

            if(titleS !=null && titleS.length()>0)
                titleS=titleS.replace("XXX",tea.getTeacherFirstName()+tea.getTeacherLastName());
            else
                titleS = new BunitHelper().getCompanyNameTitle(_ws2.getSessionBunitId()) + "薪資";

            if(contentS !=null && contentS.length()>0){
                contentS=contentS.replace("XXX",tea.getTeacherFirstName()+tea.getTeacherLastName());
                contentS=contentS.replace("\n","<br>");
            }
            String emailAddress=xinfo[1];
            String files=request.getParameter("bill"+xinfo[0]);
            String[] att=files.split("##");
            File[] attachments = null;

            if(att !=null){
                attachments = new File[att.length];
                for(int j=0;j<att.length;j++){
                    attachments[j]=new File(realpath+"/pdf_output/"+att[j]);
                }
            }
            
            try{
                et.send(emailAddress,null,null,ps.getPaySystemEmailSenderAddress(),
                    new BunitHelper().getCompanyNameTitle(_ws2.getSessionBunitId()),
                    titleS,contentS,true,ps.getPaySystemEmailCode(),attachments);

            }catch(Exception exce){

                System.out.println(exce.getMessage());
            }     
        }
    }
    
%>

<div class=es02>
&nbsp;&nbsp;&nbsp;<b><img src="pic/email.png" border=0>&nbsp;Email帳單</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


<br>
<br>
<blockquote>
    <div class=es02>
        發送完成.    
    </div>
</blockquote>