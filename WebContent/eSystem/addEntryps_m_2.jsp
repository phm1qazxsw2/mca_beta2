<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopNotLogin.jsp"%>
<%
    String created=request.getParameter("createdx").trim();
    String membrId=request.getParameter("membrId");

    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdf3=new SimpleDateFormat("yyyyMMddHHmm");
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");


    Date runx=sdf2.parse(created);

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
        ps.setUserId(0);
        ps.setModifyDate(new Date());
        
        if(psId!=0)
            em.save(ps);
        else
            em.create(ps);
    }
   

%>
    <blockquote>    
    <br>
    <div class=es02>編輯完成.
    <br>
    <br>        
    </div>
    </blockquote>
