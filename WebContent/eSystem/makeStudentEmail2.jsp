<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*,phm.util.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ include file="jumpTop.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");
	String sFn=request.getParameter("fee").trim();

	JsfAdmin ja=JsfAdmin.getInstance();
	Feeticket ft=ja.getFeeticketByNumberId(Integer.parseInt(sFn));

	StudentMgr stum=StudentMgr.getInstance();
	Student stu=(Student)stum.find(ft.getFeeticketStuId());

	String paySystemNoticeEmailTypeS=request.getParameter("paySystemNoticeEmailType");
	String paySystemNoticeEmailTitle=request.getParameter("paySystemNoticeEmailTitle");
	String paySystemNoticeEmailText=request.getParameter("paySystemNoticeEmailText");
	

	int paySystemNoticeEmailType=Integer.parseInt(paySystemNoticeEmailTypeS);
	boolean sendType=false;
	
	if(paySystemNoticeEmailType==1)
		sendType=true;	
	

	StudentMgr smx=StudentMgr.getInstance();
	JsfPay jp=JsfPay.getInstance(); 
	
	PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem e=(PaySystem)em.find(1);

	String path=application.getRealPath("/")+"eSystem/pdf_example/email";



	String emailStu="em"+String.valueOf(stu.getId());
	String[] emailS=request.getParameterValues(emailStu);
	
	
	Vector vSuccuss=new Vector();
	Vector vFail=new Vector();
		
	if(emailS !=null)
	{ 
		String xAddress="";
		for(int j=0;j<emailS.length;j++)	
				xAddress+=emailS[j]+",";
		
		String filePath=path+"/"+sFn+".pdf";
		
		File f=new File(filePath);
		
		Vector v=new Vector();

		if(f.exists())
		{
			v.add((String)filePath); 						
		}		
		File[] attachments = null;
		
		if(v !=null && v.size()!=0)
 	 	{ 
			attachments =new File[v.size()];
			
			for(int j=0;j<v.size();j++)
				attachments[j] = new File((String)v.get(j));    
		} 
		
		
		try {
			EmailTool et = new EmailTool(e.getPaySystemEmailServer(), false);
			
			et.send(xAddress, null, null,e.getPaySystemEmailSenderAddress(),e.getPaySystemEmailSender(),paySystemNoticeEmailTitle, 
		    paySystemNoticeEmailText,sendType,e.getPaySystemEmailCode(), attachments);
			
			String result="<tr bgcolor=ffffff class=es02><td>"+stu.getStudentName()+"</td><td>"+xAddress+"</td><tD>發送成功</td></tr>";
			vSuccuss.add(result);	
		}
		catch (Exception eaa) {
				String result="<tr bgcolor=ffffff class=es02><td>"+stu.getStudentName()+"</td><td>"+xAddress+"</td><tD>發送失敗</td></tr>";
				vFail.add(result);
		}
	}else{
		
		out.println("沒有選擇Email");
		return;
	}	
%>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/email.png" border=0>Email 帳單</b>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<br>
<blockquote>
<%
	if(vSuccuss !=null && vSuccuss.size()>0)
	{ 
%> 
	<B>發送成功名單:</B>
	<blockquote>		
		
		<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
		<tr align=left valign=top>
		<td bgcolor="#e9e3de">
	
		<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0  class=es02>
				<tD>姓名學生</td><td>電話號碼</td><td>發送狀態</tD>
			</tr>
		<%
			for(int k=0;k<vSuccuss.size();k++)	
			{
				out.println(vSuccuss.get(k));
			}
		%>					
		</table>
 
		</td>
		</tr>
		</table>
	</blockquote>
<%
	}

	if(vFail !=null &&  vFail.size()>0)
	{ 
%> 
	<b>發送失敗名單:
</b>		 
		<blockquote>
	
		<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
		<tr align=left valign=top>
		<td bgcolor="#e9e3de">
	
		<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0  class=es02>
				<tD>姓名學生</td><td>電話號碼</td><td>發送狀態</tD>
			</tr>
		<%
			for(int k=0;k<vFail.size();k++)	
			{
				out.println(vFail.get(k));
			}
		%>					
		</table>
 
		</td>
		</tR>
		</table>

		</blockquote>
<%
	}
%>	

</blockquote>
