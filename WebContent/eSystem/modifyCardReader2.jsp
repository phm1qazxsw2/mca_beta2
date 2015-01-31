<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    int eId=Integer.parseInt(request.getParameter("eId"));
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");    
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");    
    String date1=request.getParameter("date1").trim();
    String date2=request.getParameter("date2").trim();
    String created=date1+" "+date2;
    int membrId=Integer.parseInt(request.getParameter("membrId"));

    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");
        
    Entry en=emgr.find("id="+eId);
    en.setCreated(sdf.parse(created));
    emgr.save(en);

    String pss=request.getParameter("pssText");
    if(pss !=null){
        int psId=Integer.parseInt(request.getParameter("pssId"));
        EntrypsMgr em=EntrypsMgr.getInstance();
        
        Entryps ps=new Entryps();

        if(psId!=0)
            ps=em.find("id='"+psId+"'");
        
        ps.setCreated(sdf2.parse(date1));
        ps.setMembrId(membrId);
        ps.setPs(pss);
        ps.setUserId(ud2.getId());
        ps.setModifyDate(new Date());
        
        if(psId!=0)
            em.save(ps);
        else
            em.create(ps);
    }
%>

<div class=es02><b>&nbsp;&nbsp;&nbsp;刷卡記錄修改</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<blockquote>
<div class=es02>修改完成.</div>
</blockquote>