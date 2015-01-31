<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>




<%
///////////////////////////////////////////////////////////////////Account Code


// asset 1

    BigItemMgr bim=BigItemMgr.getInstance();


    BigItem bi=new BigItem();
    bi.setAcctCode("1111");
    bi.setBigItemName("零用金帳戶");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);
    

    bi=new BigItem();
    bi.setAcctCode("1113");
    bi.setBigItemName("銀行存款");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);


    bi=new BigItem();
    bi.setAcctCode("1116");
    bi.setBigItemName("在途現金");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("1120");
    bi.setBigItemName("短期投資");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("1131");
    bi.setBigItemName("應收票據");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);
  
  
    bi=new BigItem();
    bi.setAcctCode("1139");
    bi.setBigItemName("備抵呆帳－應收票據");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("1141");
    bi.setBigItemName("應收帳款");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("1142");
    bi.setBigItemName("應收分期帳款");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);
  
    bi=new BigItem();
    bi.setAcctCode("1149");
    bi.setBigItemName("備抵呆帳－應收帳款");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("1211");
    bi.setBigItemName("商品存貨");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("1212");
    bi.setBigItemName("寄銷商品");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("1250");
    bi.setBigItemName("預付費用");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  
  
     bi=new BigItem();
    bi.setAcctCode("1293");
    bi.setBigItemName("業主(股東)往來");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("1294");
    bi.setBigItemName("同業往來");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("1314");
    bi.setBigItemName("退休基金");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("1431");
    bi.setBigItemName("房屋及建築");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);   
  
    bi=new BigItem();
    bi.setAcctCode("1437");
    bi.setBigItemName("房屋及建築－重估增值");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);   
  
    bi=new BigItem();
    bi.setAcctCode("1438");
    bi.setBigItemName("累計折舊－房屋及建築");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);   
  
    bi=new BigItem();
    bi.setAcctCode("1541");
    bi.setBigItemName("交通及運輸設備");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("1542");
    bi.setBigItemName("累計折舊-交通及運輸");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("1551");
    bi.setBigItemName("其他設備");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  
  
    bi=new BigItem();
    bi.setAcctCode("1842");
    bi.setBigItemName("長期應收帳款");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  
  
  
//type 2 
  
    bi=new BigItem();
    bi.setAcctCode("2111");
    bi.setBigItemName("銀行透支");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("2112");
    bi.setBigItemName("銀行借款");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  
  
    bi=new BigItem();
    bi.setAcctCode("2121");
    bi.setBigItemName("應付商業本票");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("2121");
    bi.setBigItemName("應付商業本票");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("2131");
    bi.setBigItemName("應付票據");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("2141");
    bi.setBigItemName("應付帳款");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("2161");
    bi.setBigItemName("應付所得稅");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("2261");
    bi.setBigItemName("預收貨款");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

  
      bi=new BigItem();
    bi.setAcctCode("2262");
    bi.setBigItemName("預收收入");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("2283");
    bi.setBigItemName("暫收款");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("2284");
    bi.setBigItemName("代收款");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  
  
  
        bi=new BigItem();
    bi.setAcctCode("2293");
    bi.setBigItemName("業主(股東)往來");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("2504");
    bi.setBigItemName("長期借款");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("3101");
    bi.setBigItemName("股本");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  
  
      bi=new BigItem();
    bi.setAcctCode("3109");
    bi.setBigItemName("預收股本");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("3301");
    bi.setBigItemName("法定公積");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("3302");
    bi.setBigItemName("特別公積");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("3311");
    bi.setBigItemName("累計盈虧");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  

    bi=new BigItem();
    bi.setAcctCode("3317");
    bi.setBigItemName("前期損益調整");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);  
%>

done!!