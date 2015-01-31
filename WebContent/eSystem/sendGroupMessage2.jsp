<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=4;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>
<%
    int sendTo=Integer.parseInt(request.getParameter("snedTo"));
    String sendContent=request.getParameter("sendContent");
    String[] targetS=request.getParameterValues("target");
    StringBuffer sb = new StringBuffer();
    for(int i=0;targetS !=null && i<targetS.length;i++)
    {
        if (i>0) sb.append(",");
        sb.append(targetS[i]);
    }
    PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
    EzCountingService svc = EzCountingService.getInstance();
    JsfAdmin ja=JsfAdmin.getInstance();
    ArrayList<Student2> students = Student2Mgr.getInstance().retrieveList("id in (" + sb.toString() + ")", "");

    JsfPay jp=JsfPay.getInstance();
%>
<br>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/mobile.gif" border=0>&nbsp;<b>發送簡訊 - 預覽發送名單</b></div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<%
    if(sendContent==null || sendContent.length()<=0)
    {
%>
        尚未輸入簡訊內容
<%
        return;
    }
%>
<br>

<center>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=f0f0f0 class=es02>
        <td width=60>發送姓名</td>   
        <%
        if(sendTo==1){  %>
            <td width=180>預設聯絡人</td>
        <%  }else{  %>
            <td width=180>父親</td><td width=180>母親</td>    
        <%  }   %>
            <td>簡訊內容</tD>
    </tr>
<form action="sendGroupMessage3.jsp" method="post">
<%
    Iterator<Student2> iter = students.iterator();
    while (iter.hasNext()) {
        String nowContent="";
        Student2 stu=iter.next();
        nowContent=sendContent.replaceAll("xxx",stu.getStudentName());
%>
    <tr bgcolor=ffffff class=es02>
            <td>
        <a href="javascript:openwindow_phm('studentContact.jsp?studentId=<%=stu.getId()%>','聯絡資料',700,700,true);"><%=stu.getStudentName()%></a>
            </td>
<%
        if(sendTo==1){
                String mNumber="";
                String sendname="";
                switch(stu.getStudentEmailDefault())
                {
                    case 0:
                        Contact[] cons=ja.getAllContact(stu.getId());
            
                        if(cons !=null)
                        {
                            int raId=cons[0].getContactReleationId();
                            RelationMgr rm=RelationMgr.getInstance();
                            Relation ra=(Relation)rm.find(raId);
                            sendname=ra.getRelationName()+":"+cons[0].getContactName();
                            mNumber=cons[0].getContactMobile();
                        }
                        break;
                    case 1:		
                        sendname="父:"+stu.getStudentFather();                        				
                        mNumber=stu.getStudentFatherMobile();
                        break;
                    case 2:
                        sendname="母:"+stu.getStudentMother();                        				
                        mNumber=stu.getStudentMotherMobile();
                        break;	
                }
                mNumber=jp.getRealPhone(mNumber);
                
  %>
            <td>

    <input type=checkbox name="list" value="<%=stu.getId()%>##<%=mNumber%>" <%=(jp.checkMobile(mNumber))?"checked":"disabled"%>>
        <%=sendname%>:<%=(jp.checkMobile(mNumber))?mNumber:"無效號碼"%>
</tD>
  <%              
                 try {
                    //svc.sendSms(ps, mNumber, nowContent);
                 }catch(Exception e2){}
        }else{
            String sendname1="父:"+stu.getStudentFather();  
            String  mNumber=stu.getStudentFatherMobile();
            mNumber=jp.getRealPhone(mNumber);
            String sendname2="母:"+stu.getStudentMother();                      				
            String  mNumber2=stu.getStudentMotherMobile();
            mNumber2=jp.getRealPhone(mNumber2);
    %>
            <td>
<input type=checkbox name="list" value="<%=stu.getId()%>##<%=mNumber%>" <%=(jp.checkMobile(mNumber))?"checked":"disabled"%> ><%=sendname1%>:<%=(jp.checkMobile(mNumber))?mNumber:"無效號碼"%></tD>
            <td>
<input type=checkbox name="list" value="<%=stu.getId()%>##<%=mNumber2%>" <%=(jp.checkMobile(mNumber2))?"checked":"disabled"%> ><%=sendname2%>:<%=(jp.checkMobile(mNumber2))?mNumber2:"無效號碼"%></tD>

    <%                
             try {
                   // svc.sendSms(ps, mNumber, nowContent);
                   // svc.sendSms(ps, mNumber2, nowContent);
             }catch(Exception e2){}

        }
    %>
            <td><%=nowContent%></tD>
            <input type=hidden name="send<%=stu.getId()%>" value=<%=nowContent%>>
        </tr>
<%      
    }
%>
    <tr bgcolor=f0f0f0 class=es02 align=middle>
        <td colspan=<%=(sendTo==1)?"3":"4"%>>
            <input type=submit value="確認發送" onClick="return(confirm('確認發送簡訊?'))">
        </tD>
    </tr>
    </table>
    </tD>
    </tr>
    </table>

    </form>
<br>

<%@ include file="bottom.jsp"%>