<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    SchDef sd = SchDefMgr.getInstance().find("id=" + id);
    String name = sd.getName();
    Date startDate = sd.getStartDate();
    Date endDate = sd.getEndDate();
    int type = sd.getType();
    String content = sd.getContent();
    String color = sd.getColor();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd HH:mm");

    ArrayList<SchDefMembr> membrlist = SchDefMembrMgr.getInstance().retrieveList("schdefId=" + sd.getId(), "");
    String membrNames = new RangeMaker().makeRange(membrlist, "getMembrName");
    if (membrNames.equals("-1"))
        membrNames = "(沒有人)";

    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList("schdefId='"+id+"'", "order by startTime asc");
%>

<body>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;
<b><img src="pic/schedule.png" border=0>&nbsp;<%=sd.getName()%>-缺勤紀錄</b>
</div><br>

        <div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="schedule_detail.jsp?id=<%=sd.getId()%>">基本資料</a> | <a href="schedule_detail_copy.jsp?id=<%=id%>">複製此班表</a> | 缺勤紀錄 
        </div>  

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>

    
    <%
    if(schevents==null || schevents.size()<=0){
%>
    <blockquote>
        <div class=es02>
            目前沒有缺勤資料.
        </div>
    </blockquote>        
<%        
    }else{
%>
    
    <center>
    <div class=es02>        
        本班表起始日期:<b><%=sdf.format(startDate)%></b> 結束日期:<b><%=sdf.format(endDate)%></b>
    </div>
    <br>
    <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de" nowrap>
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
            <td>
            關係人
            </td>
            <td>
            假別
            </td>                
            <td>
            缺勤時間
            </td>
            <td>累計時間</td>
            <td></td>
        </tr>
<%
        

        MembrMgr mm=MembrMgr.getInstance();
        for(int i=0;i<schevents.size();i++){
            SchEvent se=schevents.get(i);
            Membr mem=(Membr)mm.find("id="+se.getMembrId());
%>
        <tr bgcolor=#ffffff class=es02 align=left valign=middle>
            <td><%=(mem !=null)?mem.getName():""%></td>
            <td align=middle><%=se.getChinsesType(se.getType())%></td>
            <td><%=sdf2.format(se.getStartTime())%>-<%=sdf2.format(se.getEndTime())%></tD>
            <td align=right><%=(se.getLastingHours()<=0)?"":se.getLastingHours()+" 小時 "%><%=(se.getLastingMins()<=0)?"":se.getLastingMins()+" 分鐘"%></tD>
            <td align=middle>
            <a href="#" onClick="javascript:openwindow_phm('modifySchEvent.jsp?seId=<%=se.getId()%>', '修改出缺勤', 400, 420, 'addevent');return false">修改</a>

            </td>
        </tr>           
<%
        }
%>
        </table>
        </td>
        </tr>
        </table>  
        </center>
<%
    }
%>
