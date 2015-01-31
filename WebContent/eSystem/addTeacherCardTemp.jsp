<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

    String dxx=request.getParameter("d");
    int membr=Integer.parseInt(request.getParameter("membrId"));

    if(pd2.getPaySystemCompanyUniteId()==null || pd2.getPaySystemCompanyUniteId().length()<=0){
%>
        <script>
            alert('登入失敗: 系統需設立辨識ID,請洽客服人員.');
        </script>
<%
        return;
    }

    String cardNum1="mm"+pd2.getPaySystemCompanyUniteId()+membr;

    SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmm");   
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyyMMdd");   

    Date d2=sdf.parse(dxx);
    String d2String=sdf2.format(d2);
    Date d3=sdf2.parse(d2String);

    CardMembrMgr cmm=CardMembrMgr.getInstance();
    CardMembr cm=new CardMembr();
    cm.setCreated(d3);
    cm.setCardId(cardNum1);
    cm.setMembrId(membr);
    cm.setActive2(2);
    cmm.create(cm);
    
    response.sendRedirect("addCardReader.jsp?membrId="+membr+"&d="+dxx+"&cardId="+cardNum1);
%>