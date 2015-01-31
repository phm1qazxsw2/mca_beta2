<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=14;
    int leftMenu=14;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu14.jsp"%>
<%
    JsfAdmin ja=JsfAdmin.getInstance();
    JsfTool jt=JsfTool.getInstance();
    JsfPay jp=JsfPay.getInstance();
    User[] u2=ja.getAllRunUsers(_ws.getBunitSpace("userBunitAccounting"));
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2=new SimpleDateFormat("MM/dd HH:mm");
    long nowDate=new Date().getTime();
    long lastDate=nowDate-(long)(1000*60*60*24*7);
    Date startDate=new Date(lastDate);
    Date endDate=new Date();
    String startDateS=request.getParameter("startDate");
    if(startDateS !=null)
        startDate=sdf.parse(startDateS);

    String endDateS=request.getParameter("endDate");
    if(endDateS !=null)
        endDate=sdf.parse(endDateS);
    
    int status=0;
    int clientServiceStar=0;
    int clientServiceUserId=ud2.getId();
    int clientServiceLog=-1;

    String sid=request.getParameter("sid");

    String query="";

    if(sid !=null && sid.length()>0)
    {
        query=" id='"+sid+"' ";
    }else{

        Calendar cc=Calendar.getInstance();
        cc.setTime(endDate);
        cc.add(Calendar.DATE,1);
        Date d2=cc.getTime();
        query="'"+sdf.format(startDate)+"'<= clientServiceDate and clientServiceDate<'"+sdf.format(d2)+"' ";
    }
    String status2=request.getParameter("status");
    if(status2 !=null){
        status=Integer.parseInt(status2);
        
        if(status !=0)
            query+=" and clientServiceStatus='"+status+"'";
    }
    String clientServiceStar2=request.getParameter("clientServiceStar");
    if(clientServiceStar2 !=null){
        clientServiceStar=Integer.parseInt(clientServiceStar2);

        if(clientServiceStar !=0)
            query+=" and clientServiceStar='"+clientServiceStar+"'";
    }
    String clientServiceUserId2=request.getParameter("clientServiceUserId");
    if(clientServiceUserId2 !=null){
        clientServiceUserId=Integer.parseInt(clientServiceUserId2);
        if(clientServiceUserId !=-1)
            query+=" and clientServiceUserId='"+clientServiceUserId+"'";
    }
    String clientServiceLog2=request.getParameter("clientServiceLog");
    if(clientServiceLog2 !=null){
        clientServiceLog=Integer.parseInt(clientServiceLog2);
        if(clientServiceLog !=-1)
            query+=" and clientServiceLogId='"+clientServiceLog+"'";
    }
%>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;客服記錄</b>
<br>
<center>
<form  name="f1" action="serviceIndex.jsp" method="get">
    <a href="#" onclick="displayCalendar(document.f1.startDate,'yyyy/mm/dd',this);return false">開始日期:</a><input type=text name="startDate" value="<%=sdf.format(startDate)%>" size=10>
    <a href="#" onclick="displayCalendar(document.f1.endDate,'yyyy/mm/dd',this);return false">結束日期:</a><input type=text name="endDate" value="<%=sdf.format(endDate)%>" size=10>
    
    狀態:
        <select name="status">
            <option value="0">全部</option>
            <option value=1>新開</option>
            <option value=2>作業中</option>
            <option value=3>支援</option>
            <option value=9>結案</option>
        </select>
    重要性
        <select name="clientServiceStar">
            <option value="0">全部</option>
            <option value=1>普通</option>
            <option value=2>重要</option>
            <option value=3>很重要</option>
            <option value=4>十分緊急</option>
        </select>
        作業人
        <select name="clientServiceUserId">
                <option value=-1 <%=(clientServiceUserId==-1)?"selected":""%>>全部</option>
                <option value=0 <%=(clientServiceUserId==0)?"selected":""%>>尚未決定</option>
            <%      
                for(int i=0;u2!=null && i<u2.length;i++)
                {
            %>
                    <option value="<%=u2[i].getId()%>"  <%=(clientServiceUserId==u2[i].getId())?"selected":""%>><%=u2[i].getUserFullname()%></option>
            <%
                }
            %> 
            </select>
            ID: <input type=text name="sid" value="<%=(sid !=null)?sid:""%>" size=4>
            <input type=hidden name="clientServiceLog" value="-1">
            <input type=submit value="搜尋">
    </form>
    </center>
  <br>
    <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
    <br>
<%
    int orderX=0;
    String order2=request.getParameter("order"); 
    if(order2 !=null)
        orderX=Integer.parseInt(order2);   

    String orderString="";
    
    switch(orderX){
        case 1:
            orderString=" order by clientServiceDate asc";
            break;
        case 2:
            orderString=" order by clientServiceDate desc";
            break;
        case 5:
            orderString=" order by clientServiceStatus asc";
            break;
        case 6:
            orderString=" order by clientServiceStatus desc";
            break;
        case 7:
            orderString=" order by clientServiceStar asc";
            break;
        case 8:
            orderString=" order by clientServiceStar desc";
            break;
        case 3:
            orderString=" order by clientServiceUserId asc";
            break;
        case 4:
            orderString=" order by clientServiceUserId desc";
            break;
        case 9:
            orderString=" order by clientServiceLogId asc";
            break;
        case 10:
            orderString=" order by clientServiceLogId desc";
            break;
        case 11:
            orderString=" order by id asc";
            break;
        case 12:
            orderString=" order by id desc";
            break;
    }

ArrayList<MembrService> mss=MembrServiceMgr.getInstance().retrieveList(query,orderString);
if(mss==null || mss.size()<=0)
{
%>
    <br>    
    <blockquote>        
    <div class=es02>沒有客服資料</div>
    </blockquote>
<%  
    return;
}    

String queryString="";
StudentMgr smm=StudentMgr.getInstance();
UserMgr umm=UserMgr.getInstance();
MessageTypeMgr mtm=MessageTypeMgr.getInstance();

%>
<div class=es02 align=right>合計:&nbsp;<%=mss.size()%>&nbsp;筆&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<center>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=f0f0f0 align=left valign=middle class=es02>
        <tD align=middle nowrap> <%=(orderX==11)?"<a href=\"serviceIndex.jsp?"+queryString+"&order=12\">ID ↓</a>":"<a href=\"serviceIndex.jsp?"+queryString+"&order=11\">ID ↑</a>"%>
</td>
        <tD align=middle nowrap>客戶名稱</td>
         <td align=middle nowrap>
            <%=(orderX==1)?"<a href=\"serviceIndex.jsp?"+queryString+"&order=2\">日期↑</a>":"<a href=\"serviceIndex.jsp?"+queryString+"&order=1\">日期↓</a>"%>
            </tD>
            <tD align=middle nowrap>
            <%=(orderX==5)?"<a href=\"serviceIndex.jsp?"+queryString+"&order=6\">狀態↑</a>":"<a href=\"serviceIndex.jsp?"+queryString+"&order=5\">狀態↓</a>"%>
            </td><td align=middle class=es02 nowrap>
            <%=(orderX==7)?"<a href=\"serviceIndex.jsp?"+queryString+"&order=8\">重要性↑</a>":"<a href=\"serviceIndex.jsp?"+queryString+"&order=7\">重要性↓</a>"%>
            </td><td align=middle nowrap>主旨</td><td align=middle nowrap>
            <%=(orderX==3)?"<a href=\"serviceIndex.jsp?"+queryString+"&order=4\">作業人↑</a>":"<a href=\"serviceIndex.jsp?"+queryString+"&order=3\">作業人↓</a>"%>
            </td><td align=middle nowrap>
            <%=(orderX==9)?"<a href=\"serviceIndex.jsp?"+queryString+"&order=10\">登入人↑</a>":"<a href=\"serviceIndex.jsp?"+queryString+"&order=9\">登入人↓</a>"%>
            </td><TD></TD>
    </tr>
<%
    for(int i=0;i<mss.size();i++){

        MembrService ms=mss.get(i);
        Membr mem=MembrMgr.getInstance().find("id='"+ms.getClientServiceMembrId()+"'");
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td class=es02><%=ms.getId()%></tD>
            <td class=es02><%=mem.getName()%></tD>
            <td class=es02><%=sdf2.format(ms.getClientServiceDate())%></td>
            <td class=es02 bgcolor=<%=(ms.getClientServiceStatus()<9)?"4A7DBD":"F77510"%> align=middle nowrap>
                <font color=white>
              <%
                    switch(ms.getClientServiceStatus()){
                        case 1:
                            out.println("新開");
                            break;
                        case 2:
                            out.println("作業中");
                            break;
                        case 3:
                            out.println("支援");
                            break;
                        case 9:
                            out.println("結案");
                            break;
                    }
                %>
                </font>
            </td>
            <td class=es02 nowrap>
            <%
                    switch(ms.getClientServiceStar()){
                        case 1:
                            out.println("普通");
                            break;
                        case 2:
                            out.println("重要");
                            break;
                        case 3:
                            out.println("<font color=blue>很重要</font>");
                            break;
                        case 4:
                            out.println("<font color=red>十分緊急</font>");
                            break;
                    }
                %>
            </td>
            <td class=es02>
            <%
            MessageType mt=(MessageType)mtm.find(ms.getClientServiceType());
            if(mt !=null)
                out.println("<font color=blue>"+mt.getMessageTypeName()+"</font>");
            %>  -
            <%=ms.getClientServiceTitle()%>
            </td>
            <td class=es02 align=middle>
            <%
                User uOp=(User)umm.find(ms.getClientServiceUserId());
                if(uOp !=null)
                    out.println(uOp.getUserFullname());
                %>
            </td>
            <td class=es02 align=middle>
            <%
                User uOp2=(User)umm.find(ms.getClientServiceLogId());
                if(uOp2 !=null)
                    out.println(uOp2.getUserFullname());
                %>
            </td>
            <TD class=es02 align=middle>

                            <a href="javascript:openwindow_phm2('addClientService.jsp?studentId=<%=mem.getSurrogateId()%>&serviceId=<%=ms.getId()%>','新增客服記錄',700,700,true);">編輯客服</a></TD>
        </tr>
<%
        if(mss.size()==1){
%>
            <script>
openwindow_phm2('addClientService.jsp?studentId=<%=mem.getSurrogateId()%>&serviceId=<%=ms.getId()%>','新增客服記錄',700,700,true);
            </script>
<%
        }

    }
%>
    </table>
    </td>
    </tr>
    </table>
    </center>

    <br>
    <br>
    <br>






<%@ include file="bottom.jsp"%>