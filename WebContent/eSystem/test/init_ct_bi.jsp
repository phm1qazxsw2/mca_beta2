<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%

    if (1==1)
        throw new Exception("obsolete!");

    JsfAdmin ja=JsfAdmin.getInstance();
    Costtrade[] ct=ja.getAllCosttrade();

    CostbigitemMgr cm=CostbigitemMgr.getInstance();

    for(int i=0;ct !=null && i< ct.length ; i++)
    {
        Costbigitem cb=new Costbigitem();
        cb.setCosttradeId(ct[i].getId());
        cb.setBigitemId(0);
        
        cm.createWithIdReturned(cb);
    }
%>

done!