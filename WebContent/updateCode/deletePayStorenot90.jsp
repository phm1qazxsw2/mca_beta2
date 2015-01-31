<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    
    	PayStoreMgr bigr = PayStoreMgr.getInstance();
        
        Object[] objs = bigr.retrieve("payStoreStatus !='90'", "");
        
        if (objs!=null && objs.length!=0)
        {
      System.out.println(objs.length);
      
            for (int i=0; i<objs.length; i++)
            {
                PayStore ps = (PayStore)objs[i];
                
                bigr.remove(ps.getId());
            }

        }else{
            
            out.println("no data");
        }
%>
done!!