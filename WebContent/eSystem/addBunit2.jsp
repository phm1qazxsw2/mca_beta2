<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String label=request.getParameter("name");    
    int flag=Integer.parseInt(request.getParameter("flag"));
    BunitMgr bm=BunitMgr.getInstance();

    Bunit b=new Bunit();
    b.setLabel(label);
    b.setStatus(1);
    b.setFlag(flag);
    b.setBuId(_ws2.getSessionBunitId());
    bm.create(b);

%>
    <blockquote>
        <div class=es02>
            新增完成.            
        </div>
    </blockquote>