<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
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
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,2))
    {
        response.sendRedirect("authIndex.jsp?page=9&info=1");
    }

    request.setCharacterEncoding("UTF-8");
    int uid = Integer.parseInt(request.getParameter("uid"));
    User u = (User) phm.ezcounting.ObjectService.find("jsf.User", "id=" + uid);

    boolean useAcct = false;
    try { useAcct = request.getParameter("use").equals("y"); } catch (Exception e) {}
    String accountName = request.getParameter("acct");
    if (useAcct && accountName!=null && accountName.length()>0) {

        TradeaccountMgr cmgr = TradeaccountMgr.getInstance();
        Tradeaccount ct = new Tradeaccount();
        ct.setTradeaccountName(accountName);
        ct.setTradeaccountActive(1);
        ct.setTradeaccountUserId(uid);
        ct.setTradeaccountAuth(1);
        ct.setTradeAccountOrder(0);
        ct.setBunitId(_ws.getSessionBunitId());
        cmgr.createWithIdReturned(ct);
    }

    String[] values = request.getParameterValues("bankid");
	SalarybankAuthMgr samgr = SalarybankAuthMgr.getInstance();	
	JsfPay jp=JsfPay.getInstance();	
    for (int i=0; values!=null && i<values.length; i++) {
        int bankId = Integer.parseInt(values[i]);
        if(jp.getSalarybankAuthByBankIdUserId(bankId,uid))
        {	
            SalarybankAuth sa = new SalarybankAuth();	
            sa.setSalarybankAuthId(bankId);
            sa.setSalarybankAuthUserID(uid);
            sa.setSalarybankAuthActive(1);
            sa.setSalarybankLoginId(ud2.getId());
            samgr.createWithIdReturned(sa);
        }
    }


        int uRole=u.getUserRole();
        if(uRole >2)
        {
        
            switch(uRole){
                
                case 3:
                    setUserAuth(100,u);
                    setUserAuth(101,u);
                    setUserAuth(102,u);
                    setUserAuth(103,u);
                    setUserAuth(104,u);
                    setUserAuth(105,u);
                    setUserAuth(200,u);
                    setUserAuth(201,u);
                    setUserAuth(202,u);
                    setUserAuth(203,u);
                    setUserAuth(205,u);
                    setUserAuth(206,u);
                    setUserAuth(207,u);
                    setUserAuth(208,u);
                    setUserAuth(209,u);
                    setUserAuth(300,u);
                    setUserAuth(301,u);
                    setUserAuth(302,u);
                    setUserAuth(303,u);
                    setUserAuth(400,u);
                    setUserAuth(401,u);
                    setUserAuth(402,u);
                    setUserAuth(403,u);
                    setUserAuth(404,u);
                    setUserAuth(405,u);
                    setUserAuth(500,u);
                    setUserAuth(501,u);
                    setUserAuth(502,u);
                    setUserAuth(503,u);
                    setUserAuth(600,u);
                    setUserAuth(601,u);
                    setUserAuth(602,u);
                    setUserAuth(603,u);
                    setUserAuth(604,u);
                    setUserAuth(700,u);
                    setUserAuth(701,u);
                    setUserAuth(800,u);
                    setUserAuth(801,u);
                    setUserAuth(802,u);
                    break;
                case 4:
                    setUserAuth(100,u);
                    setUserAuth(101,u);
                    setUserAuth(102,u);
                    setUserAuth(103,u);
                    setUserAuth(104,u);
                    setUserAuth(200,u);
                    setUserAuth(201,u);
                    setUserAuth(202,u); 
                    setUserAuth(400,u);
                    setUserAuth(401,u);
                    setUserAuth(402,u);
                    setUserAuth(404,u);
                    setUserAuth(600,u);
                    setUserAuth(601,u);
                    setUserAuth(602,u);
                    setUserAuth(603,u);
                    setUserAuth(604,u);
                    setUserAuth(700,u);
                    setUserAuth(701,u);
                    setUserAuth(800,u);
                    setUserAuth(801,u);
                    setUserAuth(802,u);                
                    break;
                case 5:
                    setUserAuth(600,u);
                    setUserAuth(601,u);
                    setUserAuth(602,u);
                    setUserAuth(603,u);
                    setUserAuth(604,u);
                    break;
            }
        }
%>
<br>
<br>
<br>
<blockquote>
<div class=es02>
設定成功！
<br>
<br>
<a href="listUser.jsp">回使用者列表</a> | <a href="authUser.jsp?userId=<%=u.getId()%>"><img src="pic/key2.png" border=0>權限編輯</a>

</div>
</blockquote>
<%@ include file="bottom.jsp"%>