<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String d1String=request.getParameter("d1");
    String d2String=request.getParameter("d2");
    int type=0;
    String typeS=request.getParameter("type");
    if(typeS !=null)
        type=Integer.parseInt(typeS);

    int bunit=-1;
    String bunitS=request.getParameter("bunit");
    try{
        bunit=Integer.parseInt(bunitS);
    }catch(Exception ex){}

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    Date d1=sdf.parse(d1String);
    Date d2=sdf.parse(d2String);

    SchEventMgr sem=SchEventMgr.getInstance();
    Calendar c=Calendar.getInstance();
    c.setTime(d2);        
    c.add(Calendar.DATE, 1);
    Date nextdate= c.getTime();
    
    ArrayList<SchEvent> asv=sem.retrieveList("'"+ sdf.format(d1) +"' <= startTime and startTime<'"+sdf.format(nextdate)+"' and status="+SchEvent.STATUS_READER_PENDDING,"");

    MembrTeacherMgr mtm=MembrTeacherMgr.getInstance();

    for(int i=0;asv !=null && i<asv.size();i++){
        SchEvent se=asv.get(i);

        if(bunit !=-1){
            MembrTeacher mt=mtm.find("membr.id='"+se.getMembrId()+"'");
            if(mt ==null || mt.getTeacherBunitId()!=bunit){
                continue;                    
            }
        }
        se.setStatus(SchEvent.STATUS_READER_CONFORM);
        se.setVerifyDate(new Date());
        se.setVerifyUserId(ud2.getId());
        sem.save(se);
    }
    if(type !=0){
        if(bunit ==-1)
            response.sendRedirect("schedule_daily.jsp?d="+d1String);
        else
            response.sendRedirect("schedule_daily.jsp?d="+d1String+"&bunit="+bunit);        
    }else{
        if(bunit ==-1)
            response.sendRedirect("schedule_detail_excel.jsp?sDate="+d1String+"&eDate="+d2String);        
        else
            response.sendRedirect("schedule_detail_excel.jsp?sDate="+d1String+"&eDate="+d2String+"&bunit="+bunit);        
    }
%>