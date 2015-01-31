<%@ page language="java" 
    import="com.axiom.mgr.*,jsf.*"
    contentType="text/html;charset=UTF-8"%>
<%

int tran_id = 0;
try {
    tran_id = Manager.startTransaction();
    
    FeeticketMgr fmgr = new FeeticketMgr(tran_id);
    Feeticket f = new Feeticket();
    fmgr.createWithIdReturned(f);
    fmgr.createWithIdReturned(f);
    fmgr.createWithIdReturned(f);
    fmgr.createWithIdReturned(f);
    fmgr.createWithIdReturned(f);
    fmgr.createWithIdReturned(f);
    fmgr.createWithIdReturned(f);
    fmgr.createWithIdReturned(f);
    
    //Manager.rollback(tran_id);
    Manager.commit(tran_id);
}
catch (Exception e) {
    Manager.rollback(tran_id);
}
%> 
done!




