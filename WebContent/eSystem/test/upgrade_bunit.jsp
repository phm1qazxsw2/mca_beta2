<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*,literalstore.*" contentType="text/html;charset=UTF-8"%>
<%
    boolean commit = false;
    int tran_id = 0;
    int tran_id2 = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        tran_id2 = com.axiom.mgr.Manager.startTransaction();

        PaySystem2 ps = new PaySystem2Mgr(tran_id).find("id=1");

        BunitMgr bumgr = new BunitMgr(tran_id);
        ArrayList<Bunit> bunits = bumgr.retrieveList("flag=" + Bunit.FLAG_BIZ, "");
        if (bunits.size()>0) {
          %><script>alert('已經有單位設定了');</script><%
          return;
        }

        Bunit bu = new Bunit();
        bu.setFlag(Bunit.FLAG_BIZ);
        bu.setLabel(ps.getPaySystemCompanyName());
        bu.setStatus(1);
        bumgr.create(bu);

        Binfo bi = new Binfo();
        bi.setBunitId(bu.getId());
        bi.setBankId(ps.getPaySystemBankAccountId());
        bi.setServiceID(ps.getPaySystemBankStoreNickName());
        bi.setStoreID(ps.getPaySystemCompanyStoreNickName());
        bi.setVirtualID(ps.getPaySystemFirst5());
        new BinfoMgr(tran_id).create(bi);

        VoucherService.init();

        bumgr.executeSQL("update bill set bunitId=" + bu.getId());
        bumgr.executeSQL("update billpay set bunitId=" + bu.getId());
        bumgr.executeSQL("update billpaid set bunitId=" + bu.getId());
        

        // 下面借 cpmgr
        Costpay2Mgr cpmgr = new Costpay2Mgr(tran_id);
        cpmgr.executeSQL("update vchr_holder set buId=" + bu.getId());
        cpmgr.executeSQL("update costpay set bunitId=" + bu.getId());
        cpmgr.executeSQL("update insidetrade set bunitId=" + bu.getId());
        cpmgr.executeSQL("update tradeaccount set bunitId=" + bu.getId());
        cpmgr.executeSQL("update bankaccount set bunitId=" + bu.getId());
        cpmgr.executeSQL("update owner set bunitId=" + bu.getId());
        cpmgr.executeSQL("update ownertrade set bunitId=" + bu.getId());
        cpmgr.executeSQL("update vitem set bunitId=" + bu.getId());
        cpmgr.executeSQL("update vpaid set bunitId=" + bu.getId());
        cpmgr.executeSQL("update cheque set bunitId=" + bu.getId());
        cpmgr.executeSQL("update acode set bunitId=" + bu.getId());
        cpmgr.executeSQL("update student set bunitId=" + bu.getId());
        cpmgr.executeSQL("update membr set bunitId=" + bu.getId());
        cpmgr.executeSQL("update teacher set bunitId=" + bu.getId());
        cpmgr.executeSQL("update discounttype set bunitId=" + bu.getId());
        cpmgr.executeSQL("update tagtype set bunitId=" + bu.getId());
        cpmgr.executeSQL("update tag set bunitId=" + bu.getId());
        cpmgr.executeSQL("update degree set bunitId=" + bu.getId());
        cpmgr.executeSQL("update relation set bunitId=" + bu.getId());
        cpmgr.executeSQL("update leavereason set bunitId=" + bu.getId());
        cpmgr.executeSQL("update leavestudent set bunitId=" + bu.getId());
        cpmgr.executeSQL("update message set bunitId=" + bu.getId());
        cpmgr.executeSQL("update messagetype set bunitId=" + bu.getId());
        cpmgr.executeSQL("update bunit set buId=" + bu.getId() + " where flag=0");
        cpmgr.executeSQL("update user set userBunitAccounting=" + bu.getId() + " where id>1");        
        cpmgr.executeSQL("update itemalias set bunitId=" + bu.getId());
        cpmgr.executeSQL("update userlog set bunitId=" + bu.getId());
        cpmgr.executeSQL("update freeze set bunitId=" + bu.getId());
        cpmgr.executeSQL("update pitem set bunitId=" + bu.getId());
        cpmgr.executeSQL("update costtrade set bunitId=" + bu.getId());
        cpmgr.executeSQL("update clientaccount set bunitId=" + bu.getId());

        BunitHelper.reset();

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