<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%

    String membr1Card1="898900001";   //正常 
    String membr1Card2="898900002";   //愛緩衝
    String membr1Card3="898900003";   //愛遲到早退
    String membr1Card4="898900004";   //愛上班不刷
    String membr1Card5="898900005";   //愛下班不刷

    int membr1Id=1;
    int membr2Id=2;
    int membr3Id=3;
    int membr4Id=4;
    int membr5Id=5;

    CardMembrMgr cmm=CardMembrMgr.getInstance();    
    CardMembr cm=new CardMembr();
    cm.setCreated(new Date());
    cm.setCardId(membr1Card1);
    cm.setMembrId(membr1Id);
    cmm.create(cm);

    cm=new CardMembr();
    cm.setCreated(new Date());
    cm.setCardId(membr1Card2);
    cm.setMembrId(membr2Id);
    cmm.create(cm);


    cm=new CardMembr();
    cm.setCreated(new Date());
    cm.setCardId(membr1Card3);
    cm.setMembrId(membr3Id);
    cmm.create(cm);

    cm=new CardMembr();
    cm.setCreated(new Date());
    cm.setCardId(membr1Card4);
    cm.setMembrId(membr4Id);
    cmm.create(cm);

    cm=new CardMembr();
    cm.setCreated(new Date());
    cm.setCardId(membr1Card5);
    cm.setMembrId(membr5Id);
    cmm.create(cm);

%>
done