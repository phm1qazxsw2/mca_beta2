<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>


<b>察看Feeticekt , Payfee , Costpay 關係是否相符 </b>

<br><br>
<%
    JsfAdmin js=JsfAdmin.getInstance();

    FeeticketMgr bigr = FeeticketMgr.getInstance();

    Object[] objs = bigr.retrieve("","");
        
    if (objs==null || objs.length==0)
    {	
        return;
    }

    Feeticket[] ft =new Feeticket[objs.length];

    for (int i=0; i<objs.length; i++)
    {
        ft[i] = (Feeticket)objs[i];
    }

    CostpayMgr cmm=CostpayMgr.getInstance();

    StringBuffer sb=new StringBuffer();
    for(int i=0;ft !=null && i<ft.length; i++)
    {
        
        PayFee[] pfx=js.getPayFeeByNumberId(ft[i].getFeeticketFeenumberId());
        
        int totalPay=0;
        
        

        for(int j=0;pfx !=null && j<pfx.length;j++)
        {
            totalPay+=pfx[j].getPayFeeMoneyNumber();
            
            Object[] objs2 = cmm.retrieve("costpayFeePayFeeID='"+pfx[j].getId()+"'","");
        
            if (objs2==null || objs2.length==0)
            {	
                sb.append("Error 2:收費沒有登入現金帳戶: feeticket:"+ft[i].getFeeticketFeenumberId()+" feeticket id="+ft[i].getId()+"payFee ID="+pfx[j].getId()+"<br>");
                
                continue;
            }
        
        
            if(pfx !=null && pfx.length>=2)
            {
                Costpay cp =(Costpay)objs2[0];
                sb.append("<blockquote>Warning:收費多餘兩筆 No:"+(j+1)+"feeticket:"+ft[i].getFeeticketFeenumberId()+" feeticket id="+ft[i].getId()+" PayFee Id:"+pfx[j].getId()+" CostpayId:"+cp.getId()+"</blockquote>");

                
            }
            
            if(objs2 !=null && objs2.length>=2)
            {
                sb.append("Error 3:收費登入多筆現金帳戶: feeticket:"+ft[i].getFeeticketFeenumberId()+" feeticket id="+ft[i].getId()+"payFee ID="+pfx[j].getId()+"<br>");
                
                continue;
            }
            
            if(objs2 !=null && objs2.length==1)
            {
                Costpay cp =(Costpay)objs2[0];
                
                if(pfx[j].getPayFeeMoneyNumber() !=cp.getCostpayIncomeNumber())
                {
                    sb.append("Error 4:收費與現金帳戶不合: feeticket:"+ft[i].getFeeticketFeenumberId()+" feeticket id="+ft[i].getId()+"payFee ID="+pfx[j].getId()+" Costpay Id="+cp.getId()+"<br>");

                    if(cp.getCostpayAccountType()==0 || cp.getCostpayAccountId()==0)
                    {
                        sb.append("Error 5:存入的現金帳戶有誤: costpayID:"+cp.getId()+"<br>");
                    }
                }

            }

        }        
        
        if(totalPay !=ft[i].getFeeticketPayMoney())
        {
            sb.append("Error 1:繳款單收款與收費總和不符 : feeticket:"+ft[i].getFeeticketFeenumberId()+" feeticket id="+ft[i].getId()+"<br>");
        }


    }
%>

<%=sb.toString()%>