package jsf;

import java.util.*;
import java.text.*;
import com.axiom.mgr.*;

public class JsfFee
{
    private static JsfFee instance;
    
    JsfFee() {}
    
    public synchronized static JsfFee getInstance()
    {
    	
        if (instance==null)
        {
            instance = new JsfFee();
        }
        return instance;
    }
   
    // 找所有未繳的帳單 不含獨立帳單   coded by jt.addStudentFee
   public Feeticket[] getNotPayFeeticket(Date runDate,int stuid)
   {
   	    FeeticketMgr cm=FeeticketMgr.getInstance();
    	 
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	

	    String query="feeticketNewFeenumber !='1' and feeticketMonth <'"+df.format(runDate)+"/01' and feeticketStatus<90 and feeticketStuId="+stuid;
	
    	Object[] objs = cm.retrieve(query,"");
	        
        if (objs==null || objs.length==0)
        {	
            return null;
        }
        
        Feeticket[] u =new Feeticket[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Feeticket)objs[i];
        }
        return u;		
   }
    
    public PayStore getPayStoreByLine(String line)
	{
		PayStoreMgr psm=PayStoreMgr.getInstance();
		String query="payStoreSource ='"+line+"' and PayStoreStatus='90'";	
		
	        Object[] objs = psm.retrieve(query, null);
	        
	        if (objs==null || objs.length==0)
	            return null;
	        
	        return (PayStore)objs[0];		
		
	}
    
    //便利商店 - 人工銷單
    synchronized public PayStore insertArtificialStore(String line,User ud2,PaySystem pSystem)
  	{ 


  	 	String[] token = new String[7];
  		token[0]=line.substring(0,8).trim();
  		token[1]=line.substring(8,16).trim();
		token[2]=line.substring(23,32).trim();//ftId
		token[3]=line.substring(32,41).trim();//moneyNumber
		token[4]=line.substring(41,45).trim();//endDate
		token[5]=line.substring(45,53).trim();//storeId
		token[6]=line.substring(53).trim();//storeId
		int tokenLength=token.length;
		
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat sdf2=new SimpleDateFormat("yyyyMM");

        PayStore ps=new PayStore();
        int tran_id = 0;	

		try{
            tran_id = Manager.startTransaction();  

            PayStoreMgr psm=new PayStoreMgr(tran_id);
			//1		
			String UpdateDate=token[0];
	        String PayDate=token[1];
	        String sFeeticketId=token[2].trim();
			Date UpdateDate2=sdf.parse(UpdateDate);
	        Date PayDate2=sdf.parse(PayDate);
			int feeticketId=Integer.parseInt(sFeeticketId);

			//7
        	String sMonth=token[4];
        	int payYear=Integer.parseInt(sMonth.substring(0,2))+1911;
        	String payMonthFormat=String.valueOf(payYear)+sMonth.substring(2);
        	Date payMonth=sdf2.parse(payMonthFormat);		
        	
        	String sMoney=token[3];
        	int payMoney=Integer.parseInt(sMoney);
        	
        	String sStoreId=token[5].trim();
			//8
			String payStoreAccountId=token[6];

            ps.setPayStoreUpdateDate   	(UpdateDate2);
			ps.setPayStorePayDate   	(PayDate2);
			ps.setPayStoreFeeticketId   	(feeticketId);
			ps.setPayStorePayMoney   	(payMoney);
			ps.setPayStoreMonth   	(payMonth);
			ps.setPayStoreId   	(sStoreId);
			ps.setPayStoreAccountId   	(payStoreAccountId);
			ps.setPayStoreSource   	(line);

            if(line==null || line.length()<=20)
            {
                try { Manager.rollback(tran_id); } catch (Exception e2) {}  

                ps.setPayStoreStatus(1);
                ps.setPayStoreException("原始資料格式不符");
                return ps;		
            }


			PayStore psZ=getPayStoreByLine(line.trim());
			if(psZ !=null)
			{
                try { Manager.rollback(tran_id); } catch (Exception e2) {}  

				ps.setPayStoreStatus(2);
				ps.setPayStoreException("已登入payStore為"+psZ.getId());
				return ps;		
			}
  

            //run Unique Key  
            int psId=0;
            try
            {
                ps.setPayStoreStatus(90);
                psId=psm.createWithIdReturned(ps);                    
            }catch (Exception e){
                
                try { Manager.rollback(tran_id); } catch (Exception e2) {}  
                
                ps.setPayStoreStatus(3);
                ps.setPayStoreException("Unique Key Error:"+e.getMessage());
                return ps;
            }
            ps.setId(psId);
            
            PayFee pf=new PayFee();
            pf.setPayFeeFeenumberId   	(ps.getPayStoreFeeticketId());
            pf.setPayFeeMoneyNumber   	(ps.getPayStorePayMoney());
            pf.setPayFeeLogDate   	(new Date());
            pf.setPayFeeLogPayDate   	(PayDate2);
            pf.setPayFeeManPCType   	(2); 
            pf.setPayFeeSourceCategory  (3);  //便利商店繳款
            pf.setPayFeeSourceId(psId);
            pf.setPayFeeStatus   	(1);
            pf.setPayFeeLogId(ud2.getId()); 
            pf.setPayFeeAccountType(2);  //存入銀行帳戶
            pf.setPayFeeAccountId(0);    //系統預設的交易帳戶
        
            Vector vResult=balanceFeeticketByFeeNumber(pf,sFeeticketId,pSystem,ud2,3,tran_id);
            	
            if(vResult ==null)
            {
                ps.setPayStoreStatus(4);
            }    
			return ps;
		}
		catch(Exception e)
		{
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  

			ps.setPayStoreSource(line);
			ps.setPayStoreStatus(5);
			ps.setPayStoreException(e.getMessage());
			return ps;	
	    } 
  	} 

    public PayAtm getPayAtmRepeat(int payAtmNumber,Date payDate)
	{
		PayAtmMgr bigr = PayAtmMgr.getInstance();
	
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
		
		String query="payAtmNumber ='"+payAtmNumber+"' and payAtmPayDate ='"+df.format(payDate)+"'";
        	
	        Object[] objs = bigr.retrieve(query, null);
	        
	        if (objs==null || objs.length==0)
	            return null;
	        
	        return (PayAtm)objs[0];		
	}

    //銷單-人工虛擬帳號
    synchronized public PayAtm insertArtificialATM(String line,User ud2,PaySystem ps) 
	{
   

		PayAtm pa=new PayAtm(); 
		
	    int tran_id = 0;	

		try{

            tran_id = Manager.startTransaction();

            PayAtmMgr pam=new PayAtmMgr(tran_id);

			String[] token = line.split("\t");
			int tokenLength=token.length;		
			
			if(tokenLength !=6)
			{
                try { Manager.rollback(tran_id); } catch (Exception e2) {}                  

				pa.setPayAtmSource(line);
				pa.setPayAtmStatus(1);
				pa.setPayAtmException("應為Tab格式 .txt");
				
				return pa;
			}
 
			
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
				
			int payAtmNumber=Integer.parseInt(token[0].trim()); 
	    	String spayDate=token[1].trim();
	    	Date payDate=sdf.parse(spayDate);

	    	int payMoney=Integer.parseInt(token[2].trim());
	    	
	    	String x4=token[3].trim();
			String accountFirst5=x4.substring(0,5); 
			int feeticketId=Integer.parseInt(x4.substring(5).trim());

        	String payWay=token[4].trim();
        	String bankId=token[5].trim();
		
			pa.setPayAtmNumber   	(payAtmNumber);
            pa.setPayAtmNumberUnique   	(payAtmNumber);
			pa.setPayAtmPayDate   	(payDate);
			pa.setPayAtmPayMoney   	(payMoney);
			
			pa.setPayAtmAccountFirst5   	(accountFirst5.trim());
			pa.setPayAtmFeeticketId   	(feeticketId);
			pa.setPayAtmWay   	(payWay);
			pa.setPayAtmBankId   	(bankId);
			pa.setPayAtmSource   	(line);

			PayAtm paS=getPayAtmRepeat(payAtmNumber,payDate);

	        if(paS !=null)
	        {
                try { Manager.rollback(tran_id); } catch (Exception e2) {}  
	        	
                pa.setPayAtmSource(line);
				pa.setPayAtmStatus(2);
				pa.setPayAtmException("已登入PayAtm為"+paS.getId());

				return pa;
	        }
 
            
            int psId=0;

            try{
            	    psId=pam.createWithIdReturned(pa);	
	      	}catch(Exception ex){
                try { Manager.rollback(tran_id); } catch (Exception e2) {}  
            
                pa.setPayAtmStatus(3);
				pa.setPayAtmException(ex.getMessage());
				return pa;
            }
            pa.setPayAtmStatus(90);
	      	pa.setId(psId);
	      	
             
            PayFee pf=new PayFee();
            pf.setPayFeeFeenumberId   	(pa.getPayAtmFeeticketId());
            pf.setPayFeeMoneyNumber   	(pa.getPayAtmPayMoney());
            pf.setPayFeeLogDate   	(new Date());
            pf.setPayFeeLogPayDate   	(payDate);
            pf.setPayFeeManPCType   	(2); 
            pf.setPayFeeSourceCategory  (1);  //1 浮動虛擬帳號  or 2 固定虛擬帳號
            pf.setPayFeeSourceId(psId);
            pf.setPayFeeStatus   	(1);
            pf.setPayFeeLogId(ud2.getId()); 
            pf.setPayFeeAccountType(2);  //存入銀行帳戶
            pf.setPayFeeAccountId(0);    //系統預設的交易帳戶

            Vector vResult=balanceFeeticketByFeeNumber(pf,String.valueOf(feeticketId),ps,ud2,3,tran_id);
	        
            if(vResult==null)
            {
                pa.setPayAtmStatus(4);
            } 
            
	       	return pa;
    
        }catch(Exception e){
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  		

        	pa.setPayAtmSource(line);
			pa.setPayAtmStatus(5);
			pa.setPayAtmException(e.getMessage());
			
			return pa;	
		} 
 
	}
	

   //櫃臺繳款
    synchronized public Vector payFeeByFace(String ticketIdS,int payMoney,int bankType,int tradeAccount,int payway,User ud2,PaySystem e)
    {
        int ticketId=Integer.parseInt(ticketIdS);

        PayFee pf=new PayFee();

        pf.setPayFeeFeenumberId   	(ticketId);
        pf.setPayFeeMoneyNumber   	(payMoney);
        pf.setPayFeeLogDate   	(new Date());
        pf.setPayFeeLogPayDate   	(new Date());
        pf.setPayFeeManPCType   	(1);
        pf.setPayFeeSourceCategory  (4);
        pf.setPayFeeSourceId(0);
        pf.setPayFeeStatus   	(1);
        pf.setPayFeeLogId(ud2.getId()); 
        pf.setPayFeeAccountType(bankType);
        pf.setPayFeeAccountId(tradeAccount); 

        int tran_id = 0;
        Vector vResult=new Vector();
        
        try{

            tran_id = Manager.startTransaction();  
            vResult=balanceFeeticketByFeeNumber(pf,ticketIdS,e,ud2,payway,tran_id); 

        }catch(Exception es){

            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
            System.out.println("get Exception outside");              

            return null;
        }       
        return vResult;
    }
   
    //for 櫃臺 便利商店 虛擬帳號 約定帳號
    public Vector balanceFeeticketByFeeNumber(PayFee originalPF,String ticketIdS,PaySystem ps,User ud2,int payway,int tran_id)
  	{	
        if (ps.getPaySystemBankAccountId()==0)
            throw new RuntimeException("paySystemBankAccountId not set");
        if (ps.getPaySystemFixATMAccount()==null || ps.getPaySystemFixATMAccount().trim().length()==0)
            throw new RuntimeException("paySystemFixATMAccount not set");
        if (ps.getPaySystemFixATMNum()==0)
            throw new RuntimeException("paySystemFixATMNum not set");

        Vector vResult=new Vector();
        FeeAdmin fa=FeeAdmin.getInstance();
        JsfAdmin ja=JsfAdmin.getInstance();
        JsfTool jt=JsfTool.getInstance();
        ticketIdS=ticketIdS.trim();
        
        //判斷是否為約定帳號
        boolean isFixAccount=false;
        String fixATMAccount=ps.getPaySystemFixATMAccount().trim();
        
        StudentMgr sm=StudentMgr.getInstance();
        Student stu=null;
System.out.println("####1");
        if(fixATMAccount !=null)
        {
            String ticketIndex=ticketIdS.substring(0,fixATMAccount.length());
            String ticketLast=ticketIdS.substring(fixATMAccount.length());
            if(fixATMAccount.equals(ticketIndex))
            {
                isFixAccount=true;
                int stuId=Integer.parseInt(ticketLast);
System.out.println(stuId);
                stu=(Student)sm.find(stuId);
            }                
        }

        int ticketid=0;
        try{
            ticketid=Integer.parseInt(ticketIdS);
        }catch(Exception ex2){}

        Feeticket ft=null;

        if(!isFixAccount)
        {
            ft=ja.getFeeticketByNumberId(ticketid); 
            
            if(ft!=null)
            {
                int stuId=ft.getFeeticketStuId();
                stu=(Student)sm.find(stuId);
            }
        }

        int myPayMoney=originalPF.getPayFeeMoneyNumber();
        int myAccountMoney=0;
        
        int sourceType=0;
        if(originalPF.getPayFeeSourceCategory()==4)
        {    sourceType=4;  //櫃臺繳款
        }else if(originalPF.getPayFeeSourceCategory()==3){
            sourceType=5;  //學費收款-便利商店
        }else if(originalPF.getPayFeeSourceCategory()==1){
            
            if(isFixAccount)
            {
                sourceType=6;  //約定帳號
                originalPF.setPayFeeSourceCategory(2); //payFee 2 =約定帳號
            }else{ 
                sourceType=1;  //虛擬帳號
            }
        }
System.out.println("####2");
        try
        { 
            if(stu !=null)
            {           
                myAccountMoney=jt.countStudentAccount(stu.getId());
                int totalMoney=myPayMoney+myAccountMoney;
                
                Feeticket balanceFeeticket[]=null;

                       
                //月帳單銷帳
                if(ft !=null && ft.getFeeticketNewFeenumber()==0)
                {
                    AdditionalFee[] af=fa.getAllNotPayAdditionalByFeenumber(ft);
                    
                    int afLength=0;

                    if(af !=null)
                        afLength=af.length;
                
                    balanceFeeticket=new Feeticket[afLength+1];

                    if(af !=null)
                    {            
                        for(int k=0;k<afLength;k++)
                        {
                            int newfeenumber=af[k].getAdditionalFeeAddition();
                            balanceFeeticket[k]=ja.getFeeticketByNumberId(newfeenumber);
                        }                    
                    }
                    // 最後一個是自己的Feeticket
                    balanceFeeticket[afLength]=ft;
System.out.println("####3.1");
                }else if(ft !=null && ft.getFeeticketNewFeenumber()==1){
                    //獨立帳單            
                    balanceFeeticket=new Feeticket[1];
                    balanceFeeticket[0]=ft;
System.out.println("####3.2");                
                }else{
                    //約定帳號
                    balanceFeeticket=jt.allNotpayFeeticket(stu.getId());
System.out.println("####3.3");                
                }
                //存入學生帳戶
                StudentAccountMgr sam=new StudentAccountMgr(tran_id);
                StudentAccount sa=new StudentAccount();	
                sa.setStudentAccountStuId   	(stu.getId());
                sa.setStudentAccountIncomeType   	(0);  //0=income  1=cost
                sa.setStudentAccountMoney   	(myPayMoney);
                
                sa.setStudentAccountSourceType   	(sourceType);  
                                                        // type 4= pay face to face 
                                                        // type 5= pay by Store 
                sa.setStudentAccountSourceId   	(originalPF.getPayFeeSourceId());  
                sa.setStudentAccountLogId   	(ud2.getId());
                sa.setStudentAccountLogDate(originalPF.getPayFeeLogDate());   
                sa.setStudentAccountNumber(ticketIdS);
                int saId=sam.createWithIdReturned(sa);
                sa.setId(saId);

                vResult.add((StudentAccount)sa);  

                //存入現金帳戶
                if (1==1)
                    throw new RuntimeException("obsolete! bunitId");
                Costpay cost=new Costpay();
                cost.setCostpayDate   	(originalPF.getPayFeeLogPayDate());
                cost.setCostpaySide   	(1);
                cost.setCostpaySideID   	(0);
                cost.setCostpayFeeticketID   	(0);
                cost.setCostpayFeePayFeeID   	(0);
                cost.setCostpayNumberInOut   	(0);
                String sum="";
                int bankType=originalPF.getPayFeeAccountType();
                int bankId=0;

                if(bankType==1)
                {
                    bankId=originalPF.getPayFeeAccountId();

                    cost.setCostpayPayway   	(payway);
                    cost.setCostpayAccountType   	(1);
                    cost.setCostpayAccountId   	(bankId);
                    cost.setCostpayLogWay   	(1); 
                    sum=stu.getStudentName()+"學費 人工登入<br>";
                }else if(bankType==2){

                    bankId=originalPF.getPayFeeAccountId();
                    if(bankId==0)
                    {
                        bankId=ps.getPaySystemBankAccountId();  //找系統預設的帳號
                    }

                    cost.setCostpayPayway   	(payway);
                    cost.setCostpayAccountType   	(2);
                    cost.setCostpayAccountId   	(bankId);
                    cost.setCostpayLogWay   	(2);
                    sum=stu.getStudentName()+"學費 電腦銷單<br>";
                }

                cost.setCostpayLogPs   	(sum);
                cost.setCostpayCostNumber   	(0);
                cost.setCostpayIncomeNumber   	(myPayMoney);
                cost.setCostpayLogDate   	(originalPF.getPayFeeLogDate());
                cost.setCostpayLogId   	(originalPF.getPayFeeLogId());
                cost.setCostpayCostbookId   	(0);
                cost.setCostpayCostCheckId   	(0);
                cost.setCostpayStudentAccountId(saId);

                CostpayMgr cpm=new CostpayMgr(tran_id);
                int costpayId=cpm.createWithIdReturned(cost);

                if(balanceFeeticket==null)  //約定帳號時 可能是空的
                {
System.out.println("####33");
                    Manager.commit(tran_id);         
                    return vResult;
                }

System.out.println("####3");
                PayFeeMgr pfm=new PayFeeMgr(tran_id);
                for(int i=0;balanceFeeticket!=null && i<balanceFeeticket.length;i++)
                {                        
 System.out.println("####3.6");    
                   if(balanceFeeticket[i] !=null)
                   {
                        int notyetPay=balanceFeeticket[i].getFeeticketTotalMoney()-balanceFeeticket[i].getFeeticketPayMoney();

                        if(notyetPay >0 && totalMoney >0)
                        {
                            int nowPay=0;
                            if(notyetPay >totalMoney)
                            {
                                nowPay=totalMoney;
                                totalMoney=0;
                            }else if(notyetPay <=totalMoney){
                                nowPay=notyetPay;
                                totalMoney=totalMoney-notyetPay;
                            }
                            //存入payFee
                            PayFee pf=new PayFee();
                            pf.setPayFeeFeenumberId   	(balanceFeeticket[i].getFeeticketFeenumberId());
                            pf.setPayFeeMoneyNumber   	(nowPay);
                            pf.setPayFeeLogDate   	(originalPF.getPayFeeLogDate());
                            pf.setPayFeeLogPayDate  (originalPF.getPayFeeLogPayDate());
                            pf.setPayFeeManPCType   	(originalPF.getPayFeeManPCType());

                            pf.setPayFeeSourceCategory  (originalPF.getPayFeeSourceCategory());
                            pf.setPayFeeSourceId(originalPF.getPayFeeSourceId());
                            pf.setPayFeeStatus   	(originalPF.getPayFeeStatus());
                            pf.setPayFeeLogId(originalPF.getPayFeeLogId()); 
                            pf.setPayFeeAccountType(bankType);  //存入的銀行帳戶
                            pf.setPayFeeAccountId(bankId); 
 System.out.println("####3.7");                                
                            int pfId=pfm.createWithIdReturned(pf);
                            pf.setId(pfId);

                            if(!balanceFeeticket(pf,balanceFeeticket[i],tran_id))  //學費沖單
                            {
  System.out.println("####3.8");                
                                try { Manager.rollback(tran_id); } catch (Exception e2) {}  
                                return null;
                            }
 System.out.println("####3.9");
                            //扣調學生帳戶的錢   
                            StudentAccount saOut=new StudentAccount();	
                            saOut.setStudentAccountStuId   	(stu.getId());
                            saOut.setStudentAccountIncomeType   	(1);  //0=income  1=cost
                            saOut.setStudentAccountRootSAId(saId);
                            saOut.setStudentAccountMoney   	(nowPay);                                    
                            saOut.setStudentAccountSourceType   	(2);  // type2 學費沖帳
                            saOut.setStudentAccountSourceId   	(pfId);
                            saOut.setStudentAccountLogId   	(ud2.getId());
                            saOut.setStudentAccountLogDate(originalPF.getPayFeeLogDate());   
                            saOut.setStudentAccountNumber("");
                            saOut.setStudentAccountPs("");
                            int saoutId=sam.createWithIdReturned(saOut);  
    System.out.println("####3.91");                                                 
                            saOut.setId(saoutId);
                            vResult.add((StudentAccount)saOut);  
 System.out.println("####4");                           
                        } 
                    
                    }        
                    if(totalMoney ==0)
                        break;       
                }
            }else{
            //沒有學生
 System.out.println("####5");                   
                //存入學生帳戶
                StudentAccountMgr sam=new StudentAccountMgr(tran_id);
                StudentAccount sa=new StudentAccount();	
                sa.setStudentAccountStuId   	(0);
                sa.setStudentAccountIncomeType   	(0);  //0=income  1=cost
                sa.setStudentAccountMoney   	(myPayMoney);

                sa.setStudentAccountSourceType   	(sourceType);  // type 4= pay ATM 
                sa.setStudentAccountSourceId   	(originalPF.getPayFeeSourceId());
                sa.setStudentAccountLogId   	(ud2.getId());
                sa.setStudentAccountLogDate(originalPF.getPayFeeLogDate());   
                sa.setStudentAccountNumber(ticketIdS);
                int saId=sam.createWithIdReturned(sa);
                sa.setId(saId);

                //存入現金帳戶
                Costpay cost=new Costpay();
                if (1==1)
                    throw new RuntimeException("obsolete! bunitId");
                cost.setCostpayDate   	(originalPF.getPayFeeLogPayDate());
                cost.setCostpaySide   	(1);
                cost.setCostpaySideID   	(0);
                cost.setCostpayFeeticketID   	(0);
                cost.setCostpayFeePayFeeID   	(0);
                cost.setCostpayNumberInOut   	(0);
                String sum="";
                int bankType=originalPF.getPayFeeAccountType();
                if(bankType==1)
                {
                    cost.setCostpayPayway   	(payway);
                    cost.setCostpayAccountType   	(1);
                    cost.setCostpayAccountId   	(originalPF.getPayFeeAccountId());
                    cost.setCostpayLogWay   	(1); 
                    sum="Error:不明帳號學費收入 人工登入<br>";
                }else if(bankType==2){

                    int bankId=originalPF.getPayFeeAccountId();
                    if(bankId==0)
                    {
                        bankId=ps.getPaySystemBankAccountId();  //找系統預設的帳號
                    }

                    cost.setCostpayPayway   	(payway);
                    cost.setCostpayAccountType   	(2);
                    cost.setCostpayAccountId   	(bankId);
                    cost.setCostpayLogWay   	(2);
                    sum="Error:不明帳號學費收入 電腦登入<br>";
                }

                cost.setCostpayLogPs   	(sum);
                cost.setCostpayCostNumber   	(0);
                cost.setCostpayIncomeNumber   	(myPayMoney);
                cost.setCostpayLogDate   	(originalPF.getPayFeeLogDate());
                cost.setCostpayLogId   	(originalPF.getPayFeeLogId());
                cost.setCostpayCostbookId   	(0);
                cost.setCostpayCostCheckId   	(0);
                cost.setCostpayStudentAccountId(saId);

                CostpayMgr cpm=new CostpayMgr(tran_id);
                int costpayId=cpm.createWithIdReturned(cost);
                
                vResult.add((StudentAccount)sa);  

            }

    System.out.println("####6");  
            Manager.commit(tran_id);         
    System.out.println("####7");           
        }catch(Exception ex){
            
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
            
            System.out.println(ex.getMessage());

            return null;
        }
        return vResult;
    }

    
   
    public boolean balanceFeeticket(PayFee pf,Feeticket ft,int tran_id)
	{
        try{

            FeeticketMgr fm=new FeeticketMgr(tran_id);
            JsfAdmin ja=JsfAdmin.getInstance();
System.out.println("#####x1");
            int payNumber=ft.getFeeticketPayMoney()+pf.getPayFeeMoneyNumber();

            if(payNumber==0)
                ft.setFeeticketStatus(1);
            else if(payNumber==ft.getFeeticketTotalMoney())
                ft.setFeeticketStatus(91);
            else if(payNumber>ft.getFeeticketTotalMoney())
                ft.setFeeticketStatus(92);
            else if(payNumber<ft.getFeeticketTotalMoney())
                ft.setFeeticketStatus(2);
            
            ft.setFeeticketPayDate(pf.getPayFeeLogPayDate());
            ft.setFeeticketPayMoney(payNumber);	
            ft.setFeeticketLock(2);
            ft.setFeeticketPrintUpdate(2);
System.out.println("#####x2");
            fm.save(ft);	
System.out.println("#####x3");            
            if(ft.getFeeticketStatus()>=90)
            {
                ClassesFeeMgr cfm=new ClassesFeeMgr(tran_id);
                ClassesFee[] cf=ja.getClassesFeeByNumber(ft.getFeeticketFeenumberId());
                
                if(cf !=null)
                {    
                    for(int i=0;i<cf.length;i++)
                    {
                        cf[i].setClassesFeeStatus   	(91);
                        cfm.save(cf[i]);       
                    }
                }      		

System.out.println("#####x4");	
                AdditionalFeeMgr afm=new AdditionalFeeMgr(tran_id);
                AdditionalFee[] af=getAdditionalFt(ft.getFeeticketFeenumberId());
            
                if(af !=null)
                {
                    for(int j=0;j<af.length;j++)
                    {
                        af[j].setAdditionalFeeActive(0);
                        afm.save(af[j]);
                    }            
                }
System.out.println("#####x5");
            }
        }catch(Exception ex){
                try { Manager.rollback(tran_id); } catch (Exception e2) {}  
        
            return false;
        }		
		return true;	
	}	


    public AdditionalFee[] getAdditionalFt(int additionalFtId)
    {
        AdditionalFeeMgr afm=AdditionalFeeMgr.getInstance();
        
        String query=" additionalFeeAddition ='"+additionalFtId+"'";
                
        Object[] objs = afm.retrieve(query,"");
                        
        if (objs==null || objs.length==0)
        {
            return null;
        }		
                
        AdditionalFee[] u =new AdditionalFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (AdditionalFee)objs[i];
        }
        
        return u;
    }
}
