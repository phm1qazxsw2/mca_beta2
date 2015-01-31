<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%


	JsfAdmin js=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	
	int stuId=Integer.parseInt(request.getParameter("stuId"));
	int tdxId=Integer.parseInt(request.getParameter("tdxId"));

	TalentdateMgr tm=TalentdateMgr.getInstance();
	Talentdate td=(Talentdate)tm.find(tdxId);


	StunoticeMgr snm=StunoticeMgr.getInstance();
	Stunotice stun=new Stunotice();
	stun.setStunoticeCategory   	(1);
	stun.setStunoticeXid   	(tdxId);
	stun.setStunoticeDate   	(td.getTalentdateStartDate());
	stun.setStunoticeStatus   	(0);
	stun.setStunoticeImportant   	(0);
	stun.setStunoticeStudentId   (stuId);
	
	snm.createWithIdReturned(stun);
	
	response.sendRedirect("listTadent.jsp?talentId="+td.getTalentdateTalentId());
	
%>