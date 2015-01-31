<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

    if(!checkAuth(ud2,authHa,700))
    {
        response.sendRedirect("authIndex.jsp?code=700");
    }

    request.setCharacterEncoding("UTF-8");
    int membrId=Integer.parseInt(request.getParameter("membrId"));

    String userLoginId=request.getParameter("userLoginId");
    String userPassword=request.getParameter("userPassword");
    int userActive=Integer.parseInt(request.getParameter("userActive"));
    String teaId = request.getParameter("teaId");
    int percent = Integer.parseInt(request.getParameter("percent"));

    MembrUserData mu = MembrUserDataMgr.getInstance().find("membrId=" + membrId);
    Teacher teacher = (Teacher) ObjectService.find("jsf.Teacher", "id=" + teaId);

    UserMgr umgr = UserMgr.getInstance();
    User tmp = umgr.findLoginId(userLoginId);
    if (tmp!=null && (mu==null || mu.getUserId()!=tmp.getId())) {
%>
<br>
<br>
    <blockquote>
        <div class=es02>
            此帳號已有人使用,請<a href="modifyTeacherUser.jsp?teacherId=<%=teaId%>">重新設定</a>. 
        </div>
    </blockquote>
      
<%
        return;
    }

    User us = null;
    if (mu==null)
        us = new User();
    else
        us = (User) umgr.find(mu.getUserId());

    us.setUserLoginId(userLoginId);
    us.setUserPassword(userPassword);
    us.setUserRole(6);
    us.setUserActive(userActive);
    us.setUserFullname(teacher.getTeacherFirstName()+teacher.getTeacherLastName());
    us.setUserEmail(teacher.getTeacherEmail());
    us.setUserPhone(teacher.getTeacherMobile());
    
    if (mu==null) {
        int userId = umgr.createWithIdReturned(us);
        MembrUser mmuu = new MembrUser();
        mmuu.setMembrId(membrId);
        mmuu.setUserId(userId);
        MembrUserMgr.getInstance().create(mmuu);
    }
    else {
        umgr.save(us);
    }

    teacher.setTeacherLevel(percent);
    TeacherMgr.getInstance().save(teacher);

%>
<script>
alert("登入資料設定成功!");
location.href='modifyTeacherUser.jsp?teacherId=<%=teaId%>';
</script>

