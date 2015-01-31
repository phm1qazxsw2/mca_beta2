<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
	String[] stuIdS=request.getParameterValues("stuId");

	if(stuIdS==null)
	{
		out.println("<br><br><blockquote>尚未選擇學生!!</blockquote>");
		return;
	}
	
	int depart=Integer.parseInt(request.getParameter("depart"));
	int level=Integer.parseInt(request.getParameter("level")); 
	int classx=Integer.parseInt(request.getParameter("classx")); 
	int status=Integer.parseInt(request.getParameter("status"));
  
		 
	String rlIdS=request.getParameter("rlId");
	int rlId=0;
	
	String ps=request.getParameter("ps");
	
	if(status >=97 && status!=999)
	{ 
		if(rlIdS==null) 
		{ 
%> 

<br>
<br>
	<b>&nbsp;&nbsp;&nbsp;登入失敗:</b>
			<blockquote>
				尚未設定離校原因的項目<br><br>
				<a href="listLeaveReason.jsp">設定離校原因</a>
			</blockquote>


<%			
			return;
 		}else{
			rlId =Integer.parseInt(rlIdS);
		} 
	}
	StudentMgr sm=StudentMgr.getInstance();
	LeaveStudentMgr lsm=LeaveStudentMgr.getInstance();
			
	StringBuffer sb=new StringBuffer();
	for(int i=0;i<stuIdS.length;i++) 
	{ 
		int stuId=Integer.parseInt(stuIdS[i]);		
		Student stu=(Student)sm.find(stuId);	

		if(status !=999) 
		{  
			if(stu.getStudentStatus()==3 || stu.getStudentStatus()==4) 
			{ 
				if(status >=97) 
				{ 
					LeaveStudent lsX=new LeaveStudent();
					lsX.setLeaveStudentStudentId(stu.getId());
					lsX.setLeaveStudentReasonId(rlId);
					lsX.setLeaveStudentPs(ps); 
					lsX.setLeaveStudentLogId (1 );
					lsm.createWithIdReturned(lsX);
				} 
			}
			stu.setStudentStatus(status); 
		}			

		if(depart !=999)  
			 stu.setStudentDepart(depart);
		
		if(level !=999)	
			stu.setStudentLevel(level);
		
		if(classx !=999) 
			stu.setStudentClassId(classx);	
			
		sm.save(stu);		

		sb.append("<font color=blue>"+stu.getStudentName()+":</font> 轉換成功<br>");
	} 
%>
<br>
<br>
<b>&nbsp;&nbsp;&nbsp;執行結果</b> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
	<%=sb.toString()%>
</blockquote>