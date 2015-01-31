<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    
    SchDefMgr sdm=SchDefMgr.getInstance();
    SchDef sd =sdm.find("id=" + id);

    int bunit=0;

    try{
        bunit=Integer.parseInt(request.getParameter("bunit"));
    }catch(Exception ex){}

    String name=request.getParameter("name");
    String startDateS=request.getParameter("startDate");
    String endDateS=request.getParameter("endDate");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    
    Date startDate=sdf.parse(startDateS);
    Date endDate=sdf.parse(endDateS);
    

    sd.setName(name);
    sd.setStartDate(startDate);
    sd.setEndDate(endDate);
    sd.setRootId(id);
    sd.setBunitId(bunit);
    
    sdm.create(sd);

    ArrayList<MembrTeacher> all_teachers = MembrTeacherMgr.getInstance().retrieveList("teacherStatus!=0", "");
    String membrIds = new RangeMaker().makeRange(all_teachers, "getMembrId");
    ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "");
    Map<Integer, SchInfo> schinfoMap = SchInfo.getSchInfoForMembrs(membrs, startDate, endDate);        
    ArrayList<SchDef> schdefs = SchInfo.getSchDefsWithin(startDate, endDate);
    
    Map<Integer,Membr> membrmap=new SortingMap(membrs).doSortSingleton("getId");            
    SchMembrMgr smmgr = SchMembrMgr.getInstance();
    ArrayList<SchMembr> all_schmembr = smmgr.retrieveList("schdefId='"+id+"'", "");
    
    long duringDate2=(long) (endDate.getTime()-startDate.getTime())/(long)(1000*60*60*24);
    int duringDate=new Long(duringDate2).intValue();
    Vector v=new Vector();

    if(all_schmembr !=null && all_schmembr.size()>0){
        
        for(int k=0;k<all_schmembr.size();k++){
            
            SchMembr sm=all_schmembr.get(k);
                      
            Membr membr=membrmap.get(sm.getMembrId());
            SchInfo info = schinfoMap.get(new Integer(membr.getId()));
            String[] ss={""};
            if(!SchDef.checkConflictSchdef(membr,info,schdefs,sd,startDate,endDate,duringDate,ss)){
                System.out.println(membr.getName()+"fail");
                v.add(ss[0]);
            }else{
                SchMembr smx = new SchMembr();
                smx.setSchdefId(sd.getId());
                smx.setMembrId(membr.getId());
                smmgr.create(smx);
            }
        }
    }

    if(v !=null && v.size()>0){
%>
    <div class=es02>
       &nbsp;&nbsp;&nbsp;<b>加入失敗列表:</b>
        &nbsp;&nbsp;&nbsp;<a href="schedule_userlist.jsp?id=<%=sd.getId()%>&save=1"><img src="pic/last.gif" border=0>&nbsp;回選單</a>
    <div>
    <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
    <div class=es02>
        <blockquote>
<%
        for(int k=0;k<v.size();k++){
            String failString=(String)v.get(k);
%>
            <%=failString%> <br>
<%
        }
%>
        </blockquote>
    </div>
<%

    }else{
        response.sendRedirect("schedule_detail.jsp?id="+sd.getId()+"&m=1");
    }
%>
    