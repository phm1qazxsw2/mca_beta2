<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%!

  	DecimalFormat mnf = new DecimalFormat("###,###,##0.00");
    String getPaddingText(Vector<SchEvent> v,Membr membr,String d1str,String d2str,int status,int type,int minX[])
    {
        if (v==null) return "";
        int min = 0;
        for (int i=0; i<v.size(); i++)
            min += v.get(i).getTimeSpan();
        
        minX[1]=min;
        
        String minsWord="";
        if(min <60){
            minsWord=min+" 分鐘";
        }else{
            minsWord=mnf.format((float)min/(float)60)+" 小時";
        }

        return "<a href=\"javascript:openwindow_phm ('schedule_event_membr.jsp?mid="+membr.getId()+"&d1="+d1str+"&d2="+d2str+"&stutus=2', '出缺勤記錄', 800,600,'scheventmembr');\">"+minsWord+" ("+v.size() + "次)</a>";

    }

%>
<%
    int topMenu=6;
    int leftMenu=3;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu6_sch.jsp"%>

<%
    YearHolidayMgr yhm=YearHolidayMgr.getInstance();
    ArrayList<YearHoliday> yh=yhm.retrieveList("","order by id desc");

    if(yh ==null || yh.size()<=0){
%>
        <br>
        <br>
        <blockquote>
            <div class=es02>

<a href="javascript:openwindow_phm2('addYearHoliday.jsp', '設定年假區間', 500, 400, 'addevent');"><img src="pic/fix.gif" border=0>&nbsp;設定年假區間</a>              
            </div>            
        </blockquote>
        <%@ include file="bottom.jsp"%>
<%
        return;
    }

    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws.getBunitSpace("buId"));

    int bunit=(ud2.getUserBunitCard()==0)?-1:ud2.getUserBunitCard();
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS);

    int yearHolidayId=-1; 
%>
<br>
<br>
<div class=es02>
    <form action="listYearHoliday.jsp" method="post">
        &nbsp;&nbsp;&nbsp;
        <b>年假設定</b>
        &nbsp;&nbsp;&nbsp;年假區間: 
            <select name="yearHolidayId">
            <%
                for(int i=0;yh !=null && i<yh.size();i++){

                    YearHoliday yhh=yh.get(i);
                    if(i==0)
                        yearHolidayId=yhh.getId();
            %>
                    <option value="<%=yhh.getId()%>"><%=yhh.getName()%></option>
            <%  }   %>
        </select>
        <%
            if(b !=null && b.size()>0){
        %>
            職員部門: <select name="bunit" size=1>
                        <option value="-1" <%=(bunit==-1)?"selected":""%>>全部</option>
            <%          
                        for(int j=0;j<b.size();j++){    
                            Bunit bb=b.get(j);
            %>
                            <option value="<%=bb.getId()%>" <%=(bunit==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
            <%          }   %>
                        <option value="0" <%=(bunit==0)?"selected":""%>>未定</option>
                    </select>
        <%
            }else{
        %>
                <input type=hidden name="bunit" value="-1">
        <%  }   %>
        <input type=submit value="搜尋">
    </form>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;<a href="javascript:openwindow_phm2('addYearHoliday.jsp', '設定年假區間', 500, 400, 'addevent');"><img src="pic/fix.gif" border=0 width=15>&nbsp;設定年假區間</a>              
</div><br>
<%
  	DecimalFormat mnf = new DecimalFormat("###,###,##0.00");
    String yearHolidayIds=request.getParameter("yearHolidayId");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");    
    if(yearHolidayIds !=null)
        yearHolidayId=Integer.parseInt(yearHolidayIds);


    String query="";
    if(bunit !=-1)
        query=" teacherBunitId='"+bunit+"'";
    ArrayList<MembrTeacher> all_teachers = MembrTeacherMgr.getInstance().retrieveList(query, " order by teacherStatus");
    String membrIds = new RangeMaker().makeRange(all_teachers, "getMembrId");
    ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "");

    YearMembrMgr ymm=YearMembrMgr.getInstance();
    ArrayList<YearMembr> aym=ymm.retrieveList("yearHolidayId='"+yearHolidayId+"'","");
    Map<Integer, YearMembr> ykMap = new SortingMap(aym).doSortSingleton("getMembrId");

    UserMgr um=UserMgr.getInstance();

    YearHoliday yhNow=yhm.find("id='"+yearHolidayId+"'");

    Calendar c=Calendar.getInstance();
    c.setTime(yhNow.getEndDate());
    c.add(Calendar.DATE,1);    
    Date nextEndDay=c.getTime();

    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList("startTime>='" + sdf.format(yhNow.getStartDate()) + "' and startTime<'" + sdf.format(nextEndDay) + "'", "");

    SchEventInfo info = new SchEventInfo(schevents);
    String d1str = java.net.URLEncoder.encode(sdf.format(yhNow.getStartDate()));
    String d2str = java.net.URLEncoder.encode(sdf.format(yhNow.getEndDate()));
%>
    <blockquote>
    <table height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor="#f0f0f0" class=es02>
                <td>姓名</td>
                <td align=middle>年假時數</tD>
                <td align=middle>設定人</tD>
                <td align=middle>已用時數</tD>
                <td align=middle>剩餘時數</tD>
            </tr>
<%
    for(int i=0;membrs !=null && i<membrs.size(); i++)
    {
        Membr m=membrs.get(i);
        YearMembr ym=ykMap.get(new Integer(m.getId()));

        Vector<SchEvent> events = info.getMembrEvents(m);   
        Map<String,Vector<SchEvent>> statusTypeEventMap=new SortingMap(events).doSort("statusType");
        int[] minX=new int[2];
%>
        <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td class=es02 align=left><%=m.getName()%></td>
            <%
            if(ym ==null){
            %>
                <form action="addYearMembr.jsp" method="post">
                <td class=es02 colspan=4 bgcolor="#f0f0f0">
                    <input type=text name="mins" value="" size=6> 小時
                    <input type=hidden name="yearHolidayId" value="<%=yearHolidayId%>">
                    <input type=hidden name="membrId" value="<%=m.getId()%>">
                    <input type=hidden name="bunit" value="<%=bunit%>">
                    <input type=hidden name="year" value="1">
                    <input type=submit value="新增" onClick="return confirm('確認新增?')">
                </td>
                </form>
            <%  }else{  %>
                <form action="modifyYearMembr.jsp" method="post">
                <td class=es02>
                    <%
                        float hours=(float)ym.getMins()/(float)60;

                        minX[0]=ym.getMins();
                    %>
                    <input type=text name="mins" value="<%=hours%>" size=6> 小時
                    <input type=hidden name="yearHolidayId" value="<%=yearHolidayId%>">
                    <input type=hidden name="membrId" value="<%=m.getId()%>">
                    <input type=hidden name="bunit" value="<%=bunit%>">
                    <input type=hidden name="ymId" value="<%=ym.getId()%>">
                    <input type=hidden name="year" value="1">
                    <input type=submit value="修改" onClick="return confirm('確認修改?')">
                </td>
                </form>
                <td align=right>
                <%
                    User u=(User)um.find(ym.getUserId());
                    if(u !=null)
                        out.println(u.getUserFullname());
                %>
                </td>
                <td align=right class=es02>
                <%
            Vector v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_YEAR));
            out.println(getPaddingText(v,m,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_YEAR,minX));
                %>
                
                </td>
                <td align=right class=es02>
                    <%
                        int resetMins=minX[0]-minX[1];
                        if(resetMins <60){
                            out.println(resetMins+" 分鐘");
                        }else{
                            out.println(mnf.format((float)resetMins/(float)60)+" 小時");
                        }
                    %>
                </td>              
            <%  }   %>
        </tr>
<%
    }
%>
    </table>
</td>
</tr>
</table>
</blockquote>
<%@ include file="bottom.jsp"%>