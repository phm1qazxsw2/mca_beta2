<%@ page language="java" import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%><%
    try
    {
        String sz=request.getParameter("z");
    	int ibi=Integer.parseInt(sz);
    	
 
    	JsfAdmin ja=JsfAdmin.getInstance();
    	IncomeSmallItem[] si=ja.getAllIncomeSmallItemByBID(ibi); 
    	
    	
    	
    	if(si ==null)
    	{
    		out.println("don`t have this sub item!");
    		
    	}
    	else
    	{
    	
		for(int i=0;i<si.length;i++)
		{
		out.println("<input type=radio name=smallItem value=\""+si[i].getId()+"\">"+si[i].getIncomeSmallItemName()+" ");
		}
	}
    }
    catch(Exception e)
    {
        e.printStackTrace();
        //out.print("bad");
    }
%>