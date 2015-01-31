package jsf;

import java.util.*;
import java.text.*;
import com.axiom.mgr.*;

public class FeeAdmin
{
    private static FeeAdmin instance;
    
    FeeAdmin() {}
    
    public synchronized static FeeAdmin getInstance()
    {
    	try{
    		JsfAuth jax=JsfAuth.getInstance();
    		if(!jax.getCouldWork())
				return null;

		}catch(Exception e){}
			
        if (instance==null)
        {
            instance = new FeeAdmin();
        }
        return instance;
    }
 
    public PayFee[] getAllPayFeeByFeenumber(int feenumber)
    {
    	JsfTool jt=JsfTool.getInstance();
    	JsfAdmin ja=JsfAdmin.getInstance();
    	String payDetail="";
	PayFee[] pfx=ja.getPayFeeByNumberId(feenumber);
     
     
     	if(pfx ==null)
     		return null;
     	else
     		return pfx;
     }		
    public int sumFeePay(PayFee[] pfx)
    {	
	int total=0;
	if(pfx !=null)
	{
		for(int yo2=0;yo2<pfx.length;yo2++)
		{
			
			total+=pfx[yo2].getPayFeeMoneyNumber();
		}
	}else{
		return 0;
	}	
	return total;
    }	

   public int[] sumPayWay(PayFee[] pfx)
    {	
    	JsfTool jt=JsfTool.getInstance();

	int[] sum={0,0,0,0};
	if(pfx !=null)
	{
		for(int yo2=0;yo2<pfx.length;yo2++)
		{

			
			switch(pfx[yo2].getPayFeeSourceCategory())
			{
				case 3:
					sum[2]+=pfx[yo2].getPayFeeMoneyNumber();
					break;
				case 2:
					sum[1]+=pfx[yo2].getPayFeeMoneyNumber();
					break;
				case 1:
					sum[0]+=pfx[yo2].getPayFeeMoneyNumber();
					break;
				case 4:
					sum[3]+=pfx[yo2].getPayFeeMoneyNumber();
					break;
			}
			
		}
	}	
	return sum;
    }	

    public String translateFeePay(PayFee[] pfx)
    {	
    	JsfTool jt=JsfTool.getInstance();
    	String payDetail="";
	if(pfx !=null)
	{
		for(int yo2=0;yo2<pfx.length;yo2++)
		{
			payDetail+=jt.ChangeDateToString(pfx[yo2].getPayFeeLogPayDate())+": ";
			
			switch(pfx[yo2].getPayFeeSourceCategory())
			{
				case 3:payDetail+="便利商店代收";
					break;
				case 2:payDetail+="虛擬帳號";
					break;
				case 1:payDetail+="虛擬帳號";
					break;
				case 4:payDetail+="機構櫃臺";
					break;
			}
			
			payDetail+=pfx[yo2].getPayFeeMoneyNumber()+"; ";
		}
	}else{
		payDetail="";
	}	
	return payDetail;
    }
 
    public String getFeeticketStatus(ClassesMoney cm,Date runDate,Student stu)
    {
    	JsfAdmin ja=JsfAdmin.getInstance();
    	if(cm.getClassesMoneyNewFeenumber()==1)
	    {
    		return "將產生獨立帳單";
	    }else if(cm.getClassesMoneyNewFeenumber()==2){
	
    	int newFeenumberCMId=cm.getClassesMoneyNewFeenumberCMId();
		ClassesFee cfx=ja.getClassesFeeX(runDate,stu,newFeenumberCMId);
		
		Feeticket ticket=new Feeticket();
		if(cfx!=null)
		{
			ticket=ja.getFeeticketByNumberId(cfx.getClassesFeeFeenumberId());
				
			int ftlock2=ticket.getFeeticketLock();
			String lockString="";
			if(ftlock2==0)
			{
				lockString="<img src=\"images/lockyes.gif\" title=\"可以改單\">";
				
			}else if(ftlock2 ==1){
				lockString="<img src=\"images/lockno.gif\" title=\"禁止改單\">";
			}else if(ftlock2==2){
				lockString="<img src=\"images/lockfinish.gif\" title=\"禁止改單\">";
			}
			return lockString+"<a href=addPayFeeType4.jsp?z="+cfx.getClassesFeeFeenumberId()+">"+cfx.getClassesFeeFeenumberId()+"</a>";
		}else{
			return "尚未建立獨立單";
		}
	}else{
	
		Feeticket ticket2=ja.getFeeticketByDateAndStuId2(runDate,stu.getId());
		if(ticket2==null)
		{
			return "將產生新帳單";
		}else{
				
			int ftlock3=ticket2.getFeeticketLock();
			String lockString="";
			if(ftlock3==0)
			{
				lockString="<img src=\"images/lockyes.gif\" title=\"可以改單\">";
				
			}else if(ftlock3 ==1){
				lockString="<img src=\"images/lockno.gif\" title=\"禁止改單\">";
			}else if(ftlock3==2){
				lockString="<img src=\"images/lockfinish.gif\" title=\"禁止改單\">";
			}
			return lockString+"<a href=addPayFeeType4.jsp?z="+ticket2.getFeeticketFeenumberId()+">"+ticket2.getFeeticketFeenumberId()+"</a>";
		}
	}    	
    }	
    
    
    public String getFeeticketStatusAdvance(ClassesMoney cm,Date runDate,Student stu)
    {
    	
   	String box="<input type=checkbox name=ids value=\""+stu.getId()+"\">";
   	String name=stu.getStudentName();

	boolean showBox=true;
	JsfAdmin ja=JsfAdmin.getInstance();
	if(cm.getClassesMoneyNewFeenumber()==1)
	{
		return box+name+"(將產生獨立帳單)";
	}
	else if(cm.getClassesMoneyNewFeenumber()==2)
	{
		int newFeenumberCMId=cm.getClassesMoneyNewFeenumberCMId();
		ClassesFee cfx=ja.getClassesFeeX(runDate,stu,newFeenumberCMId);
		
		Feeticket ticket=new Feeticket();
		if(cfx!=null)
		{
			ticket=ja.getFeeticketByNumberId(cfx.getClassesFeeFeenumberId());
				
			int ftlock2=ticket.getFeeticketLock();
			String lockString="";
			if(ftlock2==0)
			{
				lockString="<img src=\"images/lockyes.gif\" title=\"可以改單\">";
				
			}else if(ftlock2 ==1){
				showBox=false;
				
				lockString="<img src=\"images/lockno.gif\" title=\"禁止改單\">";
			}else if(ftlock2==2){
				showBox=false;	
				lockString="<img src=\"images/lockfinish.gif\" title=\"禁止改單\">";
			}
			
			String outWord="";
			if(showBox)
				outWord=box;
				
			outWord+=name+"("+lockString+"<a href=addPayFeeType4.jsp?z="+cfx.getClassesFeeFeenumberId()+">"+cfx.getClassesFeeFeenumberId()+"</a>)";
			return outWord;
		}else{
				
			return "尚未建立獨立單";
		}
	}else{
	
		Feeticket ticket2=ja.getFeeticketByDateAndStuId2(runDate,stu.getId());
		if(ticket2==null)
		{
			return box+name+"(將產生新帳單)";
		}else{
				
			int ftlock3=ticket2.getFeeticketLock();
			String lockString="";
			if(ftlock3==0)
			{
				lockString="<img src=\"images/lockyes.gif\" title=\"可以改單\">";
				
			}else if(ftlock3 ==1){
				showBox=false;
				lockString="<img src=\"images/lockno.gif\" title=\"禁止改單\">";
			}else if(ftlock3==2){
				showBox=false;
				lockString="<img src=\"images/lockfinish.gif\" title=\"禁止改單\">";
			}
			String outWord="";
			
			if(showBox)
				outWord=box;
				
			outWord+=name+"("+lockString+"<a href=addPayFeeType4.jsp?z="+ticket2.getFeeticketFeenumberId()+">"+ticket2.getFeeticketFeenumberId()+"</a>)";
			return outWord;
		}
	}    	
    }	
 
 	
 
    
    public Feeticket[] getAllFeeticket(int feeType)
    {
    	FeeticketMgr fm=FeeticketMgr.getInstance();
    	
    	Object[] objs = fm.retrieve("feeticketNewFeenumber=1 and feeticketNewFeenumberCmId=0", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Feeticket[] u = new Feeticket[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Feeticket)objs[i];
        }
        	
        return u;
    	
    }
     public String getPrintUpdateGif(Feeticket fee)
    {
		String img="";
		int status=fee.getFeeticketStatus();
			
		if(status <90)
		{
			int update=fee.getFeeticketPrintUpdate();
			switch(update)
			{
				case 0:img="<img src=\"images/p0.gif\" title=\"從未列印\">";
					break;
				case 1:img="<img src=\"images/p1.gif\" title=\"帳單不需更新\">";
					break;
				case 2:img="<img src=\"images/p2.gif\" title=\"帳單需要更新\">";
					break;
			}
		}
        return img;
    }
    
    public String getPrintUpdateGifWithWord(Feeticket fee)
    {
		String img="";
		int status=fee.getFeeticketStatus();
			
		if(status <90)
		{
			int update=fee.getFeeticketPrintUpdate();
			switch(update)
			{
				case 0:img="<img src=\"images/p0.gif\" title=\"從未產生繳款單\"> 尚未產生繳款單";
					break;
				case 1:img="<img src=\"images/p1.gif\" title=\"帳單不需更新\"> 系統與繳款單資料同步";
					break;
				case 2:img="<img src=\"images/p2.gif\" title=\"帳單需要更新\"> 系統資料已更新,需更新繳款單";
					break;
			}
		}
        return img;
    }

     public String getPrintUpdateLittleGif(Feeticket fee)
    {

		String img="";
		int status=fee.getFeeticketStatus();
		
		if(status <90)
		{
			int update=fee.getFeeticketPrintUpdate();
			switch(update)
			{
				case 0:img="<img src=\"images/lp0.gif\" border=0 title=\"從未列印\">";
					break;
				case 1:img="<img src=\"images/lp1.gif\" border=0 title=\"帳單不需更新\">";
					break;
				case 2:img="<img src=\"images/lp2.gif\" border=0 title=\"帳單需要更新\">";
					break;
			}
		}	
	        return img;
    }
   public boolean addTalentFeeClasseChargeTypeTalent(Date runDate,int cmId,int moneyNumber,String[] stus,int talentId,User u)
   {
   	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	ClassesMoney cmx=(ClassesMoney)cmm.find(cmId);
	
   	int stuLen=java.lang.reflect.Array.getLength(stus);
	ClassesCharge cc=ja.getClassesCharge(runDate,cmId);
	ClassesChargeMgr ccm=ClassesChargeMgr.getInstance();
	
	if(cc ==null)
	{
		cc=new ClassesCharge();
		cc.setClassesChargeCMId   	(cmId);
		cc.setClassesChargeMonth   	(runDate);
		cc.setClassesChargeCategory   	(2);
		cc.setClassesChargexId   	(talentId);
		cc.setClassesChargeActive   	(1);
		cc.setClassesChargeMoneyNumber   	(moneyNumber);
		//cc2.setClassesChargePs   	(String classesChargePs);

		int cc2Id=ccm.createWithIdReturned(cc);
		cc=(ClassesCharge)ccm.find(cc2Id);
	}	
	
	//out.println(cc.getId());
	
	StudentMgr smxx=StudentMgr.getInstance();
	
	for(int i=0;i<stuLen;i++)
	{	
		Student stuxx=(Student)smxx.find(Integer.parseInt(stus[i]));	
		jt.addStudentFee(runDate,cc.getId(),stuxx,moneyNumber,cmId,u);
	}	
		
	
   	return true;
   }
   
   public boolean addTalentFeeClasseChargeTypeTalentD(Date runDate,int cmId,int moneyNumber,String[] stus,int talentId,Date discountDate,User ud2)
   {
   	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	ClassesMoney cmx=(ClassesMoney)cmm.find(cmId);
	
   	int stuLen=java.lang.reflect.Array.getLength(stus);
	ClassesCharge cc=ja.getClassesCharge(runDate,cmId);
	ClassesChargeMgr ccm=ClassesChargeMgr.getInstance();
	
	if(cc ==null)
	{
		cc=new ClassesCharge();
		cc.setClassesChargeCMId   	(cmId);
		cc.setClassesChargeMonth   	(runDate);
		cc.setClassesChargeCategory   	(2);
		cc.setClassesChargexId   	(talentId);
		cc.setClassesChargeActive   	(1);
		cc.setClassesChargeMoneyNumber   	(moneyNumber);
		//cc2.setClassesChargePs   	(String classesChargePs);

		int cc2Id=ccm.createWithIdReturned(cc);
		cc=(ClassesCharge)ccm.find(cc2Id);
	}	
	
	//out.println(cc.getId());
	
	StudentMgr smxx=StudentMgr.getInstance();
	
	for(int i=0;i<stuLen;i++)
	{	
		Student stuxx=(Student)smxx.find(Integer.parseInt(stus[i]));	
		jt.addStudentFeeAndCfDiscount(runDate,cc.getId(),stuxx,moneyNumber,cmId,discountDate,ud2);
	}	
   	return true;
   }
    
   public int addClassesFee(Date runDate,int cmId,int classId,int groupId,int moneyNumber,User ud2, Student[] st){

	JsfTool jt=JsfTool.getInstance();
	JsfAdmin ja=JsfAdmin.getInstance();
   
   	int classIdX=classId;
	if(classId==0)
		classIdX=999;	

	if(st==null)
	{
		return 0;	
	}
	
	ClassesCharge cc=ja.getClassesChargeByClass(runDate,cmId,classId,groupId,1);
	ClassesChargeMgr ccm=ClassesChargeMgr.getInstance();
	
	if(cc ==null)
	{
		ClassesCharge cc2=new ClassesCharge();
		cc2.setClassesChargeCMId   	(cmId);
		cc2.setClassesChargeMonth   	(runDate);
		cc2.setClassesChargeCategory   	(1);
		cc2.setClassesChargexId   	(classId);
        cc2.setClassesChargeYId     (groupId);
		cc2.setClassesChargeActive   	(1);
		cc2.setClassesChargeMoneyNumber   	(moneyNumber);
		cc2.setClassesChargePs   	("自動產生");

		int cc2Id=ccm.createWithIdReturned(cc2);
		cc=(ClassesCharge)ccm.find(cc2Id);
	}else{
		return 0;
	}	

    int num = 0;
	for(int j=0;j<st.length;j++)
	{
		if (jt.addStudentFee(runDate,cc.getId(),st[j],moneyNumber,cmId,ud2)>0)
            num ++;
	}	

   	return num;
   }
   
 /*
 public boolean addClassesFeeReferenceLastBill(Date runDate,int cmId,int classId,int moneyNumber,User ud2){

	JsfTool jt=JsfTool.getInstance();
	JsfAdmin ja=JsfAdmin.getInstance();
	
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	ClassesMoney cm=(ClassesMoney)cmm.find(cmId);

	ClassesCharge cc=ja.getClassesChargeByClass(runDate,cmId,classId,0/ *groupId* /,1);
	ClassesChargeMgr ccm=ClassesChargeMgr.getInstance();
	
	Date CfDiscountDate=jt.getBackContinueDate(cm.getClassesMoneyContinue(),runDate);
	ClassesFee[] cfs=getClassesFeeByCmid(cmId,CfDiscountDate,classId);
	
	if(cfs==null)
	{
		return false;	
	}
	
	Student[] st=exchangeClassFee(cfs);
	
	if(cc ==null)
	{
		ClassesCharge cc2=new ClassesCharge();
		cc2.setClassesChargeCMId   	(cmId);
		cc2.setClassesChargeMonth   	(runDate);
		cc2.setClassesChargeCategory   	(1);
		cc2.setClassesChargexId   	(classId);
		cc2.setClassesChargeActive   	(1);
		cc2.setClassesChargeMoneyNumber   	(moneyNumber);
		cc2.setClassesChargePs   	("自動產生");

		int cc2Id=ccm.createWithIdReturned(cc2);
		cc=(ClassesCharge)ccm.find(cc2Id);
	}else{
		return false;
	}	
	StudentMgr smxx=StudentMgr.getInstance();
	for(int j=0;j<st.length;j++)
	{
		jt.addStudentFee(runDate,cc.getId(),st[j],moneyNumber,cmId,ud2);
	}	

   	return true;
   }


public boolean addClassesFeeAndCfDiscountReferenceLastBill(Date runDate,int cmId,
            int classId, int groupId,  int moneyNumber,Date CfDiscountDate,User ud2){

	JsfTool jt=JsfTool.getInstance();
	JsfAdmin ja=JsfAdmin.getInstance();
	
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	ClassesMoney cm=(ClassesMoney)cmm.find(cmId);

	ClassesCharge cc=ja.getClassesChargeByClass(runDate,cmId,classId,groupId/ *groupId* /,1);
	ClassesChargeMgr ccm=ClassesChargeMgr.getInstance();
	
	ClassesFee[] cfs=getClassesFeeByCmid(cmId,CfDiscountDate,classId);
	
	if(cfs==null)
	{
		return false;	
	}
	
	Student[] st=exchangeClassFee(cfs);
	
	if(cc ==null)
	{
		ClassesCharge cc2=new ClassesCharge();
		cc2.setClassesChargeCMId   	(cmId);
		cc2.setClassesChargeMonth   	(runDate);
		cc2.setClassesChargeCategory   	(1);
		cc2.setClassesChargexId   	(classId);
        cc2.setClassesChargeYId     (groupId);
		cc2.setClassesChargeActive   	(1);
		cc2.setClassesChargeMoneyNumber   	(moneyNumber);
		cc2.setClassesChargePs   	("自動產生");

		int cc2Id=ccm.createWithIdReturned(cc2);
		cc=(ClassesCharge)ccm.find(cc2Id);
	}else{
		return false;
	}	
	
	for(int j=0;j<st.length;j++)
	{
		jt.addStudentFeeAndCfDiscount(runDate,cc.getId(),st[j],moneyNumber,cmId,CfDiscountDate,ud2);
	}	
	
   	return true;
   }
*/
   
   public Student[] exchangeClassFee(ClassesFee[] cf)
   {

		if(cf ==null)
			return null;
			
   		Student[] stu=new Student[cf.length];
		StudentMgr sm=StudentMgr.getInstance();

		for(int i=0;i<cf.length;i++)
		{
				
			stu[i]=(Student)sm.find(cf[i].getClassesFeeStudentId());
		}
		
		return stu;
	}
   
   public int addClassesFeeAndCfDiscount(Date runDate,int cmId,int classId,int groupId,int moneyNumber,
        Date CfDiscountDate,User ud2, Student[] st){

	JsfTool jt=JsfTool.getInstance();
	JsfAdmin ja=JsfAdmin.getInstance();
   
	ClassesCharge cc=ja.getClassesChargeByClass(runDate,cmId,classId,groupId,1);
	ClassesChargeMgr ccm=ClassesChargeMgr.getInstance();

	
	if(cc ==null)
	{
		ClassesCharge cc2=new ClassesCharge();
		cc2.setClassesChargeCMId   	(cmId);
		cc2.setClassesChargeMonth   	(runDate);
		cc2.setClassesChargeCategory   	(1);
		cc2.setClassesChargexId   	(classId);
		cc2.setClassesChargeYId   	(groupId);
		cc2.setClassesChargeActive   	(1);
		cc2.setClassesChargeMoneyNumber   	(moneyNumber);
		//cc2.setClassesChargePs   	(String classesChargePs);

		int cc2Id=ccm.createWithIdReturned(cc2);
		cc=(ClassesCharge)ccm.find(cc2Id);
	}else{
		return 0;
	}	
		
	if(st==null)
	{
		return 0;	
	}
	
    int num = 0;
	for(int j=0;j<st.length;j++)
	{
		if (jt.addStudentFeeAndCfDiscount(runDate,cc.getId(),st[j],moneyNumber,cmId,CfDiscountDate,ud2)>0)
            num ++;
	}	

   	return num;
   }
   
   public Feeticket[] getNotPayFeeticket(Date runDate,int stuid)
   {
   	    FeeticketMgr cm=FeeticketMgr.getInstance();
    	 
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	

	    String query=" feeticketMonth <'"+df.format(runDate)+"/01' and feeticketStatus<90 and feeticketStuId="+stuid;
	
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
   
    public AdditionalFee[] getAllNotPayAdditionalFeeByFeenumber(int feenumber)
   {
        JsfAdmin js=JsfAdmin.getInstance();
        FeeticketMgr cm=FeeticketMgr.getInstance();
        AdditionalFeeMgr afm=AdditionalFeeMgr.getInstance();

        String query=" additionalFeeOriginal ="+feenumber+" or additionalFeeAddition="+feenumber;
        Object[] objs = afm.retrieve(query,"");

        if (objs==null || objs.length==0)
            return null;	

        AdditionalFee[] u =new AdditionalFee[objs.length];

        for (int i=0; i<objs.length; i++)
        {
            u[i] = (AdditionalFee)objs[i];
        }

        return u;	
   }
   
   public boolean deleteAdditionalFeeByFeenumberWithTran_Id(int feenumber,int tranID)
   {

        try{
            
            AdditionalFeeMgr afm=new AdditionalFeeMgr(tranID);

            String query=" additionalFeeOriginal ="+feenumber+" or additionalFeeAddition="+feenumber;
            Object[] objs = afm.retrieve(query,"");

            if (objs==null || objs.length==0)
                return true;	

            for (int i=0; i<objs.length; i++)
            {
                AdditionalFee af=(AdditionalFee)objs[i];                
                afm.remove(af.getId());
            }

            return true;	
        }catch(Exception e){

            try { Manager.rollback(tranID); } catch (Exception e2) {}
            return false;
        }
   }
   
    public AdditionalFee[] getAllNotPayAdditionalByFeenumber(Feeticket ft)
   {
		JsfAdmin js=JsfAdmin.getInstance();
   	
        AdditionalFeeMgr afm=AdditionalFeeMgr.getInstance();
		String query=" additionalFeeOriginal ="+ft.getFeeticketFeenumberId();
    	Object[] objs = afm.retrieve(query,"order by '"+ft.getFeeticketFeenumberId()+"' asc");
	        
         if (objs==null || objs.length==0)
	 		return null;	
	
		AdditionalFee[] u =new AdditionalFee[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (AdditionalFee)objs[i];
        }
        return u;	
   }
    public Feeticket[] getNotPayFeeticketByFeenumber(Feeticket ft)
   {
		JsfAdmin js=JsfAdmin.getInstance();
   		FeeticketMgr cm=FeeticketMgr.getInstance();

        AdditionalFeeMgr afm=AdditionalFeeMgr.getInstance();
		String query=" additionalFeeOriginal ="+ft.getFeeticketFeenumberId()+" and additionalFeeActive=1";
    	Object[] objs = afm.retrieve(query,"");
	        
         if (objs==null || objs.length==0)
	 		return null;	
	 	
		Feeticket[] fee=new Feeticket[objs.length];
		AdditionalFee[] af=new AdditionalFee[objs.length];	
		for (int i=0; i<objs.length; i++)
	    {
	        	af[i]=(AdditionalFee)objs[i];
	        	int newfeenumber=af[i].getAdditionalFeeAddition();
	
	        	fee[i]=js.getFeeticketByNumberId(newfeenumber);;
	    }
	
	   	return fee;		
   }
   
	public int getAllNotPayNumber(Feeticket ft)
	{
		int total=0;
		Feeticket[] fts=getNotPayFeeticketByFeenumber(ft);
		
		if(fts==null)
			return total;
		
		for(int i=0;i<fts.length;i++)
		{
			int payFt=fts[i].getFeeticketTotalMoney()-fts[i].getFeeticketPayMoney();
			
			total+=payFt;	
		}

		return total;		
	}

    public Feeticket[] getAllNotPayNumberByTime(Feeticket ft)
	{
		int total=0;
		Feeticket[] fts=getNotPayFeeticketByFeenumber(ft);
		
		if(fts==null)
			return null;
		
        long xNow=new Date().getTime();
        
        Vector v=new Vector();

		for(int i=0;i<fts.length;i++)
		{
            Date endDate=fts[i].getFeeticketEndPayDate();                
            
            if(endDate !=null)
            {            
                long xEnd=endDate.getTime();
                
                if(xNow > xEnd)
                {
                    v.add(fts[i]);
                }
            }
		}
        
        if(v==null || v.size()==0)
        {
            return null;
        }
        Feeticket[] ftX=new Feeticket[v.size()];

        for(int j=0;j<v.size();j++)
        {
            ftX[j]=(Feeticket)v.get(j);
        }
		return ftX;		
	}
	
	public Feeticket[] getNotpayFeeticket(PaySystem pSystem,Feeticket ft)
    {
        if(pSystem.getPaySystemExtendNotpay()==1)		
        {
            return getNotPayFeeticketByFeenumber(ft); 
        }else if(pSystem.getPaySystemExtendNotpay()==2){
            return getAllNotPayNumberByTime(ft);
        }else if(pSystem.getPaySystemExtendNotpay()==0){
            return null;
        }
        
        return null;
    }

    public int countNotpayFeeticket(Feeticket[] ft)
    {
        if(ft ==null)
            return 0;
        
        int total=0;
        for(int i=0;i<ft.length;i++)
        {
            int payFt=ft[i].getFeeticketTotalMoney()-ft[i].getFeeticketPayMoney();
			
			total+=payFt;	
        }   
        return total;
    }    
	public String getAllNotPayNumberString(Feeticket[] fts)
	{
        DecimalFormat mnf = new DecimalFormat("###,###,##0");      	
		StringBuffer total=new StringBuffer();
        JsfAdmin js=JsfAdmin.getInstance();
		if(fts==null)
			return "";
		for(int i=0;i<fts.length;i++)
		{
			int payFt=fts[i].getFeeticketTotalMoney()-fts[i].getFeeticketPayMoney();
			String feenumber=String.valueOf(fts[i].getFeeticketFeenumberId());
		    
            total.append("        * 前期未繳帳單 流水號:"+feenumber);	
        	    
            ClassesFee[] cf=js.getClassesFeeByNumber(fts[i].getFeeticketFeenumberId());
		    if(cf !=null)
            {
                total.append(" 收費項目:");
                ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
                for(int j=0;j<cf.length;j++)
                {                        
                    ClassesMoney cm=(ClassesMoney)cmm.find(cf[j].getClassesFeeCMId());
                    total.append(cm.getClassesMoneyName()+":");
                    total.append(mnf.format(cf[j].getClassesFeeShouldNumber()-cf[j].getClassesFeeTotalDiscount())+"  ");     
                 }
            }
            total.append(" \n");   
		}
            
		return total.toString();		
	}

	public boolean balanceNotPayTicket(Feeticket ft,int payMoney,int manPcType,int SourceCategory,User ud2,int tradeAccount,int bankType,int paywayX)
	{
		JsfAdmin ja=JsfAdmin.getInstance();
		JsfTool jt=JsfTool.getInstance();
		int notAllTotal=0;
 		AdditionalFee[] afNotPay=getAllNotPayAdditionalByFeenumber(ft);
	 	Feeticket[] fee=new Feeticket[afNotPay.length];

	 	for(int k=0;k<afNotPay.length;k++)
		{
			int newfeenumber=afNotPay[k].getAdditionalFeeAddition();
			fee[k]=ja.getFeeticketByNumberId(newfeenumber);
			int payTotalNot=fee[k].getFeeticketTotalMoney()-fee[k].getFeeticketPayMoney();

			notAllTotal+=payTotalNot;	
		}

		if(notAllTotal ==payMoney)
		{
			PayFee[] pfs=new PayFee[fee.length];
			for(int i=0;i<fee.length;i++)
			{
				int payMoney2=fee[i].getFeeticketTotalMoney()-fee[i].getFeeticketPayMoney();
				PayFee pf=new PayFee();
				pf.setPayFeeFeenumberId   	(fee[i].getFeeticketFeenumberId());
				pf.setPayFeeMoneyNumber   	(payMoney2);
				pf.setPayFeeLogDate   	(new Date());
				pf.setPayFeeLogPayDate   	(new Date());
				pf.setPayFeeManPCType   	(manPcType);
				pf.setPayFeeSourceCategory   	(SourceCategory);
				pf.setPayFeeStatus   	(1);
				pf.setPayFeeLogId(ud2.getId());
				pf.setPayFeeAccountType(bankType);
				pf.setPayFeeAccountId(tradeAccount);   	
								
			 	PayFeeMgr pfm=PayFeeMgr.getInstance();
			 	int pfId=pfm.createWithIdReturned(pf);
			 	pf=(PayFee)pfm.find(pfId);
			 	jt.balanceFeeticket(pf,fee[i],bankType,paywayX,tradeAccount);
			 	
			 	pf=(PayFee)pfm.find(pfId);
			 	pfs[i]=pf;
			}
			
            PaySystemMgr em=PaySystemMgr.getInstance();
        	PaySystem pSystem=(PaySystem)em.find(1);    

			JsfPay jp=JsfPay.getInstance();
			jp.sendMultiPayFeeMessage(pfs,pSystem);
			
		}		
		return true;
	}

   
   public int totalShould(Feeticket ft)
   {
   		int notPay=getAllNotPayNumber(ft);
   		int nowShould=ft.getFeeticketTotalMoney()-ft.getFeeticketPayMoney();
   		
   		int total=notPay+nowShould;
   		
   		return total;
   	
	}
   
   public CfDiscount[] getCfDiscountBy(int stuid,Date discountDate,int cmId)
   {
   	CfDiscountMgr cm=CfDiscountMgr.getInstance();
    	 
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	

		String query="cfDiscountContinue='1' and cfDiscountMonth ='"+df.format(discountDate)+"/01' and cfDiscountCmId="+cmId+" and cfDiscountStudentId="+stuid;
	
    	Object[] objs = cm.retrieve(query,"");
	        
        if (objs==null || objs.length==0)
	 	{	
            	return null;
         }
        
        CfDiscount[] u = new CfDiscount[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (CfDiscount)objs[i];
        }
        return u;		
   }
   
    public CfDiscount[] getCfDiscountByClassesId(int claId,Date discountDate,int cmId)
   {
   	CfDiscountMgr cm=CfDiscountMgr.getInstance();
    	 
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	

	String query=" cfDiscountMonth ='"+df.format(discountDate)+"/01' and cfDiscountCmId="+cmId+" and cfDiscountClassId="+claId;
	
    	Object[] objs = cm.retrieve(query,"");
	        
         if (objs==null || objs.length==0)
	 {	
            	return null;
         }
        
        CfDiscount[] u =new CfDiscount[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (CfDiscount)objs[i];
        }
        return u;		
   }
   
      
   public CfDiscount[] getContinueCfDiscountByClassesId(int claId, int groupId, Date discountDate,int cmId)
   {
   	    CfDiscountMgr cm=CfDiscountMgr.getInstance();
    	 
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	

	    String query="cfDiscountContinue='1' and cfDiscountMonth ='"+df.format(discountDate)+"/01' and cfDiscountCmId="+
            cmId+" and cfDiscountClassId="+claId + " and cfDiscountGroupId=" + groupId;
	
    	Object[] objs = cm.retrieve(query,"");
	        
        if (objs==null || objs.length==0)
        {	
            return null;
        }
        
        CfDiscount[] u =new CfDiscount[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (CfDiscount)objs[i];
        }
        return u;		
   }
   public CfDiscount[] getCfDiscountTalent(Date discountDate,int cmId)
   {
   		CfDiscountMgr cm=CfDiscountMgr.getInstance();
    	 
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	

		String query=" cfDiscountMonth ='"+df.format(discountDate)+"/01' and cfDiscountCmId="+cmId;
	
    	Object[] objs = cm.retrieve(query,"");
	        
        if (objs==null || objs.length==0)
	 	{	
            	return null;
        }
        
        CfDiscount[] u =new CfDiscount[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (CfDiscount)objs[i];
        }
        return u;		
   } 
    
   public CfDiscount[] getContinueCfDiscountTalent(Date discountDate,int cmId)
   {
   		CfDiscountMgr cm=CfDiscountMgr.getInstance();
    	 
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	

		String query="cfDiscountContinue='1' and cfDiscountMonth ='"+df.format(discountDate)+"/01' and cfDiscountCmId="+cmId;
	
    	Object[] objs = cm.retrieve(query,"");
	        
        if (objs==null || objs.length==0)
	 	{	
            	return null;
        }
        
        CfDiscount[] u =new CfDiscount[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (CfDiscount)objs[i];
        }
        return u;		
   } 

     /* 
    
	public CfDiscount[] getContinueCfDiscountTalent(Date discountDate,int cmId)
   {
   		CfDiscountMgr cm=CfDiscountMgr.getInstance();
    	 
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	

		String query="cfDiscountContinue='1' and cfDiscountMonth ='"+df.format(discountDate)+"/01' and cfDiscountCmId="+cmId;
	
    	Object[] objs = cm.retrieve(query,"");
	        
        if (objs==null || objs.length==0)
	 	{	
            	return null;
        }
        
        CfDiscount[] u =new CfDiscount[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (CfDiscount)objs[i];
        }
        return u;		
   }
    */
   public ClassesFee[] getClassesFeeByCmid(int cmId,Date continueDate,int claId)
   {
   	    ClassesFeeMgr cm=ClassesFeeMgr.getInstance();
    	 
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	

	    String query=" classesFeeMonth ='"+df.format(continueDate)+"/01' and classesFeeCMId="+cmId+" and classesFeeStuClassId="+claId;
	
    	Object[] objs = cm.retrieve(query,"");
	        
        if (objs==null || objs.length==0)
        {	
            return null;
        }
        
        ClassesFee[] u =new ClassesFee[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }
        return u;		
    }
}