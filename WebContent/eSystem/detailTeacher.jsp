<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	int teacherId=Integer.parseInt(request.getParameter("teacherId"));
 
	TeacherMgr tm=TeacherMgr.getInstance();
	Teacher tea=(Teacher)tm.find(teacherId); 
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");	
%> 	

<table width="75%" border="1">
  <tr> 
    <td width=20%  bgcolor="lightgrey">姓名 </td>
    <td>
   	<%=tea.getTeacherFirstName()%> <%=tea.getTeacherLastName()%>
    </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">暱稱</td>
    <td>
	<%=tea.getTeacherNickname()%>	
</td>
  </tr>
 
  <tr> 
    <td bgcolor="lightgrey">身份證字號</td>
    <td>
        <%=tea.getTeacherIdNumber()%>
      </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">生日</td>
    <td>
        <%=sdf.format(tea.getTeacherBirth())%>
      </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">畢業學校</td>
    <td>
        <%=tea.getTeacherSchool()%>
      </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">手機</td>
    <td>
        <%=tea.getTeacherMobile()%>
   </td>
  </tr>
   <tr> 
    <td bgcolor="lightgrey">Email</td>
    <td>
        <%=tea.getTeacherEmail()%>
</td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">家中電話</td>
    <td>
       <%=tea.getTeacherPhone()%>
    </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">家中地址</td>
    <td>
        <%=tea.getTeacherAddress()%>
   </td>
  </tr>
    <tr> 
    <td bgcolor="lightgrey">父親</td>
    <td>
        <%=tea.getTeacherFather()%>
 </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">母親</td>
    <td>
        <%=tea.getTeacherMother()%>
   </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">到園日期</td>
    <td>
        <%=sdf.format(tea.getTeacherComeDate())%>
    </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">狀態</td>
    <td>
        <%
        int status=tea.getTeacherStatus();
			
			if(status==1)
			{
				out.println("在職");				
			}
			else if(status==2)
			{
				out.println("試教");
			}
			else if(status==3)
			{
				out.println("尚未決定");
			}
			else if(status==0)
			{
				out.println("離職");
			}
        
       %>
   </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">職位</td>
    <td>
        <%
   	     int lev=tea.getTeacherLevel();
   	     
   	     
   	     if(lev==1)
   	     {
   	     	out.println("幼教老師");
   	     }
   	     else if(lev==2)
   	     {
   	     	out.println("保育員");
   	     }
   	     else if(lev==3)
   	     {
   	     	out.println("職員");
   	     }
   	     else if(lev==4)
   	     {
   	     	out.println("外籍老師");
   	     }
   	     else if(lev==5)
   	     {
   	     	out.println("主任");
   	     }
   	     else if(lev==6)
   	     {
   	     	out.println("所長");
   	     }
   	     else if(lev==7)
   	     {
   	     	out.println("工讀");
   	     }
   	     else if(lev==8)
   	     {
   	     	out.println("才藝老師");
   	     }
   	     
   	%>
 	</td>
  </tr>

  <tr> 
    <td bgcolor="lightgrey">銀行代號1</td>
    <td>
       <%=tea.getTeacherBank1()%>
  </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">銀行帳號1</td>
    <td>
        <%=tea.getTeacherAccountNumber1()%>
  </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">銀行代號2</td>
    <td>
        <%=tea.getTeacherBank2()%>
  </td>
  </tr>
  <tr> 
    <td bgcolor="lightgrey">銀行帳號2</td>
    <td>
        <%=tea.getTeacherAccountNumber2()%>
   </td>
  </tr>
  <tr><td bgcolor="lightgrey">備註</td><td colspan=2>
	<%=tea.getTeacherPs()%>
	</td></tr>
  <tr> 
    <td colspan=2> <center>
    <form action="modifyTeacher.jsp" method="get">
    	<input type="hidden" name="teacherId" value="<%=tea.getId()%>">
    	<input type="submit" value="修改基本資料">
    </form>
    </center></td>
    
  </tr>
  
</table>

</form>