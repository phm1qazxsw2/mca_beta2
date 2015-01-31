<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
	JsfAdmin ja=JsfAdmin.getInstance();
	
	JsfTool jt=JsfTool.getInstance();
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.findX(studentId, _ws2.getStudentBunitSpace("bunitId")); 

    if (stu==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

    EzCountingService ezsvc = EzCountingService.getInstance();
    Membr m = ezsvc.getStudentMembr(studentId);
%>	
<script type="text/javascript" src="js/in.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
<script type="text/javascript" src="openWindow.js"></script>

<link rel="stylesheet" href="css/ajax-tooltip.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>


&nbsp;&nbsp;&nbsp;學生:<font color=blue><%=stu.getStudentName()%></font> -<img src="pic/fix.gif" border=0>學用品規格<br><br>
&nbsp;&nbsp;&nbsp;<a href="modifyStudent.jsp?studentId=<%=stu.getId()%>">基本資料</a> |   
<a href="studentContact.jsp?studentId=<%=stu.getId()%>">聯絡資訊</a>  | 
<a href="studentStatus.jsp?studentId=<%=stu.getId()%>">就學狀態</a>  |
學用品規格 | 
<!-- <a href="studentTadent.jsp?studentId=<%=stu.getId()%>">才藝班紀錄</a> |  -->
<a href="studentSuggest.jsp?studentId=<%=stu.getId()%>">電訪/反應事項</a> |
<a href="studentVisit.jsp?studentId=<%=stu.getId()%>">入學資訊</a>
  <br>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<%
    String lastDate="";
    String lastUser="尚未登入";
    
    if(stu.getStudentStuffUserId()!=0)
    {
        UserMgr um=UserMgr.getInstance();
        User u=(User)um.find(stu.getStudentStuffUserId());
        
        if(u !=null)
        {
            lastDate=sdf1.format(stu.getStudentStuffDate());    
            lastUser=u.getUserFullname();
        }
    }
    

%>
<center>
<form action="studentStuff2.jsp" method="post">

   <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
        <td bgcolor="#e9e3de">
    <table width="100%" border=0 cellpadding=4 cellspacing=1 class=es02>
        <tr>
            <td align=middle colspan=2 bgcolor=ffffff>
                <input type=hidden name="studentId" value="<%=studentId%>">
                <input type=submit value="修改">
            </td>
        </tr>
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td  bgcolor=#f0f0f0  class=es02>上次登入時間</td>
            <td>
                <%=lastDate%>
            </td>
        </tr> 
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td  bgcolor=#f0f0f0  class=es02>上次登入人</td>
            <td class=es02>
                <%=lastUser%>
            </td>
        </tr>
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td  bgcolor=#f0f0f0  class=es02>購買記錄</td>
            <td class=es02>
<%
    ArrayList<Charge> charges = ChargeMgr.getInstance().retrieveList("membrId=" + m.getId() + " and pitemNum>0", "");
    ArrayList<ChargeItemMembr> citems = ezsvc.getChargeItemMembrs(0, charges, "order by ticketId asc");
    if (citems.size()==0)
        out.println("無");
    else {
        for (int i=0; i<citems.size(); i++) {
            ChargeItemMembr ci = citems.get(i);
%>
            <%=ci.getChargeName()%> @ <a target=_blank href="bill_detail.jsp?sid=<%=ci.getMembrId()%>&rid=<%=ci.getBillRecordId()%>&backurl=##"><%=ci.getTicketId()%></a><br>
<%
        }
    }
%>
            </td>
        </tr>

<!--
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td  bgcolor=#f0f0f0  class=es02>運動服-夏季</td>
            <td class=es02><input type=text name="studentStuff1" value="<%=(stu.getStudentStuff1()!=null)?stu.getStudentStuff1():""%>"></td>
        </tr>
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td  bgcolor=#f0f0f0  class=es02>運動服-冬季</td>
            <td class=es02><input type=text name="studentStuff2" value="<%=(stu.getStudentStuff2()!=null)?stu.getStudentStuff2():""%>"></td>
        </tr>
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td  bgcolor=#f0f0f0  class=es02>室內鞋</td>
            <td class=es02><input type=text name="studentStuff3" value="<%=(stu.getStudentStuff3()!=null)?stu.getStudentStuff3():""%>"></td>
        </tr>
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td  bgcolor=#f0f0f0  class=es02>書包</td>
            <td class=es02><input type=text name="studentStuff4" value="<%=(stu.getStudentStuff4()!=null)?stu.getStudentStuff4():""%>"></td>
        </tr>        
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td  bgcolor=#f0f0f0  class=es02>餐具組</td>
            <td class=es02><input type=text name="studentStuff5" value="<%=(stu.getStudentStuff5()!=null)?stu.getStudentStuff5():""%>"></td>
        </tr>
-->
        <tr bgcolor=#ffffff align=left valign=middle class=es02>
            <td  bgcolor=#f0f0f0  class=es02>其他備註</td>
           <td>
                <textarea name="studentStuffPs" rows=6 cols=40><%=(stu.getStudentStuffPs()!=null)?stu.getStudentStuffPs():""%></textarea>
            </td>
        </tr>
        <tr>
            <td align=middle colspan=2 bgcolor=ffffff>
                <input type=hidden name="studentId" value="<%=studentId%>">
                <input type=submit value="修改">
            </td>
        </tr>
        </table>
        
            </td>
            </tr>
            </table>
        </form>
    </center>
    
<script>
    top.nowpage=4;
</script>