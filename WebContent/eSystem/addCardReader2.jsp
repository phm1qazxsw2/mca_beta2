<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String created=request.getParameter("createdx").trim();
    String time=request.getParameter("timex").trim();
    int mid=Integer.parseInt(request.getParameter("mid"));
    String cardId=request.getParameter("cardId");
    String membrId=request.getParameter("membrId");

    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdf3=new SimpleDateFormat("yyyyMMddHHmm");
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");

    Date createdX=sdf.parse(created+" "+time);
    Date runx=sdf2.parse(created);

    String dString=sdf3.format(createdX);     

    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");

    String sdIds=request.getParameter("sdIds");
    //Date createdX=sdf2.parse(created);

    Calendar c=Calendar.getInstance();
    c.setTime(createdX);
    c.add(Calendar.DATE,1);
    Date nextday=c.getTime();

    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().retrieveList("startTime>='" + sdf2.format(createdX) + "' and startTime<'" + sdf2.format(nextday) + "' and membrId='"+membrId+"'", " order by startTime");
    SchEventInfo seinfo = new SchEventInfo(schevents);

    if(schevents ==null || schevents.size()<=0)
    {

        try{


        String pss=request.getParameter("pssText");
        if(pss !=null){
            int psId=Integer.parseInt(request.getParameter("pssId"));
            EntrypsMgr em=EntrypsMgr.getInstance();
            
            Entryps ps=new Entryps();

            if(psId!=0)
                ps=em.find("id='"+psId+"'");
            
            ps.setCreated(runx);
            ps.setMembrId(Integer.parseInt(membrId));
            ps.setPs(pss);
            ps.setUserId(ud2.getId());
            ps.setModifyDate(new Date());
            
            if(psId!=0)
                em.save(ps);
            else
                em.create(ps);
        }
       

        Entry en=new Entry();   
        en.setCreated(createdX);
        en.setMachineId(mid);
        en.setCardId(cardId);
        en.setDatatype(1);
        en.setDatauser(ud2.getId());
        emgr.create(en);  
%>
    <blockquote>    
    <br>
    <div class=es02>新增完成.
    <br>
    <br>        
            <a href="addCardReader.jsp?membrId=<%=membrId%>&d=<%=dString%>&sdIds=<%=sdIds%>">繼續輸入</a>
    </div>
    </blockquote>
<%  
        }catch(Exception e){
%>
    <blockquote>    
    <br>
    <div class=es02><font color=red>Error:</font>重複登入此時間,寫入失敗.
    <br>
    <br>        
            <a href="addCardReader.jsp?membrId=<%=membrId%>&d=<%=dString%>&sdIds=<%=sdIds%>">重新輸入</a>
    </div>
    </blockquote>
<%
        }

    }else{    
        boolean showX=false;
        SchDefMgr sdfm=SchDefMgr.getInstance();
        for(int i=0;i<schevents.size();i++){
            SchEvent se=schevents.get(i);

        //out.println(sdf.format(se.getStartTime())+","+sdf.format(se.getEndTime())+","+sdf.format(createdX));


            SchDef sd=sdfm.find("id="+se.getSchdefId());
            if(se.getStartTime().compareTo(createdX)<=0 && createdX.compareTo(se.getEndTime())<0){

                if(!showX){
%>

                <blockquote>
                <br>
                <div class=es02>&nbsp;&nbsp;&nbsp;<b><font color=red>新增失敗.</font>請先將以下影響的出勤/請假記錄做修改或刪除.</b></div>
                <br>
                    <div class=es02>
                    &nbsp;&nbsp;&nbsp;影響的出勤/請假記錄:
                    </div>
                    <br>
                    <center>

                    <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
                    <tr align=left valign=top>
                    <td bgcolor="#e9e3de">
                        
                        <table width="100%" border=0 cellpadding=4 cellspacing=1>
                            <tr bgcolor=#f0f0f>
                                <td>班表</td><td>請假時間</td><td></td>
                            </tr>
<%
                    showX=true;
                }

%>
        <tr bgcolor=ffffff class=es02>
            <tD><%=sd.getName()%></tD>
            <td class=es02 align=middle nowrap valign=top><%=sdftime.format(se.getStartTime())%>-<%=sdftime.format(se.getEndTime())%></td>
            <td>
<a href="#" onClick="javascript:openwindow_phm('modifySchEvent.jsp?seId=<%=se.getId()%>', '修改出缺勤', 400, 420, 'addevent');return false">修改</a>

            </td>
        </tr>

<%          }   
        }

        if(showX){
%>
    </table>
    </tD>
    </tr>
    </table>
    <div class=es02>
    <br>
    <br>
    <a href="addCardReader.jsp?membrId=<%=membrId%>&d=<%=dString%>&sdIds=<%=sdIds%>">重新輸入</a>
    </div>        
    </center>
<%  
        }else{

        //有event 但沒有蓋到
            Entry en=new Entry();   
            en.setCreated(createdX);
            en.setMachineId(mid);
            en.setCardId(cardId);
            en.setDatatype(1);
            en.setDatauser(ud2.getId());

            emgr.create(en);  
%>
        <blockquote>    
        <br>
        <div class=es02>新增完成.
            <br>
            <br>
            <a href="addCardReader.jsp?membrId=<%=membrId%>&d=<%=dString%>&sdIds=<%=sdIds%>">繼續輸入</a>
        </div>
        </blockquote>
        
<%
        }
    }   

%>


