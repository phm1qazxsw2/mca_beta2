<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    int bid=Integer.parseInt(request.getParameter("bid"));
    BunitMgr bm=BunitMgr.getInstance();
    
    Bunit b=bm.find("id='"+bid+"'");
%>

<body>

<div class=es02 align=left>
&nbsp;&nbsp;&nbsp;<img src="pic/tag1.png" border=0>&nbsp;修改考勤部門
</div>

    <center>
        <form name="f1" action="modifyBunit2.jsp" method="post">
        <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    單位名稱：
                </td>
                <td>
                    <input type=text name="name" value="<%=b.getLabel()%>">
                </td>
            </tr>
            <input type=hidden name="flag" value="<%=b.getFlag()%>">
<!--
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    應用類別:
                </td>
                <td>
                    <input type=radio name="flag" value="1" <%=(b.getFlag()==1)?"checked":""%>>會計管理
                    <input type=radio name="flag" value="0" <%=(b.getFlag()==0)?"checked":""%>>出勤系統
                </td>
            </tr>
-->
         <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    狀態名稱：
                </td>
                <td>
                    <input type=radio name="status" value=1 <%=(b.getStatus()==1)?"checked":""%>>使用中
                    <input type=radio name="status" value=0 <%=(b.getStatus()==0)?"checked":""%>>停用
                </td>
            </tr>
            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=hidden name="bid" value="<%=bid%>">
                <input type=submit value="修改" onClick="return(confirm('確認修改?'))">
                </td>
            </tr>
        </table>

    </td>
    </tr>
    </table>
    </center>

    </form>
</body>
