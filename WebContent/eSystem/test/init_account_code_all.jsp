<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>




<%
///////////////////////////////////////////////////////////////////Account Code

//income 

/*

    BigItemMgr bim=BigItemMgr.getInstance();
    SmallItemMgr smm=SmallItemMgr.getInstance();

    BigItem bi=new BigItem();

    bi.setAcctCode("5122");
    bi.setBigItemName("進貨費用");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("6251");
    bi.setBigItemName("薪資支出");
    bi.setBigItemActive(1);
    int bid=bim.createWithIdReturned(bi);

    SmallItem si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("勞退");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    
    bi=new BigItem();
    bi.setAcctCode("6252");
    bi.setBigItemName("租金支出");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);



    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("房租");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    bi=new BigItem();
    bi.setAcctCode("6253");
    bi.setBigItemName("文具用品");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("文具");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("影印紙");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    si=new SmallItem();
    si.setAcctCode("003");
    si.setSmallItemName("美勞工具");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    bi=new BigItem();
    bi.setAcctCode("6254");
    bi.setBigItemName("旅費");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("出差車資");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);


    bi=new BigItem();
    bi.setAcctCode("6255");
    bi.setBigItemName("交通車費");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("交通車相關費用");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("油資");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);


    bi=new BigItem();
    bi.setAcctCode("6256");
    bi.setBigItemName("郵電費");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("電話費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("郵資");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);



    bi=new BigItem();
    bi.setAcctCode("6257");
    bi.setBigItemName("修繕費");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("硬體修繕");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("消防安檢");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    bi=new BigItem();
    bi.setAcctCode("6259");
    bi.setBigItemName("廣告費");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("平面廣告");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("設計費用");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);


    bi=new BigItem();
    bi.setAcctCode("6261");
    bi.setBigItemName("水電瓦斯費");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("水費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("電費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    si=new SmallItem();
    si.setAcctCode("003");
    si.setSmallItemName("瓦斯費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);


    bi=new BigItem();
    bi.setAcctCode("6262");
    bi.setBigItemName("保險費");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("親子旅遊保險費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("幼兒平安保險");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    si=new SmallItem();
    si.setAcctCode("003");
    si.setSmallItemName("產物保險");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);


    si=new SmallItem();
    si.setAcctCode("004");
    si.setSmallItemName("勞保");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);


    si=new SmallItem();
    si.setAcctCode("005");
    si.setSmallItemName("健保");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    bi=new BigItem();
    bi.setAcctCode("6264");
    bi.setBigItemName("交際費");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("禮品");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("聚餐");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);

    bi=new BigItem();
    bi.setAcctCode("6265");
    bi.setBigItemName("捐贈");
    bi.setBigItemActive(0);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("6266");
    bi.setBigItemName("稅捐");
    bi.setBigItemActive(0);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("房屋稅");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);  

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("印花稅");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);  

    si=new SmallItem();
    si.setAcctCode("003");
    si.setSmallItemName("所得稅");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);  



    bi=new BigItem();
    bi.setAcctCode("6272");
    bi.setBigItemName("伙食費");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("6273");
    bi.setBigItemName("職工福利");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("員工聚餐");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);  

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("員工旅遊");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);  

    si=new SmallItem();
    si.setAcctCode("003");
    si.setSmallItemName("員工禮品");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);  

    si=new SmallItem();
    si.setAcctCode("004");
    si.setSmallItemName("員工津貼");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);  

    si=new SmallItem();
    si.setAcctCode("005");
    si.setSmallItemName("員工健康檢查");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si);  


    bi=new BigItem();
    bi.setAcctCode("6274");
    bi.setBigItemName("研究發展費用");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("員工研習");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("研討會相關費用");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 


    bi=new BigItem();
    bi.setAcctCode("6276");
    bi.setBigItemName("訓練費");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("6278");
    bi.setBigItemName("勞務費");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("律師顧問費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("會計師顧問費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 


    bi=new BigItem();
    bi.setAcctCode("6288");
    bi.setBigItemName("其他總務費用");
    bi.setBigItemActive(1);
    bid=bim.createWithIdReturned(bi);

    si=new SmallItem();
    si.setAcctCode("001");
    si.setSmallItemName("教具");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("002");
    si.setSmallItemName("電腦軟硬體");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("003");
    si.setSmallItemName("手續費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("004");
    si.setSmallItemName("退費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("005");
    si.setSmallItemName("雜項硬體設備");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("006");
    si.setSmallItemName("管理費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("007");
    si.setSmallItemName("圖書費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("008");
    si.setSmallItemName("會費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("009");
    si.setSmallItemName("活動費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("010");
    si.setSmallItemName("醫藥費");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 

    si=new SmallItem();
    si.setAcctCode("011");
    si.setSmallItemName("其他");
    si.setSmallItemActive(1);    
    si.setSmallItemBigItemId(bid);
    smm.createWithIdReturned(si); 


// cost
    bi=new BigItem();
    bi.setAcctCode("4111");
    bi.setBigItemName("銷貨收入");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("4611");
    bi.setBigItemName("勞務收入");
    bi.setBigItemActive(0);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("4711");
    bi.setBigItemName("業務收入");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("7111");
    bi.setBigItemName("利息收入");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

    bi=new BigItem();
    bi.setAcctCode("7140");
    bi.setBigItemName("投資收益");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);


    bi=new BigItem();
    bi.setAcctCode("7480");
    bi.setBigItemName("其他營業外收益");
    bi.setBigItemActive(1);
    bim.createWithIdReturned(bi);

*/

// asset 1



    bi=new BigItem();
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