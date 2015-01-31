<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
 	request.setCharacterEncoding("UTF-8");
 	String groupName = request.getParameter("name");
	String classesId = request.getParameter("classesId");
 	int gid=Integer.parseInt(request.getParameter("groupId"));
 	int active=-1;
	try {
		active = Integer.parseInt(request.getParameter("active"));
	} catch (Exception e) {}
 		
 	ClsGroupMgr gmgr=ClsGroupMgr.getInstance();
 	ClsGroup g=(ClsGroup)gmgr.find(gid);
 	
 	g.setName(groupName);

	if (active>=0)
	 	g.setActive(active);
 	
 	gmgr.save(g);

	response.sendRedirect("modifyClass.jsp?classesId=" + classesId);
%>

