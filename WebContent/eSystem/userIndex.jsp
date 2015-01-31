<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    HttpSession session2=request.getSession(true);
    if(session2.getAttribute("auth")==null)
    {
        JsfAdmin ja22=JsfAdmin.getInstance();
        WebSecurity _ws2 = WebSecurity.getInstance(pageContext);
        User authud2 = _ws2.getCurrentUser();
        Hashtable authHa=ja22.getHaAuthuser(authud2.getId());    
        session2.setAttribute("auth",authHa);
    }

    int topMenu=8;
    int leftMenu=0;    
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(ud2.getUserRole()==6){

        response.sendRedirect("outsourcing.jsp");
    }
%>
<%@ include file="leftMenu8.jsp"%>
<%
    JsfAdmin ja=JsfAdmin.getInstance();
    if(ja==null)
    { 
        response.sendRedirect("loginAuth.jsp");
        return;	
    } 

    JsfPay jp=JsfPay.getInstance();
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    SimpleDateFormat sdfX1=new SimpleDateFormat("MM/dd");
    SimpleDateFormat sdfX2=new SimpleDateFormat("HH:mm");    	

    Userlog[] uls=ja.getUserlogById(ud2.getId());

	Date beforeDate=null;
    if (uls!=null && uls.length>=2) 
    {
        if(ud2.getUserConfirmUpdate()==1){
            //確認更新
            Userlog[] uls2=ja.getUserlogByIdNotConfirm(ud2.getId());
            if(uls2 !=null && uls2.length>=1){
                beforeDate=uls2[0].getUserlogDate();
            }
        }else{
            //原版
            beforeDate=uls[1].getUserlogDate();
        }
    }

System.out.println("inside xxx2");
%>
<br>
<blockquote>
<table border=0 width=80%>
    <tr>
        <td rowspan=2 valign=middle align=middle>
<img src="pic/service.png" border=0 alt="得意算小秘書">
        </tD>
        <tD class=es02 valign=top colspan=4>
&nbsp;&nbsp;&nbsp;
Hi,&nbsp;<%=ja.getChineseRole(ud2.getUserRole())%> <img src="pic/user.gif" border=0>&nbsp;<b><font color=blue><%=ud2.getUserFullname()%>(<%=ud2.getUserLoginId()%>)</font></b>
        </td>
    </tr>
    <tr>
        <td width=20></td>
        <td align=left valign=top class=es02>
        <br>
    
            <b>狀態:</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<%
        if (uls!=null && uls.length>=2) 
        {
                String[] dayString={"週日","週一","週二","週三","週四","週五","週六"};
                int xday=uls[1].getUserlogDate().getDay();
%>    

                <li>上次登入的時間是<%=sdfX1.format(uls[1].getUserlogDate())%>(<%=dayString[xday]%>) <%=sdfX2.format(uls[1].getUserlogDate())%>.

<%

System.out.println("inside xxx1");

    ArrayList<Bookmark> historys2 = BookmarkMgr.getInstance().retrieveList("userId="+ud2.getId(), "order by id desc limit 1");
    Map<String, Vector<Bookmark>> historyMap2 = new SortingMap(historys2).doSort("getName");
    Iterator<String> name_iter2 = historyMap2.keySet().iterator();
    if (historys2.size()>0) {
        while (name_iter2.hasNext()) {
            String nname = name_iter2.next();
            Bookmark bm = historyMap2.get(nname).get(0); 
%>            
            <li>上次作業進度:
<a href="<%=phm.util.TextUtil.escapeJSString(bm.getUrl())%>"><%=phm.util.TextUtil.escapeJSString(nname)%></a>
<%      } 
    }%>

            <%@ include file="userselfTradeAccount.jsp"%>
<%
        }else{
%>
            <li>歡迎你第一次使用本系統.

            <li>我是您的小秘書,將提供你最即時的訊息.
<%      }   %>
        </td>
        <td width=15></td>
        <td align=left valign=top  class=es02>
            <br>
            <b>待辦事項:</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
            <%=JsfTool.getUserService(ud2,uls, _ws.getBunitSpace("bunitId"))%>
        </td>

    </tr>
</table>
</blockquote>
<script>
    function showForm(az1){

        var e=document.getElementById(az1);
        if(!e)return true;

        if(e.style.display=="none"){
            e.style.display="block"
        } else {
            e.style.display="none"
        }
        return true;
    }
</script>
<%



String backurl = "userIndex.jsp";

if (uls!=null && uls.length>=2) 
{
System.out.println("inside xxx0");
%>
<div class=es02>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>上次<%=(ud2.getUserConfirmUpdate()==1)?"確認":"登入"%>至今的更新紀錄: </b> 從<%=sdfX1.format(beforeDate)%> <%=sdfX2.format(beforeDate)%> 至 現在

<%
System.out.println("inside xxx show me");
%>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>
<%

System.out.println("inside xxx-1");

    if(ud2.getUserConfirmUpdate()==1)
    {
        if(uls[1].getUserConfirm()==0){
%>
    <form action="confirmUserLog.jsp">
        <input type=submit value="確認更新記錄">
        <input type=hidden name="userlogId" value="<%=uls[1].getId()%>">            
    </form>
<%
       }
    }

System.out.println("fee x1");
    if(checkAuth(ud2,authHa,100))
    { 
%>
<%@ include file="feeticketBeforeDate.jsp"%>

<%  
    }   

System.out.println("vitem x1");
    if(checkAuth(ud2,authHa,200))
    {
%>
<%@ include file="vitemBeforeDate.jsp"%>
<%
    }

System.out.println("inside x1");
    if(checkAuth(ud2,authHa,402))
    {
%>
<%@ include file="insidetradeBeforeDate.jsp"%>

<%
    }
    if(checkAuth(ud2,authHa,400))
    {
%>
<%@ include file="costpayBeforeDate.jsp"%>

<%
    }

    if(checkAuth(ud2,authHa,404))
    {
%>
<%@ include file="chequeBeforeDate.jsp"%>
<%
    }

/*
    if(ud2.getUserRole()<=3)
    { 
%>
<%@ include file="salaryTicketBeforeDate.jsp"%>
<%
    }
*/  
 
    if(checkAuth(ud2,authHa,600))
    {
%>

<%@ include file="studentBeforeDate.jsp"%>

<%
    }

    //考勤
    if(checkAuth(ud2,authHa,702))
    {
%>
    <%@ include file="scheventBeforeDate.jsp"%>
<%
    }

    //加班
    if(checkAuth(ud2,authHa,702))
    {
%>
    <%@ include file="overtimeBeforeDate.jsp"%>
<%
    }


    if(ud2.getUserRole()<=3)
    { 
%>
        <%@ include file="errouserlog.jsp"%>
<%
    }
%>
</blockquote>
<%
	}

    _ws.setBookmark(ud2, "協同作業-小秘書");
%>
<%@ include file="bottom.jsp"%>
