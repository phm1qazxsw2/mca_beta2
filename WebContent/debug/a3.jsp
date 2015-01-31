<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>


<b>察看SalaryTicket ,  Costpay 關係是否相符 </b>

<br><br>
<%
    JsfAdmin js=JsfAdmin.getInstance();
    SalaryAdmin sa=SalaryAdmin.getInstance();
    SalaryTicketMgr bigr = SalaryTicketMgr.getInstance();

    Object[] objs = bigr.retrieve("","");
        
    if (objs==null || objs.length==0)
    {	
        return;
    }

    SalaryTicket[] cb =new SalaryTicket[objs.length];

    for (int i=0; i<objs.length; i++)
    {
        cb[i] = (SalaryTicket)objs[i];
    }


    CostpayMgr cmm=CostpayMgr.getInstance();

    for(int i=0;cb !=null &&i< cb.length;i++)
    {
         
        SalaryFee[] sfs=sa.getSalaryFeeBySanumber(cb[i].getSalaryTicketSanumberId());
        
        int totalSF=0;
        if(sfs ==null)
        {
            out.println("Error 1: not SalaryFee salaryTicket id"+cb[i].getId()+"<br>");
            continue;
        }else{
            for(int j=0;j<sfs.length;j++)
            {
                int typeNumber=sfs[j].getSalaryFeeType();

                if(typeNumber==1 ||typeNumber==4 || typeNumber==5)
                {
                    totalSF+=sfs[j].getSalaryFeeNumber();        
                }else{
                    totalSF-=sfs[j].getSalaryFeeNumber();        
                }
            }
        }

        if(cb[i].getSalaryTicketTotalMoney() != totalSF)
        {
            out.println("Error 2: SalaryFee total not equals salaryTicket Total money salaryTicket id"+cb[i].getId()+"<br>");
            
        }

        SalaryBank[] sb=sa.getSalaryBankBySanunmber(cb[i]);        
        int payTotal=0;
        if(sb ==null)
        {
            if(cb[i].getSalaryTicketPayMoney()!=0)
            {
                out.println("Error 3: SalaryBank is empty and  salaryTicket pay money not queal 0 salaryTicket id"+cb[i].getId()+"<br>");
                continue;
            }
        }else{
            for(int k=0;k<sb.length;k++)
            {
        		payTotal += sb[k].getSalaryBankMoney();
                
                Object[] objs2 = cmm.retrieve("costpaySalaryBankId='"+sb[k].getId()+"'","");
                                                   
                int totalCostpay=0;

                if (objs2==null || objs2.length==0)
                {	
                    totalCostpay=0;
                }else{
                    
                    for(int j=0;j<objs2.length;j++)
                    {
                        Costpay cp=(Costpay)objs2[j];

                        //totalCostpay+=cp.getCostpayIncomeNumber();
                        totalCostpay+=cp.getCostpayCostNumber();
                    }
                }

                if(totalCostpay !=sb[k].getSalaryBankMoney())
                {
                    out.println("Error: 已付金額與現金帳戶不符 salarybank id:"+sb[k].getId()+" salaryTicket id="+cb[i].getId()+"<br>");
                }
            }
        }

        int titcketPay=cb[i].getSalaryTicketPayMoney();

        if(titcketPay !=payTotal)
        {
            out.println("Error 4:  SalaryBank total is not equeal  ticket pay money salaryTicket id"+cb[i].getId()+"<br>");
            continue;
        }
        out.println((i+1)+" checked <br>");
    }


%>

done