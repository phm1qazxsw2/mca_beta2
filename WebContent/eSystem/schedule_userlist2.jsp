<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int schid = Integer.parseInt(request.getParameter("schid"));
    boolean commit = false;
    int tran_id = dbo.Manager.startTransaction();
    SchDef s = null;
    Vector v=new Vector();
    int bunit=-1;
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS);

    try {
        SchDefMgr sdmgr = new SchDefMgr(tran_id);
        s = sdmgr.find("id=" + schid);

        if(s.getAutoRun()==1)
            s = s.doSplitOrNot(tran_id);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
        String[] targets = request.getParameterValues("target");

        Map<Integer, SchMembr> orgschMap = new SortingMap(SchMembrMgr.getInstance().
            retrieveList("schdefId=" + s.getId(), "")).doSortSingleton("getMembrId");        

        Date startDate=s.getStartDate();
        Date endDate=s.getEndDate();
        long duringDate2=(long) (endDate.getTime()-startDate.getTime())/(long)(1000*60*60*24);
        int duringDate=new Long(duringDate2).intValue(); 
        String query="teacherStatus!=0";
        if(bunit !=-1)
            query+=" and teacherBunitId='"+bunit+"'";

        ArrayList<MembrTeacher> all_teachers = MembrTeacherMgr.getInstance().retrieveList(query, "");
        String membrIds = new RangeMaker().makeRange(all_teachers, "getMembrId");
        ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "");
        Map<Integer, SchInfo> schinfoMap = SchInfo.getSchInfoForMembrs(membrs, startDate, endDate);        
        ArrayList<SchDef> schdefs = SchInfo.getSchDefsWithin(startDate, endDate);        
        Map<Integer,Membr> membrmap=new SortingMap(membrs).doSortSingleton("getId");            

        SchMembrMgr smmgr = new SchMembrMgr(tran_id);
        for (int i=0; targets!=null&&i<targets.length; i++) {
            Integer target = new Integer(Integer.parseInt(targets[i]));
            if (orgschMap.get(target)!=null){
                orgschMap.remove(target);
            }else { // 原來沒有后來有的加入

                //來來來  判斷他有沒有衝到的班表
                Membr membr=membrmap.get(target);

                if(membr==null)
                    continue;              
                SchInfo info = schinfoMap.get(new Integer(membr.getId()));
                if(info ==null)
                    continue;

                String[] ss={""};

                if(!SchDef.checkConflictSchdef(membr,info,schdefs,s,startDate,endDate,duringDate,ss)){
                    v.add(ss[0]);
                }else{

                    SchMembr sm = new SchMembr();
                    sm.setSchdefId(s.getId());
                    sm.setMembrId(target.intValue());
                    smmgr.create(sm);
                }
            }
        }
        
        if (orgschMap.size()>0) { // 這些是原來有后來沒的要刪掉

            MembrTeacherMgr mtm=MembrTeacherMgr.getInstance();
            //Object[] objs = new Object[orgschMap.size()];
            Iterator<Integer> iter = orgschMap.keySet().iterator();
            int i = 0;
            while (iter.hasNext()) {

                SchMembr smx=orgschMap.get(iter.next());
                Object[] o={smx};                
                if(bunit ==-1){
                    smmgr.remove(o);
                }else{                    
                    MembrTeacher mt=mtm.find("membr.id='"+smx.getMembrId()+"'");                    
                    if(mt.getTeacherBunitId()==bunit)
                        smmgr.remove(o);
                }                                    
            }

        }        
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null) { 
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>'); history.go(-1);</script><%
        } else { 
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            e.printStackTrace();
            return;
        }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }

    if(v !=null && v.size()>0){
%>
    <div class=es02>
       &nbsp;&nbsp;&nbsp;<b>加入失敗列表:</b>
        &nbsp;&nbsp;&nbsp;<a href="schedule_userlist.jsp?id=<%=s.getId()%>&save=1&bunit=<%=bunit%>"><img src="pic/last.gif" border=0>&nbsp;回選單</a>
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

        if(schid==s.getId()){
            response.sendRedirect("schedule_userlist.jsp?id="+s.getId()+"&save=1&bunit="+bunit);
        }
    }

    if(schid!=s.getId()){
%>

        <blockquote>
            <div class=es02>
                由於修改的日期在含以發生的日期,系統以產生新的班表.
                <br><br>
                <a href="#" onClick="parent.location='schedule_detail.jsp?id=<%=s.getId()%>';return false">新的班表</a>
            </div>
        </blockquote>
<%            
    }
%>
