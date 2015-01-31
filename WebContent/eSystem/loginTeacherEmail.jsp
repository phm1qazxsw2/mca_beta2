<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopNotLogin.jsp"%>
<%
    String indexId=request.getParameter("indexId").trim();

    if(indexId ==null || indexId.length()!=5)
    {
        response.sendRedirect("loginEvent.jsp?r=1");
        return;
    }

    MembrTeacherMgr mtm=MembrTeacherMgr.getInstance();
    
    String query=" teacherIdNumber like '%"+indexId + "'";
    ArrayList<MembrTeacher> am=mtm.retrieveList(query,"");

    if(am==null || am.size()<=0)
    {
        response.sendRedirect("loginEvent.jsp?r=2");
        return;
    }

    MembrTeacher mt=am.get(0);   
    int membrId=mt.getMembrId();
    int teacherId=mt.getTeacherId();

    String m=request.getParameter("m");
    
    Teacher2Mgr ttm=Teacher2Mgr.getInstance();
    Teacher2 tea=ttm.find("id='"+teacherId+"'");


    if(m !=null){
%>
    <script>
        alert('修改完成.');
    </script>
<%
    }
%>
<div class=es02>
    &nbsp;&nbsp;&nbsp;<b><%=mt.getName()%></b>&nbsp;&nbsp;  
    <a href="loginEvent2.jsp?indexId=<%=indexId%>">線上請假</a> |
    <a href="loginOvertime.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">加班登記</a> |
    <a href="searchEvent.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">缺勤/請假紀錄</a> |
    <a href="searchCard.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">刷卡紀錄</a>
    | <a href="searchYearHoliday.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">年假/補休查詢</a>
    | 刷卡Email
    &nbsp;　　　　<a href="javascript:parent.sch_qa(1);">Q&A</a>
</div>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


<br>
<blockquote>
    <table border=0>
        <tr class=es02>
    <form action="loginTeacherEmail2.jsp" method="post">
            <td>
                <b>刷卡Email設定:</b>
            </td>
            <td>     
                <input type=text name="email" value="<%=tea.getTeacherEmail()%>" size=40>
            </td>
        </tr>
        <tr class=es02>
            <td colspan=2 align=middle>
                <input type="hidden" name="teacherId" value="<%=teacherId%>">
                <input type="hidden" name="indexId" value="<%=indexId%>">
                <input type="hidden" name="mid" value="<%=membrId%>">
                <input type="submit" value="修改email">
            </td>
    </form>
        </tr>
    </table>
    <br>
    <br>
    <div class=es02>        
        <font color=blue>說明:</font>設立正確的email,系統於刷卡後將立即發送刷卡記錄到此email信箱.
    </div>
    </blockquote>

