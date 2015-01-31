<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.net.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<head>
    <title>快速編輯-學生資料</title>
</head>
<script>
    var nowpage=1;

    function checkPage(stuId) {
        <%  if (pd2.getPagetype()==7) { %>
            window.mainFrame.location = 'modify_mca_student.jsp?studentId=' + stuId;
        <%  } else { %>
        if(nowpage==1)
            window.mainFrame.location="modifyStudent.jsp?studentId="+stuId;
        else if(nowpage==2)
            window.mainFrame.location="studentContact.jsp?studentId="+stuId;
        else if(nowpage==3)
            window.mainFrame.location="studentStatus.jsp?studentId="+stuId;
        else if(nowpage==4)
            window.mainFrame.location="studentStuff.jsp?studentId="+stuId;
        else if(nowpage==5)
            window.mainFrame.location="studentSuggest.jsp?studentId="+stuId;
        else if(nowpage==6)
            window.mainFrame.location="studentVisit.jsp?studentId="+stuId;
        <%  } %>
    }
</script>
<%
    int frameWidth=150;
%>

<link href=ft02.css rel=stylesheet type=text/css> 
<link rel="stylesheet" href="style.css" type="text/css">
<frameset cols="<%=frameWidth%>,*" frameborder="NO" border="0" framespacing="0">
  <frame src="studentMenu.jsp?frameWidth=<%=frameWidth%>&<%=request.getQueryString()%>" name="leftFrame" scrolling="AUTO" resize>
  <frame src="studentFrameStart.jsp" name="mainFrame">
</frameset>