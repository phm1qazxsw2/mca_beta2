<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
	int tdId=Integer.parseInt(request.getParameter("tdId"));
	
	
	TalentdateMgr tdm=TalentdateMgr.getInstance();
	
	Talentdate  td=(Talentdate)tdm.find(tdId);
	tdm.remove(tdId);
	
	response.sendRedirect("modifyTalentWeekday.jsp?talentId="+td.getTalentdateTalentId());
	
%>
