package jsf;

import java.util.*;
import java.text.*;
import com.axiom.mgr.*;

public class SalaryAdmin
{
    private static SalaryAdmin instance;
    
    SalaryAdmin() {}
    
    public synchronized static SalaryAdmin getInstance()
    {
        if (instance==null)
        {
            instance = new SalaryAdmin();
        }
        return instance;
    }

    
    
    public boolean addSalaryFee(Date rundate,SalaryType type,Teacher tea,int meneyNumber,User ud2)
    {

        SalaryTicket st=getSalaryTicketByDateAndTeaId(rundate,tea.getId());
    	int tran_id = 0;
    	try{

            tran_id = Manager.startTransaction();                		
        
            SalaryFeeMgr sfm=new SalaryFeeMgr(tran_id);
    		SalaryTicketMgr stm=new SalaryTicketMgr(tran_id);
            
    		String ticketNumber="";
    		int thisType=type.getSalaryType();
    		if(st==null)
    		{
				ticketNumber=generateSanumber(rundate);
				SalaryFee af=new SalaryFee();
				af.setSalaryFeeSanumberId   	(Integer.parseInt(ticketNumber));
				af.setSalaryFeeMonth   	(rundate);
				af.setSalaryFeeTeacherId   	(tea.getId());
				af.setSalaryFeeDeportId   	(tea.getTeacherDepart());
				af.setSalaryFeePositionId   	(tea.getTeacherPosition());
				af.setSalaryFeeClassesId   	(tea.getTeacherClasses());
				af.setSalaryFeeType   	(thisType);
				af.setSalaryFeeTypeId   	(type.getId());
				af.setSalaryFeeNumber   	(meneyNumber);
				af.setSalaryFeePrintNeed   	(0);
				af.setSalaryFeeLogId   	(ud2.getId());
				//af.setSalaryFeeLogPs   	(String salaryFeeLogPs);
				//af.setSalaryFeeVNeed   	(String salaryFeeVNeed);
				//af.setSalaryFeeVUserId   	(String salaryFeeVUserId);
				//af.setSalaryFeeVDate   	(Date salaryFeeVDate);
				//af.setSalaryFeeVPs   	(String salaryFeeVPs);
				af.setSalaryFeeStatus   	(1);
				
				sfm.createWithIdReturned(af);
    		
				st=new SalaryTicket();
				st.setSalaryTicketMonth   	(rundate);
				st.setSalaryTicketSanumberId   	(Integer.parseInt(ticketNumber));
				st.setSalaryTicketTeacherId   	(tea.getId());
				st.setSalaryTicketDepartId   	(tea.getTeacherDepart());
				st.setSalaryTicketPositionId   	(tea.getTeacherPosition());
				st.setSalaryTicketClassesId   	(tea.getTeacherClasses());
				st.setSalaryTicketTeacherParttime(tea.getTeacherParttime());
			
				if(thisType==1)
				{
					st.setSalaryTicketMoneyType1   	(meneyNumber);
					st.setSalaryTicketMoneyType2   	(0);
					st.setSalaryTicketMoneyType3   	(0);
					st.setSalaryTicketTotalMoney   	(meneyNumber);		
				}else if(thisType==2){
					st.setSalaryTicketMoneyType1   	(0);
					st.setSalaryTicketMoneyType2   	(meneyNumber);
					st.setSalaryTicketMoneyType3   	(0);
					st.setSalaryTicketTotalMoney   	(-meneyNumber);		
				}else if(thisType==3){
					st.setSalaryTicketMoneyType1   	(0);
					st.setSalaryTicketMoneyType2   	(0);
					st.setSalaryTicketMoneyType3   	(meneyNumber);
					st.setSalaryTicketTotalMoney   	(-meneyNumber);		
				}else if(thisType==4){
					st.setSalaryTicketMoneyType1   	(meneyNumber);
					st.setSalaryTicketMoneyType2   	(0);
					st.setSalaryTicketMoneyType3   	(0);
					st.setSalaryTicketTotalMoney   	(meneyNumber);		
					
				}else if(thisType==5){
					st.setSalaryTicketMoneyType1   	(meneyNumber);
					st.setSalaryTicketMoneyType2   	(0);
					st.setSalaryTicketMoneyType3   	(0);
					st.setSalaryTicketTotalMoney   	(meneyNumber);		
				}
				
				st.setSalaryTicketPayMoney   	(0);
				//st.setSalaryTicketPayDate   	(Date salaryTicketPayDate);
				st.setSalaryTicketStatus   	(1);
				st.setSalaryFeePrintNeed   	(0);
				//st.setSalaryTicketPs   	(String salar);
				st.setSalaryTicketNewFeenumber(0);   	
				stm.createWithIdReturned(st);
			    
    		}else{
    			SalaryFee af=new SalaryFee();
				af.setSalaryFeeSanumberId   	(st.getSalaryTicketSanumberId());
				af.setSalaryFeeMonth   	(rundate);
				af.setSalaryFeeTeacherId   	(tea.getId());
				af.setSalaryFeeDeportId   	(tea.getTeacherDepart());
				af.setSalaryFeePositionId   	(tea.getTeacherPosition());
				af.setSalaryFeeClassesId   	(tea.getTeacherClasses());
				af.setSalaryFeeType   	(thisType);
				af.setSalaryFeeTypeId   	(type.getId());
				af.setSalaryFeeNumber   	(meneyNumber);
				af.setSalaryFeePrintNeed   	(0);
				af.setSalaryFeeLogId   	(ud2.getId());
				//af.setSalaryFeeLogPs   	(String salaryFeeLogPs);
				//af.setSalaryFeeVNeed   	(String salaryFeeVNeed);
				//af.setSalaryFeeVUserId   	(String salaryFeeVUserId);
				//af.setSalaryFeeVDate   	(Date salaryFeeVDate);
				//af.setSalaryFeeVPs   	(String salaryFeeVPs);
				af.setSalaryFeeStatus   	(1);
				sfm.createWithIdReturned(af);


				int type1Number=st.getSalaryTicketMoneyType1();
				int type2Number=st.getSalaryTicketMoneyType2();
				int type3Number=st.getSalaryTicketMoneyType3();
				int totalNumber=st.getSalaryTicketTotalMoney();
				if(thisType==1)
				{
					st.setSalaryTicketMoneyType1   	(type1Number+meneyNumber);
					st.setSalaryTicketTotalMoney   	(totalNumber+meneyNumber);		
				}else if(thisType==2){
					st.setSalaryTicketMoneyType2   	(type2Number+meneyNumber);
					st.setSalaryTicketTotalMoney   	((totalNumber-meneyNumber));		
				}else if(thisType==3){
					st.setSalaryTicketMoneyType3   	(type3Number+meneyNumber);
					st.setSalaryTicketTotalMoney   	((totalNumber-meneyNumber));		
				}else if(thisType==4){
					st.setSalaryTicketMoneyType1   	(type1Number+meneyNumber);
					st.setSalaryTicketTotalMoney   	(totalNumber+meneyNumber);		
				}else if(thisType==5){
					st.setSalaryTicketMoneyType1   	(type1Number+meneyNumber);
					st.setSalaryTicketTotalMoney   	(totalNumber+meneyNumber);		
				}
				
				if(st.getSalaryTicketPayMoney()==0)
					st.setSalaryTicketStatus (2);
				else if(st.getSalaryTicketPayMoney()==st.getSalaryTicketTotalMoney())
					st.setSalaryTicketStatus (90);
				else if(st.getSalaryTicketPayMoney()<st.getSalaryTicketTotalMoney())	
					st.setSalaryTicketStatus (3);
				else if(st.getSalaryTicketPayMoney()>st.getSalaryTicketTotalMoney())			
					st.setSalaryTicketStatus (91);
				stm.save(st);    		
    		}

            Manager.commit(tran_id);
            return true;
    	
		}catch(Exception e){

            try { Manager.rollback(tran_id); } catch (Exception e2) {}
			return false;	
		}	
    }
    
    
    public SalaryBank[] getSalaryBankBySanunmber(SalaryTicket st)
    {
    	
    	SalaryBankMgr bigr = SalaryBankMgr.getInstance();
        
        Object[] objs = bigr.retrieve("salaryBankSanumber="+st.getSalaryTicketSanumberId(), null);
        
        if (objs==null || objs.length==0)
            return null;
        
        SalaryBank[] u = new SalaryBank[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryBank)objs[i];
        }
        return u;
    }
    
    
    public boolean doSalarypaySuccess(SalaryOut so)
    {
		SalaryOutMgr som=SalaryOutMgr.getInstance();
    	som.save(so);
		
		BankAccountMgr bam=BankAccountMgr.getInstance();
		BankAccount ba=(BankAccount)bam.find(so.getSalaryOutBankAccountId());
		
			
		int banknumber=so.getSalaryOutBanknumber();
		SalaryBank[] sb=getAllSalaryBankByBankNum(banknumber);
		
		if(sb ==null)
		{
			return false;	
		}
 
		int payTotal=0;
 
		SalaryTicket[] st=new SalaryTicket[sb.length];
		
		TeacherMgr tm=TeacherMgr.getInstance();
		SalaryBankMgr sbm=SalaryBankMgr.getInstance();
		
		for(int i=0;i<sb.length;i++)
		{
			st[i]=getSalaryTicketBySanumber(sb[i].getSalaryBankSanumber());
			int ticketPay=st[i].getSalaryTicketTotalMoney()-st[i].getSalaryTicketPayMoney();
			
			Teacher tea=(Teacher)tm.find(sb[i].getSalaryBankTeacherId());		


			sb[i].setSalaryBankMonth   	(so.getSalaryOutMonth());
			sb[i].setSalaryBankDeportId   	(tea.getTeacherDepart());
			sb[i].setSalaryBankPositionId   	(tea.getTeacherPosition());
			sb[i].setSalaryBankClassesId   	(tea.getTeacherClasses());
			sb[i].setSalaryBankMoney   	(ticketPay);
			sb[i].setSalaryBankBankNumberId   	(so.getSalaryOutBanknumber());
			sb[i].setSalaryBankStatus   	(90);
			sb[i].setSalaryBankPayDate   	(so.getSalaryOutPayDate());
			sb[i].setSalaryBankPayWay(3);
			sb[i].setSalaryBankPayAccountType (2);  //from bank
			sb[i].setSalaryBankPayAccountId   	(ba.getId());
			
			if(tea.getTeacherAccountDefaut()==1)
			{
				sb[i].setSalaryBankToId (Integer.parseInt(tea.getTeacherBank1()));
				sb[i].setSalaryBankToAccount(tea.getTeacherAccountNumber1());  		
			}else{
				sb[i].setSalaryBankToId (Integer.parseInt(tea.getTeacherBank2()));
				sb[i].setSalaryBankToAccount(tea.getTeacherAccountNumber2());  		
			}

			sb[i].setSalaryBankLogId   	(so.getSalaryOutPayUser());
		    sb[i].setSalaryBankLogPs   	(so.getSalaryOutPayPs());
		    sb[i].setSalaryBankVerifyStatus   	(0);
			sbm.save(sb[i]);
						
			balanceCostpay(sb[i],st[i],false);			
		}
		
		return true;
    }
    
    public boolean balanceCostpay(SalaryBank sb,SalaryTicket st,boolean sbCreate)
    {
        int tran_id = 0;
        
        try{
            tran_id = Manager.startTransaction();            
            SalaryBankMgr sbm=new SalaryBankMgr(tran_id);
            SalaryTicketMgr stm=new SalaryTicketMgr(tran_id);
            CostpayMgr cm=new CostpayMgr(tran_id);
            
            if(sbCreate)
            {
                int sbId=sbm.createWithIdReturned(sb);
                sb.setId(sbId);
            }

            int total=st.getSalaryTicketTotalMoney();
            int paymoney=st.getSalaryTicketPayMoney();
            int paytime=st.getSalaryTicketPayTimes();
            
            int sbPay=sb.getSalaryBankMoney();
            
            paymoney+=sbPay;
            paytime+=1;
            st.setSalaryTicketPayDate(sb.getSalaryBankPayDate());
            st.setSalaryTicketPayMoney(paymoney);
            st.setSalaryTicketPayTimes(paytime);
            
            if(paymoney==total)
                st.setSalaryTicketStatus(90);
            else if(paymoney >total)
                st.setSalaryTicketStatus(91);
            else if(paymoney <total)	
                st.setSalaryTicketStatus(3);
        
            stm.save(st);
            Costpay cp=new Costpay();	
            if (1==1)
                throw new RuntimeException("obsolete!");
            cp.setCostpayDate   	(sb.getSalaryBankPayDate());
            cp.setCostpaySide   	(1);
            cp.setCostpaySideID   	(0);
            cp.setCostpayFeeticketID   	(0);
            cp.setCostpayFeePayFeeID   	(0);
            cp.setCostpayOwnertradeStatus   	(0);
            cp.setCostpayOwnertradeId   	(0);
            cp.setCostpaySalaryBankId(sb.getId());
            cp.setCostpayNumberInOut   	(1);
            cp.setCostpayPayway   	(sb.getSalaryBankPayWay());
            cp.setCostpayAccountType   	(sb.getSalaryBankPayAccountType());
            cp.setCostpayAccountId   	(sb.getSalaryBankPayAccountId());
            cp.setCostpayCostNumber   	(sb.getSalaryBankMoney());
            cp.setCostpayIncomeNumber   	(0);
            cp.setCostpayLogWay   	(1);
            cp.setCostpayLogDate   	(new Date());
            cp.setCostpayLogId   	(sb.getSalaryBankLogId());
            cp.setCostpayLogPs   	(sb.getSalaryBankLogPs());
            
            cp.setCostpaySalaryTicketId(st.getId());
            cm.createWithIdReturned(cp);
            

        	Manager.commit(tran_id);
            return true;	
        }catch(Exception e){

            try { Manager.rollback(tran_id); } catch (Exception e2) {}
            return false;
        }
    }
	
	public boolean balanceSalaryTicket1(SalaryBank sb,SalaryTicket st)
	{
		int total=st.getSalaryTicketTotalMoney();
		int paymoney=st.getSalaryTicketPayMoney();
		int paytime=st.getSalaryTicketPayTimes();
		
		int sbPay=sb.getSalaryBankMoney();
		
		paymoney+=sbPay;
		paytime+=1;
		
		SalaryTicketMgr stm=SalaryTicketMgr.getInstance();
		st.setSalaryTicketPayDate(sb.getSalaryBankPayDate());
		st.setSalaryTicketPayMoney(paymoney);
		st.setSalaryTicketPayTimes(paytime);
		
		if(paymoney==total)
			st.setSalaryTicketStatus(90);
		else if(paymoney >total)
			st.setSalaryTicketStatus(91);
		else if(paymoney <total)	
			st.setSalaryTicketStatus(3);
	
		stm.save(st);
		
		return true;		
	}
	
	public boolean balanceSalaryTicket2(SalaryBank sb)
	{
		SalaryTicket st=getSalaryTicketBySanumber(sb.getSalaryBankSanumber());
		
		balanceSalaryTicket1(sb,st);
		
		return true;
	}
	public String doBankout(SalaryOut so)
	{
		
		BankAccountMgr bam=BankAccountMgr.getInstance();
		BankAccount ba=(BankAccount)bam.find(so.getSalaryOutBankAccountId());
		
		int banknumber=so.getSalaryOutBanknumber();
		
		SalaryAdmin sa=SalaryAdmin.getInstance();
		SalaryBank[] sb=sa.getAllSalaryBankByBankNum(banknumber);
		
		if(sb ==null)
		{
			//out.println("尚未加入名單");
			return "1xxx尚未加入名單";	
		}
		 
		int payTotal=0;
		 
		SalaryTicket[] st=new SalaryTicket[sb.length];
		for(int i=0;i<sb.length;i++)
		{
			st[i]=sa.getSalaryTicketBySanumber(sb[i].getSalaryBankSanumber());
		 
			int ticketPay=st[i].getSalaryTicketTotalMoney()-st[i].getSalaryTicketPayMoney();
			 
			payTotal+=ticketPay ;
		}
		 
		
		StringBuffer sbuffer=new StringBuffer();
		//first line 
		
		if(ba.getBankAccount2client().length() !=4)
		{ 
			//out.println("台新企業代碼應為4碼");
			//out.println("<br><br>目前企業代碼為:"+ba.getBankAccount2client()); 
			return "1xxx台新企業代碼應為4碼<br><br>目前企業代碼為:"+ba.getBankAccount2client();		 
		}
		sbuffer.append(ba.getBankAccount2client());
		   //4 bytes 企業編號
		String account=String.valueOf(ba.getBankAccountAccount());	 
		 
		
		if(account.length()!=14)
		{ 
			//out.println("台新銀行帳戶應為14碼"); 
			//out.println("<br><br>目前台新銀行帳戶為:"+ba.getBankAccountAccount()); 
			return "1xxx台新銀行帳戶應為14碼<br><br>目前台新銀行帳戶為:"+ba.getBankAccountAccount();		 
		} 
		sbuffer.append(ba.getBankAccountAccount());  //14 bytes 台新銀行帳戶 
		
		Date payMonth=so.getSalaryOutMonth();
		
		SimpleDateFormat sdfAA=new SimpleDateFormat("yyyy-MM");
		
		int yearInt=payMonth.getYear() +1900-1911;
		int intMonth= payMonth.getMonth()+2;
		if(intMonth==13)
		{
			intMonth=1;
			yearInt++;		
		}
		
		String year="";
		if(yearInt >=100)
		 
			year="0"+String.valueOf(yearInt); 
		else
			year="00"+String.valueOf(yearInt); 
		
		sbuffer.append(year);
		
		String month="";
		if(intMonth >=10)
		  	month=String.valueOf(intMonth);
		else
			month="0"+String.valueOf(intMonth);	
		
		
		sbuffer.append(month);
		
		
		String dateString=ba.getBankAccountPayDate();
		
		if(dateString.length() <2)
		 
			dateString="0"+	dateString ;
			
		sbuffer.append(dateString);
		
		sbuffer.append("900");
		
		
		String total=String.valueOf(payTotal)+"00";
		  
		int totalLenth=13-total.length();
		
		for(int k=0;k<totalLenth;k++)
			total="0"+ total;
			
		sbuffer.append(total);
		
		
		String totalNum=String.valueOf(sb.length);
		int needNum=7-totalNum.length(); 
		
		for(int l=0;l<needNum;l++)
		 
			totalNum="0"+totalNum;
		
		sbuffer.append(totalNum);
		 
		
		String returnSpace="";
		for(int p=0;p<22;p++)
		 
			returnSpace+=" ";	
			
		returnSpace+="0\n";
		 
		sbuffer.append(returnSpace);
		
		TeacherMgr tm=TeacherMgr.getInstance();   
		for(int j=0;j<sb.length;j++)
		{
		  	int ticketPay=st[j].getSalaryTicketTotalMoney()-st[j].getSalaryTicketPayMoney();
		    	
		  	sbuffer.append(ba.getBankAccount2client());
		 	
		 	int teacherid=st[j].getSalaryTicketTeacherId();
		 	Teacher tea=(Teacher)tm.find(teacherid);
		 
		 	int aDefault=tea.getTeacherAccountDefaut();
		  	String accoutnNum="";
		  		
			if(aDefault==1)	
		  		accoutnNum=tea.getTeacherAccountNumber1 ();
		  	else
		  		accoutnNum=tea.getTeacherAccountNumber2 ();		
		  	
		  	int aLen=14-accoutnNum.length();
		  	
		  	String ox="";
		  	if(aLen!=0)	
		  	{	
		   		for(int s=0;s<aLen;s++)
		 
		   				ox +="0";
		  	}		
		  	sbuffer.append(ox);	
		  	sbuffer.append(accoutnNum);	
		  	String idNumber=tea.getTeacherIdNumber().toUpperCase(); 
			
			sbuffer.append(idNumber);	
			
			String totalPay =String.valueOf(ticketPay)+"00";
			
			int payLen=13-totalPay.length();
			
			for(int payI=0;payI<payLen;payI++)
		  	{
		  			totalPay="0"+totalPay ;
		  	}	
			sbuffer.append(totalPay);			
		
			sbuffer.append("900");	
			
			String blankString="";
			for(int bI=0;bI<4;bI++)
		 
			{
				blankString+=" ";	
			}
			
			String outPs="Jain Sheng "+sdfAA.format(payMonth);

			sbuffer.append(blankString);	
			
			int blankStirngLength=23-outPs.length();
			
			String blankString2="";
			for(int Xb=0;Xb<blankStirngLength;Xb++)
			{
				blankString2+=" ";	
			}					
			sbuffer.append(outPs);	
			sbuffer.append(blankString2);			
			
			sbuffer.append("0");	
			sbuffer.append("\n"); 
		} 

		return sbuffer.toString();
	}
    
    public SalaryTicket getSalaryTicketByDateAndTeaId(Date xdate,int teaId)
    {
    	SalaryTicketMgr bigr = SalaryTicketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query="salaryTicketMonth ='"+df.format(xdate)+"/01' and salaryTicketTeacherId="+teaId;
	       
		Object[] objs = bigr.retrieve(query, "");
	        
        if (objs==null || objs.length==0)
	 	{	
            	return null;
        }
        
        return (SalaryTicket)objs[0];
    }
    
    public SalaryTicket[] getSalaryTicketByTeaId(int teaId)
    {
    	SalaryTicketMgr bigr = SalaryTicketMgr.getInstance();
        
		String query="salaryTicketTeacherId="+teaId;
	       
		Object[] objs = bigr.retrieve(query, "");
	        
        if (objs==null || objs.length==0)
	 	{	
            	return null;
        }
        
        SalaryTicket[] u = new SalaryTicket[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryTicket)objs[i];
        }
        
        return u;
    }
    
    public BankAccount[] getAllBankAccount(String space)
    {
    	BankAccountMgr bigr = BankAccountMgr.getInstance();
        
        Object[] objs = bigr.retrieveX("", null, space);
        
        if (objs==null || objs.length==0)
            return null;
        
        BankAccount[] u = new BankAccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BankAccount)objs[i];
        }
        
        return u;
    }
    
    public BankAccount[] getATMBankAccount()
    {
    	BankAccountMgr bigr = BankAccountMgr.getInstance();
        
        Object[] objs = bigr.retrieve("bankAccountATMActive='1'","");
        
        if (objs==null || objs.length==0)
            return null;
        
        BankAccount[] u = new BankAccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BankAccount)objs[i];
        }
        
        return u;
    }
    
    public BankAccount[] getActiveBankAccount()
    {
    	BankAccountMgr bigr = BankAccountMgr.getInstance();
        
        Object[] objs = bigr.retrieve("bankAccountActive=1", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        BankAccount[] u = new BankAccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BankAccount)objs[i];
        }
        
        return u;
    }
    public SalaryType[] getSalaryTypeByType(int type)
    {
    	SalaryTypeMgr bigr = SalaryTypeMgr.getInstance();
        
        Object[] objs = bigr.retrieve("salaryType="+type," order by id");
        
        if (objs==null || objs.length==0)
            return null;
        
        SalaryType[] u = new SalaryType[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryType)objs[i];
        }
        
        return u;
    } 
    
    public SalaryType[] getAllSalaryType()
    {
    	SalaryTypeMgr bigr = SalaryTypeMgr.getInstance();
        
        Object[] objs = bigr.retrieve("","order by salaryType asc");
        
        if (objs==null || objs.length==0)
            return null;
        
        SalaryType[] u = new SalaryType[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryType)objs[i];
        }
        
        return u;
    }

    

    public SalaryType[] getSalaryTypeByTypeFixNumber(int type,int fixed)
    {
    	SalaryTypeMgr bigr = SalaryTypeMgr.getInstance();
        
        
        String query=" salaryTypeFixNumber='"+fixed+"'";
        
        if(type !=999)
        	query +=" and salaryType='"+type+"'";
        
        
        Object[] objs = bigr.retrieve(query," order by id");
        
        if (objs==null || objs.length==0)
            return null;
        
        SalaryType[] u = new SalaryType[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryType)objs[i];
        }
        
        return u;
    }
    public SalaryNumber[] getSalaryNumberByTypeId(int type)
    {
    	SalaryNumberMgr bigr = SalaryNumberMgr.getInstance();
        
        Object[] objs = bigr.retrieve("salaryNumberTypeId="+type, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        SalaryNumber[] u = new SalaryNumber[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryNumber)objs[i];
        }
        
        return u;
    }
    
    public SalaryNumber getSalaryNumberByTeacherId(int type,int teaId)
    {
    	SalaryNumberMgr bigr = SalaryNumberMgr.getInstance();
        
        Object[] objs = bigr.retrieve("salaryNumberTypeId='"+type+"' and salaryNumberTeacherId='"+teaId+"'", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        SalaryNumber u =(SalaryNumber)objs[0];
        
        return u;
    }
    public Teacher[] getTeacherByPositionClasses(int poId,int claId)
    {
    	TeacherMgr bigr = TeacherMgr.getInstance();
        String query="teacherStatus !=0 and teacherStatus !=3";
        
        if(poId!=999)
        {
        	query +=" and teacherPosition ="+poId;
        }
        
        if(claId !=999)
        		query +=" and teacherClasses="+claId;
    
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Teacher[] u = new Teacher[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Teacher)objs[i];
        }
        
        return u;
    }
    
    
    public SalaryTicket getSalaryTicketBySanumber(int numberId){
	
	    SalaryTicketMgr fng = SalaryTicketMgr.getInstance();

        String query=" salaryTicketSanumberId ="+numberId;
    	 
        String orderString="";
       
        Object[] objs = fng.retrieve(query,orderString);

        if (objs==null || objs.length==0)
            return null;
        
        SalaryTicket u= (SalaryTicket)objs[0];
       
        return u;
    	
    }
    
    public SalaryOut[] getAllSalaryOutByDate(Date runDate){
	
	SalaryOutMgr fng = SalaryOutMgr.getInstance();

	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	String query="salaryOutMonth ='"+df.format(runDate)+"/01'";

        String orderString=" order by salaryOutMonth asc";
       
        Object[] objs = fng.retrieve(query,orderString);

        if (objs==null || objs.length==0)
            return null;
        
        SalaryOut[] u = new SalaryOut[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryOut)objs[i];
        }
       
       return u;
    	
    }
   

   
   public boolean changeSalaryFee(SalaryFee sf,SalaryType st,SalaryTicket sTicket,User ud2,int money)
   {

        int tran_id = 0;
        try{

        	tran_id = Manager.startTransaction();                                

            SalaryFeeMgr sfm=new SalaryFeeMgr(tran_id);
            SalaryTicketMgr stm=new SalaryTicketMgr(tran_id);
            int thisType=st.getSalaryType();
            int originalNum=sf.getSalaryFeeNumber();
            
            sf.setSalaryFeeNumber   	(money);
            sf.setSalaryFeeLogId   	(ud2.getId());
            //af.setSalaryFeeLogPs   	(String salaryFeeLogPs);
            //af.setSalaryFeeVNeed   	(String salaryFeeVNeed);
            //af.setSalaryFeeVUserId   	(String salaryFeeVUserId);
            //af.setSalaryFeeVDate   	(Date salaryFeeVDate);
            //af.setSalaryFeeVPs   	(String salaryFeeVPs);
            sf.setSalaryFeeStatus   	(1);
            sfm.save(sf);
            
            if(thisType==1)
            {
                int oType1=sTicket.getSalaryTicketMoneyType1();
                int type1Total=oType1-originalNum+money;
            
                int allTotal=sTicket.getSalaryTicketTotalMoney()-originalNum+money;
                
                sTicket.setSalaryTicketMoneyType1(type1Total);		
                sTicket.setSalaryTicketTotalMoney   	(allTotal);		
            }else if(thisType==2){
                
                int oType2=sTicket.getSalaryTicketMoneyType2();
                
                int type2Total=oType2-originalNum+money;
                int allTotal=sTicket.getSalaryTicketTotalMoney()+originalNum-money;
                
                sTicket.setSalaryTicketMoneyType2   	(type2Total);			
                sTicket.setSalaryTicketTotalMoney   	(allTotal);		
            }else if(thisType==3){
                int oType3=sTicket.getSalaryTicketMoneyType3();
                
                int type3Total=oType3-originalNum+money;
                int allTotal=sTicket.getSalaryTicketTotalMoney()+originalNum-money;
                
                sTicket.setSalaryTicketMoneyType3   	(type3Total);
                sTicket.setSalaryTicketTotalMoney   	(allTotal);		
            }else if(thisType==4){
                int oType1=sTicket.getSalaryTicketMoneyType1();
                int type1Total=oType1-originalNum+money;
            
                int allTotal=sTicket.getSalaryTicketTotalMoney()-originalNum+money;
                
                sTicket.setSalaryTicketMoneyType1(type1Total);		
                sTicket.setSalaryTicketTotalMoney   	(allTotal);		
                
            }else if(thisType==5){
                int oType1=sTicket.getSalaryTicketMoneyType1();
                int type1Total=oType1-originalNum+money;
            
                int allTotal=sTicket.getSalaryTicketTotalMoney()-originalNum+money;
                
                sTicket.setSalaryTicketMoneyType1(type1Total);		
                sTicket.setSalaryTicketTotalMoney   	(allTotal);		
                
            }
            
            if(sTicket.getSalaryTicketPayMoney()==0)
                sTicket.setSalaryTicketStatus (2);
            else if(sTicket.getSalaryTicketPayMoney()==sTicket.getSalaryTicketTotalMoney())
                sTicket.setSalaryTicketStatus (90);
            else if(sTicket.getSalaryTicketPayMoney()<sTicket.getSalaryTicketTotalMoney())	
                sTicket.setSalaryTicketStatus (3);
            else if(sTicket.getSalaryTicketPayMoney()>sTicket.getSalaryTicketTotalMoney())			
                sTicket.setSalaryTicketStatus (91);
            
            stm.save(sTicket);
            Manager.commit(tran_id);
            return true; 		
        
        }catch(Exception e){
	        try { Manager.rollback(tran_id); } catch (Exception e2) {}
            return false;    
        }
   	}	
	public boolean deleteSalaryFee(SalaryFee sf,SalaryType st,SalaryTicket sTicket,User ud2)
   	{
        int tran_id = 0;
        
        try{
            tran_id = Manager.startTransaction();

            SalaryFeeMgr sfm=new SalaryFeeMgr(tran_id);
            SalaryTicketMgr stm=new SalaryTicketMgr(tran_id);
            
            int thisType=st.getSalaryType();
            int originalNum=sf.getSalaryFeeNumber();
            
            
            sfm.save(sf);
            
            int allTotal=0;
            if(thisType==1 ||thisType==4 || thisType==5)
            {
                int oType1=sTicket.getSalaryTicketMoneyType1()-originalNum;		
                allTotal=sTicket.getSalaryTicketTotalMoney()-originalNum;
                
                sTicket.setSalaryTicketMoneyType1(oType1);		
                sTicket.setSalaryTicketTotalMoney   	(allTotal);		
            }else if(thisType==2){
                
                int oType2=sTicket.getSalaryTicketMoneyType2()-originalNum;
                allTotal=sTicket.getSalaryTicketTotalMoney()+originalNum;
                
                sTicket.setSalaryTicketMoneyType2   	(oType2);			
                sTicket.setSalaryTicketTotalMoney   	(allTotal);		
            }else if(thisType==3){
                int oType3=sTicket.getSalaryTicketMoneyType3()-originalNum;
                allTotal=sTicket.getSalaryTicketTotalMoney()+originalNum;
                
                sTicket.setSalaryTicketMoneyType3   	(oType3);
                sTicket.setSalaryTicketTotalMoney   	(allTotal);		
            }
            
            sTicket.setSalaryTicketStatus   	(2);
            //st.setSalaryFeePrintNeed   	(0);
            //st.setSalaryTicketPs   	(String salar);
            //st.setSalaryTicketNewFeenumber(0);   	
            stm.save(sTicket);
            
            sfm.remove(sf.getId());
            
            if(allTotal==0)
            {
                stm.remove(sTicket.getId());
            }

            Manager.commit(tran_id);
    		return true; 		
        }catch(Exception e){
            
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
            
        }	
   		return false;
   	}	   
   
   
   
   
   	public SalaryOut getAllSalaryOutByNumber(int salaryoutNumber){
	
		SalaryOutMgr fng = SalaryOutMgr.getInstance();

		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query="salaryOutBanknumber ="+salaryoutNumber;

        String orderString=" order by salaryOutMonth asc";
       
        Object[] objs = fng.retrieve(query,orderString);

        if (objs==null || objs.length==0)
            return null;
        
        SalaryOut u = (SalaryOut)objs[0];
       
        return u;
    	
    }
    
     public SalaryTicket[] getAllSalaryTicketByDate(Date runDate){
	
		SalaryTicketMgr fng = SalaryTicketMgr.getInstance();
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query="salaryTicketMonth ='"+df.format(runDate)+"/01'";
        String orderString=" order by salaryTicketTeacherId asc";
        Object[] objs = fng.retrieve(query,orderString);

        if (objs==null || objs.length==0)
            return null;
        
        SalaryTicket[] u = new SalaryTicket[objs.length];
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryTicket)objs[i];
        }
       return u;
    	
    }

	public SalaryBank[] getAllSalaryBySatus(Date runDate){
	
		SalaryBankMgr fng = SalaryBankMgr.getInstance();
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query="salaryBankMonth ='"+df.format(runDate)+"/01'";
        String orderString="";
        Object[] objs = fng.retrieve(query,orderString);

        if (objs==null || objs.length==0)
            return null;
        
        SalaryBank[] u = new SalaryBank[objs.length];
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryBank)objs[i];
        }
       return u;
    	
    }




	public SalaryBank[] getAllSalaryBankByBankNum(int bankNum){
	
		SalaryBankMgr fng = SalaryBankMgr.getInstance();

		String query="salaryBankBankNumberId ="+bankNum;
        String orderString="";
        Object[] objs = fng.retrieve(query,orderString);

        if (objs==null || objs.length==0)
            return null;
        
        SalaryBank[] u = new SalaryBank[objs.length];
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryBank)objs[i];
        }
       return u;
    	
    }
    
     public SalaryBank[] getSalaryBankByDate(Date runDate){
	
		SalaryBankMgr fng = SalaryBankMgr.getInstance();
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query="salaryBankMonth ='"+df.format(runDate)+"/01'";
        String orderString=" order by salaryBankTeacherId asc";
       
        Object[] objs = fng.retrieve(query,orderString);

        if (objs==null || objs.length==0)
            return null;
        
        SalaryBank[] u = new SalaryBank[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryBank)objs[i];
        }
       return u;
    	
    }
    
    public SalaryBank[] getSalaryBankByBanknumber(SalaryOut so)
    {
    	
		SalaryBankMgr fng = SalaryBankMgr.getInstance();

        String query=" salaryBankBankNumberId ="+so.getSalaryOutBanknumber();
    	 
        Object[] objs = fng.retrieve(query,"");

        if (objs==null || objs.length==0)
            return null;
        
        SalaryBank[] u = new SalaryBank[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryBank)objs[i];
        }
       
       return u;
    		
    	
    }
    
     public SalaryBank[] getSalaryBankByDateNot90(Date runDate){
	
		SalaryBankMgr fng = SalaryBankMgr.getInstance();
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query="salaryBankMonth ='"+df.format(runDate)+"/01' and salaryBankStatus <90";
        String orderString=" order by salaryBankTeacherId asc";
       
        Object[] objs = fng.retrieve(query,orderString);

        if (objs==null || objs.length==0)
            return null;
        
        SalaryBank[] u = new SalaryBank[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryBank)objs[i];
        }
       return u;
    	
    }
    public SalaryFee[] getSalaryFeeBySanumber(int numberId){
	
	SalaryFeeMgr fng = SalaryFeeMgr.getInstance();

        String query=" salaryFeeSanumberId ="+numberId;
    	 
        String orderString=" order by salaryFeeType asc";
       
        Object[] objs = fng.retrieve(query,orderString);

        if (objs==null || objs.length==0)
            return null;
        
        SalaryFee[] u = new SalaryFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryFee)objs[i];
        }
       
       return u;
    	
    }
    public SalaryTicket[] getSalaryTicketByDatePoCla(Date runDate,int poId,int claId){
    	
	    try{
			SalaryTicketMgr fng = SalaryTicketMgr.getInstance();
	        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");
	        String query=" salaryTicketMonth ='"+df.format(runDate)+"/01'";
	        if(poId !=999)
	        	query +="and salaryTicketPositionId="+poId;
	        
	        if(claId !=999)
	        	query +="and salaryTicketClassesId="+claId;
	    	 
	        String orderString=" order by salaryTicketTotalMoney desc";
	       
	        Object[] objs = fng.retrieve(query,orderString);
        
	        if (objs==null || objs.length==0)
	            return null;
	        
	        SalaryTicket[] u = new SalaryTicket[objs.length];
	        
	        for (int i=0; i<objs.length; i++)
	        {
	            u[i] = (SalaryTicket)objs[i];
	        }
	       
	       return u;
		}
		catch(Exception e)
		{
			return null;	
		}	
	    	
    }
    
    public SalaryTicket[] getSalaryTicketAdvence(Date runDate,int partTime,int departId,int poId,int claId){
    	
	    try{
				SalaryTicketMgr fng = SalaryTicketMgr.getInstance();
				java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");
				String query=" salaryTicketMonth ='"+df.format(runDate)+"/01'"; 
				
				if(departId !=999)
					query +="and salaryTicketDepartId="+departId;
				
				if(poId !=999)
					query +="and salaryTicketPositionId="+poId;
				
				if(claId !=999)
					query +="and salaryTicketClassesId="+claId;
				 
				if(partTime !=999)
					query +="and salaryTicketTeacherParttime="+partTime;
				
				
				String orderString=" order by salaryTicketTotalMoney desc";
				
				Object[] objs = fng.retrieve(query,orderString);
				
				if (objs==null || objs.length==0)
				    return null;
				
				SalaryTicket[] u = new SalaryTicket[objs.length];
				
				for (int i=0; i<objs.length; i++)
				{
				    u[i] = (SalaryTicket)objs[i];
				}
				
				return u;
		}
		catch(Exception e)
		{
			return null;	
		}	
    	
    }
     
    
     public SalaryFee[] getSalaryFeeByMonth(Date runDate,int poId,int claId,int stId)
    {
    	try{
		SalaryFeeMgr fng = SalaryFeeMgr.getInstance();
	        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");
	        String query=" salaryFeeMonth ='"+df.format(runDate)+"/01' and salaryFeeTypeId="+stId;
	        if(poId !=999)
	        	query +=" and salaryFeePositionId="+poId;
	        
	        if(claId !=999)
	        	query +=" and salaryFeeClassesId="+claId;
	    	 
	       
	        Object[] objs = fng.retrieve(query, "");
        
	        if (objs==null || objs.length==0)
	            return null;
	        
	        SalaryFee[] u = new SalaryFee[objs.length];
	        
	        for (int i=0; i<objs.length; i++)
	        {
	            u[i] = (SalaryFee)objs[i];
	        }
	       
	       return u;
	}
	catch(Exception e)
	{
		return null;	
	}
  }       
  
    public SalaryFee[] getSalaryFeeBySalaryTypeId(Date runDate,int typeId)
    {
    	try{
			SalaryFeeMgr fng = SalaryFeeMgr.getInstance();
	        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");
	        String query=" salaryFeeMonth ='"+df.format(runDate)+"/01' and salaryFeeTypeId="+typeId;
	       
	        Object[] objs = fng.retrieve(query, "");
        
	        if (objs==null || objs.length==0)
	            return null;
	        
	        SalaryFee[] u = new SalaryFee[objs.length];
	        
	        for (int i=0; i<objs.length; i++)
	        {
	            u[i] = (SalaryFee)objs[i];
	        }
	       
	       return u;
	   
	   }catch(Exception e){
			return null;	
		}    
	}
	
	public SalaryFee[] getSalaryFeeBySalaryTypeId2(int typeId)
    {
    	try{
			SalaryFeeMgr fng = SalaryFeeMgr.getInstance();
	        
	        String query="salaryFeeTypeId="+typeId;
	       
	        Object[] objs = fng.retrieve(query, "");
        
	        if (objs==null || objs.length==0)
	            return null;
	        
	        SalaryFee[] u = new SalaryFee[objs.length];
	        
	        for (int i=0; i<objs.length; i++)
	        {
	            u[i] = (SalaryFee)objs[i];
	        }
	       
	       return u;
	}catch(Exception e){
		return null;	
	}
  }       
  
  
     
     public SalaryFee[] getSalaryFeeByStId(int stId)
    {
    	try{
		SalaryFeeMgr fng = SalaryFeeMgr.getInstance();
	        String query="salaryFeeTypeId="+stId;
	       
	        Object[] objs = fng.retrieve(query,"");
        
	        if (objs==null || objs.length==0)
	            return null;
	        
	        SalaryFee[] u = new SalaryFee[objs.length];
	        
	        for (int i=0; i<objs.length; i++)
	        {
	            u[i] = (SalaryFee)objs[i];
	        }
	       
	       return u;
	}
	catch(Exception e)
	{
		return null;	
	}
  }       
	       
    
    public String generateSanumber(Date addDate)
    {
    	try{
            SanumberMgr fng = SanumberMgr.getInstance();
            java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
            String query=" sanumberDate ='"+df.format(addDate)+"/01'";

            int addDateYear=addDate.getYear()+1900;
            int addDateMonth=addDate.getMonth()+1;

            Object[] objs = fng.retrieve(query, "");
                
            if (objs==null || objs.length==0)
            {	
                Sanumber fb=new Sanumber();
                fb.setSanumberTotal(1);
                fb.setSanumberDate(df.parse(addDateYear+"/"+addDateMonth));
                fng.createWithIdReturned(fb);	 

                return gFeeNumber(fb.getSanumberDate(),1);
            }
                 
            Sanumber fb=(Sanumber)objs[0];
            int nowNumber=fb.getSanumberTotal();
            fb.setSanumberTotal(nowNumber+1);
            fng.save(fb);	 

            nowNumber=fb.getSanumberTotal();
            return gFeeNumber(fb.getSanumberDate(),nowNumber);
        }
        catch(Exception e)
        {
            return e.getMessage();	
        }
    }		

	public String gFeeNumber(Date oMonth,int fnumber)
	{	
        
        int year=oMonth.getYear()-11;
        
        int month=oMonth.getMonth()+1;
        
        String originalNumber=String.valueOf(fnumber);
        
        String xziro="";
        if(originalNumber.length()<4)
        {
            int runTimex=4-originalNumber.length();
            for(int i=0;i<runTimex;i++)
            {
                xziro +="0";	
            }	
        }
        
        //2位數適用
        String sYear=String.valueOf(year);
        
        String smonth="";	
        if(month<10)	
            smonth="0"+String.valueOf(month);
        else
            smonth=String.valueOf(month);
            
	    return sYear+smonth+xziro+originalNumber;
	}

    public String generateBanknumber(Date addDate)
    {
    	try{
		BanknumberMgr fng = BanknumberMgr.getInstance();
	        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	    	String query=" banknumberDate ='"+df.format(addDate)+"/01'";
	       
	       int addDateYear=addDate.getYear()+1900;
	       int addDateMonth=addDate.getMonth()+1;
	       
	       
	       
	         Object[] objs = fng.retrieve(query, "");
	        
	         if (objs==null || objs.length==0)
		 {	
			Banknumber fb=new Banknumber();
			fb.setBanknumberTotal(1);
			fb.setBanknumberDate(df.parse(addDateYear+"/"+addDateMonth));
			fng.createWithIdReturned(fb);	 
			  
			
	            	return gBankNumber(fb.getBanknumberDate(),1);
	         	
	         }
	         
		 Banknumber fb=(Banknumber)objs[0];
		 int nowNumber=fb.getBanknumberTotal();
		 fb.setBanknumberTotal(nowNumber+1);
		 fng.save(fb);	 
		 
		 nowNumber=fb.getBanknumberTotal();
		 return gBankNumber(fb.getBanknumberDate(),nowNumber);
	}
	catch(Exception e)
	{
		return e.getMessage();	
	}
    }		

	public String gBankNumber(Date oMonth,int fnumber)
	{	
	
	int year=oMonth.getYear()-11;
	
	int month=oMonth.getMonth()+1;
	
	String originalNumber=String.valueOf(fnumber);
	
	String xziro="";
	if(originalNumber.length()<3)
	{
		int runTimex=3-originalNumber.length();
		for(int i=0;i<runTimex;i++)
		{
			xziro +="0";	
		}	
	}
	
	//2位數適用
	String sYear=String.valueOf(year);
	
	String smonth="";	
	if(month<10)	
		smonth="0"+String.valueOf(month);
	else
		smonth=String.valueOf(month);
		
	return sYear+smonth+xziro+originalNumber;
	}   
}