package jsf;

import java.util.*;
import java.text.*;
import com.axiom.mgr.*;

public class JsfAdmin
{
    private static JsfAdmin instance;
    
    JsfAdmin() {}
    
    public synchronized static JsfAdmin getInstance()
    {
        /*
    	try{
	    		JsfAuth jax=JsfAuth.getInstance();
	    		if(!jax.getCouldWork())
					return null;

		}catch(Exception e){}
		*/	
        if (instance==null)
        {
            instance = new JsfAdmin();
        }
        return instance;
    }



    public Authitem[] getAllAuthitem(){

   	    AuthitemMgr bigr = AuthitemMgr.getInstance();
        
        String query="";
     
        Object[] objs = bigr.retrieve(query," order by number asc");
        
        if (objs==null || objs.length==0)
            return null;
        
        Authitem[] u =new Authitem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Authitem)objs[i];
        }
        return u;

    }
    
    public Authuser[] getAuthuserByUserId(int userId){

   	    AuthuserMgr bigr = AuthuserMgr.getInstance();
        
        String query="userId = '"+userId+"'";
     
        Object[] objs = bigr.retrieve(query,"");
        
        if (objs==null || objs.length==0)
            return null;
        
        Authuser[] u =new Authuser[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Authuser)objs[i];
        }
        return u;
    }

    public Hashtable getHaAuthuser(int userId){

        Hashtable ha=new Hashtable();
        AuthuserMgr bigr = AuthuserMgr.getInstance();

        Hashtable haAu=new Hashtable();
        Authitem[] au=getAllAuthitem();
        for(int i=0;au !=null && i < au.length ; i++)
        {
            haAu.put((Integer)au[i].getAuthId(),(Integer)au[i].getNumber());
        }

        String query="userId = '"+userId+"'";     
        Object[] objs = bigr.retrieve(query,"");
        
        if (objs==null || objs.length==0){

            ha.put((Integer)999,"");        
            return ha;
        }        
        for (int i=0; i<objs.length; i++)
        {
            Authuser auser= (Authuser)objs[i];

            Integer aNum=(Integer)haAu.get((Integer)auser.getAuthitemId());
            
            if(aNum !=null){                
                ha.put((Integer)aNum,"");
            }
        }

        if(ha ==null)
            ha.put((Integer)999,"");
        return ha;            
    }

    public Costbigitem[] getCostbigitemByCTid(int ctId)
    {
    	CostbigitemMgr bigr = CostbigitemMgr.getInstance();
        
        String query="costtradeId='"+ctId+"'";
     
        Object[] objs = bigr.retrieve(query,"");
        
        if (objs==null || objs.length==0)
            return null;
        
        Costbigitem[] u =new Costbigitem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costbigitem)objs[i];
        }
        return u;
    	
    }  


    public Costbigitem[] getCostbigitemByBiId(int biId,boolean incodeAll)
    {
    	CostbigitemMgr bigr = CostbigitemMgr.getInstance();
        
        String query="bigitemId='"+biId+ "'" ;
     
        if(incodeAll)
            query += " or bigitemId='0'";

        Object[] objs = bigr.retrieve(query,"  order by bigitemId desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        Costbigitem[] u =new Costbigitem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costbigitem)objs[i];
        }
        return u;
    	
    }  

    public BigItem[] getAllBigItem()
    {
    	BigItemMgr bigr = BigItemMgr.getInstance();
        
        Object[] objs = bigr.retrieve(null, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        BigItem[] u = new BigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BigItem)objs[i];
        }
        
        return u;
    }
    
    public String getBarImage(int type,int upNum,int downNum)
    {
        if(upNum==0 || downNum==0)
        {
            if(type==1)
                return "bara0.gif";
            else
                return "barb0.gif";
        }

        double xnow=(double)upNum/(double)downNum;

        if(xnow<(double)0.20)
        {
            if(type==1)
                return "bara1.gif";
            else
                return "barb1.gif";
        }else if(xnow>=(double)0.20 && (double)0.50>xnow){
            if(type==1)
                return "bara2.gif";
            else
                return "barb2.gif";
        }else if(xnow>=(double)0.50 && (double)0.70>xnow){
           if(type==1)
                return "bara3.gif";
            else
                return "barb3.gif";
        }else if(xnow>=(double)0.70 && (double)0.80>xnow){
            if(type==1)
                return "bara4.gif";
            else
                return "barb4.gif";
        }else if(xnow>=(double)0.80 && (double)1.0>xnow){
            if(type==1)
                return "bara45.gif";
            else
                return "barb45.gif";
        }else{
            if(type==1)
                return "bara5.gif";
            else
                return "barb5.gif";
        }

    }

    public String getChineseRole(int role)
    {
        String roleName="";
        switch(role)
        {
            case 1:
        		roleName="管理者";			
    	        break;
            case 2:
                roleName="經營者";			
    	        break;
            case 3:
                roleName="會計";			
    	        break;
            case 4:
                roleName="部門主管/行政";			
    	        break;
            case 5:
                roleName="老師";			
    	        break;
        }
    
    	return roleName;
    }
    
    
    public boolean isAuthBank(int baId,int userId)
    {
    	SalarybankAuthMgr bigr = SalarybankAuthMgr.getInstance();
        
        Object[] objs = bigr.retrieve("salarybankAuthId ='"+baId+"' and salarybankAuthUserID='"+userId+"' and salarybankAuthActive='1'", null);
        
        if (objs==null || objs.length==0)
            return false;
        else
        	return true;
    }
    
    
    public ClassesMoney[] getActiveNewFeenumber()
    {
    	ClassesMoneyMgr bigr = ClassesMoneyMgr.getInstance();
        
        Object[] objs = bigr.retrieve("classesMoneyNewFeenumber = 1 and classesMoneyActive=1", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesMoney[] u =new ClassesMoney[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesMoney)objs[i];
        }
        
        return u;
    }
    
    public ClassesMoney[] getActiveBasicFeenumber()
    {
    	ClassesMoneyMgr bigr = ClassesMoneyMgr.getInstance();
        
        Object[] objs = bigr.retrieve("classesMoneyNewFeenumber =0 and classesMoneyActive=1", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesMoney[] u =new ClassesMoney[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesMoney)objs[i];
        }
        
        return u;
    }
    
    
    public Classes[] getAllActiveClasses()
    {
    	ClassesMgr bigr = ClassesMgr.getInstance();
        
        Object[] objs = bigr.retrieve("classesStatus = 1", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Classes[] u =new Classes[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Classes)objs[i];
        }
        
        return u;
    }
    
    public Userlog[] getUserlogById(int userId)
    {
    	UserlogMgr bigr = UserlogMgr.getInstance();
        
        
        Object[] objs = bigr.retrieve("userlogUserId='"+userId+"'", " order by id desc limit 2");
        
        if (objs==null || objs.length==0)
            return null;
        
        Userlog[] u =new Userlog[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Userlog)objs[i];
        }
        
        return u;
    }
    
    public Userlog[] getUserlogByIdNotConfirm(int userId)
    {
    	UserlogMgr bigr = UserlogMgr.getInstance();
        
        
        Object[] objs = bigr.retrieve("userlogUserId='"+userId+"' and userConfirm='0'", " order by created asc limit 1");
        
        if (objs==null || objs.length==0)
            return null;
        
        Userlog[] u =new Userlog[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Userlog)objs[i];
        }
        
        return u;
    }

    public Userlog[] getUserlogByIdError(Date logDate, String space)
    {
    	UserlogMgr bigr = UserlogMgr.getInstance();
        
        SimpleDateFormat sdfDateCost2=new SimpleDateFormat("yyyy/MM/dd");
        Object[] objs = bigr.retrieveX("created >='" + sdfDateCost2.format(logDate)+"' and userlogUserId='0'", "", space);

System.out.println("modified >'" + sdfDateCost2.format(logDate)+"' and userlogUserId='0'");


        if (objs==null || objs.length==0)
            return null;
        
        Userlog[] u =new Userlog[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Userlog)objs[i];
        }
        
        return u;
    }

    public ClientAccount[] getAllClientAccount(String space)
    {
    	ClientAccountMgr bigr = ClientAccountMgr.getInstance();
        
        
        Object[] objs = bigr.retrieveX("", " order by created desc", space);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClientAccount[] u =new ClientAccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClientAccount)objs[i];
        }
        return u;
    }

    public ClientAccount[] getClientAccountByCosttrade(int ctId,boolean active)
    {
    	ClientAccountMgr bigr = ClientAccountMgr.getInstance();
        
        String query="clientAccountCosttrade='"+ctId+"'";

        if(active)
            query+=" and clientAccountActive='1'";
        Object[] objs = bigr.retrieve(query, " order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        ClientAccount[] u =new ClientAccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClientAccount)objs[i];
        }
        return u;
    }

	public ClientAccount[] getActiveClientAccount()
    {
    	ClientAccountMgr bigr = ClientAccountMgr.getInstance();
        
        
        Object[] objs = bigr.retrieve("clientAccountActive='1'", " order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        ClientAccount[] u =new ClientAccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClientAccount)objs[i];
        }
        return u;
    }
    
  
    public Teacher[] getTeacherPosition(int poId)
    {
    	TeacherMgr bigr = TeacherMgr.getInstance();
        
        Object[] objs = bigr.retrieve("teacherPosition ="+poId+" and teacherStatus=1", null);
        
        if (objs==null || objs.length==0)
            return null;
		
		Teacher[] u =new Teacher[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Teacher)objs[i];
        }
        
        return u;

	}     
	
	public StudentAccount[] getAllStudentAccount()
    {
    	StudentAccountMgr bigr = StudentAccountMgr.getInstance();
        
        Object[] objs = bigr.retrieve("","order by id asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		StudentAccount[] u =new StudentAccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (StudentAccount)objs[i];
        }
        
        return u;
    }

    
    public Teacher[] getTeacherByPosition(int poId)
    {
    	TeacherMgr bigr = TeacherMgr.getInstance();
        
        Object[] objs = bigr.retrieve("teacherPosition ="+poId+" and teacherStatus=1", null);
        
        if (objs==null || objs.length==0)
            return null;
	
		Teacher[] u =new Teacher[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Teacher)objs[i];
        }
        
        return u;

    }
    
    public ClassesMoney[] getCMByTalentId(int taId)
    {
    	
    	CmxLogMgr clmg=CmxLogMgr.getInstance();
    	Object[] objs = clmg.retrieve("cmxLogCategory =2 and cmxLogXId="+taId+" and cmxLogActive=1", null);
    	
    	if (objs==null || objs.length==0)
            return null;
	
		CmxLog[] u =new CmxLog[objs.length];
	
		ClassesMoney[] cm=new ClassesMoney[objs.length];
		ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
		for (int i=0; i<objs.length; i++)
        {
            u[i] = (CmxLog)objs[i];
            cm[i]=(ClassesMoney)cmm.find(u[i].getCmxLogCMid());
        }
  
  		return cm;  	
    }	
    
    
    public ClassesMoney[] getAllClassesMoney(int active)
    {
    	ClassesMoneyMgr bigr = ClassesMoneyMgr.getInstance();
        
        String orderString=" order by created desc";

        String query="";
        
        if(active !=999)
        	query="classesMoneyActive="+active;
        	
        Object[] objs = bigr.retrieve(query,orderString);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesMoney[] u =new ClassesMoney[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesMoney)objs[i];
        }
        
        return u;
    }
    
 
    
    
    public ClassesMoney[] getAllClassesMoney(int active,int category)
    {
    	ClassesMoneyMgr bigr = ClassesMoneyMgr.getInstance();
        
        String orderString=" order by created desc";
        
        Object[] objs = bigr.retrieve("classesMoneyActive="+active+" and classesMoneyCategory="+category,orderString);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesMoney[] u =new ClassesMoney[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesMoney)objs[i];
        }
        
        return u;
    }
    
    public ClassesMoney[] getAllClassesMoney(int active,int category,int orderBy)
    {
    	ClassesMoneyMgr bigr = ClassesMoneyMgr.getInstance();
        
        String orderString=" order by created desc";
        if(orderBy==1)
         	orderString="order by classesMoneyNewFeenumber";
        
        Object[] objs = bigr.retrieve("classesMoneyActive="+active+" and classesMoneyCategory="+category+" and classesMoneyContinueActive=1",orderString);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesMoney[] u =new ClassesMoney[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesMoney)objs[i];
        }
        
        return u;
    }
    public ClassesMoney[] getClassesMoneyByNewFeenumber(int cmId)
    {
    	ClassesMoneyMgr bigr = ClassesMoneyMgr.getInstance();
        
        Object[] objs = bigr.retrieve("classesMoneyNewFeenumberCMId="+cmId,"");
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesMoney[] u =new ClassesMoney[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesMoney)objs[i];
        }
        
        return u;
    }
    public ClassesFee[] getAllClassesFeeByCmidNotMonth(int cmId)
    {
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
        Object[] objs = bigr.retrieve("classesFeeCMId="+cmId,"");
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesFee[] u =new ClassesFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }
        
        return u;
    }
  	
  	  
    
    public int acocuntClassesFee(ClassesFee[] cf)
    {
    	if(cf==null)
    		return 0;
    		
    	int total=0;
    	
    	for(int i=0;i<cf.length;i++)
    	{
    		int nowTotal=cf[i].getClassesFeeShouldNumber()-cf[i].getClassesFeeTotalDiscount();
    		total+=nowTotal;
    	}	
    	
    	return total;
    }
    
    public ClassesFee[] getClassesFeeByCcId(int ccid)
    {
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
        Object[] objs = bigr.retrieve("classesFeeChargeId="+ccid,"order by classesFeeMonth desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesFee[] u =new ClassesFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }
        
        return u;
    }
  
  
  	public TalentSalary[] getTalentSalaryByTalentId(int talentId)
    {
    	TalentSalaryMgr bigr = TalentSalaryMgr.getInstance();
        
        Object[] objs = bigr.retrieve("talentSalaryTalentId="+talentId,"");
        
        if (objs==null || objs.length==0)
            return null;
        
        TalentSalary[] u =new TalentSalary[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (TalentSalary)objs[i];
        }
        
        return u;
    }
    
    public TalentSalary[] getTalentSalaryByMonthTalentId(int talentId,Date accountMonth)
    {
    	TalentSalaryMgr bigr = TalentSalaryMgr.getInstance();
        
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/01");
        Object[] objs = bigr.retrieve("talentSalaryTalentId='"+talentId+"' and talentSalaryMonth='"+sdf.format(accountMonth)+"'","");
        
        if (objs==null || objs.length==0)
            return null;
        
        TalentSalary[] u =new TalentSalary[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (TalentSalary)objs[i];
        }
        
        return u;
    }
  
    public Dbbackup[] getAllDbbackup()
    {
    	DbbackupMgr bigr = DbbackupMgr.getInstance();
        
        Object[] objs = bigr.retrieve("","order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        Dbbackup[] u =new Dbbackup[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Dbbackup)objs[i];
        }
        
        return u;
    }
    
    public Exl[] getAllExl()
    {
    	ExlMgr bigr = ExlMgr.getInstance();
        
        Object[] objs = bigr.retrieve("","order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        Exl[] u =new Exl[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Exl)objs[i];
        }
        
        return u;
    }
    
     public ClassesMoney[] getAllTalentMoney()
    {
    	ClassesMoneyMgr bigr = ClassesMoneyMgr.getInstance();
        
        Object[] objs = bigr.retrieve("classesMoneyTalentId != 0","");
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesMoney[] u =new ClassesMoney[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesMoney)objs[i];
        }
        
        return u;
    }

    public ClassesMoney[] getClassesMoneyByIsiId(int isiId)
    {
    	ClassesMoneyMgr bigr = ClassesMoneyMgr.getInstance();
        
        Object[] objs = bigr.retrieve("classesMoneyIncomeItem='"+isiId+"'","");
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesMoney[] u =new ClassesMoney[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesMoney)objs[i];
        }
        
        return u;
    }
    
    
    public CmxLog[] getCmxLogByCMid(int cmId)
    {
    	CmxLogMgr bigr = CmxLogMgr.getInstance();
        
        Object[] objs = bigr.retrieve("cmxLogCMid ="+cmId,"");
        
        if (objs==null || objs.length==0)
            return null;
        
        CmxLog[] u =new CmxLog[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (CmxLog)objs[i];
        }
        
        return u;
    }
    
    
  
    
    public Feeticket getFeeticketByDateAndStuId2(Date xdate,int stuId)
    {
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	String query="feeticketNewFeenumber !='1' and feeticketMonth ='"+df.format(xdate)+"/01' and feeticketStuId="+stuId;
	       
	Object[] objs = bigr.retrieve(query, "");
	        
         if (objs==null || objs.length==0)
	 {	
            	return null;
         }
        
        return (Feeticket)objs[0];
    }
    
    public ClassesFee getClassesFeeX(Date runDate,Student stu,int cmId)
    {
    	ClassesFeeMgr cfm=ClassesFeeMgr.getInstance();
    	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	    String query="classesFeeMonth ='"+df.format(runDate)+"/01' and classesFeeStudentId="+stu.getId()+" and classesFeeCMId="+cmId;
	
	    Object[] objs = cfm.retrieve(query, "");
	        
        if (objs==null || objs.length==0)
        {	
            return null;
        }

        return (ClassesFee)objs[0];
    }

     public Feeticket getFeeticketByNumberId(int numberId)
    {
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
	String query="feeticketFeenumberId="+numberId;
	       
	Object[] objs = bigr.retrieve(query, "");
	        
         if (objs==null || objs.length==0)
	 {	
            	return null;
         }
        
        return (Feeticket)objs[0];
    }

    public Feeticket[] getFeeticketByDate(Date oMonth,int orderBy,int status)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	String query=" feeticketMonth ='"+df.format(oMonth)+"/01'";
	
	if(status !=0)
		query +=" and feeticketStatus ="+status;
	
	String orderString="";
    	switch(orderBy)
    	{
    		case 1: orderString=" order by feeticketFeenumberId desc";
    			break;	
    		case 2: orderString=" order by feeticketFeenumberId ";
    			break;	
    		default:
    			orderString=" order by id ";
    			break;	
    	}
	       
	Object[] objs = bigr.retrieve(query,orderString);
	        
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
    
    public Feeticket[] getFeeticketBetweenDate(Date startDate,Date endDate)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	
		String query="feeticketMonth >='"+ df.format(startDate)+"' and feeticketMonth<='"+df.format(endDate)+"'";
	
     
		Object[] objs = bigr.retrieve(query,"");
	        
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
    
    public ClassesFee[] getAllClassesFeeBetweenDate(Date startDate,Date endDate)
    {
    	
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	
	
		String query="classesFeeMonth >='"+ df.format(startDate)+"' and classesFeeMonth<='"+df.format(endDate)+"'";
	
		Object[] objs = bigr.retrieve(query,"");
	        
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
    
    
     public Feeticket[] getFeeticketByClassLevel(Date oMonth,int orderBy,int status,int classId,int levelId)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	String query=" feeticketMonth ='"+df.format(oMonth)+"/01'";
	
	if(status !=0)
		query +=" and feeticketStatus ="+status;
	
	
	if(classId !=999)
		query +=" and feeticketStuClassId="+classId;
		
	if(levelId !=999)
		query +=" and feeticketStuLevelId="+levelId;
	String orderString="";
    	switch(orderBy)
    	{
    		case 1: orderString=" order by feeticketFeenumberId desc";
    			break;	
    		case 2: orderString=" order by feeticketFeenumberId ";
    			break;
    		case 3: orderString=" order by feeticketStuId ";
    			break;	
    		case 4: orderString=" order by feeticketStuId descClassesMoney";
    			break;
    		default:
    			orderString=" order by id ";
    			break;	
    	}
	       
	Object[] objs = bigr.retrieve(query,orderString);
	        
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
    
    public Feeticket[] getFeeticketByClassStatus(Date oMonth,int orderBy,int status,int classId,int levelId)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query=" feeticketMonth ='"+df.format(oMonth)+"/01'";
	
		if(status !=0)
		{
			if(status==1)
				query +=" and feeticketStatus>='1' and feeticketStatus <='2' ";
			else if(status==90)
				query +=" and feeticketStatus>=90 ";
		}
		
		if(classId !=999)
			query +=" and feeticketStuClassId="+classId;
			
		if(levelId !=999)
			query +=" and feeticketStuLevelId="+levelId;
		String orderString="";
    	switch(orderBy)
    	{
    		case 1: orderString=" order by feeticketFeenumberId desc";
    			break;	
    		case 2: orderString=" order by feeticketFeenumberId ";
    			break;
    		case 3: orderString=" order by feeticketStuId ";
    			break;	
    		case 4: orderString=" order by feeticketStuId descClassesMoney";
    			break;
    		default:
    			orderString=" order by id ";
    			break;	
    	}
	       
		Object[] objs = bigr.retrieve(query,orderString);
	        
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

    public Feeticket[] getFeeticketByClassStatus2(Date oMonth,int orderBy,int status,int classId,int levelId)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query=" feeticketMonth ='"+df.format(oMonth)+"/01'";
	
		if(status !=0)
		{
			if(status==1)
				query +=" and feeticketStatus='1'";
            else if(status==2)
                query +=" and feeticketStatus='2'";
			else if(status==90)
				query +=" and feeticketStatus>='90'";
		}
		
		if(classId !=999)
			query +=" and feeticketStuClassId="+classId;
			
		if(levelId !=999)
			query +=" and feeticketStuLevelId="+levelId;
		String orderString="";
    	switch(orderBy)
    	{
    		case 1: orderString=" order by feeticketFeenumberId desc";
    			break;	
    		case 2: orderString=" order by feeticketFeenumberId ";
    			break;
    		case 3: orderString=" order by feeticketStuId ";
    			break;	
    		case 4: orderString=" order by feeticketStuId descClassesMoney";
    			break;
    		default:
    			orderString=" order by id ";
    			break;	
    	}
	       
		Object[] objs = bigr.retrieve(query,orderString);
	        
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
    public boolean getAllFeeticket(Date oMonth)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query=" feeticketMonth ='"+df.format(oMonth)+"/01'";

		String orderString="";

		Object[] objs = bigr.retrieve(query,orderString);
	        
        if (objs==null || objs.length==0)
	 	{	
            return false;
        }else{
            return true;                     
        }
    }
    public boolean getEditFeeticket(Date oMonth)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query=" feeticketMonth ='"+df.format(oMonth)+"/01' and feeticketLock!='0'";

		String orderString="";

		Object[] objs = bigr.retrieve(query,orderString);
	        
        if (objs==null || objs.length==0)
	 	{	
              return true;        

        }else{
              return false;        
        }
    }
    
    public boolean resetFeeicket(Date oMonth)
    {
        FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query=" feeticketMonth ='"+df.format(oMonth)+"/01'";

		String orderString="";

		Object[] objs = bigr.retrieve(query,orderString);
	     
        if (objs!=null && objs.length>0)
	 	{	
            Feeticket u =null;

            for (int i=0; i<objs.length; i++)
            {
                u= (Feeticket)objs[i];
                
                bigr.remove(u.getId());
            }
        }
        
        ClassesFeeMgr cfmr = ClassesFeeMgr.getInstance();

        String query2=" classesFeeMonth ='"+df.format(oMonth)+"/01'";
    	
        Object[] objs2 = cfmr.retrieve(query2,"");
	            
        ClassesFee u2 =null;
        if (objs2!=null && objs2.length>0)
	 	{            
            for (int i=0; i<objs2.length; i++)
            {
                u2= (ClassesFee)objs2[i];
                cfmr.remove(u2.getId());   
            }
        }
        
   	
    	CfDiscountMgr cfgr = CfDiscountMgr.getInstance();
		
		String query3=" cfDiscountMonth ='"+df.format(oMonth)+"/01'";
	       
		Object[] objs3 = cfgr.retrieve(query3,"");
            
        CfDiscount u3 =null;
	        
        if (objs3!=null && objs3.length>0)
	 	{	                	
            for (int i=0; i<objs3.length; i++)
            {
                u3 = (CfDiscount)objs3[i];
                cfgr.remove(u3.getId());
            }
        }
            
    	ClassesChargeMgr ccgr = ClassesChargeMgr.getInstance();
	    String query4=" classesChargeMonth ='"+df.format(oMonth)+"/01'";
        Object[] objs4 = ccgr.retrieve(query4,"");
        
        ClassesCharge u4 =null;
        if (objs4!=null && objs4.length>0)
        {
            for (int i=0; i<objs4.length; i++)
            {
                u4 = (ClassesCharge)objs4[i];
                ccgr.remove(u4.getId());
            }
        }

        return true;
    }

    public ClassesFee[] getAllClassesFee(Date oMonth)
    {
    	
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		
		String query=" classesFeeMonth ='"+df.format(oMonth)+"/01'";
	       
		Object[] objs = bigr.retrieve(query,"");
	        
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
    
      public ClassesFee[] getClassesFeeByStudent(Student stu)
    {
    	
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
		String query=" classesFeeStudentId ='"+stu.getId()+"'";
	       
		Object[] objs = bigr.retrieve(query,"");
	        
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
    
      public CfDiscount[] getAllCfDiscount(Date oMonth)
    {
    	
    	CfDiscountMgr bigr = CfDiscountMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		
		String query=" cfDiscountMonth ='"+df.format(oMonth)+"/01'";
	       
		Object[] objs = bigr.retrieve(query,"");
	        
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
 
    public ClassesFee[] getClassesFeeByClassLevel(Date oMonth,int cmId,int classId,int levelId)
    {
    	
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	String query=" classesFeeMonth ='"+df.format(oMonth)+"/01' and classesFeeCMId="+cmId;
	
	if(classId !=999)
		query +=" and classesFeeStuClassId="+classId;
		
	if(levelId !=999)
		query +=" and classesFeeStuLevelId="+levelId;
	String orderString="";
	       
	Object[] objs = bigr.retrieve(query,orderString);
	        
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
 
    public Feeticket[] getAllFeeticket()
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
	       
	Object[] objs = bigr.retrieve("","");
	        
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
 
    public ClassesFee[] getAllClassesFee()
    {
    	
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
	       
	Object[] objs = bigr.retrieve("","");
	        
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
 
 
     public Feeticket[] getFeeticketByStuID(Date oMonth,int stuId)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query=" feeticketMonth ='"+df.format(oMonth)+"/01' and feeticketStuId="+stuId;
	
		Object[] objs = bigr.retrieve(query,"");
	        
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
    
    public PayFee[] getPayFeeByDate(Date runMonth)
    {
    	JsfTool jt=JsfTool.getInstance();
		String chineseMonth=jt.getChineseMonth(runMonth);	
    	
    	PayFeeMgr bigr = PayFeeMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	
		String query=" payFeeFeenumberId like '"+chineseMonth+"%'";
			
		Object[] objs = bigr.retrieve(query,"");
	        
        if (objs==null || objs.length==0)
	 	{	
            	return null;
        }
        
        PayFee[] u =new PayFee[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (PayFee)objs[i];
        }
        return u;
    }
    
    public Feeticket[] getFeeticketByStuID(Date oMonth,int stuId,int status)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	
		String query=" feeticketMonth ='"+df.format(oMonth)+"/01' and feeticketStuId="+stuId;
			
		if(status !=0)
		{
			if(status==1)
				query +=" and feeticketStatus>='1' and feeticketStatus <='2' ";
			else if(status==90)
				query +=" and feeticketStatus>=90 ";
		}	
			
		Object[] objs = bigr.retrieve(query,"");
	        
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
     public Feeticket[] getFeeticketByOnlyStuID(int stuId,int orderInt)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        
		String query="feeticketStuId="+stuId;
		String orderx="";
		if(orderInt==1)
			orderx=" order by feeticketMonth desc";
		else if(orderInt==2)
			orderx=" order by feeticketMonth";
		else if(orderInt==3)
			orderx=" order by feeticketStatus desc";     
		else if(orderInt==4)
			orderx=" order by feeticketStatus";  
        	
        /*	 
        else if(orderInt==5)
        	orderx=" order by studentVisitDate";   
        else if(orderInt==6)
        	orderx=" order by studentVisitDate desc";   
        else if(orderInt==7)
        	orderx=" order by studentTryDate";   
        else if(orderInt==8)
        	orderx=" order by studentTryDate desc";  
	  */     
	Object[] objs = bigr.retrieve(query,orderx);
	        
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
    
     public Feeticket[] getNotPayFeeticketByStuID(int stuId)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
		String query="feeticketStuId="+stuId+" and feeticketStatus <90";
		String orderx=" order by feeticketMonth desc";
        	
         
		Object[] objs = bigr.retrieve(query,orderx);
	        
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
    
    public TalentTeacher[] getTalentTeacher(int talentId)
    {
    	TalentTeacherMgr bigr = TalentTeacherMgr.getInstance();
		String query="talentTeacherTalentId="+talentId;
		Object[] objs = bigr.retrieve(query,"");
	        
        if (objs==null || objs.length==0)
	 	{	
            	return null;
        }
        
        TalentTeacher[] u =new TalentTeacher[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (TalentTeacher)objs[i];
        }
        return u;
    }
    
    public TalentTeacher[] getTalentTeacherByTeacherId(int teacherId)
    {
    	TalentTeacherMgr bigr = TalentTeacherMgr.getInstance();
		String query="talentTeacherTeacherId="+teacherId;
		Object[] objs = bigr.retrieve(query,"");
	        
        if (objs==null || objs.length==0)
	 	{	
            	return null;
        }
        
        TalentTeacher[] u =new TalentTeacher[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (TalentTeacher)objs[i];
        }
        return u;
    }
    
    
    public TalentTeacher[] getActiveTalentTeacher(int talentId)
    {
    	TalentTeacherMgr bigr = TalentTeacherMgr.getInstance();
		String query="talentTeacherTalentId="+talentId+" and talentTeacherActive='1'";
		Object[] objs = bigr.retrieve(query,"");
	        
        if (objs==null || objs.length==0)
	 	{	
            	return null;
        }
        
        TalentTeacher[] u =new TalentTeacher[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (TalentTeacher)objs[i];
        }
        return u;
    }
    
    public PayAtm[] getFailPayAtm()
    {
    	
    	PayAtmMgr bigr = PayAtmMgr.getInstance();
        
        
	String query="payAtmStatus<90";
	
	       
	Object[] objs = bigr.retrieve(query,"");
	        
         if (objs==null || objs.length==0)
	 {	
            	return null;
         }
        
        PayAtm[] u =new PayAtm[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (PayAtm)objs[i];
        }
        
        
        
        return u;
    }
    
    public PayStore[] getFailPayStore()
    {
    	
    	PayStoreMgr bigr = PayStoreMgr.getInstance();
        
        
	String query="payStoreStatus<90";
	
	       
	Object[] objs = bigr.retrieve(query,"");
	        
         if (objs==null || objs.length==0)
	 {	
            	return null;
         }
        
        PayStore[] u =new PayStore[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (PayStore)objs[i];
        }
        
        return u;
    }
    
     public PayFee[] getPayFeeByNumberId(int numberId)
    {
    	
    	PayFeeMgr bigr = PayFeeMgr.getInstance();
        
        
	String query="payFeeFeenumberId='"+numberId+"'";
	
	       
	Object[] objs = bigr.retrieve(query,"");
	        
         if (objs==null || objs.length==0)
	 {	
            	return null;
         }
        
        PayFee[] u =new PayFee[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (PayFee)objs[i];
        }
        
        
        
        return u;
    }
    
    public ClassesCharge[] getClassesChargeByCMId(int cmId,boolean active)
    {
    	String query="";
    	
    	if(active)
    		query="classesChargeCMId='"+cmId+"' and classesChargeActive='1'";
    	else
    		query="classesChargeCMId='"+cmId+"'";
    	
    	ClassesChargeMgr bigr = ClassesChargeMgr.getInstance();
        
        Object[] objs = bigr.retrieve(query," order by classesChargeMonth desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesCharge[] u =new ClassesCharge[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesCharge)objs[i];
        }
        
        return u;	
    		
    }
    
    public DiscountType[] getAllDiscountType(String space)
    {
    	String query="";
    	
    	
    	DiscountTypeMgr bigr = DiscountTypeMgr.getInstance();
        
        Object[] objs = bigr.retrieveX(query,null, space);
        
        if (objs==null || objs.length==0)
            return null;
        
        DiscountType[] u =new DiscountType[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (DiscountType)objs[i];
        }
        
        return u;	
    		
    }
    
     public DiscountType[] getAactiveDiscountType()
    {
    	String query="discountTypeActive='1'";
    	
    	
    	DiscountTypeMgr bigr = DiscountTypeMgr.getInstance();
        
        Object[] objs = bigr.retrieve(query,null);
        
        if (objs==null || objs.length==0)
            return null;
        
        DiscountType[] u =new DiscountType[objs.length];
    	
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (DiscountType)objs[i];
        }
        
        return u;	
    		
    }
    public Student[] getNewStudent(int orderChooce, String space)
    {
    	StudentMgr bigr = StudentMgr.getInstance();
        
        String query="studentStatus <3";
        String orderx="";
        if(orderChooce==1)
		orderx=" order by id desc";
	else if(orderChooce==2)
		orderx=" order by id";
	else if(orderChooce==3)
		orderx=" order by studentStatus desc";     
        else if(orderChooce==4)
        	orderx=" order by studentStatus";   
        else if(orderChooce==5)
        	orderx=" order by studentVisitDate";   
        else if(orderChooce==6)
        	orderx=" order by studentVisitDate desc";   
        else if(orderChooce==7)
        	orderx=" order by studentTryDate";   
        else if(orderChooce==8)
        	orderx=" order by studentTryDate desc";  
        
        Object[] objs = bigr.retrieveX(query, orderx, space);
        
        if (objs==null || objs.length==0)
            return null;
        
        Student[] u =new Student[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Student)objs[i];
        }
        
        
        return u;
    }
     public Student[] getLeaveStudents(int status,int classId,int departId,int level,int orderNum)
    {
    	StudentMgr bigr = StudentMgr.getInstance();
    	
    	String orderString="";
    	
    	switch(orderNum)
    	{
    		case 1: orderString=" order by studentSex desc";
    			break;	
    		case 2: orderString=" order by studentSex ";
    			break;	
    		case 3: orderString=" order by studentDepart desc";
    			break;	
    		case 4: orderString=" order by studentDepart ";
    			break;	
    		case 5: orderString=" order by studentClassId desc";
    			break;	
    		case 6: orderString=" order by studentClassId ";
    			break;	
    		case 7: orderString=" order by studentStatus desc";
    			break;	
    		case 8: orderString=" order by studentStatus ";
    			break;	
    		case 9: orderString=" order by studentBirth desc";
    			break;	
    		case 10: orderString=" order by studentBirth ";
    			break;
    		default:
    			orderString=" order by id ";
    			break;	
    	
    	}
    	
        String query="";
        
        
        if(status==0)
        	query="studentStatus > 89 and studentStatus < 100 ";
        else
        	query="studentStatus ='"+status+"' ";
        
        
       	if(departId!=0)
       	{
        		query=query+"and studentDepart ='"+departId+"'";	
       	}
       
        if(classId !=0)
        {
        		query=query+"and studentClassId ='"+classId+"'";	
        }
       
        if(level != 0)
        {
			query=query+"and studentLevel ='"+level+"'";	
	}
        Object[] objs = bigr.retrieve(query, orderString);
        
        if (objs==null || objs.length==0)
            return null;
        
        Student[] u =new Student[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Student)objs[i];
        }
        
        
        return u;
    }	
     
    public Student[] getSameNameStudents(String sameName,int type, String space)
    {
    	StudentMgr bigr = StudentMgr.getInstance();
    	
    	String orderString="";
    	
        String query="";
        
        if(type==1)
        {
            query="studentName like '"+sameName+"%'"; 
        }else if(type==2){
            query="studentIDNumber like '"+sameName+"%'"; 
        }        

        
        Object[] objs = bigr.retrieveX(query, orderString, space);
        
        if (objs==null || objs.length==0)
            return null;
        
        Student[] u =new Student[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Student)objs[i];
        }
        return u;
    }

    public Student[] getStatusStudyStudents(int status,int classId,int departId, int level, int orderNum)
    {
    	StudentMgr bigr = StudentMgr.getInstance();
    	
    	String orderString="";
    	
    	switch(orderNum)
    	{
    		case 1: orderString=" order by studentSex desc";
    			break;	
    		case 2: orderString=" order by studentSex ";
    			break;	
    		case 3: orderString=" order by studentDepart desc";
    			break;	
    		case 4: orderString=" order by studentDepart ";
    			break;	
    		case 5: orderString=" order by studentClassId desc";
    			break;	
    		case 6: orderString=" order by studentClassId ";
    			break;	
    		case 7: orderString=" order by studentLevel desc";
    			break;	
    		case 8: orderString=" order by studentLevel ";
    			break;	
    		case 9: orderString=" order by studentBirth desc";
    			break;	
    		case 10: orderString=" order by studentBirth ";
    			break;
    		default:
    			orderString=" order by id desc";
    			break;	
    	
    	}
    	
        String query="";

        switch (status)
        {
            case 999:
                query="studentStatus <'100' ";
                break;
            case 1:
                query="(studentStatus ='1' or studentStatus ='2') ";                 
                break;
            case 2:
                query="(studentStatus ='3' or studentStatus ='4') ";                     
                break;
            case 3:
                query=" studentStatus ='99' ";                     
                break;
            case 4:
                query=" studentStatus ='97' ";                     
                break;
            case 5:
                query=" studentStatus ='98' ";                     
                break;
        }

       	if(departId!=999)
       	{
        		query=query+" and studentDepart ='"+departId+"'";	
       	}
       
        if(classId !=999)
        {
            query+=" and studentClassId ='"+classId+"'";	
        }

        if(level != 999)
        {
            query=query+" and studentLevel ='"+level+"'";	
        }

        Object[] objs = bigr.retrieve(query, orderString);
        
        if (objs==null || objs.length==0)
            return null;
        
        Student[] u =new Student[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Student)objs[i];
        }
        
        return u;
    }

    public String getStudentMoblieList(PaySystem ps,Student stu)
    {
        
        String mobileData="";
        if(ps.getPaySystemMessageTo()==0)
        {
            switch(stu.getStudentEmailDefault())
            {
                case 0:

                    Contact[] cons=getAllContact(stu.getId());
                    
                    if(cons !=null)
                    {
                        int raId=cons[0].getContactReleationId();
                        RelationMgr rm=RelationMgr.getInstance();
                        Relation ra=(Relation)rm.find(raId);
                        mobileData=ra.getRelationName()+":";
                        mobileData+=cons[0].getContactMobile();
                    }
                    break;
                case 1:								
                    mobileData="父:";
                    mobileData+=stu.getStudentFatherMobile();
                    break;
                case 2:
                    mobileData="母:";								
                    mobileData+=stu.getStudentMotherMobile();
                    break;	
            }
        }else{
            
            mobileData="<br>父: ";
            mobileData+=stu.getStudentFatherMobile()+"<br>";
            mobileData+="母: ";								
            mobileData+=stu.getStudentMotherMobile();
        }
        
        return mobileData;
    }

    public Student[] getStudyStudents(int classId, int groupId, int departId, int level, int orderNum)
    {
    	StudentMgr bigr = StudentMgr.getInstance();
    	
    	String orderString="";
    	
    	switch(orderNum)
    	{
    		case 1: orderString=" order by studentSex desc";
    			break;	
    		case 2: orderString=" order by studentSex ";
    			break;	
    		case 3: orderString=" order by studentDepart desc";
    			break;	
    		case 4: orderString=" order by studentDepart ";
    			break;	
    		case 5: orderString=" order by studentClassId desc";
    			break;	
    		case 6: orderString=" order by studentClassId ";
    			break;	
    		case 7: orderString=" order by studentLevel desc";
    			break;	
    		case 8: orderString=" order by studentLevel ";
    			break;	
    		case 9: orderString=" order by studentBirth desc";
    			break;	
    		case 10: orderString=" order by studentBirth ";
    			break;
    		default:
    			orderString=" order by id desc";
    			break;	
    	
    	}
    	
        String query="(studentStatus ='3' or studentStatus ='4') ";
        
       	if(departId!=999)
       	{
        		query=query+" and studentDepart ='"+departId+"'";	
       	}
       
        if(classId !=999)
        {
            query+=" and studentClassId ='"+classId+"'";	
        }

        if (groupId!=999 && groupId!=0)
            query += " and studentGroupId = " + groupId;
       
        if(level != 999)
        {
            query=query+" and studentLevel ='"+level+"'";	
        }

        Object[] objs = bigr.retrieve(query, orderString);
        
        if (objs==null || objs.length==0)
            return null;
        
        Student[] u =new Student[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Student)objs[i];
        }
        
        return u;
    }

    

    public Student[] getStudyStudents(int classId,int departId,int level,int orderNum)
    {
        return getStudyStudents(classId, 999, departId, level, orderNum);
    }
    
    public Student[] searchStudent(String searchWord,int classId,int groupId,int departId,int level,int orderNum,int status)
    {
        if (1==1)
            throw new RuntimeException("obsolete, use jsfAdmin.searchStudent");

    	StudentMgr bigr = StudentMgr.getInstance();
    	
    	String orderString="";
    	
        switch(orderNum)
    	{
    		case 1: orderString=" order by studentSex desc";
    			break;	
    		case 2: orderString=" order by studentSex ";
    			break;	
    		case 3: orderString=" order by studentDepart desc";
    			break;	
    		case 4: orderString=" order by studentDepart ";
    			break;	
    		case 5: orderString=" order by studentClassId desc";
    			break;	
    		case 6: orderString=" order by studentClassId ";
    			break;	
    		case 7: orderString=" order by studentLevel desc";
    			break;	
    		case 8: orderString=" order by studentLevel ";
    			break;	
    		case 9: orderString=" order by studentBirth desc";
    			break;	
    		case 10: orderString=" order by studentBirth ";
    			break;
    		default:
    			orderString=" order by id desc";
    			break;	
    	
    	}


        String query="";
        
        if(status==999)
            query="(studentStatus ='3' or studentStatus ='4')";
        else
            query=" studentStatus ='"+status+"' ";

        
        
        if(departId!=999)
        {
            query+=" and studentDepart ='"+departId+"'";	
        }

        if(classId!=999)
        {
            query+=" and studentClassId ='"+classId+"'";	
        }
        
        if(level != 999)
        {
            query+=" and studentLevel ='"+level+"'";	
	    }

        if (groupId!=0)
            query += " and studentGroupId=" + groupId;

        if(searchWord !=null && searchWord.length()>=1)
        {
            query+=" and (";
            query+=" id like '"+searchWord+"%'";
            query+=" or studentName like '%"+searchWord+"%'";            
            query+=" or studentNickname like '%"+searchWord+"%'";
            query+=" or studentIDNumber like '%"+searchWord+"%'";
            query+=" or studentFather like '%"+searchWord+"%'";                 
            query+=" or studentMother like '%"+searchWord+"%'";                
            query+=" or studentFatherMobile like '%"+searchWord+"%'";
            query+=" or studentFatherMobile2 like '%"+searchWord+"%'"; 
            query+=" or studentMotherMobile like '%"+searchWord+"%'";                        
            query+=" or studentMotherMobile2 like '%"+searchWord+"%'";
            query+=" or studentFatherEmail like '%"+searchWord+"%'";
            query+=" or studentMotherEmail like '%"+searchWord+"%'";    
            query+=" or studentPhone like '%"+searchWord+"%'";
            query+=" or studentPhone2 like '%"+searchWord+"%'";
            query+=" or studentPhone2 like '%"+searchWord+"%'";
            query+=" or studentAddress like '%"+searchWord+"%'";
            query+=" )";
        }

        Object[] objs = bigr.retrieve(query, orderString);
        
        if (objs==null || objs.length==0)
            return null;
        
        Student[] u =new Student[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Student)objs[i];
        }        
        return u;
    }
    

    public Tadent[] getTadentByTalentId(int talentId)
    {
    	TadentMgr bigr = TadentMgr.getInstance();
        
        String query="";
        
        query="tadentTalentId ='"+talentId+"'";		
       
        Object[] objs = bigr.retrieve(query,"");
        
        if (objs==null || objs.length==0)
            return null;
        
        Tadent[] u =new Tadent[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Tadent)objs[i];
        }
        return u;
    	
    } 
     
    public Tadent[] getTadentByStudent(Student stu)
    {
    	TadentMgr bigr = TadentMgr.getInstance();
        
        String query="";
        
        query="tadentStudentId ='"+stu.getId()+"'";		
       
        Object[] objs = bigr.retrieve(query,"");
        
        if (objs==null || objs.length==0)
            return null;
        
        Tadent[] u =new Tadent[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Tadent)objs[i];
        }
        return u;
    	
    }
 
      public Tadent[] getXactiveTadentByTalentId(int talentId,int active)
    {
    	TadentMgr bigr = TadentMgr.getInstance();
        
        String query="";
        if(active ==99 || active==1)
        	query="tadentTalentId ='"+talentId+"' and tadentActive='"+active+"'";
        else
        	query="tadentTalentId ='"+talentId+"' and tadentActive !=1 and tadentActive !=99";		


        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Tadent[] u =new Tadent[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Tadent)objs[i];
        }
        return u;
    	
    }
    
    public ClassesCharge getClassesCharge(Date searchDate,int cmId)
    {
    	ClassesChargeMgr bigr = ClassesChargeMgr.getInstance();
    	
	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	String query=" classesChargeMonth ='"+df.format(searchDate)+"/01' and classesChargeCMId='"+cmId+"' and classesChargeCategory=2";
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        return (ClassesCharge)objs[0];
    }

    public ClassesCharge[] getClassesChargeByClass(Date searchDate,int cmId,int classId, int category)
    {
    	ClassesChargeMgr bigr = ClassesChargeMgr.getInstance();
    	
    	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	    String query=" classesChargeMonth ='"+df.format(searchDate)+"/01' and classesChargeCMId='"+
            cmId+"' and classesChargexId="+classId +        
            " and classesChargeCategory="+category;
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesCharge[] ret = new ClassesCharge[objs.length];
        for (int i=0; i<objs.length; i++)
            ret[i] = (ClassesCharge) objs[i];
        
        return ret;
    }
    
    public ClassesCharge getClassesChargeByClass(Date searchDate,int cmId,int classId, int groupId, int category)
    {
    	ClassesChargeMgr bigr = ClassesChargeMgr.getInstance();
    	
    	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	    String query=" classesChargeMonth ='"+df.format(searchDate)+"/01' and classesChargeCMId='"+
            cmId+"' and classesChargexId="+classId+ " and classesChargeYId=" + groupId +        
            " and classesChargeCategory="+category;
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        return (ClassesCharge)objs[0];
    }
    
    public ClassesFee[] getClassesFeeByChargeId(Date searchDate,int chargeId)
    {
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
    	
    	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	    String query=" classesFeeMonth ='"+df.format(searchDate)+"/01' and classesFeeChargeId='"+chargeId+"'";
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesFee[] u =new ClassesFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }
       
        return u;
    }
    
  
     public ClassesFee[] getClassesFeeBycmId(Date searchDate,int cmId)
    {
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
    	
	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	String query=" classesFeeMonth ='"+df.format(searchDate)+"/01' and classesFeeCMId='"+cmId+"'";
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesFee[] u =new ClassesFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }
       
        return u;
    }
	   	
    public ClassesFee[] getClassesFeeBycmIdClassId(Date searchDate,int cmId,int classId)
    {
        ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();

        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
        
        String query=" classesFeeMonth ='"+df.format(searchDate)+"/01' and classesFeeCMId='"+cmId+"' ";
    
        if(classId!=999)
            query+="and classesFeeStuClassId='"+classId+"'";

        Object[] objs = bigr.retrieve(query,"");

        if (objs==null || objs.length==0)
            return null;

        ClassesFee[] u =new ClassesFee[objs.length];

        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }

        return u;
    } 
 
    public ClassesCharge findLastCC(int cmId)
    {
        ClassesChargeMgr bigr = ClassesChargeMgr.getInstance();

        String query="classesChargeCMId='"+cmId+"' ";
        
        Object[] objs = bigr.retrieve(query," order by classesChargeMonth desc");

        if (objs==null || objs.length==0)
            return null;

        ClassesCharge cc=(ClassesCharge)objs[0];

        return cc;
    }

    public ClassesFee findLastCF(int cmId)
    {
        ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();

        String query="classesFeeCMId='"+cmId+"' ";
        
        Object[] objs = bigr.retrieve(query," order by classesFeeMonth desc");

        if (objs==null || objs.length==0)
            return null;

        ClassesFee cc=(ClassesFee)objs[0];

        return cc;
    }

    public ClassesFee[] getClassesFeeByClassChargeId(int ccId)
    {
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
        String query="";
        
        query="classesFeeChargeId ='"+ccId+"'";		
       
        Object[] objs = bigr.retrieve(query, "order by classesFeeStuClassId");
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesFee[] u =new ClassesFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }
        return u;
    	
    }
    
     public CfDiscount[] getCfDiscountByCfid(int cfId)
    {
    	CfDiscountMgr bigr = CfDiscountMgr.getInstance();
        
        String query="";
        
        query="cfDiscountClassesFeeId ='"+cfId+"'";		
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        CfDiscount[] u =new CfDiscount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (CfDiscount)objs[i];
        }
        return u; 	
    }
    
    public boolean deleteCfDiscountByCfidWithTranId(int cfId,int tran_Id)
    {
        try{
            CfDiscountMgr bigr =new CfDiscountMgr(tran_Id);
            
            String query="";
            
            query="cfDiscountClassesFeeId ='"+cfId+"'";		
           
            Object[] objs = bigr.retrieve(query,"");
            
            if (objs==null || objs.length==0)
                return true;
            
            CfDiscount[] u =new CfDiscount[objs.length];
            
            for (int i=0; i<objs.length; i++)
            {
                CfDiscount cf= (CfDiscount)objs[i];
                bigr.remove(cf.getId());
            }
            return true; 	
        }catch(Exception e){

	        try { Manager.rollback(tran_Id); } catch (Exception e2) {}
            return false;
        }

        
    }

     public CfDiscount[] getAllCfDiscount()
    {
    	CfDiscountMgr bigr = CfDiscountMgr.getInstance();
        
        String query="";
        
       
        Object[] objs = bigr.retrieve(query,"");
        
        if (objs==null || objs.length==0)
            return null;
        
        CfDiscount[] u =new CfDiscount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (CfDiscount)objs[i];
        }
        return u;
    	
    }
    public Tadent[] getTadentByStuId(int stuId,int talentId)
    {
    	TadentMgr bigr = TadentMgr.getInstance();
        
        String query="";
        
        query="tadentStudentId ='"+stuId+"' and tadentTalentId='"+talentId+"'";		
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Tadent[] u =new Tadent[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Tadent)objs[i];
        }
        return u;
    	
    }
    
    public Talentdate[] getTalentdateByTalentId(int talentId)
    {
    	TalentdateMgr bigr = TalentdateMgr.getInstance();
        
        String query="";
        
        query="talentdateTalentId ='"+talentId+"'";		
       
        Object[] objs = bigr.retrieve(query, "order by talentdateStartDate");
        
        if (objs==null || objs.length==0)
            return null;
        
        Talentdate[] u =new Talentdate[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Talentdate)objs[i];
        }
        return u;
    	
    }
    
    public Talentdate[] getTalentdateByTalentIdAfterNow(int talentId,Date newDate)
    {
    	TalentdateMgr bigr = TalentdateMgr.getInstance();
    
    	
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

		String query="";
        
        query="talentdateTalentId ='"+talentId+"' and talentdateStartDate >='"+sdf.format(newDate)+"'";		

        Object[] objs = bigr.retrieve(query, "order by talentdateStartDate");
        
        if (objs==null || objs.length==0)
            return null;
        
        Talentdate[] u =new Talentdate[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Talentdate)objs[i];
        }
        return u;
    	
    }
    
    public Talentdate[] getTalentdateByTalentIdAfterNow(int talentId)
    {
    	TalentdateMgr bigr = TalentdateMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	
    	 String query=" talentdateStartDate >='"+df.format(new Date())+"'";
        
        query+=" and talentdateTalentId ='"+talentId+"'";		
       
        Object[] objs = bigr.retrieve(query, "order by talentdateStartDate");
        
        if (objs==null || objs.length==0)
            return null;
        
        Talentdate[] u =new Talentdate[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Talentdate)objs[i];
        }
        return u;
    	
    }
    
     public boolean haveStudentByTalent(int talentId,int studentId)
    {
    	TadentMgr bigr = TadentMgr.getInstance();
        
        String query="";
        
        query="tadentTalentId ='"+talentId+"' and tadentStudentId='"+studentId+"'";		
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return false;
        else
           return true;
    }
    public ClassesFee[] getClassesFee(int classesFeeCMId,int classesFeeStudentId)
    {
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
        String query="";
        
        query="classesFeeCMId ='"+classesFeeCMId+"' and classesFeeStudentId='"+classesFeeStudentId+"'";		
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesFee[] u =new ClassesFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }
        return u;
    }
    
   
   public ClassesFee[] getClassesFeeByNumber(int feenumber)
    {
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
        String query="";
        
        query="classesFeeFeenumberId ="+feenumber+"";		
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesFee[] u =new ClassesFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }
        return u;
    }
    
    
   
   public ClassesFee[] getClassesFeeByStuId(int classesFeeStudentId)
    {
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
        String query="";
        
        query="classesFeeStatus !='99' and classesFeeStudentId='"+classesFeeStudentId+"'";		
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesFee[] u =new ClassesFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }
        return u;
    }      
 
  
 
 
  public ClassesFee[] getClassesFeeByStuIdx(int classesFeeStudentId)
    {
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
        String query="";
        
        query="classesFeeStatus ='99' and classesFeeStudentId='"+classesFeeStudentId+"'";		
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesFee[] u =new ClassesFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }
        return u;
    }      	
  public ClassesFee[] getClassesFeeByCmid(int classesFeeCMId)
    {
    	ClassesFeeMgr bigr = ClassesFeeMgr.getInstance();
        
        String query="";
        
        query="classesFeeCMId ='"+classesFeeCMId+"'";		
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        ClassesFee[] u =new ClassesFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (ClassesFee)objs[i];
        }
        return u;
    }
    
    public Student[] getAllStudentByClassId(int classId)
    {
    	StudentMgr bigr = StudentMgr.getInstance();
        
        String query="";
        
        query="studentClassId ='"+classId+"'";		
       
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Student[] u =new Student[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Student)objs[i];
        }
        return u;
    }
    
     public Relation[] getAllRelation(String space)
    {
    	RelationMgr bigr = RelationMgr.getInstance();
        
        String query="";
        
        Object[] objs = bigr.retrieveX(query, "", space);
        
        if (objs==null || objs.length==0)
            return null;
        
        Relation[] u =new Relation[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Relation)objs[i];
        }
        return u;
    }
    
      public Position[] getAllPosition()
    {
    	PositionMgr bigr = PositionMgr.getInstance();
        
        String query="";
        
        Object[] objs = bigr.retrieve(query, " order by positionPriority desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        Position[] u =new Position[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Position)objs[i];
        }
        return u;
    }
    
       public Place[] getAllPlace()
    {
    	PlaceMgr bigr = PlaceMgr.getInstance();
        
        Object[] objs = bigr.retrieve("", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Place[] u =new Place[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Place)objs[i];
        }
        return u;
    }
    
	public MessageType[] getAllMessageType(String space)
	{
		MessageTypeMgr bigr = MessageTypeMgr.getInstance();
		
		Object[] objs = bigr.retrieveX("", "", space);
		
		if (objs==null || objs.length==0)
		    return null;
		
		MessageType[] u =new MessageType[objs.length];
		
		for (int i=0; i<objs.length; i++)
		{
		    u[i] = (MessageType)objs[i];
		}
		return u;
	}
    public Place[] getAllActivePlace()
    {
    	PlaceMgr bigr = PlaceMgr.getInstance();
        
        Object[] objs = bigr.retrieve("placeActive=1", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Place[] u =new Place[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Place)objs[i];
        }
        return u;
    }
    
    public MessageType[] getActiveMessageType(String space)
    {
    	MessageTypeMgr bigr = MessageTypeMgr.getInstance();
        
        Object[] objs = bigr.retrieveX("messageTypeStatus=1", "", space);
        
        if (objs==null || objs.length==0)
            return null;
        
        MessageType[] u =new MessageType[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (MessageType)objs[i];
        }
        return u;
    }
    
    public Depart[] getAllDepart()
    {
    	DepartMgr bigr = DepartMgr.getInstance();
        
        String query="";
        
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Depart[] u =new Depart[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Depart)objs[i];
        }
        return u;
    }
    public Level[] getAllLevel()
    {
    	LevelMgr bigr = LevelMgr.getInstance();
        
        String query="";
        
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Level[] u =new Level[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Level)objs[i];
        }
        return u;
    }
    
    public Contact[] getAllContact(int stuId)
    {
    	ContactMgr bigr = ContactMgr.getInstance();
        
        String query="contactStuId='"+stuId+"'";
        
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Contact[] u =new Contact[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Contact)objs[i];
        }
        return u;
    }
    public Tcontact[] getAllTcontact(int stuId)
    {
    	TcontactMgr bigr = TcontactMgr.getInstance();
        
        String query="tcontactStuId='"+stuId+"'";
        
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Tcontact[] u =new Tcontact[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Tcontact)objs[i];
        }
        return u;
    }
    
    public String getStudentStatus(int status)
    {
    	String anserStatus="";
    	if(status==1)
    		anserStatus="等待入學";
    	else if(status==5)
    		anserStatus="試讀中";
    	else if(status==2)
    		anserStatus="在學中";
    	else if(status==3)
    		anserStatus="畢業";
    	else if(status==4)
    		anserStatus="休學";
    	else if(status==0)
    		anserStatus="其他";
    	return anserStatus;	
    }
    
    public User[] getAllUsers(String space)
    {
        UserMgr umgr = UserMgr.getInstance();
        
        Object[] objs = umgr.retrieveX("", "", space);
        
        if (objs==null || objs.length==0)
            return null;
        
        User[] u = new User[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (User)objs[i];
        }
        
        return u;
    }
    
     public User[] getAllRunUsers(String space)
    {
        UserMgr umgr = UserMgr.getInstance();
        
        Object[] objs = umgr.retrieveX("userRole != 1 and userRole != 6","", space);
        
        if (objs==null || objs.length==0)
            return null;
        
        User[] u = new User[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (User)objs[i];
        }
        
        return u;
    }

    public User[] getAccountUsers(String space)
    {
        UserMgr umgr = UserMgr.getInstance();
        
        Object[] objs = umgr.retrieveX("userRole != 1 and userRole != 6","", space);
        
        if (objs==null || objs.length==0)
            return null;
        
        User[] u = new User[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (User)objs[i];
        }
        
        return u;
    }
    
    public Message[] getAllMessage(User ud2,int fromId,int FromStatus,int ToStatus,
            int type,int orderInt,int active, String space)
    {
        MessageMgr umgr = MessageMgr.getInstance();
        
        String query="messageTo="+ud2.getId();
        
        if(fromId !=999)
			query +=" and messageFrom="+fromId;
		
		if(FromStatus !=999)
			query += " and messageFromStatus="+FromStatus;
		
		if(ToStatus !=999)
			query +=" and messageToStatus="+ToStatus;
						        
		if(type !=999)
			query +=" and messageType="+type;
			
		if(active!=999)
			query +=" and messageActive="+active;
			 
		String orderString=" order by created desc";
		
		if(orderInt!=999)
		{
			switch(orderInt){
				case 1:
					orderString=" order by created asc";
					break;
			}
			
		}						        
        Object[] objs = umgr.retrieveX(query, orderString, space);
        
        if (objs==null || objs.length==0)
            return null;
        
        Message[] u = new Message[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Message)objs[i];
        }
        
        return u;
    } 
    
  	 public Message[] getNotHandleMessage(User ud2)
    {
        MessageMgr umgr = MessageMgr.getInstance();
        
        String query="messageTo="+ud2.getId()+" and messageToStatus<2 and messageActive=0";
        
		String orderString=" order by created desc";
		
        Object[] objs = umgr.retrieve(query, orderString);
        
        if (objs==null || objs.length==0)
            return null;
        
        Message[] u = new Message[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Message)objs[i];
        }
        
        return u;
    } 
    
    public Message[] getStudentMessage(int type,int xId)
    {
        MessageMgr umgr = MessageMgr.getInstance();
		
		String query="messagePersonType="+type+" and messagePersonId="+xId; 
		

		String orderString=" order by created desc";
		
        Object[] objs = umgr.retrieve(query, orderString);
        
        if (objs==null || objs.length==0)
            return null;
        
        Message[] u = new Message[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Message)objs[i];
        }
        
        return u;
    }

  
     public User[] getManagerUsers()
    {
        UserMgr umgr = UserMgr.getInstance();
        
        Object[] objs = umgr.retrieve("userRole='manager'", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        User[] u = new User[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (User)objs[i];
        }
        
        return u;
    }
    
    public User[] getLogUsers()
    {
        UserMgr umgr = UserMgr.getInstance();
        
        Object[] objs = umgr.retrieve("userRole !='admin' and userRole !='teacher'", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        User[] u = new User[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (User)objs[i];
        }
        
        return u;
    }
    
     public User getUserById(int id)
    {
        UserMgr umgr = UserMgr.getInstance();
        
        Object[] objs = umgr.retrieve("id='"+id+"'", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        User u = (User)objs[0];
        
        return u;
    }
    
    
    public boolean vefiryUser(int id,String pass)
    {
        UserMgr umgr = UserMgr.getInstance();
        
        Object[] objs = umgr.retrieve("id='"+id+"' and userPassword='"+pass+"'", null);
        
        if (objs==null || objs.length==0)
            return false;
        
        return true;
    }
    
     public Classes[] getAllClasses()
    {
        ClassesMgr umgr = ClassesMgr.getInstance();
        
        Object[] objs = umgr.retrieve("classesStatus =1", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Classes[] u = new Classes[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Classes)objs[i];
        }
        
        return u;
    }        
    
    public Classes[] getAllClasses2()
    {
        ClassesMgr umgr = ClassesMgr.getInstance();
        
        Object[] objs = umgr.retrieve("", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        Classes[] u = new Classes[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Classes)objs[i];
        }
        
        return u;
    }        
    public String getClassById(int classId)
    {
    	ClassesMgr cm=ClassesMgr.getInstance();
    	
    	String rWord="";
    	
    	if(classId==0)
    	{
    		return "未定";	
    	}
    	Classes cla=(Classes)cm.find(classId);

	return cla.getClassesName();
    	
    }
    
    public String getLevelById(int id)
    {
    	String rWord="";
    	
    	if(id==1)
    		rWord="幼幼班";
    	else if(id==2)
    		rWord="小班";
    	else if(id==3)
    		rWord="中班";
    	else if(id==4)
    		rWord="大班";
    	return rWord;			
    	
    }
    
    public IncomeBigItem[] getAllIncomeBigItem()
    {
    	IncomeBigItemMgr bigr = IncomeBigItemMgr.getInstance();
        
        Object[] objs = bigr.retrieve(null, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        IncomeBigItem[] u = new IncomeBigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (IncomeBigItem)objs[i];
        }
        
        return u;
    }
    
    public PayFee[] getPayFee(int cfId,int stuId)
    {
    	PayFeeMgr bigr = PayFeeMgr.getInstance();
        
        Object[] objs = bigr.retrieve("payFeeCFId='"+cfId+"' and payFeeStudentId='"+stuId+"'", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        PayFee[] u = new PayFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (PayFee)objs[i];
        }
        
        return u;
    }
    
    public int getPayFeeNumber(int cfId,int stuId)
    {
    	PayFeeMgr bigr = PayFeeMgr.getInstance();
        
        Object[] objs = bigr.retrieve("payFeeCFId='"+cfId+"' and payFeeStudentId='"+stuId+"'", null);
        
        if (objs==null || objs.length==0)
            return 0;
        
        PayFee[] u = new PayFee[objs.length];
        
        int payTotal=0;
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (PayFee)objs[i];
        
            payTotal +=u[i].getPayFeeMoneyNumber();	
        }
        return payTotal;
    }
     public Teacher[] getAllTeacher(int status,int depart,int position,int classes,int level,int orderNum)
    {
    	TeacherMgr tm=TeacherMgr.getInstance();
    	
    	String query="";
    	
    	
    	if(status !=99)
    		query=" teacherStatus='"+status+"'";
    	
    	if(depart !=0)
    	{
    		if(query.equals("")) 
    			query=" teacherDepart='"+depart+"'";
    		else
    			query=query+" and teacherDepart='"+depart+"'";	
    	}
    	if(position !=0)
    	{
    		if(query.equals("")) 
    			query=" teacherPosition='"+position+"'";
    		else
    			query=query+" and teacherPosition='"+position+"'";	
    	}
    	if(classes !=0)
    	{
    		if(query.equals("")) 
    			query=" teacherClasses='"+classes+"'";
    		else
    			query=query+" and teacherClasses='"+classes+"'";	
    	}
    	
    	if(level !=0)
    	{
    		if(query.equals("")) 
    			query=" teacherLevel='"+level+"'";
    		else
    			query=query+" and teacherLevel='"+level+"'";	
    	}
    	
    	String orderString="";
    	/*
    	
    	
    	switch(orderNum)
    	{
    		case 1:orderString=" order by teacherDepart "; 	
    			break;
    		case 2:orderString=" order by teacherDepart desc"; 	
    			break;	
    		case 3:orderString=" order by teacherPosition "; 	
    			break;
    		case 4:orderString=" order by teacherPosition desc"; 	
    			break;	
    		case 5:orderString=" order by teacherClasses "; 	
    			break;
    		case 6:orderString=" order by teacherClasses desc"; 	
    			break;	
    		case 7:orderString=" order by teacherComeDate "; 	
    			break;
    		case 8:orderString=" order by teacherComeDate desc"; 	
    			break;	
    		case 9:orderString=" order by teacherStatus "; 	
    			break;
    		case 10:orderString=" order by teacherStatus desc"; 	
    			break;		
    	}
    	*/
    	
    	Object[] o=tm.retrieve(query,orderString);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	Teacher[] tea=new Teacher[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(Teacher)o[i];
    	
    	return tea;
    		
    }  
    
    public Teacher[] getActiveTeacherAdvanced(int partTime,int depart,int position,int classes)
    {
    	TeacherMgr tm=TeacherMgr.getInstance();
    	
    	String query=" teacherStatus>=1 and teacherStatus<=2 ";
    	
    	if(partTime !=999)
    		query+="and teacherParttime='"+partTime+"'";
    			
    	if(depart !=999)
    	{
    		query+=" and teacherDepart='"+depart+"'";	
    	}
    	
    	if(position !=999)
    	{
    		query+="and teacherPosition='"+position+"'";
    	}
    	
    	if(classes !=999)
    	{
    		query+=" and teacherClasses='"+classes+"'";	
    	}
   
    	String orderString=" order by created asc";
    	
    	Object[] o=tm.retrieve(query,orderString);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	Teacher[] tea=new Teacher[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(Teacher)o[i];
    	
    	return tea;
 		
    }

    public Teacher[] getActiveTeacher(int orderNum)
    {
    	TeacherMgr tm=TeacherMgr.getInstance();
    	
    	String query=" teacherStatus='1' or  teacherStatus='2' ";
    	String orderString="";
    	switch(orderNum)
    	{
    		case 1:orderString=" order by teacherDepart "; 	
    			break;
    		case 2:orderString=" order by teacherDepart desc"; 	
    			break;	
    		case 3:orderString=" order by teacherPosition "; 	
    			break;
    		case 4:orderString=" order by teacherPosition desc"; 	
    			break;	
    		case 5:orderString=" order by teacherClasses "; 	
    			break;
    		case 6:orderString=" order by teacherClasses desc"; 	
    			break;	
    		case 7:orderString=" order by teacherComeDate "; 	
    			break;
    		case 8:orderString=" order by teacherComeDate desc"; 	
    			break;	
    		case 9:orderString=" order by teacherStatus "; 	
    			break;
    		case 10:orderString=" order by teacherStatus desc"; 	
    			break;		
    	}
    	
    	
    	Object[] o=tm.retrieve(query,orderString);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	Teacher[] tea=new Teacher[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(Teacher)o[i];
    	
    	return tea;
    		
    }
    
      public Teacher[] getLeaveTeacher(int orderNum)
    {
    	TeacherMgr tm=TeacherMgr.getInstance();
    	
    	String query=" teacherStatus !='1' and teacherStatus !='2'";
    	String orderString="";
    	switch(orderNum)
    	{
    		case 1:orderString=" order by teacherDepart "; 	
    			break;
    		case 2:orderString=" order by teacherDepart desc"; 	
    			break;	
    		case 3:orderString=" order by teacherPosition "; 	
    			break;
    		case 4:orderString=" order by teacherPosition desc"; 	
    			break;	
    		case 5:orderString=" order by teacherClasses "; 	
    			break;
    		case 6:orderString=" order by teacherClasses desc"; 	
    			break;	
    		case 7:orderString=" order by teacherComeDate "; 	
    			break;
    		case 8:orderString=" order by teacherComeDate desc"; 	
    			break;	
    		case 9:orderString=" order by teacherStatus "; 	
    			break;
    		case 10:orderString=" order by teacherStatus desc"; 	
    			break;		
    	}
    	
    	
    	Object[] o=tm.retrieve(query,orderString);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	Teacher[] tea=new Teacher[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(Teacher)o[i];
    	
    	return tea;
    		
    }
    
    
    public Degree[] getAllDegree(String space)
    {
    	DegreeMgr tm=DegreeMgr.getInstance();
    	
    	Object[] o=tm.retrieveX("", "", space);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	Degree[] tea=new Degree[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(Degree)o[i];
    	
    	return tea;
    		
    }
    
    public LeaveReason[] getAllLeaveReason(String space)
    {
    	LeaveReasonMgr tm=LeaveReasonMgr.getInstance();
    	
    	Object[] o=tm.retrieveX("", "", space);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	LeaveReason[] tea=new LeaveReason[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(LeaveReason)o[i];
    	
    	return tea;
    		
    }
    
     public LeaveReason[] getActiveLeaveReason(String space)
    {
    	LeaveReasonMgr tm=LeaveReasonMgr.getInstance();
    	
    	Object[] o=tm.retrieveX("leaveReasonActive='1'",null, space);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	LeaveReason[] tea=new LeaveReason[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(LeaveReason)o[i];
    	
    	return tea;
    		
    }
     

	    
     public LeaveStudent[] getLeaveStudentByStuId(int stuId)
    {
    	LeaveStudentMgr tm=LeaveStudentMgr.getInstance();
    	
    	Object[] o=tm.retrieve("leaveStudentStudentId='"+stuId+"'",null);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	LeaveStudent[] tea=new LeaveStudent[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(LeaveStudent)o[i];
    	
    	return tea;
    		
    }
    
    public LeaveStudent[] getLeaveStudentByTime(Date sDate,Date eDate, String space)
    {
    	LeaveStudentMgr tm=LeaveStudentMgr.getInstance();
	
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
		long endDateL=eDate.getTime()+(long)1000*60*60*24;
		Date newEndDate=new Date(endDateL);
		
    	Object[] o=tm.retrieveX("created >='"+df.format(sDate)+"' and created < '"+df.format(eDate)+"'","", space);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	LeaveStudent[] tea=new LeaveStudent[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(LeaveStudent)o[i];
    	
    	return tea;
    		
    }
    
    
    public Degree[] getAllActiveDegree(String space)
    {
    	DegreeMgr tm=DegreeMgr.getInstance();
    	
    	Object[] o=tm.retrieveX("degreeActive='1'", "", space);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	Degree[] tea=new Degree[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(Degree)o[i];
    	
    	return tea;
    		
    }
    
    public TalentFile[] getAllTalentFileByTalentdate(int tdId)
    {
    	TalentFileMgr tm=TalentFileMgr.getInstance();
    	
    	Object[] o=tm.retrieve("talentFileTalentdateId="+tdId,null);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	TalentFile[] tea=new TalentFile[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(TalentFile)o[i];
    	
    	return tea;
    		
    }
    
    public TalentFile[] getTalentFile(int stuId,int tdId)
    {
    	TalentFileMgr tm=TalentFileMgr.getInstance();
    	
    	Object[] o=tm.retrieve("talentFileStudentId="+stuId+" and talentFileTalentdateId="+tdId,null);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	TalentFile[] tea=new TalentFile[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(TalentFile)o[i];
    	
    	return tea;
    		
    }
  
  	public TalentFile[] getTalentFileByStuIdWithtaId(int stuId,int taId)
    {
    	TalentFileMgr tm=TalentFileMgr.getInstance();
    	
    	Object[] o=tm.retrieve("talentFileStudentId="+stuId+" and talentFileTalentId="+taId," order by talentFileTalentdateId asc");	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	TalentFile[] tea=new TalentFile[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(TalentFile)o[i];
    	
    	return tea;
    		
    }
  
    
    public Talent[] getAllTalent()
    {
    	TalentMgr tm=TalentMgr.getInstance();
    	
    	Object[] o=tm.retrieve(null,null);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	Talent[] tea=new Talent[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(Talent)o[i];
    	
    	return tea;
    		
    }
    
    
   
     public Talent[] getActiveTalent()
    {
    	TalentMgr tm=TalentMgr.getInstance();
    	
    	Object[] o=tm.retrieve("talentActive=1",null);	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	Talent[] tea=new Talent[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(Talent)o[i];
    	
    	return tea;
    		
    }
    

	 public Talent[] getTalentByStatus(int status)
    {
    	TalentMgr tm=TalentMgr.getInstance();
    	
    	String query="";
    	
    	if(status !=999)
    	{
    		query="talentActive='"+status+"'";
    	}
    	Object[] o=tm.retrieve(query," order by created desc");	
    	
    	if(o==null || o.length==0)
    		return null;
    	
    	Talent[] tea=new Talent[o.length];
    	
    	for(int i=0;i<o.length;i++)
    		tea[i]=(Talent)o[i];
    	
    	return tea;
    		
    }
    
    
    
    public String getTeacherName(int id)
    {
    	String tname="";
    	TeacherMgr tm=TeacherMgr.getInstance();
    	Teacher tea=(Teacher)tm.find(id);	
    	
    	if(tea==null)
    		return tname;
    	
    	return tea.getTeacherFirstName()+" "+tea.getTeacherLastName();
    }
    

    public Income[] getIncomeByDate(Date startDate,Date endDate,int BigItem,int orderNum)
    {
    	IncomeMgr cm=IncomeMgr.getInstance();
    	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	
    	
    	String query="";
    	if(BigItem==0)
    		query=" incomeDate >='"+df.format(startDate)+"'"+
    		      " and incomeDate <='"+df.format(endDate)+"'";
    		      
    		
    	else
    		query=" incomeDate >='"+df.format(startDate)+"'"+
    		      " and incomeDate <='"+df.format(endDate)+"'"+
    		      " and incomeBigItem='"+BigItem+"'";
    		
    	
    	String orderString="";
    	switch(orderNum)
    	{
    		case 1:
    			orderString="order by incomeDate desc";
    			break;
    		case 2:
    			orderString="order by incomeDate";
    			break;
    		case 3:
    			orderString="order by incomeBigItem,incomeSmallItem desc";
    			break;
    		case 4:
    			orderString="order by incomeBigItem,incomeSmallItem";
    			break;
    		case 5:
    			orderString="order by incomeMoney desc";
    			break;
    		case 6:
    			orderString="order by incomeMoney";
    			break;
    		case 7:
    			orderString="order by incomePayWay desc";
    			break;
    		case 8:
    			orderString="order by incomePayWay";
    			break;
    		case 9:
    			orderString="order by incomeLog desc";
    			break;
    		case 10:
    			orderString="order by incomeLog";
    			break;
    		case 11:
    			orderString="order by incomeVerify desc";
    			break;
    		case 12:
    			orderString="order by incomeVerify";
    			break;
    		case 13:
    			orderString="order by created desc";
    			break;
    		case 14:
    			orderString="order by created";
    			break;
    	}
    	
    
    	
    	Object[] o=cm.retrieve(query,orderString);
    	
    	if(o==null || o.length ==0)
            return null;
            
        Income[] co=new Income[o.length];
        
        for(int i=0; i< o.length ;i++)
        {
            co[i]=(Income)o[i];   
        }
        return co;
    	
    }
     public Cost[] getCostByDate(Date startDate,Date endDate,int BigItem,int orderNum)
    {
    	CostMgr cm=CostMgr.getInstance();
    	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	
    	
    	String query="";
    	if(BigItem==0)
    		query=" costDate >='"+df.format(startDate)+"'"+
    		      " and costDate <='"+df.format(endDate)+"'";
    		      
    		
    	else
    		query=" costDate >='"+df.format(startDate)+"'"+
    		      " and costDate <='"+df.format(endDate)+"'"+
    		      " and costBigItem='"+BigItem+"'";
    		
    	
    	String orderString="";
    	switch(orderNum)
    	{
    		case 1:
    			orderString="order by costDate desc";
    			break;
    		case 2:
    			orderString="order by costDate";
    			break;
    		case 3:
    			orderString="order by costBigItem,costSmallItem desc";
    			break;
    		case 4:
    			orderString="order by costBigItem,costSmallItem";
    			break;
    		case 5:
    			orderString="order by costMoney desc";
    			break;
    		case 6:
    			orderString="order by costMoney";
    			break;
    		case 7:
    			orderString="order by costPayWay desc";
    			break;
    		case 8:
    			orderString="order by costPayWay";
    			break;
    		case 9:
    			orderString="order by costLog desc";
    			break;
    		case 10:
    			orderString="order by costLog";
    			break;
    		case 11:
    			orderString="order by costVerify desc";
    			break;
    		case 12:
    			orderString="order by costVerify";
    			break;
    		case 13:
    			orderString="order by created desc";
    			break;
    		case 14:
    			orderString="order by created";
    			break;
    	}
    	
    
    	
    	Object[] o=cm.retrieve(query,orderString);
    	
    	if(o==null || o.length ==0)
            return null;
            
        Cost[] co=new Cost[o.length];
        
        for(int i=0; i< o.length ;i++)
        {
            co[i]=(Cost)o[i];   
        }
        return co;
    	
    }

    public User createUser(User u) throws AlreadyExist
    {
        UserMgr umgr = UserMgr.getInstance();
        
        // check if loginId already existed
        User tmp = umgr.findLoginId(u.getUserLoginId());
        if (tmp!=null)
            throw new AlreadyExist();
        
        u.setId(umgr.createWithIdReturned(u));
        return u;
    }
    
    
    
     public InModify[] getAllInmodify(int incomeId)
    {
    	InModifyMgr imm=InModifyMgr.getInstance();
        
        Object[] objs = imm.retrieve("inModifyIncomeId="+incomeId," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        InModify[] u = new InModify[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (InModify)objs[i];
        }
        
        return u;
    }
    
     public CoModify[] getAllComodify(int incomeId)
    {
    	CoModifyMgr imm=CoModifyMgr.getInstance();
        
        Object[] objs = imm.retrieve("coModifyIncomeId="+incomeId," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        CoModify[] u = new CoModify[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (CoModify)objs[i];
        }
        
        return u;
    }
     public IncomeBigItem[] getAllIncomeActiveBigItem2()
    {
    	IncomeBigItemMgr bigr = IncomeBigItemMgr.getInstance();
        
        Object[] objs = bigr.retrieve("incomeBigItemActive=1 and id >=3", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        IncomeBigItem[] u = new IncomeBigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (IncomeBigItem)objs[i];
        }
        
        return u;
    }		

    public TfContent[] getTfContnet(int tfId)
    {
    	TfContentMgr bigr = TfContentMgr.getInstance();
        
        Object[] objs = bigr.retrieve("tfContentTalentFileId="+tfId, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        TfContent[] u = new TfContent[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (TfContent)objs[i];
        }
        
        return u;
    }			

    public BigItem[] getAllActiveBigItem()
    {
    	BigItemMgr bigr = BigItemMgr.getInstance();
        
        Object[] objs = bigr.retrieve("BigItemActive=1","");
        
        if (objs==null || objs.length==0)
            return null;
        
        BigItem[] u = new BigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BigItem)objs[i];
        }
        
        return u;
    }	
    
     public BigItem[] getAllActiveBigItem2()
    {
    	BigItemMgr bigr = BigItemMgr.getInstance();
        
        Object[] objs = bigr.retrieve("", "order by acctCode");
        
        if (objs==null || objs.length==0)
            return null;
        
        BigItem[] u = new BigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BigItem)objs[i];
        }
        
        return u;
    }	
    
     public BigItem[] getAllBigItem2ByType(int type)
    {
    	BigItemMgr bigr = BigItemMgr.getInstance();
        
        String query="";
        //雜費
        if(type==1){
            query="acctCode like '5%' or acctCode like '6%'";                            
        }else if(type==2){
            query="acctCode like '4%' or acctCode like '7%'";
        }else if(type==3){
            query="acctCode like '1%'";
        }else if(type==4){
            query="acctCode like '2%'";
        }else if(type==5){
            query="acctCode like '3%'";
        }
        Object[] objs = bigr.retrieve(query, "order by acctCode");
        
        if (objs==null || objs.length==0)
            return null;
        
        BigItem[] u = new BigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BigItem)objs[i];
        }
        
        return u;
    }	

     public BigItem[] getActiveBigItem2ByType(int type)
    {
    	BigItemMgr bigr = BigItemMgr.getInstance();
        
        String query="bigItemActive='1' and ";
        //雜費
        if(type==1){
            query+="acctCode like '5%' or acctCode like '6%'";                            
        }else if(type==2){
            query+="acctCode like '4%' or acctCode like '7%'";
        }else if(type==3){
            query+="acctCode like '1%'";
        }else if(type==4){
            query+="acctCode like '2%'";
        }else if(type==5){
            query+="acctCode like '3%'";
        }

        Object[] objs = bigr.retrieve(query, "order by acctCode");
        
        if (objs==null || objs.length==0)
            return null;
        
        BigItem[] u = new BigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BigItem)objs[i];
        }
        
        return u;
    }	
    

     public BigItem[] getNowBigItemByCode(String code,int type)
    {
    	BigItemMgr bigr = BigItemMgr.getInstance();
        
        String query=" acctCode='"+code.trim()+"'";

        Object[] objs = bigr.retrieve(query, "order by acctCode");
        
        if (objs==null || objs.length==0)
            return null;
        
        BigItem[] u = new BigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BigItem)objs[i];
        }
        
        return u;
    }	

     public BigItem[] getActiveBigItemByCodex(String code)
    {
    	BigItemMgr bigr = BigItemMgr.getInstance();
        
        String query=" acctCode='"+code.trim()+"' and bigItemActive='1'";

        Object[] objs = bigr.retrieve(query, "order by acctCode");
        
        if (objs==null || objs.length==0)
            return null;
        
        BigItem[] u = new BigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BigItem)objs[i];
        }
        
        return u;
    }	


     public BigItem[] getAllActiveBigItemByCode(String code,int type)
    {
    	BigItemMgr bigr = BigItemMgr.getInstance();
        
        String query="";

        query =" acctCode='"+code.trim()+"' and bigItemActive=1 ";
/*
        if(type==1){
            query="( acctCode like '5%' or acctCode like '6%' ) ";                            
        }else if(type==2){
            query="( acctCode like '4%' or acctCode like '7%' ) ";
        }

        query+=" and acctCode='"+code.trim()+"' and bigItemActive=1 ";

*/

        Object[] objs = bigr.retrieve(query, "order by acctCode");
        
        if (objs==null || objs.length==0)
            return null;
        
        BigItem[] u = new BigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BigItem)objs[i];
        }
        
        return u;
    }	

     public BigItem[] getAllActiveBigItem(int type)
    {
    	BigItemMgr bigr = BigItemMgr.getInstance();
        
        String query="";

        if(type==1){
            query="( acctCode like '5%' or acctCode like '6%' ) ";                            
        }else if(type==2){
            query="acctCode like '4%' ";
        }

        query+="and bigItemActive=1 ";

        Object[] objs = bigr.retrieve(query, "order by acctCode");
        
        if (objs==null || objs.length==0)
            return null;
        
        BigItem[] u = new BigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BigItem)objs[i];
        }
        
        return u;
    }	


    public Costtrade[] getAllCosttrade(String space)
    {
    	CosttradeMgr bigr = CosttradeMgr.getInstance();
        
        Object[] objs = bigr.retrieveX(""," order by created desc", space);
        
        if (objs==null || objs.length==0)
            return null;
        
        Costtrade[] u = new Costtrade[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costtrade)objs[i];
        }
        
        return u;
    }	
    
								
    								
    public Costtrade[] getActiveCosttrade()
    {
    	CosttradeMgr bigr = CosttradeMgr.getInstance();
        
        Object[] objs = bigr.retrieve("costtradeActive = '1'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        Costtrade[] u = new Costtrade[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costtrade)objs[i];
        }
        
        return u;
    }
    public IncomeBigItem[] getAllIncomeActiveBigItem()
    {
    	IncomeBigItemMgr bigr = IncomeBigItemMgr.getInstance();
        
        Object[] objs = bigr.retrieve("incomeBigItemActive=1 and id >=3", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        IncomeBigItem[] u = new IncomeBigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (IncomeBigItem)objs[i];
        }
        
        return u;
    }	
     public IncomeBigItem[] getAllIncomeBigItem2()
    {
    	IncomeBigItemMgr bigr = IncomeBigItemMgr.getInstance();
        
        Object[] objs = bigr.retrieve("id !=1 and id !=2", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        IncomeBigItem[] u = new IncomeBigItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (IncomeBigItem)objs[i];
        }
        
        return u;
    }	

	
    public BigItem getBigItemById(int id)
    {
    	BigItemMgr bigr = BigItemMgr.getInstance();      
        BigItem bi = (BigItem) bigr.find(id);                              
        return bi;
    }
    
    public IncomeBigItem getIncomeBigItemById(int id)
    {
    	IncomeBigItemMgr bigr = IncomeBigItemMgr.getInstance();      
        IncomeBigItem bi = (IncomeBigItem) bigr.find(id);                              
        return bi;
    }

    public SmallItem getSmallItemById(int id)
    {
    	SmallItemMgr sigr = SmallItemMgr.getInstance();      
        SmallItem si = (SmallItem) sigr.find(id);                              
        return si;
    }	
     public IncomeSmallItem getIncomeSmallItemById(int id)
    {
    	IncomeSmallItemMgr sigr = IncomeSmallItemMgr.getInstance();      
        IncomeSmallItem si = (IncomeSmallItem) sigr.find(id);                              
        return si;
    }		


    public SmallItem[] getAllSmallItemByBID(int bid)
    {
    	SmallItemMgr sigr = SmallItemMgr.getInstance();
        
        Object[] objs = sigr.retrieve("smallItemBigItemId="+bid, " order by acctCode asc");
        
        if (objs==null || objs.length==0)
            return null;
        
        SmallItem[] u = new SmallItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SmallItem)objs[i];
        }
        
        return u;
    }

    public IncomeSmallItem[] getAllIncomeSmallItemByBID(int bid)
    {
    	IncomeSmallItemMgr sigr = IncomeSmallItemMgr.getInstance();
        
        Object[] objs = sigr.retrieve("incomeSmallItemIncomeBigItemId="+bid+" and id !='1'", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        IncomeSmallItem[] u = new IncomeSmallItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (IncomeSmallItem)objs[i];
        }
        
        return u;
    }
   
     public IncomeSmallItem[] getActiveIncomeSmallItemByBID(int bid)
    {
    	IncomeSmallItemMgr sigr = IncomeSmallItemMgr.getInstance();
        
        Object[] objs = sigr.retrieve("incomeSmallItemIncomeBigItemId="+bid+" and incomeSmallItemActive=1 and id !='1'", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        IncomeSmallItem[] u = new IncomeSmallItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (IncomeSmallItem)objs[i];
        }
        
        return u;
    }

    public SmallItem getSmallItemByBid(int bid,String acctCode)
    {
    	SmallItemMgr sigr = SmallItemMgr.getInstance();
        
        Object[] objs = sigr.retrieve("smallItemBigItemId="+bid+" and acctCode='"+acctCode.trim()+"'", " order by acctCode asc");
        
        if (objs==null || objs.length==0)
            return null;
        
        SmallItem u = (SmallItem)objs[0];
        
        return u;
    }

      public SmallItem[] getActiveSmallItemByBID(int bid)
    {
    	SmallItemMgr sigr = SmallItemMgr.getInstance();
        
        Object[] objs = sigr.retrieve("smallItemBigItemId="+bid+" and smallItemActive=1", " order by acctCode asc");
        
        if (objs==null || objs.length==0)
            return null;
        
        SmallItem[] u = new SmallItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SmallItem)objs[i];
        }
        
        return u;
    }
    /*
    public IncomeSmallItem[] getAllIncomeSmallItemByBID(int bid)
    {
    	IncomeSmallItemMgr sigr = IncomeSmallItemMgr.getInstance();
        
        Object[] objs = sigr.retrieve("incomeSmallItemIncomeBigItemId="+bid, null);
        
        if (objs==null || objs.length==0)
            return null;
        
        IncomeSmallItem[] u = new IncomeSmallItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (IncomeSmallItem)objs[i];
        }
        
        return u;
    }
    */
    public SmallItem[] getAllActiveSmallItemByBID(int bid)
    {
    	SmallItemMgr sigr = SmallItemMgr.getInstance();
        
        Object[] objs = sigr.retrieve("smallItemBigItemId="+bid+" and smallItemActive=1", null);
        
        if (objs==null || objs.length==0)
            return null;
        
        SmallItem[] u = new SmallItem[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SmallItem)objs[i];
        }
        
        return u;
    }

   public boolean getSnotice(int talentdateId,int stuId)
    {
    	StunoticeMgr bigr = StunoticeMgr.getInstance();
        
        Object[] objs = bigr.retrieve("stunoticeCategory=1 and stunoticeXid="+talentdateId+" and stunoticeStudentId="+stuId, null);
        
        if (objs==null || objs.length==0)
            return false;
        else
            return true;	
    }			

    public ClsGroup[] getClsGroups(int classId)
    {
        return getClsGroups(classId, true);
    }

    public ClsGroup[] getClsGroups(int classId, boolean all)
    {
        ClsGroupMgr cgmgr = ClsGroupMgr.getInstance();
        String query = "classId=" + classId ;
        if (!all)
            query += " and active=1";

        Object[] objs = cgmgr.retrieve(query, null);        
        if (objs==null)
            return null;
        ClsGroup[] ret = new ClsGroup[objs.length];
        for (int i=0; i<objs.length; i++)
            ret[i] = (ClsGroup) objs[i];
        return ret;
    }
}
