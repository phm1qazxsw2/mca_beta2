<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String cardNum1=request.getParameter("cardNum1").trim();
    int membr=Integer.parseInt(request.getParameter("membr"));
    int teacherId=Integer.parseInt(request.getParameter("teacherId"));

    CardMembrInfoMgr cmmi=CardMembrInfoMgr.getInstance();
    ArrayList<CardMembrInfo> cmi=cmmi.retrieveList("cardId="+cardNum1+" and active2=1","");
    if(cmi!=null && cmi.size()>0){
%>
    <blockquote>
        <div class=es02>
            <font color=red>設定失敗!</font>

            <br>
            <br>
            卡號:<%=cardNum1%> 現在以為 
            <%
                CardMembrInfo cmx=(CardMembrInfo)cmi.get(0);
            %>
            <b><%=cmx.getName()%></b> 所使用.
            <br>
            <br>
            <a href="modifyTeacherCard.jsp?teacherId=<%=teacherId%>">重新設定</a>
        </div>
    </blockquote>
<%
        return;
    }
    

    //明天生效
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");   
    String toString=sdf.format(new Date()); 
    Date d=sdf.parse(toString);
    Calendar c=Calendar.getInstance();
    c.setTime(d);
    c.add(Calendar.DATE,1);
    Date d2=c.getTime();

    
    c.add(Calendar.DATE,1);
    Date d3=c.getTime();

    //有沒有今天的臨時卡 有的話delete
    CardMembrMgr cmm=CardMembrMgr.getInstance();
    ArrayList<CardMembr> cmi2=cmm.retrieveList("membrId="+membr+" and '"+sdf.format(d2)+"' <= created and created <'"+sdf.format(d3)+"'","");
    if(cmi2!=null && cmi2.size()>0){
        for(int j=0;j< cmi2.size();j++){
            CardMembr cmx=cmi2.get(j);
            Object[] o={cmx};
            cmm.remove(o);
        }
    }

    //disable 正在用的card
    ArrayList<CardMembr> cmA=cmm.retrieveList("active2='1' and membrid="+membr,"");    
    for(int i=0;cmA !=null && i< cmA.size();i++){
            CardMembr cmx=(CardMembr)cmA.get(i);
            cmx.setActive2(0);
            cmm.save(cmx);
    }

    CardMembr cm=new CardMembr();
    cm.setCreated(d2);
    cm.setCardId(cardNum1);
    cm.setMembrId(membr);
    cm.setActive2(1);
    cmm.create(cm);
    
    response.sendRedirect("modifyTeacherCard.jsp?teacherId="+teacherId+"&m=1");
%>