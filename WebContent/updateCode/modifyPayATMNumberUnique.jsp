<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    
    	PayAtmMgr bigr = PayAtmMgr.getInstance();
        
        Object[] objs = bigr.retrieve("", "");
        
        if (objs!=null && objs.length!=0)
        {      
            for (int i=0; i<objs.length; i++)
            {
                PayAtm pa = (PayAtm)objs[i];
                
                pa.setPayAtmNumberUnique(i);
                
                bigr.save(pa);
            }

        }else{
            
            out.println("no data");
        }
%>
done!!