<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

 	request.setCharacterEncoding("UTF-8"); 	
 	int stuId=Integer.parseInt(request.getParameter("stuId"));
 	int memId=Integer.parseInt(request.getParameter("memId"));

 	int membrServiceId=Integer.parseInt(request.getParameter("membrServiceId"));

    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
    MembrServiceMgr csm=MembrServiceMgr.getInstance();
    MembrService cs=null;    
    if(membrServiceId!=0)
    {
        cs=(MembrService)csm.find(" id='"+membrServiceId+"'");
    }else{
        cs=new MembrService();
    }

 	int clientServiceStatus=Integer.parseInt(request.getParameter("clientServiceStatus"));
 	String clientServiceDate=request.getParameter("clientServiceDate"); 
 	int clientServiceStar=Integer.parseInt(request.getParameter("clientServiceStar"));
 	int clientServiceUserId=Integer.parseInt(request.getParameter("clientServiceUserId"));
 	String clientServiceTitle=request.getParameter("clientServiceTitle"); 
 	String clientServiceContent=request.getParameter("clientServiceContent"); 
 	int serviceType=Integer.parseInt(request.getParameter("serviceType"));

    Date serviceDate=sdf.parse(clientServiceDate.trim());
    
    cs.setClientServiceMembrId   	(memId);
    cs.setClientServiceDate   	(serviceDate);
    cs.setClientServiceUserId   	(clientServiceUserId);
    cs.setClientServiceStatus   	(clientServiceStatus);
    cs.setClientServiceTitle   	(clientServiceTitle);
    cs.setClientServiceContent   	(clientServiceContent);
    cs.setClientServiceStar   	(clientServiceStar);
    cs.setClientServiceLogId   	(ud2.getId());
    cs.setClientServiceType(serviceType);
    
    if(membrServiceId!=0)
    {
        csm.save(cs);
    }else{
        csm.create(cs);        
    }

    response.sendRedirect("listClientServiceById.jsp?studentId="+stuId);
%>
