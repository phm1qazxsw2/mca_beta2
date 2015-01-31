<%@ page language="java" import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%><%
    try
    {
        String sz=request.getParameter("z");
    	int talentId=Integer.parseInt(sz);
    	int stuId=Integer.parseInt(request.getParameter("stuId"));
 
    	JsfAdmin ja=JsfAdmin.getInstance();
    	JsfTool jt=JsfTool.getInstance();
    	Talentdate[] tdx=ja.getTalentdateByTalentIdAfterNow(talentId);
    	StudentMgr sm=StudentMgr.getInstance();
	if(tdx ==null)
	{
		out.println("尚未編輯開課日期");
		return;	
	}    	
	Student stu=(Student)sm.find(stuId);
	out.println("<b>"+stu.getStudentName()+"上課通知</b>");
%>    
	
	<table bgcolor="D5D6E6">

	<tr bgcolor="A9B0F6">
	<td>開課時間</td><td>狀態</td><td></td>
	</tr>

	<%
	for(int y=0;y<tdx.length;y++)
	{
		boolean haveWrite=ja.getSnotice(tdx[y].getId(),stuId);
	%>
	<tr>
	<td>
	<%=jt.ChangeDateToString2(tdx[y].getTalentdateStartDate())%>-<%=jt.ChangeDateToString3(tdx[y].getTalentdateEndDate())%>
	</td>
	<td><%=(haveWrite)?"已發佈":"尚未發佈"%></td>
	<td>
	<%
		if(!haveWrite){
	%>
		<form action="addStunotice.jsp" method="post">
		<input type=hidden name="stuId" value="<%=stuId%>">
		<input type=hidden name="tdxId" value="<%=tdx[y].getId()%>">
		<input type=submit value="發佈">
		</form>
	<%
		}
	%>	
	</tD>
	
	<%
	}
%>
	</table>
<%
    }
    catch(Exception e)
    {
        e.printStackTrace();
        //out.print("bad");
    }
%>