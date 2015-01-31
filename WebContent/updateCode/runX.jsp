<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    CostpayMgr cmm=CostpayMgr.getInstance();

    Costpay co=(Costpay)cmm.find(2139);    


    if(co !=null)
    {
        co.setCostpayAccountType(2);
        co.setCostpayAccountId(1);
        
        cmm.save(co);
    }

    co=(Costpay)cmm.find(2297);

    if(co !=null)
    {
        co.setCostpayAccountType(2);
        co.setCostpayAccountId(1);
        
        cmm.save(co);
    }

    co=(Costpay)cmm.find(2298);

    if(co !=null)
    {
        co.setCostpayAccountType(2);
        co.setCostpayAccountId(1);
        
        cmm.save(co);
    }



%>
done!!