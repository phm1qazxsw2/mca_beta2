package incoming;

import java.util.*;
import jsf.*;
import java.text.*;
import java.io.*;
import com.axiom.util.DbPool;
import beans.jdbc.DbConnectionPool;
import com.axiom.mgr.*;
import dbo.*;
import phm.ezcounting.*;

public class FTPATM
{
	private static FTPATM instance;
    
    FTPATM() {}
    
    public synchronized static FTPATM getInstance()
    {
        if (instance==null)
        {
            instance = new FTPATM();
        }
        return instance;
    }

    /*
	public PayAtm insertFTPATM(String line,User ud2,PaySystem ps) 
	{
        JsfFee jf=JsfFee.getInstance();
		PayAtm pa = null;
		JsfTool jt=JsfTool.getInstance();	      	
		boolean commit = false;
        int tran_id = 0;	
		//String exampleLine="00002068010002830620080108000003A082832ATM  67770      +C9548197010015900          013                    101937            W";		
		try{ 

            tran_id = Manager.startTransaction();  
            PayAtmMgr pam = new PayAtmMgr(tran_id);
            pa = new PayAtm(); 

			if(line.length()<30)
			{
				pa.setPayAtmSource(line);
				pa.setPayAtmStatus(2);
				pa.setPayAtmException("字串間隔長度有誤(6tab)");				
				return pa;
			}
             			
 			SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");

			String payDateString=line.substring(18,26);  
			Date payDate=sdf.parse(payDateString); 
			String payAtmNumberString=line.substring(26,32);
			int payAtmNumber=Integer.parseInt(payAtmNumberString);
			
			String payMoneyString=line.substring(43,55).trim();	
			int payMoney=Integer.parseInt(payMoneyString)/10;
			
			String accountFirst5=line.substring(57,62).trim();	
			
			int defaulAccountLength=9;
			
			if(ps.getPaySystemFixATMAccount()!=null && ps.getPaySystemFixATMAccount().length()>0) 
				defaulAccountLength=ps.getPaySystemFixATMAccount().length()+ps.getPaySystemFixATMNum();
		
			int endAccountPosition=62+defaulAccountLength;	
			String accountFeenumber=line.substring(62,endAccountPosition).trim();			
			int feenumberId=Integer.parseInt(accountFeenumber);
	    	
        	String payWay=line.substring(39,43).trim();	
        	String bankId=line.substring(83,86).trim();	

			pa.setPayAtmNumber   	(payAtmNumber);
            pa.setPayAtmNumberUnique   	(payAtmNumber);
			pa.setPayAtmPayDate   	(payDate);
			pa.setPayAtmPayMoney   	(payMoney);
			pa.setPayAtmAccountFirst5   	(accountFirst5);
			pa.setPayAtmFeeticketId   	(feenumberId);
			pa.setPayAtmWay   	(payWay);
			pa.setPayAtmBankId   	(bankId);
			pa.setPayAtmSource   	(line);

			PayAtm paS=jf.getPayAtmRepeat(payAtmNumber,payDate);
	        if(paS !=null)
	        {
	        	pa.setPayAtmSource(line);
				pa.setPayAtmStatus(1);
				pa.setPayAtmException("重覆消單");
				pa.setId(paS.getId());
				return pa;
	        }
 
            int psId=0;

            try{
                psId=pam.createWithIdReturned(pa);	
	      	}
            catch(Exception ex){      
                ex.printStackTrace();
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

            Vector vResult=jf.balanceFeeticketByFeeNumber(pf,String.valueOf(feenumberId),ps,ud2,3,tran_id);
	        
            if(vResult==null)
            {
                pa.setPayAtmStatus(4);
            } 
            commit = true;
	       	return pa;      
		}
        catch(Exception e){
            e.printStackTrace();
        	pa.setPayAtmSource(line);
			pa.setPayAtmStatus(5);
			pa.setPayAtmException(e.getMessage());
			return pa;	
		}
        finally {
            if (!commit) {
    			try { Manager.rollback(tran_id); } catch (Exception e2) {}
            }
        }
	}
    */

	public static void main(String[] args) {
        
        try 
        {
            DataSource.setup("datasource");
            File f = new File("tmp/testftp.txt");
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(f)));
            String line;
            EzCountingService ezsvc = EzCountingService.getInstance();
            ArrayList<MembrInfoBillRecord> paid = new ArrayList<MembrInfoBillRecord>();
            while ((line=br.readLine())!=null)
                ; //ezsvc.doATMBalance(line, paid);
            /*
			DbConnectionPool pool = 
        	    new DbConnectionPool(args[0], args[1], args[2], args[3]);
            
            DbPool.setDbPool(pool);
        
			FTPATM fa=FTPATM.getInstance();
			                
			String exampleLine="00002068010002830620080312000009A183419ATM 95000       +C9548197030017100          009                    691883            W";		
			
            JsfTool jt=JsfTool.getInstance();
            JsfPay jp=JsfPay.getInstance();
			PaySystemMgr em=PaySystemMgr.getInstance();
			PaySystem pSystem=(PaySystem)em.find(1);

			jsf.UserMgr um=jsf.UserMgr.getInstance();
			jsf.User u=(jsf.User)um.find(1);	
			
			PayAtm pa=fa.insertFTPATM(exampleLine,u,pSystem);
            if(pa.getPayAtmStatus()==90)
            {			
                PayFee[] pf=jt.getPayFeeByCategoryOnlyATM(pa.getId());
                if(pf !=null)
                    jp.sendMultiPayFeeMessage(pf,pSystem);
	        }
            */

	    }catch (Exception e) {
            e.printStackTrace();
        }
	}
}