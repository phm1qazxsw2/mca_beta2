package jsf;

import java.util.*;
import jsi.*;
import java.text.*;
import phm.util.*;
import java.io.*;
import com.axiom.util.DbPool;
import beans.jdbc.DbConnectionPool;

public class ReportAdmin
{
	private static ReportAdmin instance;
    
    ReportAdmin() {}
    
    public synchronized static ReportAdmin getInstance()
    {
        if (instance==null)
        {
            instance = new ReportAdmin();
        }
        return instance;
    }
    	
    public String getCashAccount()
    {
		StringBuffer sb=new StringBuffer();

    	DecimalFormat nf = new DecimalFormat("###,##0.00");
  		DecimalFormat mnf = new DecimalFormat("###,###,##0");
  		
  		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
  
   		JsfAdmin ja=JsfAdmin.getInstance();
		SalaryAdmin sa=SalaryAdmin.getInstance();

        if (1==1)
            throw new RuntimeException("obsolete!");

		JsfPay jp=JsfPay.getInstance();
		Tradeaccount[] tradeA=jp.getAllTradeaccount(null);

		int total2=0;	
		int costTotal=0;
		int  incomeTotal=0;
		int totalAccountNum=0;
 
		int tradeNum[]=null;
	

		if(tradeA!=null)
		{
			int totalTrade=tradeA.length;
			Costpay[] cp=jp.getAccountType1Costpay();
			
			if(cp!=null)
	  		{
				Hashtable allTrade=jp.getTradeAcccountNum(cp);		
				Hashtable incomeHa=(Hashtable)allTrade.get("in"); 
				Hashtable costHa=(Hashtable)allTrade.get("co"); 
	
				sb.append("<b>零用金帳戶:</b>");
				
				String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
				sb.append(xString);
				sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
				sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
				sb.append("<td>帳戶名稱</tD><tD>支出</tD><tD>存入</tD><tD>餘額</tD></tr>"); 
				
				tradeNum=new int[tradeA.length]; 
				for(int tI=0;tI<tradeA.length;tI++)
				{
					tradeNum[tI]=0; 
				}	
				
				for(int j=0;j<tradeA.length;j++)
				{
		  			sb.append("<tr bgcolor=ffffff>");  
		  			sb.append("<td align=left>"+tradeA[j].getTradeaccountName()+"</tD>");
		  			
		  			int cost=0; 
					if(costHa.get(String.valueOf(tradeA[j].getId()))==null)
					{
						cost=0;
						sb.append("<td align=right>0</tD>");
					}else{
						String costS=(String)costHa.get(String.valueOf(tradeA[j].getId()));
						cost=Integer.parseInt(costS);
						sb.append("<td align=right>"+mnf.format(cost)+"</tD>");
						costTotal += cost;
					}
					
					int income=0; 
					
					if(incomeHa.get(String.valueOf(tradeA[j].getId()))==null)
					{
						income=0;
						sb.append("<td align=right>0</tD>");
					}else{
						String incomeS=(String)incomeHa.get(String.valueOf(tradeA[j].getId()));
						income=Integer.parseInt(incomeS);
						
						sb.append("<td align=right>"+mnf.format(income)+"</tD>");
						incomeTotal +=income; 
					}
					tradeNum[j]=income-cost;
					sb.append("<td align=right>"+mnf.format(tradeNum[j])+"</tD>");
					
					sb.append("</tr>");
	  			}
	  			sb.append("<tr>");
	  			sb.append("<td>合計</td>");
				sb.append("<tD align=right>"+mnf.format(costTotal)+"</td>");
				sb.append("<tD align=right>"+mnf.format(incomeTotal)+"</td>");
				sb.append("<tD align=right><b>"+mnf.format(incomeTotal-costTotal)+"</b></td>");
  				sb.append("</tr>");
  				
  				total2=incomeTotal-costTotal;
	  			sb.append("</table></td></tr></table></center>");
	  		}
    	}	

        if (1==1)
            throw new RuntimeException("obsolete!");
    	
    	BankAccount[] ba=sa.getAllBankAccount(null);
		int baNum[] =null;
		int bcostTotal=0;
		int  bincomeTotal=0;
 
		if(ba!=null)
		{
			Costpay[] bcp=jp.getAccountType2Costpay(); 
			
			if(bcp !=null) 
			{  
		 		Hashtable allBankTrade=jp.getBankNum(bcp);		
				Hashtable bincomeHa=(Hashtable)allBankTrade.get("in"); 
				Hashtable bcostHa=(Hashtable)allBankTrade.get("co"); 
			
				sb.append("<br><b>銀行帳戶:</b>");
				
				String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
				sb.append(xString);
				sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
				sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
				sb.append("<td>帳戶名稱</tD><tD>支出</tD><tD>存入</tD><tD>餘額</tD></tr>");

				baNum=new int[ba.length]; 
				for(int bI=0;bI<ba.length;bI++)
				{
					baNum[bI]=0; 
				}	
  				for(int j=0;j<ba.length;j++)
				{	 	
   					sb.append("<tr bgcolor=ffffff>");  
    				sb.append("<td>"+ba[j].getBankAccountName()+"</tD>");
    					
					int cost=0; 
					if(bcostHa.get(String.valueOf(ba[j].getId()))==null)
					{
						cost=0;
						sb.append("<td align=right>0</tD>");
					}else{
						String costS=(String)bcostHa.get(String.valueOf(ba[j].getId()));
						cost=Integer.parseInt(costS);
						sb.append("<td align=right>"+mnf.format(cost)+"</tD>");
						bcostTotal += cost; 
					}
					
					int income=0; 
					
					if(bincomeHa.get(String.valueOf(ba[j].getId()))==null)
					{
						income=0;
						sb.append("<td align=right>0</tD>");
					}else{
						String incomeS=(String)bincomeHa.get(String.valueOf(ba[j].getId()));
						income=Integer.parseInt(incomeS); 
						sb.append("<td align=right>"+mnf.format(income)+"</tD>");
						bincomeTotal +=income;
					}
					baNum[j]=income-cost;			    					

					sb.append("<td class=es02  align=right>"+mnf.format(income-cost)+"</tD>");
    				sb.append("</tr>");		
				} 
	
				sb.append("<tr>");		
				sb.append("<td>合計</td>");
				sb.append("<tD align=right>"+mnf.format(bcostTotal)+"</td>");
				sb.append("<tD align=right>"+mnf.format(bincomeTotal)+"</td>");
				sb.append("<tD align=right><b>"+mnf.format(bincomeTotal-bcostTotal)+"</b></td>");
		  		sb.append("</tr>");		

 	 	 		sb.append("</table></td></tr></talbe></center>"); 			
			}
		} 
		
		sb.append("<br><center><Font Color=2>[現金帳戶報表 產生時間:"+sdf.format(new Date())+"  系統自動發送]</font></center>");	
    	
    	return sb.toString();	
    }	
     
   	public String getStudentUpdate(Date runDate)
    { 
   		JsfPay jp=JsfPay.getInstance(); 
   		JsfTool jt=JsfTool.getInstance();

		Student[] st=jp.getStudentModifiedByDate(runDate); 
		
		if(st ==null)
  			return "";
  			
  		StringBuffer sb=new StringBuffer();
  		  	
  		sb.append("<b>學生名單更動概況:</b>");
		String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
		sb.append(xString);
		sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
		sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");

  		sb.append("<td>學生姓名</td><tD>入學狀態</td><td>性別</td><td>單位</td><td>班級</td><td>年級</td><td>生日</td><td>家中電話1</td></tR>"); 
		
		ClassesMgr cm=ClassesMgr.getInstance();
		DepartMgr dm=DepartMgr.getInstance();
		LevelMgr lm=LevelMgr.getInstance();
		
		for(int i=0;i<st.length;i++)
		{  
			sb.append("<tr bgcolor=ffffff>");	
			sb.append("<td>"+st[i].getStudentName()+"</td>"); 
			switch(st[i].getStudentStatus())
			{ 
				case 1:
					sb.append("<td>參觀登記/上網登入</td>");
					break;
				case 2:
					sb.append("<td>報名/等待入學</td>");
					break;
				case 3:
					sb.append("<td>試讀</td>");
					break;
				case 4:
					sb.append("<td>入學</td>");
					break;
				case 97:
					sb.append("<td>離校</tD>");
					break;
				case 99:
					sb.append("<td>畢業</td>");
					break;
			} 
			if(st[i].getStudentSex()==1)
				sb.append("<td>男</td>"); 
			else
				sb.append("<td>女</td>");
			
			int departIdx=st[i].getStudentDepart();
			if(departIdx==0)
			{
				sb.append("<td>未定</td>");
			}else{
				Depart dex=(Depart)dm.find(departIdx);
				sb.append("<td>"+dex.getDepartName()+"</tD>");
			}
			
			int cid=st[i].getStudentClassId(); 
			if(cid==0)
			{
				sb.append("<td>未定</tD>"); 
			}else{		
				Classes cla=(Classes)cm.find(cid);
				sb.append("<td>"+cla.getClassesName()+"</td>");
			}	
			
			int levelx=st[i].getStudentLevel(); 
			if(levelx==0)
			{
				sb.append("<td>未定</tD>");
			}else{
				Level leve=(Level)lm.find(levelx);
				sb.append("<td>"+leve.getLevelName()+"</td>");
			}
			
			sb.append("<td>"+jt.ChangeDateToString(st[i].getStudentBirth())+"</td>");
			sb.append("<td>"+st[i].getStudentPhone()+"</td>");
			sb.append("</tr>");	
		}
  			
		sb.append("</table></td></tr></table></center>");
  		
      	return sb.toString();
    } 
    
    public String getFeeticketUpdate(Date runDate)
    {
   		JsfPay jp=JsfPay.getInstance(); 
   		JsfTool jt=JsfTool.getInstance();
   		JsfAdmin ja=JsfAdmin.getInstance();
    	DecimalFormat mnffee = new DecimalFormat("###,###,##0");
    	Feeticket[] ticket=jp.getFeeticketModifiedByDate(runDate);
    	StudentMgr sm=StudentMgr.getInstance();	
	
		if(ticket==null) 
		{ 
			return "";
		} 
		
		StringBuffer sb=new StringBuffer();
		
		sb.append("<b>學費更動概況:</b>");
		
		String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
		sb.append(xString);
		sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
		sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
		sb.append("<td>姓名</td><td>流水序號</td><td>繳款狀態</td><td>項目</td><td>應繳金額/未繳金額</td></tr>"); 
		
		
		int totoalShould=0;
		int totalDiscount=0;
		int total=0;
		int totalPay=0;
		
		for(int i=0;i<ticket.length;i++)
		{
			Student stu=(Student)sm.find(ticket[i].getFeeticketStuId());
			totoalShould +=ticket[i].getFeeticketSholdMoney();
			totalDiscount+=ticket[i].getFeeticketDiscountMoney();
			total+=ticket[i].getFeeticketTotalMoney();
			totalPay+=ticket[i].getFeeticketPayMoney();
			
			sb.append("<tr bgcolor=ffffff><td>"+stu.getStudentName()+"</td><td>");			
			int ftlock=ticket[i].getFeeticketLock();

			if(ftlock==0)
			{
				sb.append("[可編輯]-"+ticket[i].getFeeticketFeenumberId());
			}else if(ftlock ==1){ 
				sb.append("[鎖定中]-"+ticket[i].getFeeticketFeenumberId());
			}else if(ftlock==2){
				sb.append("[已銷單]-"+ticket[i].getFeeticketFeenumberId());
			} 
			sb.append("</td><td>");
	
			int status2=ticket[i].getFeeticketStatus();
			switch(status2){
				case 1:
					sb.append("尚未繳款");
					break;
				case 2:
					sb.append("已繳款尚未繳清");
					break;
				case 91:
					sb.append("已繳清");
					break;
				case 92:
					sb.append("超繳");
					break;	
			} 
			
			sb.append("</td><td>");

			ClassesFee[] cf=ja.getClassesFeeByNumber(ticket[i].getFeeticketFeenumberId());
			ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
			if(cf !=null){
				for(int i2=0;i2<cf.length;i2++)
				{
					ClassesMoney cm=(ClassesMoney)cmm.find(cf[i2].getClassesFeeCMId());
					sb.append(cm.getClassesMoneyName()+":");
					sb.append(mnffee.format(cf[i2].getClassesFeeShouldNumber()-cf[i2].getClassesFeeTotalDiscount())+"<br>");
				}
			}
			sb.append("</td><td>");
			int shouldpaythis=0;
			shouldpaythis =ticket[i].getFeeticketTotalMoney()-ticket[i].getFeeticketPayMoney();
			
			sb.append(mnffee.format(ticket[i].getFeeticketTotalMoney())+"/");
			
			if(shouldpaythis>0)
			{
				sb.append(mnffee.format(shouldpaythis));
			}else{
				sb.append("0");
			}
			sb.append("</td>");
			
			sb.append("</tr>"); 
		}
		sb.append("</table></td></tr></table>");
		sb.append("</center>");		
        
        return sb.toString();
	}      
	
	
    public String getSalaryUpdate(Date runDate)
    {  
     	DecimalFormat stmnf = new DecimalFormat("###,###,##0");
		
		JsfPay jp=JsfPay.getInstance(); 
   		JsfTool jt=JsfTool.getInstance();
   		JsfAdmin ja=JsfAdmin.getInstance();

		SalaryTicket[] stXX=jp.getSalaryTicketModifiedBydate(runDate);
 				
 		if(stXX==null)		
 			return ""; 	

		StringBuffer sb=new StringBuffer();
		
		sb.append("<b>薪資更動概況</b>"); 
		
		String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
		sb.append(xString);
		sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
		sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
		sb.append("<td>流水號</td><td>姓名</td><td>狀態</td><td>應領所得</td><td>代扣</td><td>應扣薪資</td><td>薪資合計</td><td>付款次數</td><td>已付金額</td><td>應付餘額</td></tr>"); 
		
		int totalType1=0;
		int totalType2=0;
		int totalType3=0;
		int payTotal=0;
		int shouldTotal=0;
		TeacherMgr tm=TeacherMgr.getInstance();
	
		for(int i=0;i<stXX.length;i++)
		{	
			totalType1+=stXX[i].getSalaryTicketMoneyType1();
			totalType2+=stXX[i].getSalaryTicketMoneyType2();
			totalType3+=stXX[i].getSalaryTicketMoneyType3(); 
			payTotal += stXX[i].getSalaryTicketPayMoney();  
			shouldTotal+=stXX[i].getSalaryTicketTotalMoney()-stXX[i].getSalaryTicketPayMoney();
			Teacher tea=(Teacher)tm.find(stXX[i].getSalaryTicketTeacherId());
			
			sb.append("<tr bgcolor=ffffff>");
			sb.append("<tD>"+stXX[i].getSalaryTicketSanumberId()+"</td>");			
			sb.append("<tD>"+tea.getTeacherFirstName()+tea.getTeacherLastName()+"</td>");				
			sb.append("<td>");
			switch(stXX[i].getSalaryTicketStatus())
			{
				case 1:
					sb.append("尚未支付");
					break;
				case 2:
					sb.append("<font color=red>金額已更新</font>");
	  				break;
	  			case 3:
	  				sb.append("<font color=blue>支付部分</font>");
	  				break;
				case 90:
	  				sb.append("已付清");
	  				break;
	  			case 91:
	  				sb.append("超付");
	  				break;
	  			default:
	  				sb.append("其他");
	  				break;		
	 		}
			sb.append("</td>");
			sb.append("<tD align=right>"+stmnf.format(stXX[i].getSalaryTicketMoneyType1())+"</td>");			
			sb.append("<tD align=right>"+stmnf.format(stXX[i].getSalaryTicketMoneyType2())+"</td>");			
			sb.append("<tD align=right>"+stmnf.format(stXX[i].getSalaryTicketMoneyType3())+"</td>");			
			sb.append("<tD align=right>"+stmnf.format(stXX[i].getSalaryTicketTotalMoney())+"</td>");	
			sb.append("<tD align=right>"+stmnf.format(stXX[i].getSalaryTicketPayTimes())+"</td>");			
			sb.append("<tD align=right>"+stmnf.format(stXX[i].getSalaryTicketPayMoney())+"</td>");  
			sb.append("<tD align=right>"+stmnf.format(stXX[i].getSalaryTicketTotalMoney()-stXX[i].getSalaryTicketPayMoney())+"</td>"); 
			sb.append("</tr>");
		}	
		sb.append("</table></td></tr></table>");	
		sb.append("</center>");
		return sb.toString();
    }
	
	public String getCostbookUpdate(int type,Date runDate)
    {   
     	//type 0  =income
     	//type 1  =cost		
     		
     	DecimalFormat stmnf = new DecimalFormat("###,###,##0");

		JsfPay jp=JsfPay.getInstance(); 
   		JsfTool jt=JsfTool.getInstance();
   		JsfAdmin ja=JsfAdmin.getInstance();

		UserMgr umc=UserMgr.getInstance();
		DecimalFormat mnfcost = new DecimalFormat("###,###,##0");
		SimpleDateFormat sdfDateCost=new SimpleDateFormat("yyyy-MM-dd");
		
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");

		Costbook[] cbs=jp.getCostbookBydate(type,runDate);
    		
    	if(cbs ==null)	
    		return "";	
    		
    	StringBuffer sb=new StringBuffer();
    	
    	if(type==1)		
    		sb.append("<b>雜費支出更動概況:</b>");
    	else 	
    		sb.append("<b>雜費收入更動概況:</b>");		
     		
     	String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
		sb.append(xString);
		sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
		sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
     	sb.append("<td>傳票編號</td><td>入帳日期</td><td>傳票抬頭</td><td>登入人</td><td>登入金額</td>");
		sb.append("<td>");
		if(type==1)
			sb.append("已付金額");
		else
			sb.append("已收金額");
		sb.append("</td><td>"); 
		
		if(type==1)
			sb.append("需付金額");
		else
			sb.append("未收金額");
			
 		sb.append("</td><td>附件</td><td>審核狀態</tD></tr>");
		
		int total1=0;
		int total2=0;
		int total3=0;
		
		BigItemMgr bim=BigItemMgr.getInstance();						
		SmallItemMgr sim=SmallItemMgr.getInstance(); 
		
		
		for(int j=0;j<cbs.length;j++)	
		{  
			sb.append("<tr bgcolor=ffffff>");	
     		sb.append("<td>"+cbs[j].getCostbookCostcheckId()+"</td>");
			sb.append("<td>"+sdfDateCost.format(cbs[j].getCostbookAccountDate())+"</td>");
			sb.append("<td>"+cbs[j].getCostbookName()+"</td>"); 
			
			User ux=(User)umc.find(cbs[j].getCostbookLogId());
			sb.append("<td>"+ux.getUserFullname()+"</tD>");
			sb.append("<td align=right>"+cbs[j].getCostbookTotalMoney()+"</td>"); 
			sb.append("<td align=right>"+cbs[j].getCostbookPaiedMoney()+"</td>");
			int shouldPay=cbs[j].getCostbookTotalMoney()-cbs[j].getCostbookPaiedMoney();
			sb.append("<td align=right>"+mnfcost.format(shouldPay)+"</td>");
		
			total1+=cbs[j].getCostbookTotalMoney();
			total2+=cbs[j].getCostbookPaiedMoney();
			
			sb.append("<td>");
			switch(cbs[j].getCostbookAttachStatus()){
				case 1:
					sb.append("<font color=red>未附</font>");
					break;
				case 2:	
					sb.append("<font color=red>不完整</font>");
					break; 
				case 99:
					sb.append("完整");
					break; 				
			}
			sb.append("</td><td>");

			if(cbs[j].getCostbookVerifyStatus()==0)
			{
				sb.append("尚未審核");
				
				if(shouldPay!=0)
				{ 
					sb.append("-尚未結清");					
				}
								
			}else if(cbs[j].getCostbookVerifyStatus()==90){

				sb.append("OK");
				User vu=(User)umc.find(cbs[j].getCostbookVerifyId());
				sb.append("("+vu.getUserFullname()+"-"+sdf.format(cbs[j].getCostbookVerifyDate())+")");					
			} 
			
			sb.append("</td>");
			sb.append("</tr>"); 
		
			Cost[] co=jp.getCostByCBId(cbs[j]);	
 	 		if(co!=null)
			{	
				for(int k=0;k<co.length;k++) 
				{
			
					sb.append("<tr bgcolor=ffffff class=es02>");
					sb.append("<tD></td><tD>");
		
					BigItem biX=(BigItem)bim.find(co[k].getCostBigItem());
					sb.append(biX.getBigItemName()+"->");	
					
					SmallItem siX=(SmallItem)sim.find(co[k].getCostSmallItem());							
					sb.append(siX.getSmallItemName());
					sb.append("</td><td  colspan=3>"+co[k].getCostName()+"</tD>");
					sb.append("<tD align=right colspan=3>");
					sb.append(mnfcost.format(co[k].getCostMoney())); 
					sb.append("</td><td align=right colspan=2></td></tR>");
				}	
			}
		}		
     	sb.append("</table></td></tr></table>");	
     	sb.append("</center>");
     	
     	return sb.toString();
	}	   
	
	public String getTadentUpdate(Date runDate)
    {   
 
    	JsfPay jp=JsfPay.getInstance(); 
   		JsfTool jt=JsfTool.getInstance();
   		JsfAdmin ja=JsfAdmin.getInstance();
		TalentMgr tmxx=TalentMgr.getInstance();
		StudentMgr smXXX=StudentMgr.getInstance();	
		SimpleDateFormat sdfXT=new SimpleDateFormat("yyyy/MM/dd"); 
		
		Tadent[] tds=jp.getTadentByDate(runDate);
  
		if(tds==null)
  			return "";

		StringBuffer sb=new StringBuffer();
		sb.append("<b>才藝班更動概況:</b>");

		String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
		sb.append(xString);
		sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
		sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
		sb.append("<td>才藝班名稱</td><td>姓名</td><td>報名日期</tD><td>加入日期</td><td>狀態</td></tr>");

		for(int i=0;i<tds.length;i++)
		{
			Student stu=(Student)smXXX.find(tds[i].getTadentStudentId());
			Talent ta=(Talent)tmxx.find(tds[i].getTadentTalentId());
			
			sb.append("<tr bgcolor=ffffff><td>"+ta.getTalentName()+"</td>");
			sb.append("<td>"+stu.getStudentName()+"</tD>");
			sb.append("<td>"+sdfXT.format(tds[i].getCreated())+"</tD>");
			
			if(tds[i].getTadentComeDate()==null)
			{ 
					sb.append("<td>尚未加入</tD>");
  			}else{
 					sb.append("<td>"+sdfXT.format(tds[i].getTadentComeDate())+"</td>");
 			} 
			switch(tds[i].getTadentActive())
			{ 
				case 99:
					sb.append("<td>入學中</td>");
					break;
				case 1:
					sb.append("<td>已報名;拒絕入學</tD>");
					break; 
				case 2:
					sb.append("<td>已報名;等待入學</tD>");
					break; 
				case 3:
					sb.append("<td>中途退出</td>");
					break;  
				case 4:
					sb.append("<td>結業</tD>");
					break; 
			}	
			
			sb.append("</tr>");
		}
		sb.append("</table></td></tr></table>");
  		sb.append("</center>");	
  		return sb.toString();
	}	
	
	public String getInsidetradeUpdate(Date runDate)
    {   
    	JsfPay jp=JsfPay.getInstance(); 
   		JsfTool jt=JsfTool.getInstance();
   		JsfAdmin ja=JsfAdmin.getInstance();

		Insidetrade[] in=jp.getInsidetradeModifiedByDate(runDate); 

		if(in==null)
  			return "";
		
		StringBuffer sb=new StringBuffer();
		UserMgr uminside=UserMgr.getInstance(); 
		DecimalFormat mnfinside = new DecimalFormat("###,###,##0");
		sb.append("<b>內部轉帳更動概況:</b>");

		String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
		sb.append(xString);
		sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
		sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
		sb.append("<td>交易日期</td><td>交易人</tD><td>轉出帳戶</td><td>轉入帳戶</tD><td>金額</tD><td>註記</tD><td>對帳狀態</td></tr>");
  			
		UserMgr ux=UserMgr.getInstance();
		TradeaccountMgr tmx2=TradeaccountMgr.getInstance();
		BankAccountMgr bam2=BankAccountMgr.getInstance();
		
		SimpleDateFormat df=new SimpleDateFormat("yyyy/MM/dd");
		
		for(int i=0;i<in.length;i++)
 		{
 	 		User uc=(User)ux.find(in[i].getInsidetradeUserId()); 
			sb.append("<tr bgcolor=ffffff><td>"+df.format(in[i].getInsidetradeDate())+"</td>");
  			sb.append("<td>"+uc.getUserFullname()+"</td>"); 
  			sb.append("<td>");
  				
  			if(in[i].getInsidetradeFromType()==1)	
			{
				Tradeaccount  td=(Tradeaccount)tmx2.find(in[i].getInsidetradeFromId()); 
				sb.append("零用金帳戶-"+td.getTradeaccountName());

			}else if(in[i].getInsidetradeFromType()==2){
				
				BankAccount ba=(BankAccount)bam2.find(in[i].getInsidetradeFromId()); 
				sb.append("銀行帳戶-"+ba.getBankAccountName());
			}				
  			sb.append("</td>");
  			sb.append("<td>"); 
  			if(in[i].getInsidetradeToType()==1)	
				{
					Tradeaccount  td=(Tradeaccount)tmx2.find(in[i].getInsidetradeToId()); 
					sb.append("零用金帳戶-"+td.getTradeaccountName());

				}else if(in[i].getInsidetradeToType()==2){
					
					BankAccount ba=(BankAccount)bam2.find(in[i].getInsidetradeToId()); 
					sb.append("銀行帳戶-"+ba.getBankAccountName());
				}				
  			
  			sb.append("</td>");		
  			sb.append("<td>"+mnfinside.format(in[i].getInsidetradeNumber())+"</td>");				
  			
  			if(in[i].getInsidetradeUserPs()!=null && in[i].getInsidetradeUserPs().length()>0)
  			{
  				sb.append("<td>"+in[i].getInsidetradeUserPs()+"</td>"); 
  			}else{
				sb.append("<tD></td>");  			
  			}
  			
  			sb.append("<tD>");  					
  			int checkLog=in[i].getInsidetradeCheckLog();
  			switch(checkLog)
  			{
  				case 0:
  					sb.append("尚未");	
  					break;
  				case 1:
  					sb.append("<font color=red>警示</font>");	
  					User ux2=(User)uminside.find(in[i].getInsidetradeCheckUserId());
  					if(ux2 !=null)
  						sb.append(ux2.getUserFullname()+"-"+df.format(in[i].getInsidetradeCheckDate()));		
  					break;					
  				case 90:
  					sb.append("OK<br>");	
  					User ux3=(User)uminside.find(in[i].getInsidetradeCheckUserId());
  					
  					if(ux3 !=null)
  						sb.append(ux3.getUserFullname()+"-"+df.format(in[i].getInsidetradeCheckDate()));		
  					break;		
  				default:
			}
  			sb.append("</tD>");
  			sb.append("</tr>");
  		} 
  			
  		sb.append("</table></td></tr></table>");
  		sb.append("</center>");	
  		return sb.toString();
	}
	public String getCostpayUpdate(Date runDate)
    {    
    	JsfPay jp=JsfPay.getInstance(); 
   		JsfTool jt=JsfTool.getInstance();
   		JsfAdmin ja=JsfAdmin.getInstance();

		Costpay[] cp=jp.getCostpayModifiedByDate(runDate);  
			
		if(cp==null)
  			return "";
  			
  		StringBuffer sb=new StringBuffer();
  		
  		SimpleDateFormat sdfDate=new SimpleDateFormat("yyyy/MM/dd");
		SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM");
		
		BankAccountMgr bam2=BankAccountMgr.getInstance();
		TradeaccountMgr tam=TradeaccountMgr.getInstance();	 
		FeeticketMgr fm=FeeticketMgr.getInstance();
		CostbookMgr cm1=CostbookMgr.getInstance(); 
		StudentMgr stuM=StudentMgr.getInstance(); 
		InsidetradeMgr in1=InsidetradeMgr.getInstance(); 
		OwnertradeMgr ownM=OwnertradeMgr.getInstance();
		OwnerMgr owM=OwnerMgr.getInstance();
		SalaryBankMgr sbm=SalaryBankMgr.getInstance();
		StudentAccountMgr samm=StudentAccountMgr.getInstance();		
		
		sb.append("<b>交易更動概況:</b>"); 

		String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
		sb.append(xString);
		sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
		sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
		sb.append("<td>序號</td><td>入帳日期</tD><td>交易明細</td><td>交易帳戶</tD><td>支出</tD><td>存入</tD><td>小計</td></tr>");

		int total=0; 
		int incomeTotal=0;
		int costTotal=0;
		for(int i=0;i<cp.length;i++)
		{  
			
			sb.append("<tr bgcolor=ffffff><td>"+cp[i].getId()+"</td>");
 			sb.append("<td>"+sdfDate.format(cp[i].getCostpayDate())+"</td><td>");

			if(cp[i].getCostpaySide()==1)
			{ 
				if(cp[i].getCostpayFeeticketID()==0)
				{  
					if(cp[i].getCostpayOwnertradeStatus()==0)
					{ 
						if(cp[i].getCostpaySalaryBankId()==0)
						{  
							if(cp[i].getCostpayStudentAccountId()==0)
							{		
					
								Costbook  co=(Costbook)cm1.find(cp[i].getCostpayCostbookId());
								
								String outCostword="此傳票已刪除";	
								if(co !=null)	 
									outCostword=co.getCostbookName();
		
								if(cp[i].getCostpayNumberInOut()==1)
								{
									sb.append("雜費支出-"+outCostword);
								}else{
									sb.append("雜費收入-"+outCostword);
								}	
							
							}else{
							
								StudentAccount sa=(StudentAccount)samm.find(cp[i].getCostpayStudentAccountId());
								
								if(sa !=null)
								{  
									Student stuXX=(Student)stuM.find(sa.getStudentAccountStuId());
									String stuName="不名帳號:"+sa.getStudentAccountNumber();
									
									if(stuXX !=null)
										 stuName=stuXX.getStudentName();
									
									if(sa.getStudentAccountSourceType()==3)	
									{
										sb.append(stuName+"固定虛擬帳號 退費");
									}else if(sa.getStudentAccountSourceType()==1){
										sb.append(stuName+"固定虛擬帳號 匯入");
									}else if(sa.getStudentAccountSourceType()==4){
										sb.append(stuName+"便利商店 逾繳");
									} 
 
								}
							}
						}else{
							sb.append("薪水櫃臺");
						} 
					}else{
						Ownertrade ot=(Ownertrade)ownM.find(cp[i].getCostpayOwnertradeId());
						
						if(ot.getOwnertradeInOut()==0)
						{ 
							sb.append("股東挹注-");	
						}else{ 
							sb.append("股東提取-");
	 	 	 	 	 	}  	
	 	 	 	 	 	 
						Owner ow2=(Owner)owM.find(ot.getOwnertradeOwnerId());
						sb.append(ow2.getOwnerName());
					}			
				}else{
					sb.append("學費收入");
	
					Feeticket  fee=(Feeticket)fm.find(cp[i].getCostpayFeeticketID()); 
					Date aDate=fee.getFeeticketMonth();
					Student stu=(Student)stuM.find(fee.getFeeticketStuId());
					sb.append(stu.getStudentName()+","+sdf2.format(aDate));
				} 
			}else{ 
				sb.append("內部轉帳");
	
				Insidetrade inXX=(Insidetrade)in1.find(cp[i].getCostpaySideID());
				if(cp[i].getCostpayNumberInOut()==1)
				{
					sb.append("匯出 to ");		

					if(inXX.getInsidetradeToType()==1)	
					{
						Tradeaccount  td=(Tradeaccount)tam.find(inXX.getInsidetradeToId()); 
						sb.append("零用金帳戶-"+td.getTradeaccountName());
	
					}else if(inXX.getInsidetradeToType()==2){
						
						BankAccount ba=(BankAccount)bam2.find(inXX.getInsidetradeToId()); 
						sb.append("銀行帳戶-"+ba.getBankAccountName());
					}		
						
				}else{
				  	sb.append("匯入 from");				

					if(inXX.getInsidetradeFromType()==1)	
					{
						Tradeaccount  td=(Tradeaccount)tam.find(inXX.getInsidetradeFromId()); 
						sb.append("零用金帳戶-"+td.getTradeaccountName());
	
					}else if(inXX.getInsidetradeFromType()==2){
						
						BankAccount ba=(BankAccount)bam2.find(inXX.getInsidetradeFromId()); 
						sb.append("銀行帳戶-"+ba.getBankAccountName());
					}		
				} 
		}
		sb.append("</td><td>");
		
		if(cp[i].getCostpayAccountType()==1)	
		{
			Tradeaccount  td=(Tradeaccount)tam.find(cp[i].getCostpayAccountId()); 
			sb.append("零用金帳戶-"+td.getTradeaccountName());

		}else if(cp[i].getCostpayAccountType()==2){
			
			BankAccount ba=(BankAccount)bam2.find(cp[i].getCostpayAccountId()); 
			sb.append("銀行帳戶-"+ba.getBankAccountName());
		}		
		sb.append("</td>");
		sb.append("<td align=right>"+cp[i].getCostpayCostNumber()+"</tD>");
		sb.append("<td align=right>"+cp[i].getCostpayIncomeNumber()+"</tD>");
		
		int nowtotal=cp[i].getCostpayIncomeNumber()-cp[i].getCostpayCostNumber();
		total+=nowtotal ;
		incomeTotal +=cp[i].getCostpayIncomeNumber();
		costTotal +=cp[i].getCostpayCostNumber();

		sb.append("<td align=right>"+total+"</td>");
		sb.append("</tr>"); 
		

		}			

		sb.append("</table></td></tr></table>");
  		sb.append("</center>");	
  		return sb.toString();
	} 
	
	public String getMyAccount(User u)
    {    
		if(u==null) 
			return "沒有使用者";		    	 
			
		JsfPay jp=JsfPay.getInstance(); 
   		JsfTool jt=JsfTool.getInstance();
   		JsfAdmin ja=JsfAdmin.getInstance();

		DecimalFormat mnftrade = new DecimalFormat("###,###,##0");

		Tradeaccount[] tradeA=jp.getActiveTradeaccount(u.getId());
	
		if(tradeA==null)
		{
			return "沒有零用金帳戶";	
		}  
  
   		Costpay[] cpta=jp.getAccountType1Costpay(); 
   		
		if(cpta==null)
  			return "零用金帳戶目前沒有交易紀錄";
  			
  		Hashtable allTrade=jp.getTradeAcccountNum(cpta);		
  			
  		StringBuffer sb=new StringBuffer();
		
		sb.append("<b>"+u.getUserFullname()+"零用金帳戶:</b>");
 

		String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
		sb.append(xString);
		sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
		sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
		sb.append("<td>帳戶名稱</td><td>支出</tD><td>存入</td><td>餘額</tD></tr>");

		int[] payTotal={0,0,0};
		if(tradeA!=null) 
		{	
			for(int p=0;p<tradeA.length;p++)
			{
 
				int[] allNum=jp.getSingleTradeANum (allTrade,tradeA[p].getId()); 
 
				payTotal[0]+=allNum[0];
				payTotal[1]+=allNum[1];	
				payTotal[2]+=allNum[2];	
				
				sb.append("<tr bgcolor=ffffff>");
				sb.append("<td>"+tradeA[p].getTradeaccountName()+"</td>");
				sb.append("<td align=right>"+mnftrade.format(allNum[1])+"</td>");
 				sb.append("<td align=right>"+mnftrade.format(allNum[0])+"</td>");
				sb.append("<td align=right><b>"+mnftrade.format(allNum[2])+"</b></td>");
				sb.append("</tr>");
			}
		}
		sb.append("<tr><td>小計</td><td align=right>"+mnftrade.format(payTotal[1])+"</td>"); 
		sb.append("<td align=right>"+mnftrade.format(payTotal[0])+"</td>"); 
		sb.append("<td align=right><b>"+mnftrade.format(payTotal[2])+"</b></td>");
		sb.append("</tr>");
		
		sb.append("</table></td></tr></table>");
  		sb.append("</center>");	
  		
		return sb.toString();
	}
	
	public String getBalanceUpdate(Date runDate2)
    {    
		try{
			
		DecimalFormat mnf = new DecimalFormat("###,###,##0");
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
		SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd");

		String xmonth=sdf.format(runDate2);
		Date runDate=sdf.parse(xmonth);
		
		StringBuffer sb=new StringBuffer();

		sb.append("<b>"+xmonth+"損益試算:</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font size=2>[結算日期:"+sdf2.format(runDate2)+"]</font>");

		JsfPay jp=JsfPay.getInstance();
	
		int[] fee=jp.getFeeticketByDate(runDate); 
		int[] salary=jp.getSalaryByDate(runDate);
		int[] cost=jp.getCostByDate(runDate,1); 
		int[] income=jp.getCostByDate(runDate,0); 
		
		int[] total0={fee[0]+income[0],fee[1]+income[1],fee[2]+income[2]};
		int[] total1={salary[0]+cost[0],salary[1]+cost[1],salary[2]+cost[2]};
		
		int[] allTotal={total0[0]-total1[0],total0[1]-total1[1],total0[2]-total1[2]};
		
		
		Utility u=Utility.getInstance();
		SimpleDateFormat sdfX1=new SimpleDateFormat("yyyy/MM"); 
		SimpleDateFormat sdfX2=new SimpleDateFormat("yyyy/MM/01"); 

		

  		String xString="<center><table width=85% height= border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td bgcolor=#e9e3de>";
		sb.append(xString);
		sb.append("<table width=100% border=0 cellpadding=4 cellspacing=1>"); 
		sb.append("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
		sb.append("<td colspan=2></td><td>應收金額</tD><td>實收金額</tD><td>未收金額</td></tr>");
		
		sb.append("<tr bgcolor=ffffff><td width=50></td><td>學費收入</td>");
		sb.append("<td align=right><b>"+mnf.format(fee[0])+"</b></td>"); 
		sb.append("<td align=right>"+mnf.format(fee[1])+"</td>"); 
		sb.append("<td align=right>"+mnf.format(fee[2])+"</td>"); 
		sb.append("</tr>");		
	
		sb.append("<tr bgcolor=ffffff><td width=50></td><td>雜費收入</td>");
		sb.append("<td align=right><b>"+mnf.format(income[0])+"</b></td>"); 
		sb.append("<td align=right>"+mnf.format(income[1])+"</td>"); 
		sb.append("<td align=right>"+mnf.format(income[2])+"</td>"); 
		sb.append("</tr>");		
	
		sb.append("<tr><td colspan=2>收入總和</td>");
		sb.append("<td align=right>"+mnf.format(total0[0])+"</td>"); 
		sb.append("<td align=right>"+mnf.format(total0[1])+"</td>"); 
		sb.append("<td align=right>"+mnf.format(total0[2])+"</td>"); 
		sb.append("</tr>");		
	
		sb.append("<tr bgcolor=ffffff><td width=50></td><td>薪資</td>");
		sb.append("<td align=right><b>"+mnf.format(salary[0])+"</b></td>"); 
		sb.append("<td align=right>"+mnf.format(salary[1])+"</td>"); 
		sb.append("<td align=right>"+mnf.format(salary[2])+"</td>"); 
		sb.append("</tr>");		
		
		sb.append("<tr bgcolor=ffffff><td width=50></td><td>雜費支出</td>");
		sb.append("<td align=right><b>"+mnf.format(cost[0])+"</b></td>"); 
		sb.append("<td align=right>"+mnf.format(cost[1])+"</td>"); 
		sb.append("<td align=right>"+mnf.format(cost[2])+"</td>"); 
		sb.append("</tr>");		
		
		sb.append("<tr><td colspan=2>支出總和</td>");
		sb.append("<td align=right>"+mnf.format(total1[0])+"</td>"); 
		sb.append("<td align=right>"+mnf.format(total1[1])+"</td>"); 
		sb.append("<td align=right>"+mnf.format(total1[2])+"</td>"); 
		sb.append("</tr>");		
	
		sb.append("<tr bgcolor=ffffff><td colspan=2>損益試算</td>");
		sb.append("<td align=right>"+mnf.format(allTotal[0])+"</td>"); 
		sb.append("<td align=right>"+mnf.format(allTotal[1])+"</td>"); 
		sb.append("<td align=right>"+mnf.format(allTotal[2])+"</td>"); 
		sb.append("</tr>");		
		
		sb.append("</table></tD></tr></table></center>");
		
		return sb.toString();
	
		}catch(Exception ex){ 
			
			return "";	
		} 
	} 
	
	
    public static void main(String[] args) {
        try {
        
        	DbConnectionPool pool = 
        	    new DbConnectionPool(args[0], args[1], args[2], args[3]);
            DbPool.setDbPool(pool);
        
			ReportAdmin ra=ReportAdmin.getInstance();
			Date xDate2=new Date(); 
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");				
			String dateString=sdf.format(xDate2);
			Date xDate=sdf.parse(dateString);
			
			JsfPay jp=JsfPay.getInstance();

			
			PaySystemMgr em=PaySystemMgr.getInstance();
			PaySystem e=(PaySystem)em.find(1);
			if(e.getPaySystemEmailServer()==null || e.getPaySystemEmailServer().length()<=0) 
			{
				System.out.println("STMP Server not setup yet!");
				return;
			}		
			
			User[] u=jp.getEmailUser(); 
			if(u ==null)	 
			{ 
				System.out.println("no user email in list");
				return;
			} 
			
			EmailTool et = new EmailTool(e.getPaySystemEmailServer(), false);
			File[] attachments = null;

			for(int i=0;i<u.length;i++)	
			{ 
				if(!jp.checkEmail(u[i].getUserEmail()))
				{
				  	System.out.println(u[i].getUserEmail()+" fail"); 
				  	continue;
				 }
				StringBuffer sb=new StringBuffer("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">");
				sb.append("<style type=\"text/css\"> <!--.es02{font-size: 12px; line-height:120% ; color: #3c3c3c }--> </style>"); 
				sb.append("</head><body>");
				
				if(u[i].getUserContentType1()==1)
					sb.append(ra.getBalanceUpdate(xDate));
				
				if(u[i].getUserContentType2()==1)
					sb.append(ra.getCashAccount()+"<BR>");
				
				if(u[i].getUserContentType3()==1)  
					 sb.append(ra.getMyAccount(u[i])+"<br>");
				
				if(u[i].getUserContentType4()==1) 
					sb.append(ra.getFeeticketUpdate(xDate)+"<BR>");
				
				if(u[i].getUserContentType5()==1)  
					sb.append(ra.getStudentUpdate(xDate)+"<BR>");
					
				if(u[i].getUserContentType6()==1) 
					sb.append(ra.getTadentUpdate(xDate)+"<BR>"); 
					
				if(u[i].getUserContentType7()==1)  
					sb.append(ra.getSalaryUpdate(xDate)+"<BR>"); 
					
				if(u[i].getUserContentType8()==1)  
					sb.append(ra.getCostbookUpdate(0,xDate)+"<BR>"); 			
						
				if(u[i].getUserContentType9()==1) 
					sb.append(ra.getCostbookUpdate(1,xDate)+"<BR>");
				
				if(u[i].getUserContentType10()==1) 
					sb.append(ra.getInsidetradeUpdate(xDate));	
				
				if(u[i].getUserContentType11()==1)
					sb.append(ra.getCostpayUpdate(xDate)+"<BR>"); 
				
				sb.append("</body></html>");

				et.send(u[i].getUserEmail(), null, null,e.getPaySystemEmailSenderAddress(),e.getPaySystemEmailSender(),e.getPaySystemCompanyName()+":"+dateString+"財務報表",sb.toString(),true,e.getPaySystemEmailCode(),attachments);
			}	 
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}    