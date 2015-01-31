<%@ page language="java" import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%><%
    try
    {
        String sz=request.getParameter("z");
    	int ibi=Integer.parseInt(sz);
    	int talentId=Integer.parseInt(request.getParameter("talentId"));
 
    	JsfAdmin ja=JsfAdmin.getInstance();
    	Student[] stu=ja.getStudyStudents(ibi,999,999,11);
    	
    	
    	
    	if(stu ==null)
    	{
    		out.println("<font color=blue>don`t have data!</font>");
    		
    	}
    	else
    	{
    	
    	boolean haveData=false;

		int sum=0;
		for(int i=0;i<stu.length;i++)
		{
			int stuId=stu[i].getId();
			Tadent[] tade=ja.getTadentByStuId(stuId,talentId);
			
			if(tade==null)
			{
				sum++;
			
				out.println("<input type=checkbox name=studentId value=\""+stuId+"\">"+stu[i].getStudentName());
				haveData=true;
			
				if(i>3 && sum%6==0)
					out.println("<br>");
			}
			
			
		}
		
		if(!haveData)
			out.println("<font color=blue>all members have been added!</font>");
	}
	
    }
    catch(Exception e)
    {
        e.printStackTrace();
        //out.print("bad");
    }
%>