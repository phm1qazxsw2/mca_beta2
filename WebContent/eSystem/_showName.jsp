<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ include file="justHeader.jsp"%>
<%
	String xId=request.getParameter("xId");
	String r=request.getParameter("r");
	
	if(xId==null || xId.length()<=1)
{

  		out.println("");	
 	
	}else{
  		
  		JsfAdmin ja=JsfAdmin.getInstance();
  		Student[] stu=ja.getSameNameStudents(xId.trim(),1, _ws2.getStudentBunitSpace("bunitId"));
  			
  		if(stu==null)	
  		{
			out.println("<div class=es02>無相似姓名,<font color=blue>可加入</font></div>");	
  		}else{

			JsfTool jt=JsfTool.getInstance();
%> 		
			<div class=es02>
			<font color=red>已加入的相似姓名:</font>
			<table border=0 class=es02>
		<% 
			for(int i=0;i<stu.length;i++) 
			{ 
		%>
		
				<tr class=es02> 
				 <tD><b><%=stu[i].getStudentName()%></b></td>
				 <td><%
						switch(stu[i].getStudentStatus())
						{
							case 1:
								out.println("參觀登記/上網登入");
								break;
							case 2:
								out.println("報名/等待入學");
								break;
							case 3:
								out.println("試讀");
								break;
							case 4:
								out.println("入學");
								break;
							case 97:
								out.println("離校");
								break;
							case 99:
								out.println("畢業");
								break;
						}
		
					%></td>
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