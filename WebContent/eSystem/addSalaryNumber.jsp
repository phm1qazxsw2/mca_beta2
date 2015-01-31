<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>

<%
 	String teas[]=request.getParameterValues("teaName");
 	
 	if(teas==null || teas.length==0)
 	{
 %>
 		尚未選擇老師!! <br><br>
 <%
 		return;
 	}
 
 	int teaLen=java.lang.reflect.Array.getLength(teas);
 
	int stId=Integer.parseInt(request.getParameter("stId"));
	int poId=Integer.parseInt(request.getParameter("poId"));
	int classId=Integer.parseInt(request.getParameter("classId"));

	SalaryTypeMgr stm=SalaryTypeMgr.getInstance();
	SalaryType st=(SalaryType)stm.find(stId);
	
	SalaryNumberMgr snm=SalaryNumberMgr.getInstance();

	for(int i=0;i<teaLen;i++)
	{
		
		int teaId=Integer.parseInt(teas[i]);
		int teacherMoney=Integer.parseInt(request.getParameter(teas[i]));
		
		SalaryNumber sn=new SalaryNumber();
		sn.setSalaryNumberTypeId(st.getId());
		sn.setSalaryNumberTeacherId(teaId);
		sn.setSalaryNumberMoneyNumber(teacherMoney);
		sn.setSalaryNumberLogId(ud2.getId());
		sn.setSalaryNumberLogDate(new Date());
		
		snm.createWithIdReturned(sn);
	
		
	}

	response.sendRedirect("modifySalaryType1a.jsp?stId="+stId+"&poId="+poId+"&classId="+classId);
%>

