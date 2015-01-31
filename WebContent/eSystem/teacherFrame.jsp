<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<head>
    <title>快速編輯教職員資料</title>
</head>
<script>
    var nowpage=1;

    function checkPage(teaId){
        
        if(nowpage==1)
            window.mainFrame.location="modifyTeacher.jsp?teacherId="+teaId;
        else if(nowpage==2)
            window.mainFrame.location="modifyTeacherWork.jsp?teacherId="+teaId;
        else if(nowpage==3)
            window.mainFrame.location="modifyTeacherFee.jsp?teacherId="+teaId;
        else if(nowpage==4)
            window.mainFrame.location="modifyTeacherAccount.jsp?teacherId="+teaId;
        else if(nowpage==5)
            window.mainFrame.location="modifyTeacherUser.jsp?teacherId="+teaId;
        else if(nowpage==6)
            window.mainFrame.location="modify_outsourcing.jsp?teacherId="+teaId;
        else if(nowpage==7)
            window.mainFrame.location="modifyTeacherCard.jsp?teacherId="+teaId;
    }
</script>

<%
    int frameWidth=150;
%>
<link href=ft02.css rel=stylesheet type=text/css> 
<link rel="stylesheet" href="style.css" type="text/css">
<frameset cols="<%=frameWidth%>,*" frameborder="NO" border="0" framespacing="0">
  <frame src="teacherMenu.jsp?frameWidth=<%=frameWidth%>&<%=request.getQueryString()%>" name="leftFrame" scrolling="AUTO" resize>
  <frame src="studentFrameStart.jsp" name="mainFrame">
</frameset>