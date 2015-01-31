<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String bids=request.getParameter("bid");    
    String label=request.getParameter("name");    
    String statusS=request.getParameter("status");  
    int flag=Integer.parseInt(request.getParameter("flag"));

    int bid=Integer.parseInt(bids);
    int status=Integer.parseInt(statusS);
  
    BunitMgr bm=BunitMgr.getInstance();

    Bunit b=bm.find("id="+bid);
    b.setLabel(label);
    b.setStatus(status);
    b.setFlag(flag);
    bm.save(b);

%>
    <blockquote>
        <div class=es02>
            修改完成.            
        </div>
    </blockquote>