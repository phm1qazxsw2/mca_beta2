<%@ page language="java" 
    import="dbo.*,phm.ezcounting.*,java.util.*,phm.accounting.*,java.text.*"
    contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        VoucherService vsvc = new VoucherService(tran_id);
        vsvc.init();

        //現金
        boolean isSystem = true;
        Acode r1 = vsvc.getAcode("4100", "001", "月費收入");        
        r1 = vsvc.getAcode("4100", "002", "才藝班收入");
        r1 = vsvc.getAcode("4100", "003", "交通車收入");
        r1 = vsvc.getAcode("4100", "004", "餐點費收入");
        r1 = vsvc.getAcode("4100", "005", "學用品收入");

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>
<br>ok