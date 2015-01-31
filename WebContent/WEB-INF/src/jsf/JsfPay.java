package jsf;

import java.util.*;
import java.text.*;
import jsi.*;
import java.net.*;
import java.io.*;
import com.axiom.mgr.*;
import phm.ezcounting.*;

public class JsfPay
{
    private static JsfPay instance;
    
    JsfPay() {}
    
    public synchronized static JsfPay getInstance()
    {
        if (instance==null)
        {
            instance = new JsfPay();
        }
        return instance;
    }
    
    public Costpay[] getCashTypeDateCostpay(Date startDate,Date endDate,String space)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	long endDateL=endDate.getTime()+(long)1000*60*60*24;
    	
    	Date newEndDate=new Date(endDateL);

		String query=" costpayDate >='"+df.format(startDate)+"'"+
	    		      " and costpayDate <'"+df.format(newEndDate)+"' and costpayAccountType in (1,2,3,4,5)"; // 3 is cheque

        Object[] objs = bigr.retrieveX(query," order by costpayDate asc", space);
        
        if (objs==null || objs.length==0)
            return null;
        
        Costpay[] u = new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
        
        return u;
    }

    public String getMessageList(int type,int classId,int xGroup)
    {
    	String outWord="";	
    	
    	if(xGroup==1)
    	{
	    	if(type==1)
	    	{
	    		outWord=getType1List();
	    	}else if(type==2){
	    		
	    		outWord=getType2List(classId);	
	    	}else if(type==3){
	    		outWord=getType3List(classId);		
	    	}else if(type==0){
	    		StringBuffer sb=new StringBuffer();
	    		
	    		sb.append("<font color=red>行政:</font><br>"+getType1List());
	    		sb.append("<br><font color=red>老師:</font><br>"+getType2List(classId));	
	    		sb.append("<br><font color=red>學生:</font><br>"+getType3List(classId));	
	    		
	    		return sb.toString();
	    	}
	    	
    	}else{
    		outWord=getTypeTalentList(classId);	
    	}	
    	
    	return outWord;
    }
    
    public String getTypeTalentList(int talentId)
    {
    	JsfAdmin ja=JsfAdmin.getInstance();
    	Tadent[] td=ja.getXactiveTadentByTalentId(talentId,99);	
    	StudentMgr sm=StudentMgr.getInstance();
    	
    	
    	if(td==null)
    		return "";
    	
    	PaySystemMgr em=PaySystemMgr.getInstance();
		PaySystem e=(PaySystem)em.find(1);
		
		
    	StringBuffer sb=new StringBuffer();	
    	for(int i=0;i<td.length;i++)
    	{	
    		Student stu2=(Student)sm.find(td[i].getTadentStudentId());
    		
    		sb.append(getStudetNum(e,stu2));
			
			if(i%3==0)
				sb.append("<br>");
		}
		
		return sb.toString();
    }
    
    public String getType3List(int classId)
    {
    	PaySystemMgr em=PaySystemMgr.getInstance();
		PaySystem e=(PaySystem)em.find(1);
		
		JsfAdmin ja=JsfAdmin.getInstance();		
		Student[] st=ja.getStudyStudents(classId,999,999,8);
		
		if(st==null)
			return "";
		
		StringBuffer sb=new StringBuffer();
		for(int i=0;i<st.length;i++)
		{
			sb.append(getStudetNum(e,st[i]));
		}
		
		return sb.toString();		
    }
    
    public String getStudetNum(PaySystem p,Student stu)
    {
    	StringBuffer sb=new StringBuffer();
    	String mobileNum="";
    	
    	int toType=p.getPaySystemMessageTo();
    	
		if(toType==0)
		{
             switch(stu.getStudentEmailDefault())
            {
                case 0:

                    JsfAdmin ja=JsfAdmin.getInstance();
                    Contact[] cons=ja.getAllContact(stu.getId());
                    
                    if(cons !=null)
                    {
                        int raId=cons[0].getContactReleationId();
                        RelationMgr rm=RelationMgr.getInstance();
                        Relation ra=(Relation)rm.find(raId);
                        
                        mobileNum=cons[0].getContactMobile();
                    }
                    break;
                case 1:								
                    mobileNum=stu.getStudentFatherMobile();
                    break;
                case 2:				
                    mobileNum=stu.getStudentMotherMobile();
                    break;	
            }

			if(checkMobile(mobileNum))
			{
				sb.append("<input type=checkbox name=mobiles value="+mobileNum+">"+stu.getStudentName()+"-(預設號碼:"+mobileNum+"<br>");
			}else{
				sb.append("<a href=\"modifyStudent.jsp?studentId="+stu.getId()+"\">"+stu.getStudentName()+"</a>-(預設號碼無效) <br>");
			}	
			
			return sb.toString();
		}else{
			
            sb.append(stu.getStudentName()+" (");

			if(checkMobile(stu.getStudentFatherMobile()))
			{
					sb.append("<input type=checkbox name=mobiles value="+stu.getStudentFatherMobile()+">父:"+stu.getStudentFatherMobile()+" , ");
			}else{
					sb.append("<a href=\"modifyStudent.jsp?studentId="+stu.getId()+"\"> 父:號碼無效</a> , ");
			}		
			
			if(checkMobile(stu.getStudentMotherMobile()))
			{
					sb.append("<input type=checkbox name=mobiles value="+stu.getStudentMotherMobile()+"> 母:"+stu.getStudentMotherMobile());
			}else{
					sb.append("<a href=\"modifyStudent.jsp?studentId="+stu.getId()+"\">母:號碼無效</a>");
			}
                
            sb.append(")<br>");			

			return sb.toString();			
		}	
    }
	
	public String getBillNumber(PaySystem ps,Student stu)
	{
		StringBuffer sb=new StringBuffer();
    	String mobileNum="";
    	
    	int toType=ps.getPaySystemNoticeMessageTo();
    	
		if(toType==0)
		{
			switch(stu.getStudentMobileDefault())
			{
				case 1:
					mobileNum=stu.getStudentFatherMobile();
					break;
				case 2:
					mobileNum=stu.getStudentFatherMobile2();
					break;
				case 3:
					mobileNum=stu.getStudentMotherMobile();
					break;
				case 4:
					mobileNum=stu.getStudentMotherMobile2();
					break;		
			}	
			
			if(checkMobile(mobileNum))
			{
				sb.append("<input type=checkbox name=\"mo"+stu.getId()+"\" value=\""+mobileNum+"\" checked>(預設號碼:"+mobileNum+") , ");
			}else{
				sb.append("<a href=\"#\" onClick=\"javascript:openwindow15("+stu.getId()+")\">(預設號碼無效)</a> , ");
			}	
			
			return sb.toString();
		}else{
			
			if(checkMobile(stu.getStudentFatherMobile()))
			{
					sb.append("<input type=checkbox  name=\"mo"+stu.getId()+"\" value="+stu.getStudentFatherMobile()+" checked>父:"+stu.getStudentFatherMobile()+") , ");
			}else{
					sb.append("<a href=\"#\" onClick=\"javascript:openwindow15("+stu.getId()+")\">(父:號碼無效)</a> , ");
			}		
			
			if(checkMobile(stu.getStudentMotherMobile()))
			{
					sb.append("<input type=checkbox  name=\"mo"+stu.getId()+"\" value="+stu.getStudentMotherMobile()+" checked>母:"+stu.getStudentMotherMobile()+") , ");
			}else{
					sb.append("<a href=\"#\" onClick=\"javascript:openwindow15("+stu.getId()+")\">(母:號碼無效)</a> , ");
			}
			
			return sb.toString();			
		}		
	}

	public String getBillEmail(PaySystem ps,Student stu)
	{
		StringBuffer sb=new StringBuffer();
    	String emailAddress="";
    	
    	int toType=ps.getPaySystemNoticeEmailTo();
    	
		if(toType==0)
		{
			switch(stu.getStudentEmailDefault())
			{
				case 1:
					emailAddress=stu.getStudentFatherEmail();
					break;
				case 2:
					emailAddress=stu.getStudentMotherEmail();
					break;
			}	
			
			if(checkEmail(emailAddress))
			{
				sb.append("<input type=checkbox name=\"em"+stu.getId()+"\" value=\""+emailAddress+"\" checked>(預設Email:"+emailAddress+" , ");
			}else{
				sb.append("<a href=\"#\" onClick=\"javascript:openwindow15("+stu.getId()+")\">(預設Email無效)</a> , ");
			}	
			
			return sb.toString();
		}else{
			
			if(checkEmail(stu.getStudentFatherEmail()))
			{
					sb.append("<input type=checkbox  name=\"em"+stu.getId()+"\" value="+stu.getStudentFatherEmail()+" checked>父:"+stu.getStudentFatherEmail()+" , ");
			}else{
					sb.append("<a href=\"#\" onClick=\"javascript:openwindow15("+stu.getId()+")\">(父:Email無效)</a> , ");
			}		
			
			if(checkEmail(stu.getStudentMotherEmail()))
			{
					sb.append("<br><input type=checkbox  name=\"em"+stu.getId()+"\" value="+stu.getStudentMotherEmail()+" checked>母:"+stu.getStudentMotherEmail()+" , ");
			}else{
					sb.append("<br><a href=\"#\" onClick=\"javascript:openwindow15("+stu.getId()+")\">(母:Email無效)</a> , ");
			}
			
			return sb.toString();			
		}		
	}

	public String getStuFixAccount(PaySystem e,Student stu, boolean showDash)
    {
        return getStuFixAccount(e, stu.getId(), showDash);
    }


	public String getStuFixAccount(PaySystem e,int stuId, boolean showDash) 
	{ 
		StringBuffer sb=new StringBuffer();
		
		if(e.getPaySystemFirst5().length()<5) 
		{ 
			return "Error! 尚未設定虛擬帳號前五碼";	
		}  
		
		sb.append(e.getPaySystemFirst5().trim()); 
		
		if(showDash) 
			sb.append("-");	
		
		if(e.getPaySystemFixATMAccount().length()<=0)
  		{
  			return "Error! 尚未設定固定虛擬帳號代碼";	
  		}
		
		sb.append(e.getPaySystemFixATMAccount().trim());
	
		if(showDash) 
			sb.append("-"); 
			
		String stuIdS=String.valueOf(stuId);		
		
		int num=e.getPaySystemFixATMNum();
		
		if(num==0) 
			return "Error! 尚未設定固定虛擬帳號的位數";		
		
		int run0=num-stuIdS.length();
		
		if(run0<=0)
  			return "Error! 尚未設定固定虛擬帳號的位數不正確";		
 			
 		for(int i=0;i<run0;i++)	
 			sb.append("0");	
 		
 		sb.append(stuIdS);		
 			
 		return sb.toString();
	} 


	public boolean checkEmail(String eAddress)
	{
		if(eAddress==null || eAddress.length()<4)
			return false;
		
		if(eAddress.indexOf("@")==-1)
			return false;
		
		return true;	
	}

    public String getType2List(int classId)
    {
    	SalaryAdmin sa=SalaryAdmin.getInstance();
    	
    	int newClass=classId;
    	
    	Teacher[] tea=sa.getTeacherByPositionClasses(999,classId);

		if(tea==null)
		{
			return "";	
		}
		StringBuffer sb=new StringBuffer();
	
		for(int i=0;i<tea.length;i++)
		{
			if(checkMobile(tea[i].getTeacherMobile()))
			{
				sb.append("<input type=checkbox name=mobiles value="+tea[i].getTeacherMobile()+">"+tea[i].getTeacherFirstName()+tea[i].getTeacherLastName()+"-("+tea[i].getTeacherMobile()+") , ");
			}else{
				sb.append("<a href=\"#\" onClick=\"javascript:openwindow16('"+tea[i].getId()+"')\">"+tea[i].getTeacherFirstName()+tea[i].getTeacherLastName()+"</a>-(無效號碼) , ");
			}
		}
    	return sb.toString();
    }
    public String getType1List()
    {
        if (1==1)
            throw new RuntimeException("obsolete! use getAllRunUsers without bunitSpace");

    	JsfAdmin ja=JsfAdmin.getInstance();
    	User[] u2=ja.getAllRunUsers(null);
	
		if(u2==null)
		{
			return "";	
		}
		StringBuffer sb=new StringBuffer();
	
		for(int i=0;i<u2.length;i++)
		{
			if(checkMobile(u2[i].getUserPhone()))
			{
				sb.append("<input type=checkbox name=mobiles value="+u2[i].getUserPhone()+">"+u2[i].getUserFullname()+"-("+u2[i].getUserPhone()+") , ");
			}else{
				sb.append("<a href=modifyUser.jsp?userId="+u2[i].getId()+">"+u2[i].getUserFullname()+"</a>-(無效號碼) , ");
			}
		}
		
		return sb.toString();
    }
    
    
    public boolean sendMultiPayFeeMessage(PayFee[] pfs,PaySystem e)
    {		
		if(e.getPaySystemMessageActive()==0 || e.getPaySystemMessageActive()==9)
			return false;
					
		PayFeeMgr pfm=PayFeeMgr.getInstance();
		for(int i=0;i<pfs.length;i++)
		{
			String returnWord=sendPayFeeMessage(e,pfs[i]);	
			if(returnWord.equals("98"))
				break;
		}
		
		return true;
    }
    
    public String sendPayFeeMessage(PaySystem e,PayFee pf)
    {
    	if(e.getPaySystemMessageActive()==0)
    		return "97";
    	
    	
		FeeticketMgr ftm=FeeticketMgr.getInstance();
		JsfAdmin js=JsfAdmin.getInstance();
		Feeticket ft=js.getFeeticketByNumberId(pf.getPayFeeFeenumberId());
	
		StudentMgr sm=StudentMgr.getInstance();
		Student stu=(Student)sm.find(ft.getFeeticketStuId());

		String[][] sendWord=changeMessageContext(e,stu,pf,ft);
		PayFeeMgr pfm=PayFeeMgr.getInstance();
		String returnWord="";
		for(int i=0;i<2;i++)
		{
			if(checkMobile(sendWord[i][0]))
				returnWord=sendMobileMessage(e,sendWord[i][0],sendWord[i][1]);
		
			if(returnWord.length()>2)
			{ 
				pf.setPayFeeMessageStatus(1);	
				pfm.save(pf);
			}else{
				try{
					pf.setPayFeeMessageStatus(Integer.parseInt(returnWord));	
					pfm.save(pf);
				}catch(Exception ex){}
			} 
		}
		return returnWord;
    }
    
    public String[][] changeMessageContext(PaySystem e,Student stu,PayFee pf,Feeticket ft)
    {
    	String[][] outWord={{"0","0"},{"0","0"}};
		
		String mobileNum="";
		if(e.getPaySystemMessageTo()==0)
		{

            switch(stu.getStudentEmailDefault())
            {
                case 0:

                    JsfAdmin ja=JsfAdmin.getInstance();
                    Contact[] cons=ja.getAllContact(stu.getId());
                    
                    if(cons !=null)
                    {
                        int raId=cons[0].getContactReleationId();
                        RelationMgr rm=RelationMgr.getInstance();
                        Relation ra=(Relation)rm.find(raId);

                        mobileNum=cons[0].getContactMobile();
                    }
                    break;
                case 1:								

                    mobileNum=stu.getStudentFatherMobile();
                    break;
                case 2:
                    mobileNum=stu.getStudentMotherMobile();
                    break;	
            }
			
			if(checkMobile(mobileNum))
			{
				String messageWord=changeMessageWord(e,stu,pf,ft);	
				
				if(messageWord.length()>0)
				{
					outWord[0][0]=mobileNum;
					outWord[0][1]=messageWord;
				}
			}
		}else if(e.getPaySystemMessageTo()==1){
			
				String messageWord=changeMessageWord(e,stu,pf,ft);
				
				if(checkMobile(stu.getStudentFatherMobile()))
				{
					outWord[0][0]=stu.getStudentFatherMobile();
					outWord[0][1]=messageWord;
					
					if(checkMobile(stu.getStudentMotherMobile()))
					{
						outWord[1][0]=stu.getStudentMotherMobile();
						outWord[1][1]=messageWord;
					}
				}else{
					
					if(checkMobile(stu.getStudentMotherMobile()))
					{
						outWord[0][0]=stu.getStudentFatherMobile();
						outWord[0][1]=messageWord;
					}
					
				}
		}
		return outWord;
    }
    
    public String replaceBillMobileWord(String replaceWords,String runmonth,Student stu2,String feeId,String num,String edate)
    {
    	String xWord=replaceWords;
    	xWord=xWord.replace("XXX",stu2.getStudentName());
    	xWord=xWord.replace("MMM",runmonth);	
    	xWord=xWord.replace("ZZZ",num);	
		xWord=xWord.replace("YYY",edate);
		
		feeId=feeId.replace("###",",");
		xWord=xWord.replace("FFF",feeId);
		
		return xWord;
	}
    public String changeMessageWord(PaySystem e,Student stu,PayFee pf,Feeticket ft)
    {
    	StringBuffer sb=new StringBuffer();
    	String originalWord=e.getPaySystemMessageText();
    	JsfTool jt=JsfTool.getInstance();
    	Date feemonth=ft.getFeeticketMonth();
    	int fyear=feemonth.getYear()+1900-1911;
    	int fmonth=feemonth.getMonth()+1;
    	
    	String showMonth=String.valueOf(fyear)+"年"+String.valueOf(fmonth)+"月";
    	SimpleDateFormat sdf=new SimpleDateFormat("");
    	if(originalWord !=null)
    	{
    		originalWord=originalWord.replace("XXX",stu.getStudentName());
    		originalWord=originalWord.replace("YYY",jt.ChangeDateToString(pf.getPayFeeLogPayDate()));
    		
    		int payWayA=pf.getPayFeeSourceCategory(); 
			String payword="";				
			switch(payWayA)
			{ 
				case 4:
					payword="櫃臺繳款";	
					break;		
				case 1:
					payword="虛擬帳號";	
					break;	
 				case 2:
					payword="約定帳號";	
					break;	
 				case 3:
					payword="便利商店代收";	
					break;		
				case 5:
					payword="指定匯款帳號";	
					break;			
			} 

    		originalWord=originalWord.replace("ZZZ",payword);
    		originalWord=originalWord.replace("SSS",showMonth);
			originalWord=originalWord.replace("MMM",String.valueOf(pf.getPayFeeMoneyNumber()));
			originalWord=originalWord.replace("FFF",String.valueOf(pf.getPayFeeFeenumberId()));    				
		
			return originalWord;
    		
    	}else{
    		return "";	
    	}
    }
    public boolean checkMobile(String num)
    {
        
        num=getRealPhone(num);

    	if(num.length()==10 && num.substring(0,2).equals("09"))
    		return true;
    	else
    		return false;	
    }
    
    public String getRealPhone(String phonenum)
    {        
        if(phonenum==null || phonenum.length()<=0)
            return "";

        StringBuffer sb=new StringBuffer();
        for(int i=0;i<phonenum.length();i++)
        {
            char c=phonenum.charAt(i);

            if('0'<=c  &&  c<='9')
            {
                sb.append(c);
            }
        }
        return sb.toString();
    }

    public String sendMobileMessage(PaySystem e,String phone,String word)
    {

        if(e.getPaySystemMessageActive()==0 || e.getPaySystemMessageActive()==9)
            return "97";
		String strOnlineSend="";
		String thisLine;
		URL u;
		URLConnection uc;
    	
        phone=getRealPhone(phone);

    	strOnlineSend =e.getPaySystemMessageURL()+"?CID="+e.getPaySystemMessageUser()+"&CPW="+e.getPaySystemMessagePass()+"&N="+phone+"&M="+URLEncoder.encode(word);

		try {
    		u = new URL(strOnlineSend);
    		uc = u.openConnection();
    		BufferedReader theHTML = new BufferedReader(new InputStreamReader(uc.getInputStream()));
    		thisLine = theHTML.readLine();
			
        	return thisLine;
		}catch(Exception ex) {
    
    		return "98";
		}
    }
    
    
    public static boolean INCOMEStatus(Date accountDate)
    {
    	
    	try{
    		
	    	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM");
	    	String runDateString=sdf.format(accountDate);
	    	
	    	Date runDate=sdf.parse(runDateString);
	
	    	ClosemonthMgr cm=ClosemonthMgr.getInstance();
			
			String query="";
			
			java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	
	
			query=" closemonthMonth >='"+df.format(runDate)+"' and closemonthIncomestatus='90'";
			 
			Object[] objs = cm.retrieve(query, " order by closemonthMonth desc");
	        
	        if (objs==null || objs.length==0)
	            return true;
	    	else
	    		return false;	
   
   		}catch(Exception e){
   			return false;	
   		}
    }
    
    public static boolean COSTPAYIncomeStatus(Date accountDate,Date created)
    {
    	
    	try{
    		
	    	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM");
	    	String runDateString=sdf.format(accountDate);
	    	
	    	Date runDate=sdf.parse(runDateString);
	
	    	ClosemonthMgr cmx=ClosemonthMgr.getInstance();
			
			String query="";
			
			java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	
	
			query=" closemonthMonth ='"+df.format(runDate)+"' and closemonthIncomestatus='90'";
			 
			Object[] objs = cmx.retrieve(query, " order by closemonthMonth desc");
	        
	        if (objs==null || objs.length==0)
	        {
	            return true;
	    	}else{
	    	
	    		Closemonth cm=(Closemonth)objs[0];
	    		
   				long xIncomeClose=(long)cm.getClosemonthIncomeDate().getTime();
   				long xCreate=(long)created.getTime();
				
				if(xCreate>xIncomeClose)
					return true;
				else
					return false;
   			
   			}
   		}catch(Exception e){
   			return false;	
   		}
    }
    
       public static boolean COSTPAYCostStatus(Date accountDate,Date created)
    {
    	
    	try{
    		
	    	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM");
	    	String runDateString=sdf.format(accountDate);
	    	
	    	Date runDate=sdf.parse(runDateString);
	
	    	ClosemonthMgr cmx=ClosemonthMgr.getInstance();
			
			String query="";
			
			java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	
	
			query=" closemonthMonth ='"+df.format(runDate)+"' and closemonthCoststatus='90'";
			 
			Object[] objs = cmx.retrieve(query, " order by closemonthMonth desc");
	        
	        if (objs==null || objs.length==0)
	        {
	            return true;
	    	}else{
	    	
	    		Closemonth cm=(Closemonth)objs[0];
	    		
   				long xIncomeClose=(long)cm.getClosemonthCostDate().getTime();
   				long xCreate=(long)created.getTime();
				
				if(xCreate>xIncomeClose)
					return true;
				else
					return false;
   			
   			}
   		}catch(Exception e){
   			return false;	
   		}
    }
    public static boolean COSTStatus(Date accountDate)
    {
    	try{
    	
	    	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM");
	    	String runDateString=sdf.format(accountDate);
	    	
	    	Date runDate=sdf.parse(runDateString);
	
	    	ClosemonthMgr cm=ClosemonthMgr.getInstance();
			
			String query="";
			
			java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	
	
			query=" closemonthMonth >='"+df.format(runDate)+"' and closemonthCoststatus='90'";
			 
			Object[] objs = cm.retrieve(query, " order by closemonthMonth desc");
	        
	        if (objs==null || objs.length==0)
	            return true;
	    	else
	    		return false;	
    
    	}catch(Exception e){
    		return false;	
    	}
    	
    }
    
    public static boolean FEEStatus(Date runDate)
    {
    	ClosemonthMgr cm=ClosemonthMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closemonthMonth >='"+df.format(runDate)+"' and closemonthFeestatus='90'";
		 
		Object[] objs = cm.retrieve(query, " order by closemonthMonth desc");
        
        if (objs==null || objs.length==0)
            return true;
    	else
    		return false;	
    }
	
	    
    public static boolean SALARYStatus(Date runDate)
    {
    	ClosemonthMgr cm=ClosemonthMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closemonthMonth >='"+df.format(runDate)+"' and closemonthSalarystatus='90'";
		 
		Object[] objs = cm.retrieve(query, " order by closemonthMonth desc");
        
        if (objs==null || objs.length==0)
            return true;
    	else
    		return false;	
    }
	
	
	public Hashtable getTradeAcccountNum(Costpay[] cp)
	{
		
		
		Hashtable incomeHa=new Hashtable();
		Hashtable costHa=new Hashtable();
		
		for(int i=0;cp!=null && i<cp.length;i++)
		{
			if(cp[i].getCostpayNumberInOut()==1)
			{
				if(costHa.get(String.valueOf(cp[i].getCostpayAccountId()))==null)
				{
					costHa.put(String.valueOf(cp[i].getCostpayAccountId()),String.valueOf(cp[i].getCostpayCostNumber()));
					
				}else{
					
					String oldCost=(String)costHa.get(String.valueOf(cp[i].getCostpayAccountId())); 
					
					int nowTotal=cp[i].getCostpayCostNumber()+Integer.parseInt(oldCost);
					
					costHa.put(String.valueOf(cp[i].getCostpayAccountId()),String.valueOf(nowTotal));
				}
			}else{
				if(incomeHa.get(String.valueOf(cp[i].getCostpayAccountId()))==null)
				{
					incomeHa.put(String.valueOf(cp[i].getCostpayAccountId()),String.valueOf(cp[i].getCostpayIncomeNumber()));
					
				}else{
					
					String oldCost=(String)incomeHa.get(String.valueOf(cp[i].getCostpayAccountId()));
					int nowTotal=cp[i].getCostpayIncomeNumber()+Integer.parseInt(oldCost);
					
					incomeHa.put(String.valueOf(cp[i].getCostpayAccountId()),String.valueOf(nowTotal));
				}
			
			}
		}


		Hashtable allHa=new Hashtable();
		
		allHa.put((String)"in",(Hashtable)incomeHa);
		allHa.put((String)"co",(Hashtable)costHa);
		
		return allHa;
	}
	
	public Hashtable getBankNum(Costpay[] bcp)
	{
		
		
		Hashtable bincomeHa=new Hashtable();
		Hashtable bcostHa=new Hashtable();
		
		for(int i=0;bcp!=null && i<bcp.length;i++)
		{
			if(bcp[i].getCostpayNumberInOut()==1)
			{
				if(bcostHa.get(String.valueOf(bcp[i].getCostpayAccountId()))==null)
				{
					bcostHa.put(String.valueOf(bcp[i].getCostpayAccountId()),String.valueOf(bcp[i].getCostpayCostNumber()));
					
				}else{
					
					String oldCost=(String)bcostHa.get(String.valueOf(bcp[i].getCostpayAccountId())); 
					
					int nowTotal=bcp[i].getCostpayCostNumber()+Integer.parseInt(oldCost);
					
					bcostHa.put(String.valueOf(bcp[i].getCostpayAccountId()),String.valueOf(nowTotal));
				}
			}else{
				if(bincomeHa.get(String.valueOf(bcp[i].getCostpayAccountId()))==null)
				{
					bincomeHa.put(String.valueOf(bcp[i].getCostpayAccountId()),String.valueOf(bcp[i].getCostpayIncomeNumber()));
					
				}else{
					
					String oldCost=(String)bincomeHa.get(String.valueOf(bcp[i].getCostpayAccountId()));
					int nowTotal=bcp[i].getCostpayIncomeNumber()+Integer.parseInt(oldCost);
					
					bincomeHa.put(String.valueOf(bcp[i].getCostpayAccountId()),String.valueOf(nowTotal));
				}
			
			}
		}
 
		Hashtable allHa=new Hashtable();
		
		allHa.put((String)"in",(Hashtable)bincomeHa);
		allHa.put((String)"co",(Hashtable)bcostHa);
		
		return allHa;
	}
	
	
	public int[] getSingleTradeANum(Hashtable allHa,int tradeAId)
	{
		int[] allNum=new int[3];
		
		Hashtable incomeHa=(Hashtable)allHa.get("in"); 
		Hashtable costHa=(Hashtable)allHa.get("co"); 

		String incomeS=(String)incomeHa.get(String.valueOf(tradeAId));
		
		if(incomeS==null)
			allNum[0]=0;
		else
			allNum[0]=Integer.parseInt(incomeS);
			
		String costS=(String)costHa.get(String.valueOf(tradeAId));	
		if(costS==null)
			allNum[1]=0;
		else
			allNum[1]=Integer.parseInt(costS);
			
		allNum[2]=allNum[0]-allNum[1];
		
		return allNum;	
	}
	
    public int saveCost(Cost c,Costbook cb)
	{
        int tran_id = 0;
        try{
	        tran_id = Manager.startTransaction();    

            CostMgr cm=new CostMgr(tran_id);
            CostbookMgr cmx=new CostbookMgr(tran_id);


            int totalNum=cb.getCostbookTotalNum();
            int totalMoney=cb.getCostbookTotalMoney(); 
            int shouldTotal=totalMoney+c.getCostMoney();
            cb.setCostbookTotalNum(totalNum+1);
            cb.setCostbookTotalMoney(shouldTotal);
            
            int totalPay=cb.getCostbookPaiedMoney();
        
            if(shouldTotal==totalPay)
            {
                cb.setCostbookPaiedStatus(90);	
            }else if(shouldTotal<totalPay){
                cb.setCostbookPaiedStatus(91);		
            }else if(shouldTotal>totalPay){
                cb.setCostbookPaiedStatus(3);		
            }  	
            
            int costId=cm.createWithIdReturned(c); 
            cmx.save(cb);	
      
            Manager.commit(tran_id);  
      		return costId;

        }catch(Exception e){
            try { Manager.rollback(tran_id); } catch (Exception e2) {}
            
            return 0;
        }
    }
	
	public PayFee[] getpayFeeByPaySourse(int source,int sid)
    {
    	PayFeeMgr bigr = PayFeeMgr.getInstance();
        
        String query="payFeeSourceId='"+sid+"' and payFeeSourceCategory ='"+source+"'";
        
        	
        Object[] objs = bigr.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
	
		PayFee[] u =new PayFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (PayFee)objs[i];
        }

        return u;
    }

	public Cost[] getCostByCBId(Costbook cb)
    {
    	CostMgr bigr = CostMgr.getInstance();
        
        Object[] objs = bigr.retrieve("costCostbookId ='"+cb.getId()+"'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Cost[] u =new Cost[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Cost)objs[i];
        }
  
        return u;
    }

	public Costpay[] getCostpayByBeforedate(Date before, String space)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieveX("modified >='"+sdf.format(before)+"'"," order by costpayLogDate desc", space);
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
        return u;
    } 
    
    public Costpay[] getCostpayModifiedByDate(Date before)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
 
       	Date nextDate=getNextDate(before); 
        
        String query="modified >='"+sdf.format(before)+"' and modified<'"+sdf.format(nextDate)+"'";
 
         
        Object[] objs = bigr.retrieve(query," order by modified asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }


	public Costpay[] getCostpayByPayfeeId(int payFeeId)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        
        Object[] objs = bigr.retrieve("costpayFeePayFeeID ='"+payFeeId+"'"," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }

	public Costpay[] getCostpayByStudentAccountId(int saId)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        
        Object[] objs = bigr.retrieve("costpayStudentAccountId ='"+saId+"'"," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }

	public StudentAccount[] getStudentAccountByPayfeeId(int payFeeId)
    {
    	StudentAccountMgr bigr = StudentAccountMgr.getInstance();
        
        Object[] objs = bigr.retrieve("studentAccountPayFeeId ='"+payFeeId+"'"," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		StudentAccount[] u =new StudentAccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (StudentAccount)objs[i];
        }
  
        return u;
    }


	public Tadent[] getTadentByDate(Date before)
    {
    	TadentMgr bigr = TadentMgr.getInstance();
      
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
 
       	Date nextDate=getNextDate(before); 
        
        String query="modified >='"+sdf.format(before)+"' and modified<'"+sdf.format(nextDate)+"'";

        Object[] objs = bigr.retrieve(query," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Tadent[] u =new Tadent[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Tadent)objs[i];
        }
        return u;
    }


	public Feeticket[] getFeeticketModifiedByDate(Date before)
    {
    	FeeticketMgr bigr = FeeticketMgr.getInstance();

        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
 
       	Date nextDate=getNextDate(before); 
        
        String query="modified >='"+sdf.format(before)+"' and modified<'"+sdf.format(nextDate)+"'";
 
        Object[] objs = bigr.retrieve(query," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Feeticket[] u =new Feeticket[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Feeticket)objs[i];
        }
  
        return u;
    }



	public Feeticket[] getFeeticketByBeforedate(Date before)
    {
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("modified >='"+sdf.format(before)+"'"," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Feeticket[] u =new Feeticket[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Feeticket)objs[i];
        }
  
        return u;
    }
    
    
    public Tadent[] getTadentByBeforedate(Date before)
    {
    	TadentMgr bigr = TadentMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("modified >='"+sdf.format(before)+"'"," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Tadent[] u =new Tadent[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Tadent)objs[i];
        }
        return u;
    }
    
    public FixCost[] getFixCostByCbId(int cbId)
    {

    	FixCostMgr fcgr = FixCostMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = fcgr.retrieve("fixCostCostId='"+cbId+"'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		FixCost[] u =new FixCost[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (FixCost)objs[i];
        }
  
        return u;
    }
    
    public FixCost[] getFixCostByUserId(int userId)
    {

    	FixCostMgr fcgr = FixCostMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        String query="";
        
        if(userId !=999)
        	query="fixCostUserid='"+userId+"'";
        
        Object[] objs = fcgr.retrieve(query," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		FixCost[] u =new FixCost[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (FixCost)objs[i];
        }
  
        return u;
    }
    
    public Costpay[] getFeeticketByBeforeFeecoloseDate(Closemonth cm)
    {
    	if(cm.getClosemonthFeestatus()!=90)
  		{
			return null;
		}
    	CostpayMgr bigr = CostpayMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("created >'"+sdf.format(cm.getClosemonthFeeDate())+"' and costpayFeePayFeeID!='0' or costpayStudentAccountId!='0'"," order by created asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    
    public Feeticket[] getPreFeeticketPaied(Date runMonth)
    {
    	FeeticketMgr feegr = FeeticketMgr.getInstance();
    	
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/01");
        
        Object[] objs = feegr.retrieve("feeticketMonth >'"+sdf.format(runMonth)+"' and feeticketStatus!='0'"," order by created asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Feeticket[] u =new Feeticket[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Feeticket)objs[i];
        }
        return u;
    }
     
   	public String[] showCostpayTitle(Costpay cp, User ud2, CostpayDescription cpd, String backurl) 
        throws Exception
   	{ 	
   		String[] outword={"",""};
		if(ud2==null) 
		{  
			return outword; 
		} 
			 

		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
		SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM");
		SimpleDateFormat sdf3=new SimpleDateFormat("yyyy/MM/dd HH:mm");
		
		BankAccountMgr bam2=BankAccountMgr.getInstance();
		TradeaccountMgr tam=TradeaccountMgr.getInstance();	 
		FeeticketMgr fm=FeeticketMgr.getInstance();
		CostbookMgr cm1=CostbookMgr.getInstance(); 
		StudentMgr stuM=StudentMgr.getInstance(); 
		InsidetradeMgr in1=InsidetradeMgr.getInstance(); 
		OwnertradeMgr ownM=OwnertradeMgr.getInstance();
		OwnerMgr owM=OwnerMgr.getInstance();
		SalaryBankMgr sbm=SalaryBankMgr.getInstance(); 
		SalaryTicketMgr stm=SalaryTicketMgr.getInstance();
		
        TeacherMgr tmm=TeacherMgr.getInstance();		
		PayFeeMgr pfm=PayFeeMgr.getInstance(); 
		StudentAccountMgr samm=StudentAccountMgr.getInstance();				

        if (phm.ezcounting.EzCountingService.paidByMembr(cp)) {
            return phm.ezcounting.EzCountingService.getCostPayDescription(cp, cpd);
        }
        else if (phm.ezcounting.EzCountingService.isSalaryPay(cp)) {
            return phm.ezcounting.EzCountingService.getSalaryCostPayDescription(cp, cpd);
        }
        else if (phm.ezcounting.EzCountingService.isRefund(cp)) {
            return phm.ezcounting.EzCountingService.getRefundCostPayDescription(cp);
        }
        else if (phm.ezcounting.EzCountingService.isVpaid(cp)) {
            return phm.ezcounting.EzCountingService.getVpaidCostPayDescription(cp, cpd, backurl);
        }
        else if (cp.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_MANUAL_VOUCHER) {
            if (cp.getCostpayNumberInOut()==1)
                outword[0] = "<img src='pic/costOut.png'> 傳票貸項";
            else
                outword[0] = "<img src='pic/costIn.png'> 傳票借項";
            outword[1] = "<a href='javascript:show_voucher("+cp.getCostpayStudentAccountId()+",\"vchr\")'>詳細資料</a>";
            return outword;
        }
        else if (cp.getCostpayFeePayFeeID()==Costpay2.COSPAY_TYPE_INITIALIZE) {
            if (cp.getCostpayNumberInOut()==1)
                outword[0] = "<img src='pic/costOut.png'> 帳戶初始化";
            else
                outword[0] = "<img src='pic/costIn.png'> 帳戶初始化";
            outword[1] = "";
            return outword;
        }
		Student stu3=null;
			if(cp.getCostpaySide()==1)
			{ 
				if(cp.getCostpayFeeticketID()==0)
				{  
					if(cp.getCostpayOwnertradeStatus()==0)
					{ 
						if(cp.getCostpaySalaryBankId()==0)
						{ 
							 if(cp.getCostpayStudentAccountId()==0)
							 { 
								Costbook  co=(Costbook)cm1.find(cp.getCostpayCostbookId());
								
								if(co !=null) 
								{ 
									if(cp.getCostpayNumberInOut()==1)
									{
										outword[0]="<img src=\"pic/costOut.png\" border=0> 雜費支出-"+co.getCostbookName();
										
									}else{
										outword[0]="<img src=\"pic/costIn.png\" border=0> 雜費收入-"+co.getCostbookName();
									}	
								}
								outword[1]="<a href=modifyCostbook.jsp?cid="+cp.getCostpayCostbookId()+"&showType=3>詳細資料</a>"; 
							}else{
								
								StudentAccount sa=(StudentAccount)samm.find(cp.getCostpayStudentAccountId());
								
								if(sa !=null)
								{ 
							    		stu3=(Student)stuM.find(sa.getStudentAccountStuId());						
  									
  									outword[0]="<img src=\"pic/feeIn.png\" border=0> 學費收入-";

 									if(stu3 !=null)
 									{
										outword[0]+=stu3.getStudentName();		
 										outword[1]="<a href=\"listStudentAccount.jsp?studentId="+stu3.getId()+"\">詳細資料</a>";
 									}else{
                                        outword[0]+="<font color=blue>不明來源</font>";
 								        outword[1]="<a href=\"listStudentAccount.jsp?studentId=0\">詳細資料</a>";
                                    }		
 									if(sa.getStudentAccountSourceType()==1)
 										outword[0]+=",虛擬帳號";
 									else if(sa.getStudentAccountSourceType()==2)			
										outword[0]+=",學費銷帳";		
 									else if(sa.getStudentAccountSourceType()==3)			
										outword[0]+=",固定虛擬帳號 退費";
 									else if(sa.getStudentAccountSourceType()==4)			 
 										outword[0]+=",櫃臺繳款";
                                    else if(sa.getStudentAccountSourceType()==5)			 
 										outword[0]+=",便利商店代收";
                                    else if(sa.getStudentAccountSourceType()==6)			 
 										outword[0]+=",約定帳號";
                                    	
									outword[0]+="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;存入帳號:"+sa.getStudentAccountNumber();
 								}else{
 								  	outword[0]="<img src=\"pic/feeIn.png\" border=0> 學費收入-不明帳號,固定虛擬帳號 匯入";		
 								} 
							}							
						}else{ 
							SalaryBank snC=(SalaryBank)sbm.find(cp.getCostpaySalaryBankId());
							outword[0]="<img src=\"pic/salaryOut.png\" border=0> 薪資發放"; 
							outword[1]="<a href=\"salaryTicketDetailX.jsp?stNumber="+snC.getSalaryBankSanumber()+"\">詳細資料</a>";
							
							SalaryTicket stX=(SalaryTicket)stm.find(cp.getCostpaySalaryTicketId());
							
							if(stX !=null) 
							{  
								if(ud2.getUserRole()>2 && stX.getSalaryTicketTeacherParttime()==0)
									return outword;
							
								Teacher tea=(Teacher)tmm.find(stX.getSalaryTicketTeacherId());
								
								if(tea !=null)	
									outword[0]+="-"+tea.getTeacherFirstName()+tea.getTeacherLastName(); 
								
								outword[0]+=","+sdf2.format(stX.getSalaryTicketMonth());	
							} 
						} 
					}else{
						Ownertrade ot=(Ownertrade)ownM.find(cp.getCostpayOwnertradeId());
						
						if(ot.getOwnertradeInOut()==0)
						{ 
							outword[0]="股東挹注-";	
						}else{ 
							outword[0]="股東提取-";
	 	 	 	 	 	}  	
	 	 	 	 	 	 
						Owner ow2=(Owner)owM.find(ot.getOwnertradeOwnerId());
						outword[0]+=ow2.getOwnerName(); 
						
						outword[1]="<a href=\"detailOwnertrade.jsp?otId="+cp.getCostpayOwnertradeId()+"\">詳細資料</a>";					}			
				}else{
					outword[0]="<img src=\"pic/feeIn.png\" border=0> 學費收入-";
					Feeticket  fee=(Feeticket)fm.find(cp.getCostpayFeeticketID()); 
					Date aDate=fee.getFeeticketMonth();
					Student stu=(Student)stuM.find(fee.getFeeticketStuId());
					outword[0]+=stu.getStudentName()+","+sdf2.format(aDate); 
					
					PayFee pf=(PayFee)pfm.find(cp.getCostpayFeePayFeeID());
  					
  					if(pf !=null)	
					{
						int payWayA=pf.getPayFeeSourceCategory(); 
						
						switch(payWayA)
						{ 
							case 3:
									outword[0]+="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;便利商店代收";
									break;
							case 2:
									outword[0]+="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;固定虛擬帳號";
									break;
							case 1:
									outword[0]+="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;浮動虛擬帳號";
									break;
							case 4:
									outword[0]+="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;櫃臺繳款";
									break;
						} 
					}		  					
  						
  					
 					outword[1]="<a href=\"addPayFeeType4x.jsp?z="+fee.getFeeticketFeenumberId()+"\">詳細資料1</a>"; 
				} 
			}else{ 
			
				Insidetrade in=(Insidetrade)in1.find(cp.getCostpaySideID());
				if(cp.getCostpayNumberInOut()==1)
  				{
  					outword[0]+="<img src=\"pic/outtrade.png\" border=0> 內部轉帳匯出 ";		
  					
					if(in.getInsidetradeToType()==1)	
					{
						Tradeaccount  td=(Tradeaccount)tam.find(in.getInsidetradeToId()); 
						outword[0]+="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;to 零用金-"+td.getTradeaccountName();
	
					}else if(in.getInsidetradeToType()==2){
						
						BankAccount ba=(BankAccount)bam2.find(in.getInsidetradeToId()); 
						outword[0]+="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;to 銀行帳戶-"+ba.getBankAccountName();
					}		
  					
  				}else{
  				  	outword[0]+="<img src=\"pic/intrade.png\" border=0> 內部轉帳匯入";				

					if(in.getInsidetradeFromType()==1)	
					{
						Tradeaccount  td=(Tradeaccount)tam.find(in.getInsidetradeFromId()); 
						outword[0]+="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;from 零用金-"+td.getTradeaccountName();
	
					}else if(in.getInsidetradeFromType()==2){
						
						BankAccount ba=(BankAccount)bam2.find(in.getInsidetradeFromId()); 
						outword[0]+="<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;from 銀行帳戶-"+ba.getBankAccountName();
					}		
  				} 
  				
  				outword[1]="<a href=\"modifyInsidetrade.jsp?inId="+cp.getCostpaySideID()+"\">詳細資料</a>";
			}
	 		
	 		return outword;
	}

    
    
    public Costbook[] getPreCostbookPaied(Date runMonth,int type)
    {
    	CostbookMgr feegr = CostbookMgr.getInstance();
    	
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/31");
        
        Object[] objs = feegr.retrieve("costbookAccountDate >'"+sdf.format(runMonth)+"' and costbookOutIn='"+type+"'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costbook[] u =new Costbook[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costbook)objs[i];
        }
        return u;
    }
    public SalaryTicket[] getPreSalaryTicketPaied(Date runMonth)
    {
    	SalaryTicketMgr feegr = SalaryTicketMgr.getInstance();
    	
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/01");

        Object[] objs = feegr.retrieve("salaryTicketMonth >'"+sdf.format(runMonth)+"' and SalaryTicketStatus!='1'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		SalaryTicket[] u =new SalaryTicket[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryTicket)objs[i];
        }
        return u;
    }
    public Costpay[] getAllCostpayByFeeticekt(Feeticket ft)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        Object[] objs = bigr.retrieve("costpayFeeticketID='"+ft.getId()+"'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    
    public Costpay[] getAllCostpayByCostbook(Costbook cb)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        Object[] objs = bigr.retrieve("costpayCostbookId='"+cb.getId()+"'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    public Costpay[] getAllCostpayBySalaryTicket(SalaryTicket st)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        Object[] objs = bigr.retrieve("costpaySalaryTicketId='"+st.getId()+"'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    
    public Costpay[] getAllSalaryCostpay()
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        Object[] objs = bigr.retrieve("costpaySalaryBankId !='0'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    public Costpay[] getFeeticketByAfterFeecoloseDate(Closemonth cm)
    {
    	if(cm.getClosemonthFeestatus()!=90)
  		{
			return null;
		}
    	CostpayMgr bigr = CostpayMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("created <='"+sdf.format(cm.getClosemonthFeeDate())+"' and costpayFeePayFeeID!='0'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    
    public Costpay[] getCostpayByAfterIncomecoloseDate(Closemonth cm)
    {
    	if(cm.getClosemonthIncomestatus()!=90)
  		{
			return null;
		}
    	CostpayMgr bigr = CostpayMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("created <='"+sdf.format(cm.getClosemonthIncomeDate())+"' and costpayCostbookId!='0' and costpayNumberInOut='0'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
   	public Costpay[] getCostpayByAfterCostcloseDate(Closemonth cm)
    {
    	if(cm.getClosemonthCoststatus()!=90)
  		{
			return null;
		}
    	CostpayMgr bigr = CostpayMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("created <='"+sdf.format(cm.getClosemonthCostDate())+"' and costpayCostbookId!='0' and costpayNumberInOut='1'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    
    public Costpay[] getCostpayByAfterSalarycoloseDate(Closemonth cm)
    {
    	if(cm.getClosemonthSalarystatus()!=90)
  		{
			return null;
		}
    	CostpayMgr bigr = CostpayMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("created <='"+sdf.format(cm.getClosemonthSalaryDate())+"' and costpaySalaryBankId!='0'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    
    public Costpay[] getSalaryticketByBeforeFeecoloseDate(Closemonth cm)
    {
    	if(cm.getClosemonthSalarystatus()!=90)
  		{
			return null;
		}
    	CostpayMgr bigr = CostpayMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("created >'"+sdf.format(cm.getClosemonthSalaryDate())+"' and costpaySalaryBankId!='0'"," order by created asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    
    
    public Costpay[] getCostpayByBeforeIncomecoloseDate(Closemonth cm,int type)
    {
    	if(cm.getClosemonthIncomestatus()!=90)
  		{
			return null;
		}
    	CostpayMgr bigr = CostpayMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("created >'"+sdf.format(cm.getClosemonthIncomeDate())+"' and costpayCostbookId!='0' and costpayNumberInOut='"+type+"'"," order by created asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    
    
    public Costpay[] getCostpayByBeforeIncomecoloseDate(Closemonth cm)
    {
    	if(cm.getClosemonthIncomestatus()!=90)
  		{
			return null;
		}
    	CostpayMgr bigr = CostpayMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("created >'"+sdf.format(cm.getClosemonthIncomeDate())+"' and costpayCostbookId!='0' and costpayNumberInOut='0'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    
    public Costpay[] getCostpayByBeforeCostcoloseDate(Closemonth cm)
    {
    	if(cm.getClosemonthCoststatus()!=90)
  		{
			return null;
		}
    	CostpayMgr bigr = CostpayMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("created >'"+sdf.format(cm.getClosemonthCostDate())+"' and costpayCostbookId!='0' and costpayNumberInOut='1'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
    }
    public int totalCostpayFeenumber(Costpay[] cp)
    {
    	if(cp==null)
    		return 0;
    	
    	int total=0;
    	for(int i=0;i<cp.length;i++)
    	{
    		total+=cp[i].getCostpayIncomeNumber();
    	}
		return total;    		
    }
     
    public int totalCostpayFeenumberCost(Costpay[] cp)
    {
    	if(cp==null)
    		return 0;
    	
    	int total=0;
    	for(int i=0;i<cp.length;i++)
    	{
    		total+=cp[i].getCostpayCostNumber();
    	}
		return total;    		
    } 
    public Costbook[] getCostbookBydate(int type,Date before)
    {
    	CostbookMgr bigr = CostbookMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
         
 
       	Date nextDate=getNextDate(before); 
        
        String query="costbookOutIn="+type+" and modified >='"+sdf.format(before)+"' and modified<'"+sdf.format(nextDate)+"'";
        
        Object[] objs = bigr.retrieve(query," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costbook[] u =new Costbook[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costbook)objs[i];
        }
  
        return u;
    }

    public Costbook[] getCostbookByBeforedate(int type,Date before)
    {
    	CostbookMgr bigr = CostbookMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("costbookOutIn="+type+" and modified >='"+sdf.format(before)+"'"," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costbook[] u =new Costbook[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costbook)objs[i];
        }
  
        return u;
    }
     
    public Date getNextDate(Date rundate) 
	{  
		try{
				
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
			
			String xRunS=sdf.format(rundate);
			Date xRun=sdf.parse(xRunS);  
			
			long runLong=xRun.getTime()+(long)(1000*60*60*24);
			
			return (Date)new Date(runLong);		
		}catch(Exception ex){ 
			
			return null;			
		} 
	} 
	 	 
    public Student[] getStudentModifiedByDate(Date before)
    {
    	StudentMgr bigr = StudentMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
         
       	Date nextDate=getNextDate(before); 
        
        String query="modified >='"+sdf.format(before)+"' and modified<'"+sdf.format(nextDate)+"'";
         
        Object[] objs = bigr.retrieve(query," order by modified desc");
         
        if (objs==null || objs.length==0)
            return null;
	
		Student[] u =new Student[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Student)objs[i];
        }
  
        return u;
    }
  
 	public User[] getEmailUser()
    {
    	UserMgr bigr = UserMgr.getInstance();

        String query="userEmailReport ='1' and userActive='1'";
         
        Object[] objs = bigr.retrieve(query," order by modified desc");
        
 
        if (objs==null || objs.length==0)
            return null;
	
		User[] u =new User[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (User)objs[i];
        }
  
        return u;
    }

    
     public Student[] getStudentByBeforedate(Date before, String space)
    {
    	StudentMgr bigr = StudentMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieveX("modified >='"+sdf.format(before)+"'"," order by modified desc", space);
        
        if (objs==null || objs.length==0)
            return null;
	
		Student[] u =new Student[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Student)objs[i];
        }
  
        return u;
    }
     
    public Insidetrade[] getInsidetradeModifiedByDate(Date before)
    {
    	InsidetradeMgr bigr = InsidetradeMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
         
       	Date nextDate=getNextDate(before); 
        
        String query="modified >='"+sdf.format(before)+"' and modified<'"+sdf.format(nextDate)+"'";

        Object[] objs = bigr.retrieve(query," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Insidetrade[] u =new Insidetrade[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Insidetrade)objs[i];
        }
        return u;
    }

     public Insidetrade[] getInsidetradeByBeforedate(Date before, String space)
    {
    	InsidetradeMgr bigr = InsidetradeMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieveX("modified >='"+sdf.format(before)+"'"," order by modified desc", space);
        
        if (objs==null || objs.length==0)
            return null;
	
		Insidetrade[] u =new Insidetrade[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Insidetrade)objs[i];
        }
        return u;
    }
    public SalaryTicket[] getSalaryTicketByBeforedate(Date before)
    {
        return null; // 暫時沒 upgrade, 資料也具敏感性
        /*
    	SalaryTicketMgr bigr = SalaryTicketMgr.getInstance();
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
        
        Object[] objs = bigr.retrieve("modified >='"+sdf.format(before)+"'"," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		SalaryTicket[] u =new SalaryTicket[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryTicket)objs[i];
        }
        return u;
        */
    } 
    
    public SalaryTicket[] getSalaryTicketModifiedBydate(Date before)
    {
    	SalaryTicketMgr bigr = SalaryTicketMgr.getInstance();
         
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
       	Date nextDate=getNextDate(before); 
        String query="modified >='"+sdf.format(before)+"' and modified<'"+sdf.format(nextDate)+"'";

        Object[] objs = bigr.retrieve(query," order by modified desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		SalaryTicket[] u =new SalaryTicket[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalaryTicket)objs[i];
        }
        return u;
    }

    
	public boolean deleteCost(Cost oldCost)
	{
        int tran_id = 0;
        
        try{
            tran_id = Manager.startTransaction();            
		
            CostMgr cm=new CostMgr(tran_id);
            CostbookMgr cbm=new CostbookMgr(tran_id);

            int oldMoney=oldCost.getCostMoney();

            Costbook cb=(Costbook)cbm.find(oldCost.getCostCostbookId());

            int oldtotal=cb.getCostbookTotalMoney();
            int nowtotal=oldtotal-oldMoney;
            cb.setCostbookTotalMoney(nowtotal);

            int nowTotalnum=cb.getCostbookTotalNum(); 

            cb.setCostbookTotalNum(nowTotalnum-1);
            int totalPay=cb.getCostbookPaiedMoney();

            if(nowtotal==0 && totalPay==0)
            {
                cb.setCostbookPaiedStatus(0);	
            }else{

                if(nowtotal==totalPay)
                {
                    cb.setCostbookPaiedStatus(90);	
                }else if(nowtotal<totalPay){
                    cb.setCostbookPaiedStatus(91);		
                }else if(nowtotal>totalPay){
                    cb.setCostbookPaiedStatus(3);		
                }  	
            }
            cm.remove(oldCost.getId());
            cbm.save(cb);
            Manager.commit(tran_id);
    		return true;
        }catch(Exception e){
	        try { Manager.rollback(tran_id); } catch (Exception e2) {}

            return false;               
        }
	}

	public int modifyCost(Cost co)
	{
        int tran_id = 0;
        
        try{
            tran_id = Manager.startTransaction();            
            
            CostMgr cm=new CostMgr(tran_id);
            CostbookMgr cbm=new CostbookMgr(tran_id);
            
            Cost oldCost=(Cost)cm.find(co.getId());
                
            int oldMoney=oldCost.getCostMoney();
            int newMoney=co.getCostMoney();
                
            oldCost.setCostName(co.getCostName());
            oldCost.setCostMoney(newMoney);
            oldCost.setCostPs(co.getCostPs());
            
            Costbook cb=(Costbook)cbm.find(oldCost.getCostCostbookId());
            
            int oldtotal=cb.getCostbookTotalMoney();
            int nowtotal=oldtotal-oldMoney+newMoney;
            cb.setCostbookTotalMoney(nowtotal);
            
            
            int totalPay=cb.getCostbookPaiedMoney();
        
            if(nowtotal==totalPay)
            {
                cb.setCostbookPaiedStatus(90);	
            }else if(nowtotal<totalPay){
                cb.setCostbookPaiedStatus(91);		
            }else if(nowtotal>totalPay){
                cb.setCostbookPaiedStatus(3);		
            }  	
            cm.save(oldCost);
            cbm.save(cb);
		
            Manager.commit(tran_id);
		    return cb.getId();
        }catch(Exception e){
	        try { Manager.rollback(tran_id); } catch (Exception e2) {}

            return 0;                
        }

	}

	public int modifyCostpay(Costpay cp)
	{
        int tran_id = 0;
        try{
            tran_id = Manager.startTransaction();       

            CostpayMgr cm=new CostpayMgr(tran_id);
            CostbookMgr cbm=new CostbookMgr(tran_id);
            Costpay oldCostpay=(Costpay)cm.find(cp.getId());
            
            int oldMoney=0;
            int newMoney=0;
            
            if(oldCostpay.getCostpayNumberInOut()==1)
            {
                oldMoney=oldCostpay.getCostpayCostNumber();
                newMoney=cp.getCostpayCostNumber();
            }else{
                oldMoney=oldCostpay.getCostpayIncomeNumber();
                newMoney=cp.getCostpayIncomeNumber();
            }
            

            oldCostpay.setCostpayDate(cp.getCostpayDate());
            
            if(oldCostpay.getCostpayNumberInOut()==1)
            {
                oldCostpay.setCostpayCostNumber(newMoney);
            }else{
                oldCostpay.setCostpayIncomeNumber(newMoney);
            }
            
            oldCostpay.setCostpayLogPs(cp.getCostpayLogPs());
            
            Costbook cb=(Costbook)cbm.find(oldCostpay.getCostpayCostbookId());
            
            int nowtotal=cb.getCostbookTotalMoney();
            
            int totalPay=cb.getCostbookPaiedMoney();
            
            int nowPay=totalPay-oldMoney+newMoney;
            
            cb.setCostbookPaiedMoney(nowPay);

            if(nowtotal==nowPay)
            {
                cb.setCostbookPaiedStatus(90);	
            }else if(nowtotal<nowPay){
                cb.setCostbookPaiedStatus(91);		
            }else if(nowtotal>nowPay){
                cb.setCostbookPaiedStatus(3);		
            }  	
            cm.save(oldCostpay);
            cbm.save(cb);
            
            Manager.commit(tran_id);

            return cb.getId();
        }catch(Exception e){
            try { Manager.rollback(tran_id); } catch (Exception e2) {}
            return 0;
        }
	}
	
	    public Tradeaccount[] getAllTradeaccount(String space)
    {
    	TradeaccountMgr bigr = TradeaccountMgr.getInstance();
        
        Object[] objs = bigr.retrieveX(""," order by tradeAccountOrder desc", space);
        
        if (objs==null || objs.length==0)
            return null;
        
        Tradeaccount[] u = new Tradeaccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Tradeaccount)objs[i];
        }
        
        return u;
    }									
    
     public Tradeaccount[] getActiveTradeaccount(int userId)
    {
    	TradeaccountMgr bigr = TradeaccountMgr.getInstance();
        
        Object[] objs = bigr.retrieve("TradeaccountActive='1' and TradeaccountUserId='"+
            userId+"'"," order by tradeAccountOrder desc");
        
        if (objs==null || objs.length==0)
            return null;
        
        Tradeaccount[] u = new Tradeaccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Tradeaccount)objs[i];
        }
        
        return u;
    }	
    
     public Owner[] getAllOwner(String space)
    {
    	OwnerMgr bigr = OwnerMgr.getInstance();
        
        Object[] objs = bigr.retrieveX("","", space);
        
        if (objs==null || objs.length==0)
            return null;
        
        Owner[] u = new Owner[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Owner)objs[i];
        }
        
        return u;
    }	
    
    public Owner[] getActiveOwner()
    {
    	OwnerMgr bigr = OwnerMgr.getInstance();
        
        Object[] objs = bigr.retrieve("ownerStatus='1'","");
        
        if (objs==null || objs.length==0)
            return null;
        
        Owner[] u = new Owner[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Owner)objs[i];
        }
        
        return u;
    }	
	
	
	public Costbook getCostbookByCheckid(String checkId)
    {
    	CostbookMgr bigr = CostbookMgr.getInstance();
        
        Object[] objs = bigr.retrieve("costbookCostcheckId='"+checkId+"'","");
        
        if (objs==null || objs.length==0)
            return null;
        
        Costbook u = (Costbook)objs[0];
        
        return u;
    }	
	public boolean addIncomeOwnertrade(Ownertrade ow, int bunitId)
	{
		
        int tran_id = 0;

        try{

            tran_id = Manager.startTransaction();            
            OwnertradeMgr om=new OwnertradeMgr(tran_id);
            CostpayMgr cm=new CostpayMgr(tran_id);
            ow.setBunitId(bunitId);
            int omId=om.createWithIdReturned(ow);
            
            Costpay cp=new Costpay();
            cp.setCostpayDate   	(ow.getOwnertradeAccountDate());
            cp.setCostpaySide   	(1);
            cp.setCostpaySideID   	(0);
            cp.setCostpayFeeticketID   	(0);
            cp.setCostpayFeePayFeeID   	(0);
            cp.setCostpayOwnertradeStatus   	(1);
            cp.setCostpayOwnertradeId   	(omId);
            cp.setCostpayNumberInOut   	(ow.getOwnertradeInOut());
            cp.setCostpayPayway   	(ow.getOwnertradeWay());
            cp.setCostpayAccountType   	(ow.getOwnertradeAccountType());
            cp.setCostpayAccountId   	(ow.getOwnertradeAccountId());
            cp.setCostpayCostNumber   	(0);
            cp.setCostpayIncomeNumber   	(ow.getOwnertradeNumber());
            cp.setCostpayLogWay   	(1);
            cp.setCostpayLogDate   	(ow.getOwnertradeAccountDate());
            cp.setCostpayLogId   	(ow.getOwnertradeLogId());
            cp.setCostpayLogPs   	(ow.getOwnertradeLogPs());
            cp.setBunitId(bunitId);
            cm.createWithIdReturned(cp);
            Manager.commit(tran_id);
    		return true;

	    }catch(Exception e){

	        try { Manager.rollback(tran_id); } catch (Exception e2) {}            
            return false;
        }
    }
	
	public boolean addCostOwnertrade(Ownertrade ow, int bunitId)
	{
		int tran_id = 0;
        
        try{
            tran_id = Manager.startTransaction();  
            CostpayMgr cm=new CostpayMgr(tran_id);
            
            OwnertradeMgr om=new OwnertradeMgr(tran_id);
            ow.setBunitId(bunitId);
            int omId=om.createWithIdReturned(ow);

            Costpay cp=new Costpay();
            cp.setCostpayDate   	(ow.getOwnertradeAccountDate());
            cp.setCostpaySide   	(1);
            cp.setCostpaySideID   	(0);
            cp.setCostpayFeeticketID   	(0);
            cp.setCostpayFeePayFeeID   	(0);
            cp.setCostpayOwnertradeStatus   	(1);
            cp.setCostpayOwnertradeId   	(omId);
            cp.setCostpayNumberInOut   	(ow.getOwnertradeInOut());
            cp.setCostpayPayway   	(ow.getOwnertradeWay());
            cp.setCostpayAccountType   	(ow.getOwnertradeAccountType());
            cp.setCostpayAccountId   	(ow.getOwnertradeAccountId());
            cp.setCostpayCostNumber   	(ow.getOwnertradeNumber());
            cp.setCostpayIncomeNumber   	(0);
            cp.setCostpayLogWay   	(1);
            cp.setCostpayLogDate   	(ow.getOwnertradeAccountDate());
            cp.setCostpayLogId   	(ow.getOwnertradeLogId());
            cp.setCostpayLogPs   	(ow.getOwnertradeLogPs());
            cp.setBunitId(bunitId);
            cm.createWithIdReturned(cp);
        
            Manager.commit(tran_id);            

            return true;
        }catch(Exception e){

            try { Manager.rollback(tran_id); } catch (Exception e2) {}
            return false;
        }
	}
	
	public Ownertrade[] getPersonOwnertrade(Owner ow)
    {
    	OwnertradeMgr bigr = OwnertradeMgr.getInstance();
        
        Object[] objs = bigr.retrieve("ownertradeOwnerId='"+ow.getId()+"'", null);
        
        if (objs==null || objs.length==0)
            return null;
	
		Ownertrade[] u =new Ownertrade[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Ownertrade)objs[i];
        }
  
        return u;
    }
	
	public Ownertrade[] getAllOwnertrade(String space)
    {
    	OwnertradeMgr bigr = OwnertradeMgr.getInstance();
        
        Object[] objs = bigr.retrieveX("", null, space);
        
        if (objs==null || objs.length==0)
            return null;
	
		Ownertrade[] u =new Ownertrade[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Ownertrade)objs[i];
        }
  
        return u;
    }
    
    public Ownertrade[] getOwnertradeBeforeDate(Date lastDate)
    {
    	OwnertradeMgr bigr = OwnertradeMgr.getInstance();
        
        
        long endDateL=lastDate.getTime()+(long)1000*60*60*24;
    	
    	Date newEndDate=new Date(endDateL);
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
		String query=" created <'"+df.format(newEndDate)+"'";	
        
        
        Object[] objs = bigr.retrieve(query,"");
        
        if (objs==null || objs.length==0)
            return null;
	
		Ownertrade[] u =new Ownertrade[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Ownertrade)objs[i];
        }
  
        return u;
    }
    
    
	public SalarybankAuth[] getSalarybankAuthByBankId(BankAccount sb)
    {
    	SalarybankAuthMgr bigr = SalarybankAuthMgr.getInstance();
        
        Object[] objs = bigr.retrieve("salarybankAuthId ='"+sb.getId()+"'", null);
        
        if (objs==null || objs.length==0)
            return null;
	
		SalarybankAuth[] u =new SalarybankAuth[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalarybankAuth)objs[i];
        }
  
        return u;
    }
    
    public boolean getSalarybankAuthByBankIdUserId(int baId,int UserId)
    {
    	SalarybankAuthMgr bigr = SalarybankAuthMgr.getInstance();
        
        Object[] objs = bigr.retrieve("salarybankAuthId ='"+baId+"' and salarybankAuthUserID='"+UserId+"'", null);
        
        if (objs==null || objs.length==0)
            return true;
		else
        	return false;
    }
    
    public SalarybankAuth[] getSalarybankAuthByUserId(User ux)
    {
    	SalarybankAuthMgr bigr = SalarybankAuthMgr.getInstance();
        
        Object[] objs = bigr.retrieve("salarybankAuthUserID ='"+ux.getId()+"'", null);
        
        if (objs==null || objs.length==0)
            return null;
	
		SalarybankAuth[] u =new SalarybankAuth[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (SalarybankAuth)objs[i];
        }
  
        return u;
    }
    
    public BankAccount[] getAllBankAccount(String space)
    {
    	BankAccountMgr bigr = BankAccountMgr.getInstance();
        
        Object[] objs = bigr.retrieveX("", "", space);
        
        if (objs==null || objs.length==0)
            return null;
        
        BankAccount[] u = new BankAccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (BankAccount)objs[i];
        }
        
        return u;
    }
    
    public Costpay[] getAccountType1Costpay()
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        
        Object[] objs = bigr.retrieve("costpayAccountType='1'", "");
        
        if (objs==null || objs.length==0)
            return null;
        
        Costpay[] u = new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
        
        return u;
    }
    
    public Costpay[] getAccountType2Costpay()
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        
        Object[] objs = bigr.retrieve("costpayAccountType='2'", "");
        
        if (objs==null || objs.length==0)
            return null;
        
        Costpay[] u = new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
        
        return u;
    }
 
 
    public Costpay[] getAccountType1CostpayByTradeId(int tradeId)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        
        Object[] objs = bigr.retrieve("costpayAccountType='1' and costpayAccountId='"+tradeId+"'", "");
        
        if (objs==null || objs.length==0)
            return null;
        
        Costpay[] u = new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
        
        return u;
    }
    
    public boolean balanceAccount(int accountType,int accountId,int modifyTotal,Date payDate,User ud2){

        int originalTotal=getAccountCostpay(accountType,accountId);
        CostbookMgr cbm=CostbookMgr.getInstance();    
        JsfTool jt=JsfTool.getInstance();
        int costtradeId=0;
        String costbookName="帳戶初始化";
        int attachStatus=0;
        int attachway=0;
        String ps="";
        int typeX=0;
        int difNum=originalTotal-modifyTotal;

        if(difNum ==0)
            return false;
        else if( difNum <0)
            typeX=0;
        else if(difNum>0)
            typeX=1;

        int checkId=Integer.parseInt(jt.generateCostcheck(payDate));
        Costbook cb=new Costbook();  
 
        cb.setCostbookOutIn(typeX);
        cb.setCostbookCostcheckId(checkId); 
        cb.setCostbookAccountDate   	(payDate);
        cb.setCostbookCosttradeId   	(costtradeId);
        cb.setCostbookName   	(costbookName);
        cb.setCostbookLogId   	(ud2.getId());
        cb.setCostbookLogPs   	(ps);
        cb.setCostbookAttachStatus   	(attachStatus);
        cb.setCostbookAttachType   	(attachway);
        cb.setCostbookTotalMoney   	(0);
        cb.setCostbookTotalNum   	(0);
        cb.setCostbookPaiedMoney   	(0);
        cb.setCostbookPaiedStatus   (0);
        cb.setCostbookPaidNum   	(0);
        cb.setCostbookVerifyStatus  (0);
        cb.setCostbookVerifyId   	(0);
        //cb.setCostbookVerifyDate   	();
        cb.setCostbookVerifyPs   	("");
        cb.setCostbookActive(1); 
    
        int cId=cbm.createWithIdReturned(cb);
        cb.setId(cId);

        int bigItem=1;
        int smallItem=1;    
        int costMoney=Math.abs(difNum);
        String costName="帳戶初始化";
        Cost c=new Cost();	
        c.setCostAccountDate(cb.getCostbookAccountDate()); 
        c.setCostOutIn (typeX);
        c.setCostName   	(costName);
        c.setCostMoney   	(costMoney);
        c.setCostLogId   	(ud2.getId());
        c.setCostBigItem   	(bigItem);
        c.setCostSmallItem   	(smallItem);
        c.setCostCostbookId   	(cb.getId());
        c.setCostCostCheckId   	(cb.getCostbookCostcheckId());
        c.setCostPs   	("");
        saveCost(c,cb);


        int typeInOut=typeX;
        Costpay cp=new Costpay();
        if (1==1)
            throw new RuntimeException("obsolete!");
		cp.setCostpayDate   	(payDate);
		cp.setCostpaySide(1); 
		cp.setCostpayNumberInOut(typeX);
		cp.setCostpayPayway(1); 

        cp.setCostpayAccountType   	(accountType);
		cp.setCostpayAccountId   	(accountId);

		if(typeInOut==1){ 
			cp.setCostpayCostNumber   	(costMoney);
			cp.setCostpayIncomeNumber (0);
		}else{
			cp.setCostpayCostNumber   	(0);
			cp.setCostpayIncomeNumber (costMoney);
		}

		cp.setCostpayLogWay(1); 
		cp.setCostpayLogDate(new Date());
        cp.setCostpayLogId   	(ud2.getId());
		cp.setCostpayLogPs   	("帳戶初始化");
		cp.setCostpayBanklog   	(0);
		cp.setCostpayCostbookId   	(cId);
		cp.setCostpayCostCheckId(cb.getCostbookCostcheckId());

		int cpId=payCost(cb,cp);

        return true;

    }


    public int getAccountCostpay(int type,int tradeId)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        
        Object[] objs = bigr.retrieve("costpayAccountType='"+type+"' and costpayAccountId='"+tradeId+"'", "");
        
        if (objs==null || objs.length==0)
            return 0;
        
        Costpay[] u = new Costpay[objs.length];
        
        int total=0; 
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
            total+=u[i].getCostpayIncomeNumber()-u[i].getCostpayCostNumber();
        }
        
        return total;
    }
    
    public Costpay[] getCostpayByType(int incomeType)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        
        String query="";
        
        switch(incomeType)
        {
        	case 1:
        		query="costpayFeeticketID !='0' and costpaySide='"+1+"'";	
        		break;
        }
        
        Object[] objs = bigr.retrieve(query, "");
        
        if (objs==null || objs.length==0)
            return null;
        
        Costpay[] u = new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
        
        return u;
    }
    public boolean isAuthorAccount(User u,int accountType,int accountId)
    {
    		if(accountType==1)
    		{
    			TradeaccountMgr tam=TradeaccountMgr.getInstance();
    			
    			Tradeaccount ta=(Tradeaccount)tam.find(accountId);
        
       			if(ta!=null&&ta.getTradeaccountUserId()==u.getId())
       				return true;
       			else 
       				return false; 
    		}else{
    			SalarybankAuthMgr sam=SalarybankAuthMgr.getInstance();
    			Object[] objs = sam.retrieve("salarybankAuthId='"+accountId+"' and salarybankAuthUserID='"+u.getId()+"'", "");
    			
    			if (objs==null || objs.length==0)
    				return false;
    			else
    				return true;		
    		}
    }
    
    public Hashtable getOrderDateByCostpay(Costpay[] cps)
    {
    	if(cps==null)
    	{
    		return null;
    	}
		
		Hashtable ha=new Hashtable();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
		
		for(int i=0;i<cps.length;i++)
		{
			String accountDate=sdf.format(cps[i].getCostpayDate());	
			Hashtable dateha=(Hashtable)ha.get(accountDate);
			
			if(dateha==null)
			{
				dateha=new Hashtable();	

				Vector v=new Vector();		
				v.add((Costpay)cps[i]);
				
										
				if(cps[i].getCostpayNumberInOut()==1)
				{
					dateha.put((String)"1",(Vector)v);
				}else if(cps[i].getCostpayNumberInOut()==0){
					dateha.put((String)"0",(Vector)v);
				}
				ha.put((String)accountDate,(Hashtable)dateha);
			}else{
				if(cps[i].getCostpayNumberInOut()==1)
				{
					Vector v=(Vector)dateha.get((String)"1");
					if(v==null)
					{
						Vector v2=new Vector();		
						v2.add((Costpay)cps[i]);
						dateha.put((String)"1",(Vector)v2);
						ha.put((String)accountDate,(Hashtable)dateha);
					}else{
						v.add((Costpay)cps[i]);
						dateha.put((String)"1",(Vector)v);
						ha.put((String)accountDate,(Hashtable)dateha);	
					}					
				}else if(cps[i].getCostpayNumberInOut()==0){
				
					Vector v=(Vector)dateha.get((String)"0");
					if(v==null)
					{
						Vector v2=new Vector();		
						v2.add((Costpay)cps[i]);
						dateha.put((String)"0",(Vector)v2);
						ha.put((String)accountDate,(Hashtable)dateha);
					}else{
						v.add((Costpay)cps[i]);
						dateha.put((String)"0",(Vector)v);
						ha.put((String)accountDate,(Hashtable)dateha);	
					}					
				}	
			}
		}
		
		return ha;
    }
    
    public String getCostpayContentForPDF(Costpay cp)
    {
    	CostbookMgr cm1=CostbookMgr.getInstance(); 
    	StudentMgr stuM=StudentMgr.getInstance(); 
		InsidetradeMgr in1=InsidetradeMgr.getInstance(); 
		OwnertradeMgr ownM=OwnertradeMgr.getInstance();
	  	OwnerMgr owM=OwnerMgr.getInstance();
	  	SalaryBankMgr sbm=SalaryBankMgr.getInstance();
	  	
		UserMgr umm=UserMgr.getInstance();		
		JsfPay jpp=JsfPay.getInstance();
		
			  	
	  	TeacherMgr tm=TeacherMgr.getInstance();
		TradeaccountMgr tam=TradeaccountMgr.getInstance(); 
		BankAccountMgr bam2=BankAccountMgr.getInstance();
		FeeticketMgr fm=FeeticketMgr.getInstance();
		SalaryTicketMgr stmX=SalaryTicketMgr.getInstance();

		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
		SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM");
 
 
    	StringBuffer outWord=new StringBuffer();
		if(cp.getCostpaySide()==1)
		{ 
			if(cp.getCostpayFeeticketID()==0)
			{  
				if(cp.getCostpayOwnertradeStatus()==0)
				{ 
					if(cp.getCostpaySalaryBankId()==0)
					{ 
						Costbook  co=(Costbook)cm1.find(cp.getCostpayCostbookId());
						
						if(co !=null){ 
						
							if(cp.getCostpayNumberInOut()==1)
							{
								outWord.append("雜費支出 "+co.getCostbookName());
							}else{
								outWord.append("雜費收入 "+co.getCostbookName());
							}	
						}else{
							outWord.append("System Error");
						}	
					}else{
						SalaryTicket st=(SalaryTicket)stmX.find(cp.getCostpaySalaryTicketId());
						
						Teacher tea=(Teacher)tm.find(st.getSalaryTicketTeacherId());

						outWord.append("薪資支出 "+sdf2.format(st.getSalaryTicketMonth())+" "+tea.getTeacherFirstName()+tea.getTeacherLastName());
					}

				}else{
					
					
					Ownertrade ot=(Ownertrade)ownM.find(cp.getCostpayOwnertradeId());
					
					if(ot.getOwnertradeInOut()==0)
					{ 
						outWord.append("股東挹注 ");	
					}else { 
						outWord.append("股東提取 ");
 	 	 	 	 	}  	
 	 	 	 	 	 
					Owner ow2=(Owner)owM.find(ot.getOwnertradeOwnerId());
					outWord.append(ow2.getOwnerName());

				}			
			}else{
				outWord.append("學費收入 ");

				Feeticket  fee=(Feeticket)fm.find(cp.getCostpayFeeticketID()); 
				Date aDate=fee.getFeeticketMonth();
				
				Student stu=(Student)stuM.find(fee.getFeeticketStuId());
				outWord.append(stu.getStudentName()+","+sdf2.format(aDate));
	
			} 
		}else{ 
		
			outWord.append("內部轉帳 ");

			Insidetrade in=(Insidetrade)in1.find(cp.getCostpaySideID());
			if(cp.getCostpayNumberInOut()==1)
			{
				outWord.append("支出 \n to ");		
  		
		  		if(in.getInsidetradeToType()==1)
		  			outWord.append("零用金帳戶-");
		  		else	
		  			outWord.append("銀行帳戶-");

				if(in.getInsidetradeToType()==1)	
				{
					Tradeaccount  td=(Tradeaccount)tam.find(in.getInsidetradeToId()); 
					outWord.append(td.getTradeaccountName());

				}else if(in.getInsidetradeToType()==2){
					
					BankAccount ba=(BankAccount)bam2.find(in.getInsidetradeToId()); 
					outWord.append(ba.getBankAccountName());
				}		
				
			}else{
			  	outWord.append("    存入/n from");				
			
				if(in.getInsidetradeFromType()==1)
					outWord.append("零用金帳戶-");
				else	
					outWord.append("銀行帳戶-");

				if(in.getInsidetradeFromType()==1)	
				{
					Tradeaccount  td=(Tradeaccount)tam.find(in.getInsidetradeFromId()); 
					outWord.append(td.getTradeaccountName());

				}else if(in.getInsidetradeFromType()==2){
					
					BankAccount ba=(BankAccount)bam2.find(in.getInsidetradeFromId()); 
					outWord.append(ba.getBankAccountName());
				}		
			} 
		}

		outWord.append("    ");
		if(cp.getCostpaySide()==1) 
		{
			 if(cp.getCostpayFeeticketID()==0)
			 { 
			  	if(cp.getCostpayOwnertradeStatus()==0)
				{ 
					if(cp.getCostpaySalaryBankId()==0)
					{ 
							outWord.append("傳票號碼:"+cp.getCostpayCostCheckId());
					
							Costbook cbs=(Costbook)cm1.find(cp.getCostpayCostbookId());
						
							if(cbs !=null)
							{ 
								User ux=(User)umm.find(cbs.getCostbookLogId()); 
								outWord.append(" 登入人:");
								
								if(ux !=null)	
								{
									outWord.append(ux.getUserFullname());	
								}	
								outWord.append("\n");
								Cost[] co=jpp.getCostByCBId(cbs);	
								if(co!=null)
								{	
									int xxx=0;
									for(int k=0;k<co.length;k++) 
									{  
										if(k==0) 
											outWord.append("  ->");
										
										outWord.append(co[k].getCostName()+":"+co[k].getCostMoney()+" "); 
									}
								}
							}
					}else{
 
							 	SalaryBank snC=(SalaryBank)sbm.find(cp.getCostpaySalaryBankId());									
								outWord.append("薪資單號:"+snC.getSalaryBankSanumber());

						} 
					}else{

					}
		
				}else{
					Feeticket  fee=(Feeticket)fm.find(cp.getCostpayFeeticketID()); 
					outWord.append("流水號:"+fee.getFeeticketFeenumberId()); 
				}
			}else{
		
			}
		return outWord.toString();
    }
    
    public String getCostpayContent(Costpay cp)
    {
    	CostbookMgr cm1=CostbookMgr.getInstance(); 
    	StudentMgr stuM=StudentMgr.getInstance(); 
		InsidetradeMgr in1=InsidetradeMgr.getInstance(); 
		OwnertradeMgr ownM=OwnertradeMgr.getInstance();
	  	OwnerMgr owM=OwnerMgr.getInstance();
	  	SalaryBankMgr sbm=SalaryBankMgr.getInstance();
	  	UserMgr umm=UserMgr.getInstance();
	  	TeacherMgr tm=TeacherMgr.getInstance();
		TradeaccountMgr tam=TradeaccountMgr.getInstance(); 
		BankAccountMgr bam2=BankAccountMgr.getInstance();
		FeeticketMgr fm=FeeticketMgr.getInstance();
		SalaryTicketMgr stmX=SalaryTicketMgr.getInstance();
		JsfPay jpp=JsfPay.getInstance(); 

		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
		SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM");
 
 
    	StringBuffer outWord=new StringBuffer();
		if(cp.getCostpaySide()==1)
		{ 
			if(cp.getCostpayFeeticketID()==0)
			{  
				if(cp.getCostpayOwnertradeStatus()==0)
				{ 
					if(cp.getCostpaySalaryBankId()==0)
					{ 
						Costbook  co=(Costbook)cm1.find(cp.getCostpayCostbookId());
						
						if(co !=null){ 
						
							if(cp.getCostpayNumberInOut()==1)
							{
								outWord.append("雜費支出</td><tD>"+co.getCostbookName());
							}else{
								outWord.append("雜費收入</td><tD>"+co.getCostbookName());
							}	
						}else{
							outWord.append("<font color=red>System Error</font>");
						}	
					}else{
						SalaryTicket st=(SalaryTicket)stmX.find(cp.getCostpaySalaryTicketId());
						
						Teacher tea=(Teacher)tm.find(st.getSalaryTicketTeacherId());

						outWord.append("薪資支出</td><tD>"+sdf2.format(st.getSalaryTicketMonth())+" "+tea.getTeacherFirstName()+tea.getTeacherLastName());
					}

				}else{
					
					
					Ownertrade ot=(Ownertrade)ownM.find(cp.getCostpayOwnertradeId());
					
					if(ot.getOwnertradeInOut()==0)
					{ 
						outWord.append("股東挹注</td><tD>");	
					}else { 
						outWord.append("股東提取</td><tD>");
 	 	 	 	 	}  	
 	 	 	 	 	 
					Owner ow2=(Owner)owM.find(ot.getOwnertradeOwnerId());
					outWord.append(ow2.getOwnerName());

				}			
			}else{
				outWord.append("學費收入</td><tD>");

				Feeticket  fee=(Feeticket)fm.find(cp.getCostpayFeeticketID()); 
				Date aDate=fee.getFeeticketMonth();
				
				Student stu=(Student)stuM.find(fee.getFeeticketStuId());
				outWord.append(stu.getStudentName()+","+sdf2.format(aDate));
	
			} 
		}else{ 
		
			outWord.append("內部交易</td><tD>");

			Insidetrade in=(Insidetrade)in1.find(cp.getCostpaySideID());
			if(cp.getCostpayNumberInOut()==1)
			{
				outWord.append("&nbsp;支出<br> to ");		
  		
		  		if(in.getInsidetradeToType()==1)
		  			outWord.append("零用金帳戶-");
		  		else	
		  			outWord.append("銀行帳戶-");

				if(in.getInsidetradeToType()==1)	
				{
					Tradeaccount  td=(Tradeaccount)tam.find(in.getInsidetradeToId()); 
					outWord.append(td.getTradeaccountName());

				}else if(in.getInsidetradeToType()==2){
					
					BankAccount ba=(BankAccount)bam2.find(in.getInsidetradeToId()); 
					outWord.append(ba.getBankAccountName());
				}		
				
			}else{
			  	outWord.append("&nbsp;&nbsp;&nbsp;&nbsp; 存入<BR> from");				
			
				if(in.getInsidetradeFromType()==1)
					outWord.append("零用金帳戶-");
				else	
					outWord.append("銀行帳戶-");

				if(in.getInsidetradeFromType()==1)	
				{
					Tradeaccount  td=(Tradeaccount)tam.find(in.getInsidetradeFromId()); 
					outWord.append(td.getTradeaccountName());

				}else if(in.getInsidetradeFromType()==2){
					
					BankAccount ba=(BankAccount)bam2.find(in.getInsidetradeFromId()); 
					outWord.append(ba.getBankAccountName());
				}		
			} 
		}

		outWord.append("&nbsp;&nbsp;&nbsp;&nbsp;");
		if(cp.getCostpaySide()==1) 
		{
			 if(cp.getCostpayFeeticketID()==0)
			 { 
			  	if(cp.getCostpayOwnertradeStatus()==0)
				{ 
					if(cp.getCostpaySalaryBankId()==0)
					{ 
						outWord.append("<a href=\"modifyCostbook.jsp?cid="+cp.getCostpayCostbookId()+"&showType=3\" target=\"_blank\">傳票號碼:"+cp.getCostpayCostCheckId()+"</a>");
						Costbook cbs=(Costbook)cm1.find(cp.getCostpayCostbookId());
						
						if(cbs !=null) 
						{ 
							User ux=(User)umm.find(cbs.getCostbookLogId()); 
							outWord.append(" 登入人:");
							
							if(ux !=null)	
							{
								outWord.append(ux.getUserFullname());	
							}	
							outWord.append("<br>");
							Cost[] co=jpp.getCostByCBId(cbs);	
							if(co!=null)
							{	
								for(int k=0;k<co.length;k++) 
								{ 
									outWord.append(co[k].getCostName()+":"+co[k].getCostMoney()+" "); 
								}
							}
						}
					}else{
 
							 	 SalaryBank snC=(SalaryBank)sbm.find(cp.getCostpaySalaryBankId());									
			outWord.append("<a href=\"salaryTicketDetailX.jsp?stNumber="+snC.getSalaryBankSanumber()+"\" target=\"_blank\">薪資單號:"+snC.getSalaryBankSanumber()+"</a>");

						} 
					}else{
			outWord.append("<a href=\"detailOwnertrade.jsp?otId="+cp.getCostpayOwnertradeId()+"\" target=\"_blank\">詳細資料</a>");
					}
		
				}else{
					Feeticket  fee=(Feeticket)fm.find(cp.getCostpayFeeticketID()); 
			outWord.append("<a href=\"addPayFeeType4x.jsp?z="+fee.getFeeticketFeenumberId()+"\" target=\"_blank\">流水號:"+fee.getFeeticketFeenumberId()+"</a>"); 
				}
			}else{
			outWord.append("<a href=\"modifyInsidetrade.jsp?inId="+cp.getCostpaySideID()+"\" target=\"_blank\">詳細資料</a>");
		
			}
		return outWord.toString();
    }
    
    public Costpay[] getReportCostpay(Date startDate,Date endDate)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	long endDateL=endDate.getTime()+(long)1000*60*60*24;
    	
    	Date newEndDate=new Date(endDateL);

		String query=" costpayDate >='"+df.format(startDate)+"'"+
	    		      " and costpayDate <'"+df.format(newEndDate)+"'";	

        Object[] objs = bigr.retrieve("costpaySide='1'"," order by costpayDate asc");
        
        if (objs==null || objs.length==0)
            return null;
        
        Costpay[] u = new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
        
        return u;
    }
    
    public Costpay[] getAccountType2CostpayByBaId(int tradeId)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        
        Object[] objs = bigr.retrieve("costpayAccountType='2' and costpayAccountId='"+tradeId+"'","");
        
        if (objs==null || objs.length==0)
            return null;
        
        Costpay[] u = new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
        
        return u;
    }

    public phm.ezcounting.IncomeCost getIncomeCost(int accounttype, int tradeId, int type, int tradeType, Date endDate)
    {
        String query = getCostpayQueryString(accounttype, tradeId, type, tradeType, null, endDate);
        String qq = query;
        ArrayList<phm.ezcounting.IncomeCost> ic = phm.ezcounting.IncomeCostMgr.getInstance().retrieveList(qq, "");
        return ic.get(0);
    }

    public String getCostpayQueryString(int accounttype, int tradeId, int type,
        int tradeType, Date startDate, Date endDate)
    {
        
        String query="costpayAccountType='"+accounttype+"' and costpayAccountId='"+tradeId+"'";
        
        if(type !=99)
        {
        	query+=" and costpayNumberInOut='"+type+"'";	
        }
        
        if(tradeType !=99)
        {
        	switch(tradeType)
        	{
        		case 4:
        			query+=" and costpaySide='0' and costpaySideID !='0'";	
        			break;
        		case 1:
        			query+=" and costpaySide='1' and costpayFeeticketID !='0'";	
        			break;		
        		case 2:
        			query+=" and costpaySide='1' and costpaySalaryTicketId !='0'";	
        			break;		
        		case 3:
        			query+=" and costpaySide='1' and costpayCostbookId !='0'";	
        			break;		
        	}	
        }
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	

    	//long endDateL=endDate.getTime()+(long)1000*60*60*24;
    	//Date newEndDate=new Date(endDateL);

        if (startDate!=null)
            query+=" and costpayLogDate>='"+df.format(startDate)+"'";
        if (endDate!=null) {
            Calendar c = Calendar.getInstance();
            c.setTime(endDate);
            c.add(Calendar.DATE, 1);
    		query+=" and costpayLogDate <'"+df.format(c.getTime())+"'";	
        }

        return query;
    }
    
    
    public Costpay[] getCostpayByBaId(int accounttype,int tradeId,int type,int tradeType,Date endDate)
    {
    	CostpayMgr bigr = CostpayMgr.getInstance();
        
        String query = getCostpayQueryString(accounttype, tradeId, type, tradeType, null, endDate);
        Object[] objs = bigr.retrieve(query, "");
        
        if (objs==null || objs.length==0)
            return null;
        
        Costpay[] u = new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
        
        return u;
    }
    
    public boolean insertInsidetrade(Insidetrade in, User ud2, int bunitId)
        throws Exception
    {
        boolean commit = false;
        int tran_id = 0;
        int tran_id2 = 0;
	    try{
            tran_id = Manager.startTransaction();                        
            tran_id2 = dbo.Manager.startTransaction();

            Costpay cost1=new Costpay();
            cost1.setCostpayDate   	(in.getInsidetradeDate());
            cost1.setCostpaySide   	(0);
            cost1.setCostpayNumberInOut   	(1);
            cost1.setCostpayPayway   	(in.getInsidetradeWay());
            cost1.setCostpayAccountType   	(in.getInsidetradeFromType());
            cost1.setCostpayAccountId   	(in.getInsidetradeFromId());
            cost1.setCostpayCostNumber   	(in.getInsidetradeNumber());
            cost1.setCostpayIncomeNumber   	(0);
            cost1.setCostpayLogWay   	(1);
            cost1.setCostpayLogDate   	(in.getInsidetradeDate());
            cost1.setCostpayLogId   	(ud2.getId());
            cost1.setCostpayLogPs   	(in.getInsidetradeUserPs());
            cost1.setBunitId(bunitId);
            
            Costpay income1=new Costpay();
            income1.setCostpayDate   	(in.getInsidetradeDate());
            income1.setCostpaySide   	(0);
            income1.setCostpayNumberInOut   	(0);
            income1.setCostpayPayway   	(in.getInsidetradeWay());
            income1.setCostpayAccountType   	(in.getInsidetradeToType());
            income1.setCostpayAccountId   	(in.getInsidetradeToId());
            income1.setCostpayCostNumber   	(0);
            income1.setCostpayIncomeNumber   	(in.getInsidetradeNumber());
            income1.setCostpayLogWay   	(1);
            income1.setCostpayLogDate   	(in.getInsidetradeDate());
            income1.setCostpayLogId   	(ud2.getId());
            income1.setCostpayLogPs   	(in.getInsidetradeUserPs());
            income1.setBunitId(bunitId);
            
            InsidetradeMgr im = new InsidetradeMgr(tran_id);
            CostpayMgr cm = new CostpayMgr(tran_id);
            
            in.setBunitId(bunitId);
            int imId=im.createWithIdReturned(in);
            in.setId(imId);
            cost1.setCostpaySideID   	(imId);
            income1.setCostpaySideID   	(imId);
            
            cm.createWithIdReturned(cost1);
            cm.createWithIdReturned(income1);
		 
            VoucherService vsvc = new VoucherService(tran_id2, bunitId);
            vsvc.genVoucherForInsideTransfer(in, im, ud2.getId());

            Manager.commit(tran_id);
            dbo.Manager.commit(tran_id2);
            commit = true;
		}
        finally {
            if (!commit) {
                try { Manager.rollback(tran_id); } catch (Exception e2) {}            
                try { dbo.Manager.rollback(tran_id2); } catch (Exception e2) {}
            }
        }
        return commit;
    }

    public boolean removeCostpay(Costbook cb, Costpay cp)
    {
        int tran_id = 0;
        try{        
            tran_id = Manager.startTransaction();
            
            int paNUM=cb.getCostbookPaidNum();
            int paMoney=cb.getCostbookPaiedMoney();
     
            int type=cb.getCostbookOutIn();
     
            int cpMeney=0;
            if(type==1)
                cpMeney=cp.getCostpayCostNumber();
            else
                cpMeney=cp.getCostpayIncomeNumber();
              
            int totalPay=paMoney-cpMeney;
            cb.setCostbookPaidNum(paNUM-1); 
            cb.setCostbookPaiedMoney(totalPay);
            
            if(cb.getCostbookTotalMoney()==totalPay)
            {
                cb.setCostbookPaiedStatus(90);	
            }else if(cb.getCostbookTotalMoney()<totalPay){
                cb.setCostbookPaiedStatus(91);		
            }else if(cb.getCostbookTotalMoney()>totalPay){
                cb.setCostbookPaiedStatus(3);		
            }  	
 
            CostbookMgr cbm=new CostbookMgr(tran_id);                 
            cbm.save(cb);

            CostpayMgr cpm=new CostpayMgr(tran_id);
            cpm.remove(cp.getId());

            Manager.commit(tran_id);

            return true;
        
        }catch(Exception e){

            e.printStackTrace();
            try { Manager.rollback(tran_id); } catch (Exception e2) {}
            return false;
        }
    }
    
     
    public int payCost(Costbook cb,Costpay cp)
    {
        int tran_id = 0;
        try{        
            tran_id = Manager.startTransaction();
            
            int paNUM=cb.getCostbookPaidNum();
            int paMoney=cb.getCostbookPaiedMoney();
     
            int type=cb.getCostbookOutIn();
     
            int cpMeney=0;
            if(type==1)
                cpMeney=cp.getCostpayCostNumber();
            else
                cpMeney=cp.getCostpayIncomeNumber();
              
            int totalPay=paMoney+cpMeney;
            cb.setCostbookPaidNum(paNUM+1); 
            cb.setCostbookPaiedMoney(totalPay);
            
            if(cb.getCostbookTotalMoney()==totalPay)
            {
                cb.setCostbookPaiedStatus(90);	
            }else if(cb.getCostbookTotalMoney()<totalPay){
                cb.setCostbookPaiedStatus(91);		
            }else if(cb.getCostbookTotalMoney()>totalPay){
                cb.setCostbookPaiedStatus(3);		
            }  	
 
            CostbookMgr cbm=new CostbookMgr(tran_id);                 
            cbm.save(cb);

            CostpayMgr cpm=new CostpayMgr(tran_id);
            int cpId=cpm.createWithIdReturned(cp);

            Manager.commit(tran_id);

            return cpId;
        
        }catch(Exception e){

            e.printStackTrace();
            try { Manager.rollback(tran_id); } catch (Exception e2) {}
            return 0;
        }
    }

	public Costpay[] getCostpayByCostbook(Costbook cb)
	{
		CostpayMgr bigr = CostpayMgr.getInstance();
        
        Object[] objs = bigr.retrieve("costpayCostbookId ='"+cb.getId()+"'", null);
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
  
        return u;
	}	
	
	public Insidetrade[] getAllInsidetrade(int orderId)
	{
		InsidetradeMgr bigr = InsidetradeMgr.getInstance();
        
        
        String orderS="";
        
        switch(orderId)
        {
        	case 0:
        		orderS=" order by created asc";	
        		break;
        	case 1:
        		orderS=" order by created desc";	
        		break;
        	case 2:
        		orderS=" order by insidetradeUserId desc";	
        		break;
        	case 3:
        		orderS=" order by insidetradeUserId desc";	
        		break;
        	case 4:
        		orderS=" order by insidetradeFromType,insidetradeFromId desc";	
        		break;
        	case 5:
        		orderS=" order by insidetradeFromType,insidetradeFromId desc";	
        		break;
        	case 6:
        		orderS=" order by insidetradeToType,insidetradeToId desc";	
        		break;
        	case 7:
        		orderS=" order by insidetradeToType,insidetradeToId desc";	
        		break;
        	case 8:
        		orderS=" order by insidetradeCheckLog desc";	
        		break;
        	case 9:
        		orderS=" order by insidetradeCheckLog desc";	
        		break;
        }
        Object[] objs = bigr.retrieve("", orderS);
        
        if (objs==null || objs.length==0)
            return null;
	
		Insidetrade[] u =new Insidetrade[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Insidetrade)objs[i];
        }
  
        return u;
	}
	
	public Insidetrade[] getInsidetradeByVstatus(int vstatus,int orderId, String space)
	{
		InsidetradeMgr bigr = InsidetradeMgr.getInstance();
        
        String orderS="";
        
        switch(orderId)
        {
        	case 0:
        		orderS=" order by created asc";	
        		break;
        	case 1:
        		orderS=" order by created desc";	
        		break;
        	case 2:
        		orderS=" order by insidetradeUserId desc";	
        		break;
        	case 3:
        		orderS=" order by insidetradeUserId desc";	
        		break;
        	case 4:
        		orderS=" order by insidetradeFromType,insidetradeFromId desc";	
        		break;
        	case 5:
        		orderS=" order by insidetradeFromType,insidetradeFromId desc";	
        		break;
        	case 6:
        		orderS=" order by insidetradeToType,insidetradeToId desc";	
        		break;
        	case 7:
        		orderS=" order by insidetradeToType,insidetradeToId desc";	
        		break;
        	case 8:
        		orderS=" order by insidetradeCheckLog desc";	
        		break;
        	case 9:
        		orderS=" order by insidetradeCheckLog desc";	
        		break;
        }
        
        String query="";
        if(vstatus !=999)
        {
        	query="insidetradeCheckLog='"+vstatus+"'";		
        }
        Object[] objs = bigr.retrieveX(query, orderS, space);
        
        if (objs==null || objs.length==0)
            return null;
	
		Insidetrade[] u =new Insidetrade[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Insidetrade)objs[i];
        }
  
        return u;
	}
	
	public Costbook[] getCostbooks(int type,int trader,int logId,Date startDate,Date endDate)
	{
		CostbookMgr cm=CostbookMgr.getInstance();
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	long endDateL=endDate.getTime()+(long)1000*60*60*24;
    	
    	Date newEndDate=new Date(endDateL);

		String query=" costbookAccountDate >='"+df.format(startDate)+"'"+
	    		      " and costbookAccountDate <'"+df.format(newEndDate)+"'";	


		 
		if(type !=99)
			query+=" and costbookOutIn='"+type+"'";
			
		if(trader !=0)
			query+=" and costbookCosttradeId='"+trader+"'";
		
		if(logId !=0)
			query+=" and costbookLogId='"+logId+"'";
		

	
		Object[] objs = cm.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
	
		Costbook[] u =new Costbook[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costbook)objs[i];
        }
  
        return u;
	}
	
	public Costbook[] getCostbooks(int type,int trader,int logId,Date startDate,Date endDate,int paystatus)
	{
		CostbookMgr cm=CostbookMgr.getInstance();
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	long endDateL=endDate.getTime()+(long)1000*60*60*24;
    	
    	Date newEndDate=new Date(endDateL);

		String query=" costbookAccountDate >='"+df.format(startDate)+"'"+
	    		      " and costbookAccountDate <'"+df.format(newEndDate)+"'";	


		if(type !=99)
			query+=" and costbookOutIn='"+type+"'";
			
		if(trader !=0)
			query+=" and costbookCosttradeId='"+trader+"'";
		
		if(logId !=0)
			query+=" and costbookLogId='"+logId+"'";
		
		if(paystatus!=0)
		{
			if(paystatus==1)
			{
				query+=" and costbookPaiedStatus <90";
			}else if(paystatus==90){
				query+=" and costbookPaiedStatus >=90";
			} 
				
					
		}

	
		Object[] objs = cm.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
	
		Costbook[] u =new Costbook[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costbook)objs[i];
        }
  
        return u;
	}
	
	
	public Costbook[] getCostbooksAdvanced(int type,int trader,int logId,Date startDate,Date endDate,int paystatus,int vstatus,int attachatatus)
	{
		CostbookMgr cm=CostbookMgr.getInstance();
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	long endDateL=endDate.getTime()+(long)1000*60*60*24;
    	
    	Date newEndDate=new Date(endDateL);

		String query=" costbookAccountDate >='"+df.format(startDate)+"'"+
	    		      " and costbookAccountDate <'"+df.format(newEndDate)+"'";	

		if(vstatus !=99)
			query+=" and costbookVerifyStatus='"+vstatus+"'";	
			
		if(attachatatus !=0)
			query+=" and costbookAttachStatus='"+attachatatus+"'";		

		if(type !=99)
			query+=" and costbookOutIn='"+type+"'";
			
		if(trader !=0)
			query+=" and costbookCosttradeId='"+trader+"'";
		
		if(logId !=0)
			query+=" and costbookLogId='"+logId+"'";
		
		if(paystatus!=0)
		{
			if(paystatus==1)
			{
				query+=" and costbookPaiedStatus <90";
			}else if(paystatus==90){
				query+=" and costbookPaiedStatus >=90";
			} 
				
					
		}

	
		Object[] objs = cm.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
	
		Costbook[] u =new Costbook[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costbook)objs[i];
        }
  
        return u;
	}
	
	public PayFee[] getPayFeeByMonth(Date runDate)
	{
		PayFeeMgr cm=PayFeeMgr.getInstance();
		
		int year=runDate.getYear()+1900-1911;
		int month=runDate.getMonth()+1;
		String syear=String.valueOf(year);
		String smonth="";
		
		if(month<=9)
			smonth="0"+String.valueOf(month);
		else
			smonth=String.valueOf(month);
			
		String headNum=syear+smonth;	
			
		int startnum=Integer.parseInt(headNum)*100000;
		int endnum=Integer.parseInt(headNum)*100000+99999;	
		
		String query=" payFeeFeenumberId >"+startnum+" and payFeeFeenumberId <="+endnum;
	    		      

		Object[] objs = cm.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
	
		PayFee[] u =new PayFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (PayFee)objs[i];
        }
  
        return u;
	}
	
	public PayFee[] getPayFeeByMonthWay(Date runDate,int way)
	{
		PayFeeMgr cm=PayFeeMgr.getInstance();
		
		int year=runDate.getYear()+1900-1911;
		int month=runDate.getMonth()+1;
		String syear=String.valueOf(year);
		String smonth="";
		
		if(month<=9)
			smonth="0"+String.valueOf(month);
		else
			smonth=String.valueOf(month);
			
		String headNum=syear+smonth;	
			
		int startnum=Integer.parseInt(headNum)*100000;
		int endnum=Integer.parseInt(headNum)*100000+99999;	
		
		String query=" payFeeFeenumberId >"+startnum+" and payFeeFeenumberId <="+endnum+" and payFeeSourceCategory="+way;
	    		      

		Object[] objs = cm.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
	
		PayFee[] u =new PayFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (PayFee)objs[i];
        }
  
        return u;
	}
	public Costbook[] getCostbooks2(int type,int trader,int logId,Date startDate,Date endDate)
	{
		CostbookMgr cm=CostbookMgr.getInstance();
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	

		String query=" costbookAccountDate >='"+df.format(startDate)+"'"+
	    		      " and costbookAccountDate <'"+df.format(endDate)+"'";	

		 
		if(type !=99)
			query+=" and costbookOutIn='"+type+"'";
			
		if(trader !=0)
			query+=" and costbookCosttradeId='"+trader+"'";
		
		if(logId !=0)
			query+=" and costbookLogId='"+logId+"'";
		

		Object[] objs = cm.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
	
		Costbook[] u =new Costbook[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costbook)objs[i];
        }
  
        return u;
	}
	
	public Cost[] getCostByAllItem(Date startDate,Date endDate,int type)
	{
		CostMgr cm=CostMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	long endDateL=endDate.getTime()+(long)1000*60*60*24;
    	
    	Date newEndDate=new Date(endDateL);

		query+=" costAccountDate >='"+df.format(startDate)+"'"+
	    		      " and costAccountDate <'"+df.format(newEndDate)+"' and costOutIn='"+type+"'";	

		 
		Object[] objs = cm.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
	
		Cost[] u =new Cost[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Cost)objs[i];
        }
  
        return u;
	}
	
	public Cost[] getCostByItem(int bId,int sId,Date startDate,Date endDate,int type)
	{
		CostMgr cm=CostMgr.getInstance();
		
		String query="";
		
		if(bId==0)
			query="costSmallItem='"+sId+"'";
		else
			query="costBigItem='"+bId+"'";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	long endDateL=endDate.getTime()+(long)1000*60*60*24;
    	
    	Date newEndDate=new Date(endDateL);

		query+=" and costAccountDate >='"+df.format(startDate)+"'"+
	    		      " and costAccountDate <'"+df.format(newEndDate)+"' and costOutIn='"+type+"'";	

		 
		Object[] objs = cm.retrieve(query, null);
        
        if (objs==null || objs.length==0)
            return null;
	
		Cost[] u =new Cost[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Cost)objs[i];
        }
  
        return u;
	}
	
	public Closemonth[] getClosemonth(Date runDate)
	{
		ClosemonthMgr cm=ClosemonthMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closemonthMonth <='"+df.format(runDate)+"'";
		 
		Object[] objs = cm.retrieve(query, " order by closemonthMonth desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closemonth[] u =new Closemonth[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closemonth)objs[i];
        }
        return u;
	}

	public DoTrade[] getDoTradeByUser(int userId)
	{
		DoTradeMgr cm=DoTradeMgr.getInstance();
		
		String query="";
		if(userId !=999)
			query="doTradeUserId='"+userId+"'";
		Object[] objs = cm.retrieve(query, " order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		DoTrade[] u =new DoTrade[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (DoTrade)objs[i];
        }
        return u;
	}
	
	public DoTrade[] getDoTradeByCostpayId(int cpId)
	{
		DoTradeMgr cm=DoTradeMgr.getInstance();
		
		Object[] objs = cm.retrieve("doTradeCostpayId='"+cpId+"'", " order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		DoTrade[] u =new DoTrade[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (DoTrade)objs[i];
        }
        return u;
	}


	public Closemonth[] getAllFinishClosemonthAsc()
	{
		ClosemonthMgr cm=ClosemonthMgr.getInstance();
		
		String query="closemonthStatus='90'";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		Object[] objs = cm.retrieve(query, "order by closemonthMonth asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closemonth[] u =new Closemonth[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closemonth)objs[i];
        }
        return u;
	}
	
	public Closemonth[] getAllFinishClosemonthDesc()
	{
		ClosemonthMgr cm=ClosemonthMgr.getInstance();
		
		String query="closemonthStatus='90'";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		Object[] objs = cm.retrieve(query, "order by closemonthMonth desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closemonth[] u =new Closemonth[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closemonth)objs[i];
        }
        return u;
	}

	public boolean changeClosemonthStatus(Closemonth cm)
	{
		ClosemonthMgr cmm=ClosemonthMgr.getInstance();
		
		if(cm.getClosemonthFeestatus()==90 && cm.getClosemonthIncomestatus()==90 && cm.getClosemonthSalarystatus()==90 && cm.getClosemonthCoststatus()==90)
		{
			cm.setClosemonthStatus(90);
			cmm.save(cm);	
			
		}else if(cm.getClosemonthFeestatus()==1 || cm.getClosemonthIncomestatus()==1 || cm.getClosemonthSalarystatus()==1 || cm.getClosemonthCoststatus()==1){
			cm.setClosemonthStatus(1);
			cmm.save(cm);	
		}		
		return true;		
	}
	public Closemonth[] getClosemonthAsc(Date runDate)
	{
		ClosemonthMgr cm=ClosemonthMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closemonthMonth <='"+df.format(runDate)+"'";
		 
		Object[] objs = cm.retrieve(query, " order by closemonthMonth asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closemonth[] u =new Closemonth[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closemonth)objs[i];
        }
        return u;
	}
	public Closemonth getThisClosemonth(Date runDate)
	{
		ClosemonthMgr cm=ClosemonthMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closemonthMonth ='"+df.format(runDate)+"'";
		 
		Object[] objs = cm.retrieve(query, " order by closemonthMonth desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closemonth u =(Closemonth)objs[0];

        return u;
	}
	
	public boolean fixFeeticketBypay0(Date xdate)
    {
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query=" feeticketMonth ='"+df.format(xdate)+"/01' and feeticketTotalMoney='0' and feeticketPayMoney='0'";
	       
		Object[] objs = bigr.retrieve(query, "");
	        
	     if (objs==null || objs.length==0)
	     	return true;    
       	
       	Feeticket u =null;
        
        for (int i=0; i<objs.length; i++)
        {
            u = (Feeticket)objs[i];
            u.setFeeticketStatus(91);
			bigr.save(u);            
        }
        return true;
    }
    
   	public boolean fixIncomeBypay0(Date xdate)
    {
    	CostbookMgr bigr = CostbookMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query=" costbookAccountDate >='"+df.format(xdate)+"/01' and  costbookAccountDate <='"+df.format(xdate)+"/31' and costbookTotalNum='0' and costbookPaiedMoney='0'  and costbookOutIn='0'";
	       
		Object[] objs = bigr.retrieve(query, "");
	        
	     if (objs==null || objs.length==0)
	     	return true;    
       	
       	Costbook u =null;
        
        for (int i=0; i<objs.length; i++)
        {
            u = (Costbook)objs[i];
            u.setCostbookPaiedStatus(90);
			bigr.save(u);            
        }
        return true;
    }
    
    public boolean fixCostBypay0(Date xdate)
    {
    	CostbookMgr bigr = CostbookMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query=" costbookAccountDate >='"+df.format(xdate)+"/01' and  costbookAccountDate <='"+df.format(xdate)+"/31' and costbookTotalNum='0' and costbookPaiedMoney='0' and costbookOutIn='1'";
	       
		Object[] objs = bigr.retrieve(query, "");
	        
	     if (objs==null || objs.length==0)
	     	return true;    
       	
       	Costbook u =null;
        
        for (int i=0; i<objs.length; i++)
        {
            u = (Costbook)objs[i];
            u.setCostbookPaiedStatus(90);
			bigr.save(u);            
        }
        return true;
    }
    
    public boolean fixSalaryBypay0(Date xdate)
    {
    	SalaryTicketMgr bigr = SalaryTicketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		String query=" salaryTicketMonth ='"+df.format(xdate)+"/01' and salaryTicketTotalMoney='0' and salaryTicketPayMoney='0'";
	       
		Object[] objs = bigr.retrieve(query, "");
	        
	     if (objs==null || objs.length==0)
	     	return true;    
       	
       	SalaryTicket u =null;
        
        for (int i=0; i<objs.length; i++)
        {
            u = (SalaryTicket)objs[i];
            u.setSalaryTicketStatus(90);
			bigr.save(u);            
        }
        return true;
    }
	public boolean runCloseFee(Closemonth cm)
	{
	 	JsfAdmin ja=JsfAdmin.getInstance();
		JsfTool jt=JsfTool.getInstance();
		
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
		
		Date runDate=cm.getClosemonthMonth();
		
		fixFeeticketBypay0(runDate);
		
		int[] fee=getFeeticketByDate(runDate); 
		
		Date feeDate=new Date();
		int prePayFee=getNumberStudentAccount(feeDate);
		
		
		ClosemonthMgr cmm=ClosemonthMgr.getInstance();
		cm.setClosemonthFeesNum   	(fee[1]);
		cm.setClosemonthFeesNotNum   	(fee[2]);
		cm.setClosemonthFeestatus   	(90);
		cm.setClosemonthFeeDate   	(feeDate);
		cm.setClosemonthFeePrepay(prePayFee);
		
		cmm.save(cm); 
		
		Feeticket[] ticket=ja.getFeeticketByClassStatus(runDate,3,1,999,999);
	 
		
		ClosefeeMgr cfm=ClosefeeMgr.getInstance();
		FeeticketMgr fmx= FeeticketMgr.getInstance();
		if(ticket !=null)
	  	{ 
	  		for(int i=0;i<ticket.length;i++)
	 
	  		{ 
	  			int shouldpaythis=0;
				shouldpaythis =ticket[i].getFeeticketTotalMoney()-ticket[i].getFeeticketPayMoney() ;
	  			
	  			if(shouldpaythis !=0)
	  			{
		  			Closefee  cf=new Closefee();
					cf.setClosefeeMonth   	(runDate);
					cf.setClosefeeType   	(0);
					cf.setClosefeeStatus   	(0);
					cf.setClosefeeFtId   	(ticket[i].getId());
					cf.setClosefeeFeenumberId(ticket[i].getFeeticketFeenumberId());
					cf.setClosefeeNum   	(shouldpaythis);
		  			cfm.createWithIdReturned(cf);
				}		
				ticket[i].setFeeticketLock(2); 
				fmx.save(ticket[i]);
	  		}
	  	}
	  	
	  	Closefee[] cf=getBeforeClosefee(runDate);
	  	
	  	if(cf !=null)
	  	{
	  		for(int j=0;j<cf.length;j++)
	  		{
	  			int ftid=cf[j].getClosefeeFtId();
	  			
	  			Feeticket feeX=(Feeticket)fmx.find(ftid);
	  			
	  			if(feeX.getFeeticketStatus()!=1)
	  			{
					int shouldpaythis=0;
					shouldpaythis =feeX.getFeeticketTotalMoney()-feeX.getFeeticketPayMoney() ;
					
					if(shouldpaythis==0)
					{
						cf[j].setClosefeeStatus(90);		
						cfm.save(cf[j]);
					}
					int beforePay=closefeeBeforeType1Sum(cf[j]);
					
					int nowChange=cf[j].getClosefeeNum()-beforePay-shouldpaythis;
	
					if(nowChange !=0)
					{
						Closefee newCf=new Closefee();				
						newCf.setClosefeeMonth (runDate);
					    newCf.setClosefeeType (1);
					    newCf.setClosefeeStatus(90);
					    newCf.setClosefeeFtId  (feeX.getId());
					    newCf.setClosefeeFeenumberId   	(feeX.getFeeticketFeenumberId());
					    newCf.setClosefeeNum (nowChange);  
		  				cfm.createWithIdReturned(newCf);
					}
	  			}
	  		}	
	  	}
	  	
		return true;		
	}
	
	public int getNumberStudentAccount(Date feeDate) 
	{  
		StudentAccountMgr sagr = StudentAccountMgr.getInstance();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

		String query="created <='"+sdf.format(feeDate)+"'";
		
        Object[] objs = sagr.retrieve(query, "");
        
        if (objs==null || objs.length==0)
            return 0; 
        
        int total=0;    
        for (int i=0; i<objs.length; i++)
        {
           	StudentAccount sa=(StudentAccount)objs[i]; 
            
			if(sa.getStudentAccountIncomeType()==0) 
			{	
				total+=sa.getStudentAccountMoney(); 
			}else if(sa.getStudentAccountIncomeType()==1){
				total-=sa.getStudentAccountMoney();
			}			
        }
		return total;        
	} 

	public int getAfterNumberStudentAccount(Date feeDate)
	{ 
 
		StudentAccountMgr sagr = StudentAccountMgr.getInstance();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

		String query="created >'"+sdf.format(feeDate)+"'";
		
        Object[] objs = sagr.retrieve(query, "");
        
        if (objs==null || objs.length==0)
            return 0; 
        
        int total=0;    
        for (int i=0; i<objs.length; i++)
        {
           	StudentAccount sa=(StudentAccount)objs[i];
 
            
			if(sa.getStudentAccountIncomeType()==0) 
			{	
				total+=sa.getStudentAccountMoney();
 
			}else if(sa.getStudentAccountIncomeType()==1){
				total-=sa.getStudentAccountMoney();
			}			
        }
		return total;        
	} 


	
	public boolean runCloseIncome(Closemonth cm)
	{
		
		Date runDate=cm.getClosemonthMonth();	
	 	
	 	Utility u=Utility.getInstance();
		SimpleDateFormat sdfX1=new SimpleDateFormat("yyyy/MM"); 
		SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy/MM/01"); 
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd"); 

				
		String startString=sdfX2.format(runDate); 
		String endString=u.getLastDateInMonth(runDate);
 
		Costbook[] cbs=null;
		try{
			cbs=getCostbooks(0,0,0,sdf.parse(startString),sdf.parse(endString),0);
		}catch(Exception e){
			return false;	
		}
		
	 	JsfAdmin ja=JsfAdmin.getInstance();
		JsfTool jt=JsfTool.getInstance();
		
		fixIncomeBypay0(runDate);
		
		int[] fee=getCostByDate(runDate,0); 
		
		ClosemonthMgr cmm=ClosemonthMgr.getInstance();
		cm.setClosemonthIncomeNum   	(fee[1]);
		cm.setClosemonthIncomeNotNum   	(fee[2]);
		cm.setClosemonthIncomestatus   	(90);
		cm.setClosemonthIncomeDate   	(new Date());
		
		cmm.save(cm); 
	 	
		CloseincomeMgr cim=CloseincomeMgr.getInstance();
		CostbookMgr fmx= CostbookMgr.getInstance();
		if(cbs !=null)
	  	{ 
	  		for(int i=0;i<cbs.length;i++)
	 
	  		{ 
	  			int shouldpaythis=0;
				shouldpaythis =cbs[i].getCostbookTotalMoney()-cbs[i].getCostbookPaiedMoney() ;
	  			
	  			if(shouldpaythis !=0)
	  			{
		  			Closeincome  cf=new Closeincome();
					cf.setCloseincomeMonth   	(runDate);
					cf.setCloseincomeType   	(0);
					cf.setCloseincomeStatus   	(0);
					cf.setCloseincomeCbId   	(cbs[i].getId());
					cf.setCloseincomeCbCheckId(cbs[i].getCostbookCostcheckId());
					cf.setCloseincomeNum   	(shouldpaythis);
		  			cim.createWithIdReturned(cf);
				}		
	  		}
	  	}
	  	
	  	Closeincome[] ci=getBeforeCloseincome(runDate);
	  	
	  	if(ci !=null)
	  	{
	  		for(int j=0;j<ci.length;j++)
	  		{
	  			int cbId=ci[j].getCloseincomeCbId();
	  			
	  			Costbook cb=(Costbook)fmx.find(cbId);
	  			
	  			if(cb.getCostbookPaiedStatus()!=0)
	  			{
					int shouldpaythis=0;
					shouldpaythis =cb.getCostbookTotalMoney()-cb.getCostbookPaiedMoney() ;
					
					if(shouldpaythis==0)
					{
						ci[j].setCloseincomeStatus(90);		
						cim.save(ci[j]);
					}
					int beforePay=closeincomeBeforeType1Sum(ci[j]);
					
					int nowChange=ci[j].getCloseincomeNum()-beforePay-shouldpaythis;
	
					if(nowChange !=0)
					{
						Closeincome newCf=new Closeincome();				
						newCf.setCloseincomeMonth (runDate);
					    newCf.setCloseincomeType (1);
					    newCf.setCloseincomeStatus(90);
					    newCf.setCloseincomeCbId  (cbId);
					    newCf.setCloseincomeCbCheckId   	(cb.getCostbookCostcheckId());
					    newCf.setCloseincomeNum (nowChange);  
		  				cim.createWithIdReturned(newCf);
					}
	  			}
	  		}	
	  	}
		return true;		
	}
	
	public boolean runCloseCost(Closemonth cm)
	{
		
		Date runDate=cm.getClosemonthMonth();	
	 	
	 	Utility u=Utility.getInstance();
		SimpleDateFormat sdfX1=new SimpleDateFormat("yyyy/MM"); 
		SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy/MM/01"); 
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd"); 

				
		String startString=sdfX2.format(runDate); 
		String endString=u.getLastDateInMonth(runDate);
 
		Costbook[] cbs=null;
		try{
			cbs=getCostbooks(1,0,0,sdf.parse(startString),sdf.parse(endString),0);
		}catch(Exception e){
			return false;	
		}
		
	 	JsfAdmin ja=JsfAdmin.getInstance();
		JsfTool jt=JsfTool.getInstance();
		
		fixCostBypay0(runDate);
		
		int[] fee=getCostByDate(runDate,1); 
		
		ClosemonthMgr cmm=ClosemonthMgr.getInstance();
		cm.setClosemonthCostNum   	(fee[1]);
		cm.setClosemonthCostNotNum   	(fee[2]);
		cm.setClosemonthCoststatus   	(90);
		cm.setClosemonthCostDate   	(new Date());
		
		cmm.save(cm); 
	 	
		ClosecostMgr com=ClosecostMgr.getInstance();
		CostbookMgr fmx= CostbookMgr.getInstance();
		if(cbs !=null)
	  	{ 
	  		for(int i=0;i<cbs.length;i++)
	  		{ 
	  			int shouldpaythis=0;
				shouldpaythis =cbs[i].getCostbookTotalMoney()-cbs[i].getCostbookPaiedMoney() ;
	  			
	  			if(shouldpaythis !=0)
	  			{
		  			Closecost  cf=new Closecost();
					cf.setClosecostMonth   	(runDate);
					cf.setClosecostType   	(0);
					cf.setClosecostStatus   	(0);
					cf.setClosecostCbId   	(cbs[i].getId());
					cf.setClosecostCbCheckId(cbs[i].getCostbookCostcheckId());
					cf.setClosecostNum   	(shouldpaythis);
		  			com.createWithIdReturned(cf);
				}		
	  		}
	  	}
	  	
	  	Closecost[] cc=getBeforeClosecost(runDate);
	  	
	  	if(cc !=null)
	  	{
	  		for(int j=0;j<cc.length;j++)
	  		{
	  			int cbId=cc[j].getClosecostCbId();
	  			
	  			Costbook cb=(Costbook)fmx.find(cbId);
	  			
	  			if(cb.getCostbookPaiedStatus()!=0)
	  			{
					int shouldpaythis=0;
					shouldpaythis =cb.getCostbookTotalMoney()-cb.getCostbookPaiedMoney() ;
					
					if(shouldpaythis==0)
					{
						cc[j].setClosecostStatus(90);		
						com.save(cc[j]);
					}
					int beforePay=closecostBeforeType1Sum(cc[j]);
					
					int nowChange=cc[j].getClosecostNum()-beforePay-shouldpaythis;
	
					if(nowChange !=0)
					{
						Closecost newCf=new Closecost();				
						newCf.setClosecostMonth (runDate);
					    newCf.setClosecostType (1);
					    newCf.setClosecostStatus(90);
					    newCf.setClosecostCbId  (cbId);
					    newCf.setClosecostCbCheckId   	(cb.getCostbookCostcheckId());
					    newCf.setClosecostNum (nowChange);  
		  				com.createWithIdReturned(newCf);
					}
	  			}
	  		}	
	  	}
		return true;		
	}
	
	
	public boolean runCloseSalary(Closemonth cm)
	{
	 	JsfAdmin ja=JsfAdmin.getInstance();
		JsfTool jt=JsfTool.getInstance();
		SalaryAdmin sa=SalaryAdmin.getInstance();
		
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
		
		Date runDate=cm.getClosemonthMonth();
		
		fixSalaryBypay0(runDate);
		
		int[] salary=getSalaryByDate(runDate);
		
		ClosemonthMgr cmm=ClosemonthMgr.getInstance();
		cm.setClosemonthSalaryNum   	(salary[1]);
		cm.setClosemonthSalaryNotNum   	(salary[2]);
		cm.setClosemonthSalarystatus   	(90);
		cm.setClosemonthSalaryDate   	(new Date());
		cmm.save(cm); 
		
		
		SalaryTicket[] ticket=sa.getSalaryTicketByDatePoCla(runDate,999,999);
		ClosesalaryMgr cfm=ClosesalaryMgr.getInstance();
		
		
		if(ticket !=null)
	  	{ 
	  		for(int i=0;i<ticket.length;i++)
	  		{ 
	  			int shouldpaythis=0;
				shouldpaythis =ticket[i].getSalaryTicketTotalMoney()-ticket[i].getSalaryTicketPayMoney() ;
	  			
				if(shouldpaythis !=0)
				{	  			
		  			Closesalary  cf=new Closesalary();
					cf.setClosesalaryMonth   	(runDate);
					cf.setClosesalaryType   	(0);
					cf.setClosesalaryStatus   	(0);
					cf.setClosesalarySalaryId   	(ticket[i].getId());
					cf.setClosesalarySalaryNum(ticket[i].getSalaryTicketSanumberId());
					cf.setClosesalaryNum   	(shouldpaythis);
		  			cfm.createWithIdReturned(cf);
				}		
				//ticket[i].setFeeticketLock(2); 
				//fmx.save(ticket[i]);
	  		}
	  	}
	  	
	  	Closesalary[] cs=getBeforeClosesalary(runDate);
	  	SalaryTicketMgr stm=SalaryTicketMgr.getInstance();
	  	if(cs !=null)
	  	{
	  		for(int j=0;j<cs.length;j++)
	  		{
	  			int csid=cs[j].getClosesalarySalaryId();
	  			
	  			SalaryTicket stX=(SalaryTicket)stm.find(csid);
	  			
	  			if(stX.getSalaryTicketStatus()!=1)
	  			{
					int shouldpaythis=0;
					shouldpaythis =stX.getSalaryTicketTotalMoney()-stX.getSalaryTicketPayMoney() ;
					
					if(shouldpaythis==0)
					{
						cs[j].setClosesalaryStatus(90);		
						cfm.save(cs[j]);
					}
					int beforePay=closesalaryBeforeType1Sum(cs[j]);
					
					int nowChange=cs[j].getClosesalaryNum()-beforePay-shouldpaythis;
	
					if(nowChange !=0)
					{
						Closesalary newCf=new Closesalary();				
						newCf.setClosesalaryMonth (runDate);
					    newCf.setClosesalaryType (1);
					    newCf.setClosesalaryStatus(90);
					    newCf.setClosesalarySalaryId  (stX.getId());
					    newCf.setClosesalarySalaryNum   	(stX.getSalaryTicketSanumberId());
					    newCf.setClosesalaryNum (nowChange);  
		  				cfm.createWithIdReturned(newCf);
					}
	  			}
	  		}	
	  	}
	  	
		return true;		
	}
	public int closefeeBeforeType1Sum(Closefee cf)
	{
		ClosefeeMgr cm=ClosefeeMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closefeeMonth <'"+df.format(cf.getClosefeeMonth())+"' and closefeeType='1' and closefeeFtId='"+cf.getClosefeeFtId()+"'";
		 
		Object[] objs = cm.retrieve(query, " order by closefeeMonth asc");
        
        if (objs==null || objs.length==0)
            return 0;
	
		Closefee[] u =new Closefee[objs.length];
        
        int sum=0;
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closefee)objs[i];
            sum+=u[i].getClosefeeNum();
        }
        return sum;
	}
	
	public int closeincomeBeforeType1Sum(Closeincome ci)
	{
		CloseincomeMgr cm=CloseincomeMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closeincomeMonth <'"+df.format(ci.getCloseincomeMonth())+"' and closeincomeType='1' and closeincomeCbId='"+ci.getCloseincomeCbId()+"'";
		 
		Object[] objs = cm.retrieve(query, " order by closeincomeMonth asc");
        
        if (objs==null || objs.length==0)
            return 0;
	
		Closeincome[] u =new Closeincome[objs.length];
        
        int sum=0;
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closeincome)objs[i];
            sum+=u[i].getCloseincomeNum();
        }
        return sum;
	}
	
	public int closecostBeforeType1Sum(Closecost cc)
	{
		ClosecostMgr cm=ClosecostMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closecostMonth <'"+df.format(cc.getClosecostMonth())+"' and closecostType='1' and closecostCbId='"+cc.getClosecostCbCheckId()+"'";
		 
		Object[] objs = cm.retrieve(query, " order by closecostMonth asc");
        
        if (objs==null || objs.length==0)
            return 0;
	
		Closecost[] u =new Closecost[objs.length];
        
        int sum=0;
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closecost)objs[i];
            sum+=u[i].getClosecostNum();
        }
        return sum;
	}
	public int closesalaryBeforeType1Sum(Closesalary cs)
	{
		ClosesalaryMgr cm=ClosesalaryMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closesalaryMonth <'"+df.format(cs.getClosesalaryMonth())+"' and closesalaryType='1' and closesalarySalaryId='"+cs.getClosesalarySalaryId()+"'";
		 
		Object[] objs = cm.retrieve(query, " order by closesalaryMonth asc");
        
        if (objs==null || objs.length==0)
            return 0;
	
		Closesalary[] u =new Closesalary[objs.length];
        
        int sum=0;
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closesalary)objs[i];
            sum+=u[i].getClosesalaryNum();
        }
        return sum;
			
	}
	
	public int closefeeBeforeMonth(Date runDate)
	{
		ClosefeeMgr cm=ClosefeeMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closefeeMonth <='"+df.format(runDate)+"' and closefeeType='1'";
		 
		Object[] objs = cm.retrieve(query, " order by closefeeMonth asc");
        
        if (objs==null || objs.length==0)
            return 0;
	
		Closefee[] u =new Closefee[objs.length];
        
        int sum=0;
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closefee)objs[i];
            sum+=u[i].getClosefeeNum();
        }
        return sum;
	}

	public int closeincomeBeforeMonth(Date runDate)
	{
		CloseincomeMgr cm=CloseincomeMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closeincomeMonth <='"+df.format(runDate)+"' and closeincomeType='1'";
		 
		Object[] objs = cm.retrieve(query, " order by closeincomeMonth asc");
        
        if (objs==null || objs.length==0)
            return 0;
	
		Closeincome[] u =new Closeincome[objs.length];
        
        int sum=0;
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closeincome)objs[i];
            sum+=u[i].getCloseincomeNum();
        }
        return sum;
	}

	public int closesalaryBeforeMonth(Date runDate)
	{
		ClosesalaryMgr cm=ClosesalaryMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closesalaryMonth <='"+df.format(runDate)+"' and closesalaryType='1'";
		 
		Object[] objs = cm.retrieve(query, " order by closesalaryMonth asc");
        
        if (objs==null || objs.length==0)
            return 0;
	
		Closesalary[] u =new Closesalary[objs.length];
        
        int sum=0;
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closesalary)objs[i];
            sum+=u[i].getClosesalaryNum();
        }
        return sum;
			
	}
	public int closecostBeforeMonth(Date runDate)
	{
		ClosecostMgr cm=ClosecostMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closecostMonth <='"+df.format(runDate)+"' and closecostType='1'";
		 
		Object[] objs = cm.retrieve(query, " order by closecostMonth asc");
        
        if (objs==null || objs.length==0)
            return 0;
	
		Closecost[] u =new Closecost[objs.length];
        
        int sum=0;
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closecost)objs[i];
            sum+=u[i].getClosecostNum();
        }
        return sum;
	}

	
	public Closefee[] closefeeThisMonth(Date runDate)
	{
		ClosefeeMgr cm=ClosefeeMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closefeeMonth ='"+df.format(runDate)+"' and closefeeType='0'";
		 
		Object[] objs = cm.retrieve(query, " order by closefeeMonth asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closefee[] u =new Closefee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closefee)objs[i];
        }
        return u;
			
	}
	
	public Closesalary[] closesalaryThisMonth(Date runDate)
	{
		ClosesalaryMgr cm=ClosesalaryMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closesalaryMonth ='"+df.format(runDate)+"' and closesalaryType='0'";
		 
		Object[] objs = cm.retrieve(query, " order by closesalaryMonth asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closesalary[] u =new Closesalary[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closesalary)objs[i];
        }
        return u;
			
	}
	
	public Closefee[] closefeeBeforeMonth2(Date runDate)
	{
		ClosefeeMgr cm=ClosefeeMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closefeeMonth <='"+df.format(runDate)+"' and closefeeType='1'";
		 
		Object[] objs = cm.retrieve(query, " order by closefeeMonth asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closefee[] u =new Closefee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closefee)objs[i];
        }
        return u;
			
	}
	
	public Closesalary[] closesalaryBeforeMonth2(Date runDate)
	{
		ClosesalaryMgr cm=ClosesalaryMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closesalaryMonth <='"+df.format(runDate)+"' and closesalaryType='1'";
		 
		Object[] objs = cm.retrieve(query, " order by closesalaryMonth asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closesalary[] u =new Closesalary[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closesalary)objs[i];
        }
        return u;
			
	}
	
	public Closesalary[] closesalaryBeforeMonthType0(Date runDate)
	{
		ClosesalaryMgr cm=ClosesalaryMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closesalaryMonth <'"+df.format(runDate)+"' and closesalaryType='0'";
		 
		Object[] objs = cm.retrieve(query, " order by closesalaryMonth asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closesalary[] u =new Closesalary[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closesalary)objs[i];
        }
        return u;
			
	}
	public Closefee[] getBeforeClosefee(Date runDate)
	{
		ClosefeeMgr cm=ClosefeeMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closefeeMonth <'"+df.format(runDate)+"' and closefeeType='0' and closefeeStatus<'90'";
		 
		Object[] objs = cm.retrieve(query, " order by closefeeMonth asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closefee[] u =new Closefee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closefee)objs[i];
        }
        return u;
	}
	
	public Closeincome[] getBeforeCloseincome(Date runDate)
	{
		CloseincomeMgr cm=CloseincomeMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closeincomeMonth <'"+df.format(runDate)+"' and closeincomeType='0' and closeincomeStatus<'90'";
		 
		Object[] objs = cm.retrieve(query, " order by closeincomeMonth asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closeincome[] u =new Closeincome[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closeincome)objs[i];
        }
        return u;
	}
	
	public Closecost[] getBeforeClosecost(Date runDate)
	{
		ClosecostMgr cm=ClosecostMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closecostMonth <'"+df.format(runDate)+"' and closecostType='0' and closecostStatus<'90'";
		 
		Object[] objs = cm.retrieve(query, " order by closecostMonth asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closecost[] u =new Closecost[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closecost)objs[i];
        }
        return u;
	}
	
	public Closesalary[] getBeforeClosesalary(Date runDate)
	{
		ClosesalaryMgr cm=ClosesalaryMgr.getInstance();
		
		String query="";
		
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/01");	

		query=" closesalaryMonth <'"+df.format(runDate)+"' and closesalaryType='0' and closesalaryStatus<'90'";
		 
		Object[] objs = cm.retrieve(query, " order by closesalaryMonth asc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Closesalary[] u =new Closesalary[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Closesalary)objs[i];
        }
        return u;
	}
	public int[] getFeeticketByDate(Date runDate)
	{
		int[] total={0,0,0};

		JsfAdmin ja=JsfAdmin.getInstance();
		
		Feeticket[] ticket=ja.getFeeticketByClassLevel(runDate,3,0,999,999);
			
		if(ticket ==null)
		{	
			return total;
		}
		
		for(int i=0;i<ticket.length;i++)
		{
			total[0]+=ticket[i].getFeeticketTotalMoney();	
			total[1]+=ticket[i].getFeeticketPayMoney();
			total[2]+=ticket[i].getFeeticketTotalMoney()-ticket[i].getFeeticketPayMoney();
		}
		
		return total;
	}
	
    public int[] getFeeticketByDatePlusNum(Date runDate)
	{
		int[] total={0,0,0,0,0,0,0};

		JsfAdmin ja=JsfAdmin.getInstance();
		
		Feeticket[] ticket=ja.getFeeticketByClassLevel(runDate,3,0,999,999);
			
		if(ticket ==null)
		{	
			return total;
		}

        total[3]=ticket.length;
		
		for(int i=0;i<ticket.length;i++)
		{
			total[0]+=ticket[i].getFeeticketTotalMoney();	
			total[1]+=ticket[i].getFeeticketPayMoney();
			total[2]+=ticket[i].getFeeticketTotalMoney()-ticket[i].getFeeticketPayMoney();
            
            if(ticket[i].getFeeticketPayMoney()!=0)
            {
                total[4]++;
                
                if((ticket[i].getFeeticketTotalMoney()-ticket[i].getFeeticketPayMoney())!=0)
                    total[6]++;
            }else{
                total[5]++;
            }
		}
		
		return total;
	}

	public int[] getSalaryByDate(Date runDate)
	{
		int[] total={0,0,0};
		SalaryAdmin sa=SalaryAdmin.getInstance();

		SalaryTicket[] st=sa.getSalaryTicketByDatePoCla(runDate,999,999);
	
		if(st==null)
			return total;
			
		for(int i=0;i<st.length;i++)
		{
				total[0]+=st[i].getSalaryTicketTotalMoney();
				total[1]+=st[i].getSalaryTicketPayMoney();
				total[2]+=st[i].getSalaryTicketTotalMoney()-st[i].getSalaryTicketPayMoney();
		}
		return total;
	}
	
	public int[] getSalaryByParttime(Date runDate)
	{
		int[] total={0,0,0};
		SalaryAdmin sa=SalaryAdmin.getInstance();
		SalaryTicket[] st=sa.getSalaryTicketByDatePoCla(runDate,999,999);
	
		if(st==null) 
		{ 
			System.out.println("no data");	
			return total;
		}		
		for(int i=0;i<st.length;i++)
		{
				if(st[i].getSalaryTicketTeacherParttime()==0)
				{					
					total[0]+=st[i].getSalaryTicketTotalMoney();
				}else if(st[i].getSalaryTicketTeacherParttime()==1){
						
					total[1]+=st[i].getSalaryTicketTotalMoney();	
				}else if(st[i].getSalaryTicketTeacherParttime()==2){
					total[2]+=st[i].getSalaryTicketTotalMoney();	
				}
				
		}
		return total;
	}
	
	public int[] getCostByDate(Date runDate,int type)
	{
		int[] total={0,0,0};
		
		int eyear=runDate.getYear()+1900;
		int emonth=runDate.getMonth()+1;

		emonth+=1;

		if(emonth==13)
		{
			emonth=1;
			eyear+=1;	
		}
		String sYear=String.valueOf(eyear);
		String sMonth="";			
		if(emonth<=9)
			sMonth="0"+String.valueOf(emonth);	
		else
			sMonth=String.valueOf(emonth);	
			
		try{
				
			java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");		
			
			//java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
			String parseString=sYear+"/"+sMonth+"/01";
			Date endDate=df.parse(parseString);		
			
			
			
			
			Costbook[] cbs=getCostbooks2(type,0,0,runDate,endDate);		
					
			if(cbs==null)
			{
				return total;
			}
			
			for(int i=0;i<cbs.length;i++)
			{
				total[0]+=cbs[i].getCostbookTotalMoney();
				total[1]+=cbs[i].getCostbookPaiedMoney();
				total[2]+=cbs[i].getCostbookTotalMoney()-cbs[i].getCostbookPaiedMoney();	
			}
					
		}catch(Exception e){}		

		return total;
	}
	
	public int getOwnertradeBeforeRundate(Date runDate)
	{
			
		OwnertradeMgr om=OwnertradeMgr.getInstance();
		
		long endDateL=runDate.getTime()+(long)1000*60*60*24;
    	
    	Date newEndDate=new Date(endDateL);
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
		String query=" created <'"+df.format(newEndDate)+"'";	

		
		
        Object[] objs = om.retrieve(query," order by ownertradeAccountDate desc");
     	
     	if (objs==null || objs.length==0)
            return 0;
	
		Ownertrade u =null;
        
        int allTotal=0; 
        for (int i=0; i<objs.length; i++)
        {
            u= (Ownertrade)objs[i];
       		if(u.getOwnertradeInOut()==1)
				allTotal-=u.getOwnertradeNumber();
			else if(u.getOwnertradeInOut()==0)	
				allTotal+=u.getOwnertradeNumber();		
       	
        }
        return allTotal;
	}
	
	public int getOwnertradeAfterRundate(Date runDate)
	{
			
		OwnertradeMgr om=OwnertradeMgr.getInstance();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
        Object[] objs = om.retrieve(" created >='"+sdf.format(runDate)+"'"," order by ownertradeAccountDate desc");
     	
     	if (objs==null || objs.length==0)
            return 0;
	
		Ownertrade u =null;
        
        int allTotal=0; 
        for (int i=0; i<objs.length; i++)
        {
            u= (Ownertrade)objs[i];
       		if(u.getOwnertradeInOut()==1)
				allTotal-=u.getOwnertradeNumber();
			else if(u.getOwnertradeInOut()==0)	
				allTotal+=u.getOwnertradeNumber();		
       	
        }
        return allTotal;
	}
	
}    