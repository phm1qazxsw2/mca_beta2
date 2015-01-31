<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");
 	
 	int teacherId=Integer.parseInt(request.getParameter("teacherId"));
	String teacherComeDate=request.getParameter("teacherComeDate"); 
	int teacherStatus=Integer.parseInt(request.getParameter("teacherStatus")); 
	int teacherLevel=0;
    try { teacherLevel=Integer.parseInt(request.getParameter("teacherLevel")); } catch (Exception e) {}
	String teacherPs=request.getParameter("teacherPs"); 
	int teacherDepart=0;
    try { teacherDepart=Integer.parseInt(request.getParameter("teacherDepart")); } catch (Exception e) {}
	int teacherClass=0;
    try { teacherClass=Integer.parseInt(request.getParameter("teacherClass"));  } catch (Exception e) {}
	int teacherPosition=0;
    try { teacherPosition=Integer.parseInt(request.getParameter("teacherPosition"));  } catch (Exception e) {}

	int bunit=0;
    try { bunit=Integer.parseInt(request.getParameter("bunit"));  } catch (Exception e) {}

	
	TeacherMgr tm=TeacherMgr.getInstance();
	Teacher tea=(Teacher)tm.find(teacherId);

    JsfTool jt=JsfTool.getInstance();

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	Date teacherComeDate2 = null;
    try { teacherComeDate2 = sdf.parse(teacherComeDate); } catch (Exception e) {}
    if (teacherComeDate2!=null)
        tea.setTeacherComeDate(teacherComeDate2);
    else
        tea.setTeacherComeDate(null);

	tea.setTeacherStatus   	(teacherStatus);
	tea.setTeacherLevel   	(teacherLevel);
	tea.setTeacherPs   	(teacherPs);
	tea.setTeacherDepart(teacherDepart);
	tea.setTeacherPosition(teacherPosition);
	tea.setTeacherClasses(teacherClass);
    tea.setTeacherBunitId(bunit);
	tm.save(tea);

    phm.ezcounting.Membr m = phm.ezcounting.MembrMgr.
        getInstance().find("type=" + Membr.TYPE_TEACHER + " and surrogateId=" + tea.getId());
    m.setBunitId(bunit);
    phm.ezcounting.MembrMgr.getInstance().save(m);
    response.sendRedirect("modifyTeacherWork.jsp?teacherId=" + teacherId);
%>
