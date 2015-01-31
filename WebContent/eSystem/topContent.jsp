<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<style type="text/css">

.invertedshiftdown{
	width:100%;
	height:38px;
	background-color:#6B696B;
	overflow:hidden;
}

.invertedshiftdown a{
float: left;
display: block;
font: bold 12px Arial;
text-decoration: none;
margin: 0 1px 0 0; /*Margin between each menu item*/
padding: 9px 10px 5px 10px; /*Padding within each menu item*/
background-color: 6B696B; /*Default menu color*/

/*BELOW 4 LINES add rounded bottom corners to each menu item.
  ONLY WORKS IN FIREFOX AND FUTURE CSS3 CAPABLE BROWSERS
  REMOVE IF DESIRED*/
#-moz-border-radius-bottomleft: 5px;
#border-bottom-left-radius: 5px;
#-moz-border-radius-bottomright: 5px;
#border-bottom-right-radius: 5px;
height:32px;
color:white;
}

.invertedshiftdown a:hover{
background-color: #FF0000; /*Red color theme*/
#padding-top: 9px; /*Flip default padding-top value with padding-bottom */
#padding-bottom: 5px; /*Flip default padding-bottom value with padding-top*/
color: white;
text-decoration: underline;

}

.invertedshiftdown .current{ /** currently selected menu item **/
background-color: #FF0000; /*Red color theme*/
padding-top: 9px; /*Flip default padding-top value with padding-bottom */
padding-bottom: 5px; /*Flip default padding-bottom value with padding-top*/
color: white;
}

#myform{
}

.myforminput{
width: 140px;
border: 1px solid white;
height: 20px;
}

.myformsubmit{
font: normal 12px Verdana;
height: 20px;
border: 1px solid #ffffff;
background-color: #6B696B;
color: white;
width:50px;
}

.newMenuItem{
	float:left;
	background-color:#ff0000;
	height:30;
}

</style>


<div class="invertedshiftdown">
<div style="width:100%;background-image:url(pic/bg03.gif);height:9px;overflow:hidden;"></div>
<div style="width:40px;float:left;border:solid 0px blue;height:20;"></div>
<%
    if(checkAuth(ud2,authHa,100))
    {
        String page_url = (pZ2.getPagetype()!=7)?"billoverview.jsp":"mca_fee_list.jsp"; // 7 is 馬禮遜
%>
<a <%=(topMenu==1)?"class=\"current\"":""%> href="<%=page_url%>" title="開單，帳務管理，收費報表等"><font color=white>帳　單</font></a>

<%  
    }

    if(checkAuth(ud2,authHa,200))
    {
%>
<a <%=(topMenu==2)?"class=\"current\"":""%> href="incomeIndex.jsp" title="雜費支出/收入,內部交易的相關作業"><font color=white>財務作業</font></a>
<%
    }
/*
    if(checkAuth(ud2,authHa,300))
    {
%>
<a <%=(topMenu==5)?"class=\"current\"":""%> href="salaryoverview.jsp" title="編輯薪資資料"><font color=white>薪　資</font></a>

<%
    }
    if(checkAuth(ud2,authHa,400))
    {
%>
<a <%=(topMenu==11)?"class=\"current\"":""%> href="cashaccountIndex.jsp" title="現有的現今金明細等"><font color=white>現金帳戶</font></a>

<%
    }
*/    

/*
    if(checkAuth(ud2,authHa,500)&& pZ2.getVersion()==1)
    {
%>
<a <%=(topMenu==10)?"class=\"current\"":""%> href="freportIndex.jsp" title="財務現狀,財務統計及相關報表統計"><font color=white>報表統計</font></a>
<%
    }
*/
    if(checkAuth(ud2,authHa,600))
    {
        String student_index_page = "studentIndexx.jsp";
        if (pZ2.getPagetype()==7)
            student_index_page = "listStudent.jsp";
%>
<a <%=(topMenu==4)?"class=\"current\"":""%> href="<%=student_index_page%>" title="<%=(pZ2.getCustomerType()==0)?"編輯學生資料":"編輯客戶資料"%>"><font color=white><%=(pZ2.getCustomerType()==0)?"學　生":"客　戶"%></font></a>
<%
    }

/*
    if(checkAuth(ud2,authHa,700) && pZ2.getVersion()==1)
    {
%>

<a <%=(topMenu==6)?"class=\"current\"":""%> href="listTeacher.jsp" title="<%=(pZ2.getCustomerType()==0)?"編輯教職員資料":"編輯員工資料"%>"><font color=white><%=(pZ2.getCustomerType()==0)?"教職員":"員　工"%></font></a>
<%
    }
    if(checkAuth(ud2,authHa,800))
    {   
%>
<a <%=(topMenu==9)?"class=\"current\"":""%> href="inventory_list.jsp" title="學用品登入"><font color=white>學用品</font></a>
<%
    }
*/
%>

<%


    if(ud2.getUserRole()==6){
%>
<a <%=(topMenu==13)?"class=\"current\"":""%> href="outsourcing.jsp" title="派　遣"><font color=white>派　遣</font></a>

<%  }   %>
  
<%
    if(ud2.getUserRole()<6){
%>
<a <%=(topMenu==8)?"class=\"current\"":""%> href="userIndex.jsp" title="與其他使用者共舞"><font color=white>協同作業</font></a>

<%
    }
%>
<%
    if(AuthAdmin.authPage(ud2,4) && topMenu==7)
    {
%>
<a <%=(topMenu==7)?"class=\"current\"":""%> href="steupIndex.jsp" title="系統設定"><font color=white>設　定</font></a>

<%  }   %>

<%
    if(pZ2.getMembrService()==1){
%>
<a <%=(topMenu==14)?"class=\"current\"":""%> href="serviceIndex.jsp" title="客服記錄"><font color=white>客　服</font></a>
<%  }   %>


<table border="0" align="right" height="10">
<tr><td height="10">
<% if(ud2.getUserRole()!=6){ %>

<form id="myform" action="listStudent.jsp" method=get>

<input type=hidden name="status" value="-1">
<input type=hidden name="tag" value="-1">
<input class="myforminput" type="text" class="textinput" name="searchWord" > 
<input class="myformsubmit" type="submit" value="搜尋" />

</form>

<%  }else{   %>

    <a href="http://www.phm.com.tw/outsourcing/index.htm" target="_blank"><font color=white>?&nbsp;使用手冊</font></a>

<%  }   %>

&nbsp;&nbsp;</td></tr></table>
</div>


<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td width="131">
<br>
