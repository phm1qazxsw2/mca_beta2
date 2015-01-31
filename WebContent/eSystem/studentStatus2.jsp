<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");
 	
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 	int studentStatus=Integer.parseInt(request.getParameter("studentStatus")); 
	String studentPs=request.getParameter("studentPs");
	
	
	StudentMgr sm=StudentMgr.getInstance();
	Student st=(Student)sm.findX(studentId, _ws2.getStudentBunitSpace("bunitId")); 

	LeaveReason[] lr=null;
	
	JsfAdmin ja=JsfAdmin.getInstance();
	
	int leaveStudentId=0; 
	
	LeaveStudentMgr lsm=LeaveStudentMgr.getInstance();
	
    if(studentStatus >=97)
	{  
		lr=ja.getActiveLeaveReason(_ws2.getStudentBunitSpace("bunitId"));
	
		if(lr==null)	
		{ 
%>		
			<blockquote>
				尚未設定離校原因的項目<br><br>
				<a href="listLeaveReason.jsp">設定離校原因</a> 
			</blockquote>
	<%		
			return;
		
        } 
				
		LeaveStudent ls=(LeaveStudent)new LeaveStudent(); 
		ls.setLeaveStudentStudentId(studentId);
		
        ls.setLeaveStudentLogId(ud2.getId());
		
		leaveStudentId = lsm.createWithIdReturned(ls);
System.out.println("## studentId=" + studentId + " LeaveStudent.id=" + leaveStudentId);
    }
 
			
	st.setStudentStatus   	(studentStatus);	
	st.setStudentPs   	(studentPs);	
	sm.save(st);

    //#### handling student set here
    TagMembrMgr tmmgr = TagMembrMgr.getInstance();
    String[] tagIds = request.getParameterValues("tagId");
    if (tagIds!=null) {
        Membr membr = MembrMgr.getInstance().find("surrogateId=" + studentId + " and type=" + Membr.TYPE_STUDENT);
        Map<Integer/*tagId*/, Vector<TagMembr>> tagmembrMap = new SortingMap(TagMembrMgr.getInstance().
            retrieveList("membrId=" + membr.getId(), "")).doSort("getTagId");
        for (int i=0; i<tagIds.length; i++) {
            if (tagmembrMap.get(new Integer(tagIds[i]))==null) { // 新加的
                TagMembr tm = new TagMembr();
                tm.setTagId(Integer.parseInt(tagIds[i]));
                tm.setMembrId(membr.getId());
                tmmgr.create(tm);
            }
            else {
                tagmembrMap.remove(new Integer(tagIds[i]));
            }
        }
        // whatever left, remove user from it.
        Set keys = tagmembrMap.keySet();
        Iterator<Integer> kiter = keys.iterator();
        while (kiter.hasNext()) {
            TagMembr tm = tagmembrMap.get(kiter.next()).get(0);
            Object[] objs = { tm };
            tmmgr.remove(objs);
        }
    }
    //########

    //response.sendRedirect("detaialStudent.jsp?studentId="+studentId);
    if(studentStatus >=97)
	{ 		
		LeaveStudent lsX=(LeaveStudent)lsm.find(leaveStudentId);
		
		if(lsX==null) 
		{
			out.println("離校原因登入失敗");
			return;
		}					

%>	
	<br>
		<B>&nbsp;&nbsp;&nbsp;<%=st.getStudentName()%>-離校原因登入:</b> 
		<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
		<br>
	<center>	
	
	<form action="addLeaveStudent.jsp" method="post">	
	<table width="65%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
				<td> 
					離校原因 
				</tD>
				<td bgcolor=ffffff>
					<select name="lrId"  size==1>
						<%
							for(int i=0;i<lr.length;i++)
  							{
  						%>
  							<option value="<%=lr[i].getId()%>"><%=lr[i].getLeaveReasonName()%></option>	
  						<%
  							}
  						%>
 					</select>
				</td> 
			</tr> 
			<tr bgcolor=#f0f0f0 class=es02>
				<tD>備註</tD>
				<td bgcolor=ffffff>
					<textarea name="ps" cols=40 rows=4></textarea>
				</td>
			</tr>
			<tr>
				<tD colspan=2> 
					<center> 
					<input type=hidden name="leaveStudentId" value="<%=leaveStudentId%>"> 
					
					<input type="submit" value="登入">
					</center>
				</tD> 
			</tr>
		</table>
		</tD>
		</tr>
		</table>		
		</center>
		</form>				
<% 
		return;
	}

%>
&nbsp;&nbsp;&nbsp;學生:<font color=blue><%=st.getStudentName()%></font> -<img src="pic/fix.gif" border=0>就學狀態<br><br>

<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
	<br>
	<br>
	<blockquote>
		<div class=es02>修改完成!</div>
	
		<br>
		<br>
		<a href="studentStatus.jsp?studentId=<%=studentId%>">回就學狀態</a>
	
	</blockquote>
