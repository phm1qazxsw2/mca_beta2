<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,2))
    {
        response.sendRedirect("authIndex.jsp?page=9&info=1");
    }

    int userId=Integer.parseInt(request.getParameter("userId"));

    JsfAdmin ja=JsfAdmin.getInstance();
    Authuser[] auu=ja.getAuthuserByUserId(userId);
    
    Hashtable ha=new Hashtable();
    
    for(int i=0;auu !=null && i<auu.length ; i++)
    {
        ha.put((Integer)auu[i].getAuthitemId(),(Integer)auu[i].getId());        
    }

    AuthuserMgr amm=AuthuserMgr.getInstance();

    String[] authIdS=request.getParameterValues("authId");

    for(int i=0;authIdS!=null && i<authIdS.length;i++)
    {
        int authId=Integer.parseInt(authIdS[i]);

        if(ha.get((Integer)authId)==null){
            
            Authuser au=new Authuser();
            au.setAuthitemId(authId);
            au.setUserId(userId);
            amm.createWithIdReturned(au);
        }else{
            ha.remove((Integer)authId);
        }
    }

    Enumeration haKey=ha.keys();
	Enumeration haEle=ha.elements();

    while(haEle.hasMoreElements())
	{
		Integer key=(Integer)haKey.nextElement();
		Integer haX=(Integer)haEle.nextElement();

        amm.remove((int)haX);
    }


    response.sendRedirect("authUser.jsp?userId="+userId);
%>

<%@ include file="bottom.jsp"%>