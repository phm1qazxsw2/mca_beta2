<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String d1String=request.getParameter("d1");
    String d2String=request.getParameter("d2");

    int bunit=-1;
    String bunitS=request.getParameter("bunit");
    try{
        bunit=Integer.parseInt(bunitS);
    }catch(Exception ex){}


    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    Date d1=sdf.parse(d1String);
    Date d2=sdf.parse(d2String);
    int type=0;
    String typeS=request.getParameter("type");
    if(typeS !=null)
        type=Integer.parseInt(typeS);

    SchEventMgr sem=SchEventMgr.getInstance();
    
    Calendar c=Calendar.getInstance();
    c.setTime(d2);        
    c.add(Calendar.DATE, 1);
    d2 = c.getTime();
    
    ArrayList<SchEvent> asv=sem.retrieveList("'"+ sdf.format(d1) +"' <= startTime and startTime<'"+sdf.format(d2)+"' and status="+SchEvent.STATUS_READER_PENDDING,"");

    MembrTeacherMgr mtm=MembrTeacherMgr.getInstance();
    for(int i=0;asv !=null && i<asv.size();i++){
        SchEvent se=asv.get(i);

        if(bunit !=-1){
            MembrTeacher mt=mtm.find("membr.id='"+se.getMembrId()+"'");
            if(mt ==null || mt.getTeacherBunitId()!=bunit){
                continue;                    
            }
        }
        Object[] o={se};
        sem.remove(o);
    }


    if(type !=0){

        CardCheckdateMgr ccm2=CardCheckdateMgr.getInstance();

        if(bunit ==-1){
            ArrayList<CardCheckdate> ccd2=ccm2.retrieveList("'"+ sdf.format(d1) +"' <= checkdate and checkdate<'"+sdf.format(d2)+"'","");
            for(int i=0;ccd2 !=null && i<ccd2.size();i++){
                CardCheckdate cc=ccd2.get(i);
                Object[] o={cc};
                ccm2.remove(o);
            }
        }
        
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