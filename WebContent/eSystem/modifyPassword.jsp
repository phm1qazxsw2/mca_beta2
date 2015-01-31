<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%
     JsfAdmin ja=JsfAdmin.getInstance();
     String m=request.getParameter("m");
 
     SimpleDateFormat sdfLog=new SimpleDateFormat("MM/dd HH:mm");

%>
<br>

&nbsp;&nbsp;&nbsp;<img src="pic/user.gif" border=0> <b>修改密碼</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<BR> 

<blockquote>
<form action="modifyPassword2.jsp" method="post" name="f1" id="f1">
    <table width="" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td bgcolor=#f0f0f0 class=es02>原密碼</td> 
            <td><input type=password name="oldPa" size=15></tD>
        </tr>
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td bgcolor=#f0f0f0 class=es02>新密碼</td>
            <td><input type=password name="newPa" size=15></tD>
        </tr>
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td bgcolor=#f0f0f0 class=es02>新密碼確認</td>
            <td><input type=password name="newPa1" size=15></tD>
        </tR>
        <tr>
            <td colspan=2 align=middle>
                <input type=submit value="修改" onClick="return check()">
           </td>
        </tr>
        </table>

    </td>
    </tr>
    </table> 
    </form>
    <br>
    <br> 	
</blockquote>
<script>

    function check(){

        if(f1.newPa.value.length<=0 || f1.newPa.value !=f1.newPa1.value){

            alert("請確認密碼");
            return false;
        }
        return true;
    }
</script>
<%
if(m!=null) 
{ 
%> 
	<script>
		alert('修改完成!');
	</script>
<%
}
%>
<%@ include file="bottom.jsp"%>