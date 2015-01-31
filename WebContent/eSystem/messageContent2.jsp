<%@ page language="java" buffer="32kb" contentType="text/html;charset=UTF-8"%>
<%
request.setCharacterEncoding("UTF-8");
JsfAdmin ja=JsfAdmin.getInstance();

int personType=0;
int personId=0;
int emailSend=0;
int mobileSend=0;

String personTypeS=request.getParameter("personType");

if(personTypeS!=null)
{
	int xType=Integer.parseInt(personTypeS);
	
	if(xType==0)
		personType=0;
	else if(xType==9999)
		personType=1;
	else
		personType=2;	
}

String personIdS=request.getParameter("xId");

if(personIdS!=null)
	personId=Integer.parseInt(personIdS);

String sendEmailS=request.getParameter("sendEmail"); 

if(sendEmailS!=null)
	emailSend=Integer.parseInt(sendEmailS);

String sendMobileS=request.getParameter("sendMobile"); 

if(sendMobileS!=null) 
	mobileSend=Integer.parseInt(sendMobileS);	
 	
int toUser=Integer.parseInt(request.getParameter("toUser"));
int toStatus=Integer.parseInt(request.getParameter("toStatus"));
int messageType=Integer.parseInt(request.getParameter("messageType"));
String title=request.getParameter("title");
String content=request.getParameter("content");

int userId=0;

if(ud2!=null)
	userId=ud2.getId();

Message me=new Message();
me.setMessageFromDate   	(new Date());
me.setMessageFrom   	(userId);
me.setMessageFromStatus   	(toStatus);
me.setMessageTo   	(toUser);
me.setMessageToStatus   	(0);
me.setMessageTitle   	(title);
me.setMessageText   	(content);
me.setMessageType   	(messageType);
me.setMessagePersonType(personType);
me.setMessagePersonId(personId); 
me.setMessageEmailStatus(0);
me.setBunitId(_ws.getSessionBunitId());

MessageMgr mm=MessageMgr.getInstance();
int meid=mm.createWithIdReturned(me);	

PaySystemMgr em=PaySystemMgr.getInstance();
PaySystem e=(PaySystem)em.find(1);

JsfPay jp=JsfPay.getInstance(); 

UserMgr umx=UserMgr.getInstance();
User u2=(User)umx.find(toUser);

if(emailSend==1)
{ 
	try{

	if(e.getPaySystemEmailServer()==null || e.getPaySystemEmailServer().length()<=0)
	{
		System.out.println("STMP Server not setup yet!");
		return;
	}		
	
	if(!jp.checkEmail(u2.getUserEmail())) 
	{ 
		out.println("無效Email");
		return; 
	}

	EmailTool et = new EmailTool(e.getPaySystemEmailServer(), false);
	File[] attachments = null;

	String senderEmail=e.getPaySystemEmailSenderAddress();
	
	if(jp.checkEmail(ud2.getUserEmail()))
		senderEmail=ud2.getUserEmail();
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");	
	SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy-MM-dd HH:mm");
	String dateString=sdf.format(new Date());

	StringBuffer sb=new StringBuffer("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
	sb.append("<style type=\"text/css\"> <!--.es02{font-size: 12px; line-height:120% ; color: #3c3c3c }--> </style>"); 
	sb.append("</head><body>");
		
	String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
		sb.append(xString);
		sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
		sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
		sb.append("<td>寄件人</td><td>"+ud2.getUserFullname()+"</tD></tr>");
		
		sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
		sb.append("<td>寄件時間</td><td>"+sdf.format(me.getMessageFromDate())+"</tD></tr>");
		
		int meType=me.getMessagePersonType();
		int  xId=me.getMessagePersonId();
  		if(meType!=0)
		{
			sb.append("<tr bgcolor=ffffff><td bgcolor=f0f0f0>關係人</tD><td>");
			if(meType==1)	
				{ 
					sb.append("教職員-");
					if(xId==0)	
					{
						sb.append("全部");
					}else{
						TeacherMgr tm=TeacherMgr.getInstance();
						Teacher tea=(Teacher)tm.find(xId); 
						sb.append(tea.getTeacherFirstName()+tea.getTeacherLastName());						
					}
					
				}else if(meType==2){ 
					
					sb.append("學生家長-");

					if(xId==0)	
					{
						sb.append("全部");
					}else{
						StudentMgr sm=StudentMgr.getInstance();
						Student stu=(Student)sm.find(xId);					
						sb.append(stu.getStudentName());
					}
	 	 	 	 } 
			
			sb.append("</td></tr>"); 
		}
	
		sb.append("<tr bgcolor=ffffff><td bgcolor=f0f0f0>重要性</tD><td>");	
		
		switch(me.getMessageFromStatus()){
			case 1:
				sb.append("<font color=red><b>急迫</b></font>");
				break;
			case 2:
				sb.append("<font color=blue>重要</font>");
				break;		
			case 3:
				sb.append("普通");
				break;
		}
		sb.append("</td></tr>"); 

		
		MessageTypeMgr  mtm=MessageTypeMgr.getInstance();
		MessageType  mt=(MessageType)mtm.find(me.getMessageType());
   
    	sb.append("<tr bgcolor=ffffff><td bgcolor=f0f0f0>主旨</tD><td>");	
   		if(mt!=null)
			sb.append(mt.getMessageTypeName()+"-");

		sb.append(me.getMessageTitle());	
		sb.append("</td></tr>");			
		
		sb.append("<tr bgcolor=ffffff><td bgcolor=f0f0f0>內容</tD><td>");	
		
		String contentEmail=content.replace("\n","<br>");
		sb.append(contentEmail); 
		sb.append("</td></tr>");	
		
		sb.append("</table></td></tr></table>");
  		sb.append("</center>");	
		
	et.send(u2.getUserEmail(), null, null,senderEmail,ud2.getUserFullname(),e.getPaySystemCompanyName()+" 站內訊息:"+title+" "+dateString,sb.toString(),true,e.getPaySystemEmailCode(),attachments);

	}catch(Exception exce){
	
		System.out.println(exce.getMessage());
	} 
	
}

if(mobileSend==1) 
{   

try{
	String mNumber=u2.getUserPhone().trim();
 	
 	
 	StringBuffer sb=new StringBuffer();
 		
 	sb.append(e.getPaySystemCompanyName()+" 站內訊息:"+title);
 	sb.append(" 重要性:");	
		
	switch(me.getMessageFromStatus()){
		case 1:
			sb.append("急迫");
			break;
		case 2:
			sb.append("重要");
			break;		
		case 3:
			sb.append("普通");
			break;
	}
		
 	sb.append(" 請查閱email或系統");
	sb.append("-"+ud2.getUserFullname());
 	
	String outWord=jp.sendMobileMessage(e,mNumber,sb.toString());
	
	}catch(Exception exp){
		System.out.println(exp.getMessage());
	}
} 

%>
