<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ include file="justHeader.jsp"%>
<%
	String xId=request.getParameter("xId");
	
	if(xId==null || xId.length()<=8)
	{
  		out.println("");	
	}else{
  		JsfAdmin ja=JsfAdmin.getInstance();
  		Student[] stu=ja.getSameNameStudents(xId,2,_ws2.getStudentBunitSpace("bunitId"));
		
		if(stu==null)
		{
			out.println("<font color=blue>可加入</font>");
		}else{
			
			JsfTool jt=JsfTool.getInstance();
%>
			<div class=es02>
			已加入的相似字號:
			<table border=0 class=es02>
		<%
			for(int i=0;i<stu.length;i++)
 			{ 
		%>
				<tr class=es02>
 
				 <tD><b><%=stu[i].getStudentName()%></b></td>
				 <td>
					身份證字號:<%=stu[i].getStudentIDNumber()%>
				</td>
				 <td>加入日期:<%=jt.ChangeDateToString(stu[i].getCreated())%></td> 
				</tr>		 
		<%
			}
		%>				
			</table>
			</div>
<%	
		}	
	}
%>