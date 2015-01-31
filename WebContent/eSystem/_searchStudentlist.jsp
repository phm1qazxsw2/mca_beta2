<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%><%

	String idS=request.getParameter("id");

	String ran=request.getParameter("ran");

	int classId=Integer.parseInt(idS); 
	JsfAdmin ja=JsfAdmin.getInstance();
	 
	if(classId==0)
  	{
  		out.println("");
  	}else if(classId==9999){
  			
  		
  		Teacher[] tea=ja.getActiveTeacher(0);
		if(tea==null)	
		{
			out.println("");
		}else{
	%>
		<select name="xId" size=1>
			<option value="0">全部</option>
 	<%		
			for(int i=0;i<tea.length;i++)	
			{
	%>
				<option value="<%=tea[i].getId()%>"><%=tea[i].getTeacherFirstName()%><%=tea[i].getTeacherLastName()%></option> 
	<%		
			}	
	%>
		</select>
	<%				
		}
  	}else{
  		
  		Student[] st=ja.getStudyStudents(classId,999,999,0);			
  				
  		if(st ==null)	
  		{
			out.println("");
  		}else{
%>
			<select name="xId">
				<option value="0">全部</option>
<%	 
				for(int i=0;i<st.length;i++) 
				{ 
%>
					<option value="<%=st[i].getId()%>"><%=st[i].getStudentName()%></option>
<%									
				} 
%> 
			</select>
<%				
		}
  	}
%>