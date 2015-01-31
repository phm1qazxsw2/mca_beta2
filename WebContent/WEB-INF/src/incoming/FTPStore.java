package incoming;

import jsf.*;
import java.util.*;
import java.text.*;
import java.io.*;
import com.axiom.util.DbPool;
import beans.jdbc.DbConnectionPool;
//import com.axiom.mgr.*;
import dbo.*;
import phm.ezcounting.*;

public class FTPStore
{
	private static FTPStore instance;
    
    FTPStore() {}
    
    public synchronized static FTPStore getInstance()
    {
        if (instance==null)
        {
            instance = new FTPStore();
        }
        return instance;
    }

    /*
	public PayStore insertFTPStore(String line,User ud2,PaySystem pSystem)
  	{ 
                        
  		//String exampleLine="2008010720080106JSM000097010016800001115297017111111 20680100028306";		
	 	JsfTool jt=JsfTool.getInstance();
	  	PayStore ps=new PayStore();
        JsfFee jf=JsfFee.getInstance();	 			
        int tran_id = 0;
        boolean commit = false;
	  	try{
	
            tran_id = Manager.startTransaction();  
    	 	PayStoreMgr psm=new PayStoreMgr(tran_id);
	  		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd"); 
			SimpleDateFormat sdf2=new SimpleDateFormat("yyyyMM"); 
			
	  	 	String[] token = new String[7];
	  		
	  		String dataDateString=line.substring(0,8).trim();
	  		Date dataDate=sdf.parse(dataDateString);
	  		
	  		String payDateString=line.substring(8,16).trim();
	  		Date payDate=sdf.parse(payDateString);		
	  		
	  		String feeticketIdString=line.substring(19,32).trim();		
	  		int feeticketid=Integer.parseInt(feeticketIdString);
	  		
	  		String moneyString=line.substring(32,41).trim();	
	  		int money=Integer.parseInt(moneyString);

			String endDateString=line.substring(41,45).trim();
			int payYear=Integer.parseInt(endDateString.substring(0,2))+1911;
	        String payMonthFormat=String.valueOf(payYear)+endDateString.substring(2);
	        Date payMonth=sdf2.parse(payMonthFormat);		
	   		
	   		String storeId=line.substring(45,53).trim();
	   		String accountId=line.substring(53).trim();
	   		
			ps.setPayStoreUpdateDate   	(dataDate);
			ps.setPayStorePayDate   	(payDate);
			ps.setPayStoreFeeticketId   	(feeticketid);
			ps.setPayStorePayMoney   	(money);
			ps.setPayStoreMonth   	(payMonth);
			ps.setPayStoreId   	(storeId);
			ps.setPayStoreAccountId   	(accountId);
			ps.setPayStoreSource   	(line);

			PayStore psZ=jf.getPayStoreByLine(line);
			if(psZ !=null)
			{
				ps.setPayStoreSource(line);
				ps.setPayStoreStatus(6);
				ps.setPayStoreException("重複消單");
                ps.setId(psZ.getId());
				return ps;		
			}
			
            int psId=0;
            try
            {
                ps.setPayStoreStatus(90);
                psId=psm.createWithIdReturned(ps);                    
            }
            catch (Exception e){
                ps.setPayStoreStatus(3);
                ps.setPayStoreException("Unique Key Error:"+e.getMessage());
                return ps;
            }            

            ps.setId(psId);
            
            PayFee pf=new PayFee();
            pf.setPayFeeFeenumberId   	(ps.getPayStoreFeeticketId());
            pf.setPayFeeMoneyNumber   	(ps.getPayStorePayMoney());
            pf.setPayFeeLogDate   	(new Date());
            pf.setPayFeeLogPayDate   	(payDate);
            pf.setPayFeeManPCType   	(2); 
            pf.setPayFeeSourceCategory  (3);  //便利商店繳款
            pf.setPayFeeSourceId(psId);
            pf.setPayFeeStatus   	(1);
            pf.setPayFeeLogId(ud2.getId()); 
            pf.setPayFeeAccountType(2);  //存入銀行帳戶
            pf.setPayFeeAccountId(0);    //系統預設的交易帳戶
        
            Vector vResult=jf.balanceFeeticketByFeeNumber(pf,feeticketIdString,pSystem,ud2,3,tran_id);
            	
            if(vResult ==null)
            {
                ps.setPayStoreStatus(4);
            }    
            commit = true;
			return ps;
		}
		catch(Exception e)
		{
			ps.setPayStoreSource(line);
			ps.setPayStoreStatus(5);
			ps.setPayStoreException(e.getMessage());
			return ps;	
	    }
        finally {
            if (!commit)
    			try { Manager.rollback(tran_id); } catch (Exception e2) {}  
        }
	} 
    */


	public static void main(String[] args) {
        
        try 
        {
            DataSource.setup("datasource");
            File f = new File("tmp/teststore.txt");
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(f)));
            String line;
            EzCountingService ezsvc = EzCountingService.getInstance();
            ArrayList<MembrInfoBillRecord> paid = new ArrayList<MembrInfoBillRecord>();
//            while ((line=br.readLine())!=null)
//                ezsvc.doStoreBalance(line, paid);
 
            /*
			DbConnectionPool pool = 
        	    new DbConnectionPool(args[0], args[1], args[2], args[3]);
            
            DbPool.setDbPool(pool);
        
			FTPStore fs=FTPStore.getInstance();
			
			String exampleLine="2008011220080111JSM00009704000480000115009701TFM     20680100028306";		
			
            JsfTool jt=JsfTool.getInstance();
            JsfPay jp=JsfPay.getInstance();
			PaySystemMgr em=PaySystemMgr.getInstance();
			PaySystem pSystem=(PaySystem)em.find(1);

			jsf.UserMgr um=jsf.UserMgr.getInstance();
			jsf.User u=(User)um.find(1);	
			
			PayStore ps=fs.insertFTPStore(exampleLine.trim(),u,pSystem);

            //send SMS
            if(ps.getPayStoreStatus()==90)
            {
                PayFee[] pf=jt.getPayFeeByCategoryAndIdes(3,ps.getId());			
                if(pf !=null)
                    jp.sendMultiPayFeeMessage(pf,pSystem);
            }
            */
	    }catch (Exception e) {
            e.printStackTrace();
        } 
	}
}