<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>


<b>反查 Costpay 關係是否相符 </b>

<br><br>
<%
    JsfAdmin js=JsfAdmin.getInstance();
    JsfPay jp=JsfPay.getInstance();
    CostpayMgr cmm=CostpayMgr.getInstance();
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

    //外部交易
    Object[] objs = cmm.retrieve("costpaySideID ='0'","");
        
    if (objs==null || objs.length==0)
    {	
        return;
    }

    Costpay[] cp =new Costpay[objs.length];

    for (int i=0; i<objs.length; i++)
    {
        cp[i] = (Costpay)objs[i];
    }

    out.println("total length:"+cp.length+"<br>");

    for(int i=0;cp !=null &&i< cp.length;i++)
    {
        if(cp[i].getCostpayAccountType()==0 ||cp[i].getCostpayAccountId()==0)
        {
            out.println("<font color=red>Error:</font>:沒有指定存入的帳戶 costPayId"+cp[i].getId());
        }        


        if(cp[i].getCostpayFeeticketID()==0)
	    {  
            if(cp[i].getCostpayOwnertradeStatus()==0)
            { 
                if(cp[i].getCostpaySalaryBankId()==0)
                { 
                    if(cp[i].getCostpayStudentAccountId()==0)
                    { 
                        Costbook  co=(Costbook)cm1.find(cp[i].getCostpayCostbookId());
						
		
						if(co ==null)
                        {
                            out.println("costbook null: cpId="+cp[i].getId()+"<br>");
                        }else{
                            int totalCostbook=0;                            
                            Costpay[] cpxx=jp.getCostpayByCostbook(co);                    
                            
                            for(int k2=0;k2<cpxx.length;k2++)
                            {
                                if(co.getCostbookOutIn()==1)
					  			    totalCostbook+=cpxx[k2].getCostpayCostNumber();
					  		    else
                                    totalCostbook+=cpxx[k2].getCostpayIncomeNumber();
                            }
                        
                            if(totalCostbook !=co.getCostbookPaiedMoney())
                            {
                                out.println("costbook not equals costpay total money: cpId="+cp[i].getId()+" costbookId"+co.getId()+"<br>");
                            }                  
                        }
                     }else{  
                        
                        StudentAccount sa=(StudentAccount)samm.find(cp[i].getCostpayStudentAccountId());
                        
                        if(sa ==null)
                        { 
                            
                            out.println("Error StudentAccount not data costpayId="+cp[i].getId()+" saId="+cp[i].getCostpayStudentAccountId()+"<br>");
                        }else{
                            if(sa.getStudentAccountIncomeType()==1)
                            {
                                if(cp[i].getCostpayCostNumber() !=sa.getStudentAccountMoney())
                                    out.println("Error: costpay numer not equals account COST number cpId="+cp[i].getId()+" studentAccont Id="+sa.getId()+"<br>");
                            }else{
                                   if(cp[i].getCostpayIncomeNumber() !=sa.getStudentAccountMoney())
                                    out.println("Error: costpay numer not equals account INCOME number cpId="+cp[i].getId()+" studentAccont Id="+sa.getId()+"<br>");
                            }
                        } 
                    }					
                 }else{

                    SalaryBank snC=(SalaryBank)sbm.find(cp[i].getCostpaySalaryBankId());
                    
                    if(snC ==null){       
                        out.println("Error:salary bank is empty costpayId="+cp[i].getId()+"<br>"); 
                    }else{
                        if(snC.getSalaryBankMoney() !=cp[i].getCostpayCostNumber())
                        {
                            out.println("Error:salary bank is not equals costpay costpayId="+cp[i].getId()+" salarybankid="+snC.getId()+"<br>"); 
                        }
                    }
                }

             }else{
                Ownertrade ot=(Ownertrade)ownM.find(cp[i].getCostpayOwnertradeId());
                
                if(ot ==null)
                {
                    out.println("Ownertrade is null costpay ID="+cp[i].getId());
                }else{
                    if(ot.getOwnertradeInOut()==0)
                    { 
                        if(ot.getOwnertradeNumber() !=cp[i].getCostpayIncomeNumber())
                            out.println("Ownertrade is not equals INCOME costpay ID="+cp[i].getId()+"<br>");
                    }else{ 
                        if(ot.getOwnertradeNumber() !=cp[i].getCostpayCostNumber())
                            out.println("Ownertrade is not equals COST costpay ID="+cp[i].getId()+"<br>");
                    }  	
                }
            }
      

        }else{
            PayFee pf=(PayFee)pfm.find(cp[i].getCostpayFeePayFeeID());
            
            if(pf ==null)
            {
                out.println("Error: payfee is null costpay Id="+cp[i].getId());    
            }else{
                
                if(pf.getPayFeeMoneyNumber() !=cp[i].getCostpayIncomeNumber())
                {
                    out.println("Error: payfee is not equals INCOME costpayId="+cp[i].getId()+" payFee id="+pf.getId());    
                }
            }
        } 
        out.println("costpay running: costpayID"+cp[i].getId()+"  income ="+cp[i].getCostpayIncomeNumber()+" cost="+cp[i].getCostpayCostNumber()+"<br>");

    }                 
        
   

%>

done