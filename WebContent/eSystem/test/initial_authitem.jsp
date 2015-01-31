<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%!
    public boolean setUserAuth(int authNum,User u){

        AuthitemMgr amm=AuthitemMgr.getInstance();
        AuthuserMgr aum = AuthuserMgr.getInstance();
        String query="Number = '"+authNum+"'";
     
        Object[] objs = amm.retrieve(query,"");
        
        if (objs==null || objs.length==0)
            return false;
        
        Authitem ai=(Authitem)objs[0];
        Authuser au=new Authuser();
        au.setAuthitemId(ai.getAuthId());
        au.setUserId(u.getId());
        aum.createWithIdReturned(au);
        
        return true;
    }

%>
<%


// 授權的頁面資料


    AuthitemMgr amm=AuthitemMgr.getInstance();
    Authitem au=null;

    au=new Authitem();
    au.setAuthId(41);
    au.setNumber(207);
    au.setPagename("傳票管理");
    amm.createWithIdReturned(au);


    au=new Authitem();
    au.setAuthId(42);
    au.setNumber(208);
    au.setPagename("財務報表/關帳");
    amm.createWithIdReturned(au);


    au=new Authitem();
    au.setAuthId(43);
    au.setNumber(209);
    au.setPagename("相關設定");
    amm.createWithIdReturned(au);


    au=new Authitem();
    au.setAuthId(44);
    au.setNumber(405);
    au.setPagename("現金流量報表");
    amm.createWithIdReturned(au);

    amm.remove(24);
    amm.remove(25);
    amm.remove(26);
    amm.remove(27);
    amm.remove(28);



    au=new Authitem();
    au.setAuthId(45);
    au.setNumber(702);
    au.setPagename("考勤系統");
    amm.createWithIdReturned(au);


%>

done  2!