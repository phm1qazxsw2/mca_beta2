<%@ page language="java"  import="mca.*,web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*" contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    int tran_id2 = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        tran_id2 = com.axiom.mgr.Manager.startTransaction();

        UserBunitMgr ubmgr = new UserBunitMgr(tran_id);
        UserMgr umgr = new UserMgr(tran_id2);
        Object[] users = umgr.retrieve("id in (12,13,14)", "");

        for (int i=0; users!=null&&i<users.length; i++) {
            User u = (User) users[i];
            if (ubmgr.numOfRows("userId=" + u.getId() + " and bunitId=16")>0)
                continue;
            UserBunit ub = new UserBunit();
            ub.setUserId(u.getId());
            ub.setBunitId(16);
            ubmgr.create(ub);
        }

        /*
        ArrayList<Bunit> bunits = new BunitMgr(tran_id).retrieveList("flag=" + Bunit.FLAG_BIZ, "");

        UserBunitMgr ubmgr = new UserBunitMgr(tran_id);
        UserMgr umgr = new UserMgr(tran_id2);
        Object[] users = umgr.retrieve("id in (9,10,11)", "");
        for (int i=0; users!=null&&i<users.length; i++) {
            User u = (User) users[i];
            
            for (int j=0; j<bunits.size(); j++) {
                Bunit bu = bunits.get(j);
                if (bu.getId()==u.getUserBunitAccounting())
                    continue;
                UserBunit ub = new UserBunit();
                ub.setUserId(u.getId());
                ub.setBunitId(bu.getId());
                ubmgr.create(ub);
            }
        }
        */

        dbo.Manager.commit(tran_id);
        com.axiom.mgr.Manager.commit(tran_id2);
        commit = true;
    }
    finally {
        if (!commit) {
            com.axiom.mgr.Manager.rollback(tran_id2);
            dbo.Manager.rollback(tran_id);
        }
    }    
%>done!