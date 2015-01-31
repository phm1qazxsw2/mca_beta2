<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>


<b>察看Costbook ,  Costpay 關係是否相符 </b>

<br><br>
<%
    JsfAdmin js=JsfAdmin.getInstance();

    CostbookMgr bigr = CostbookMgr.getInstance();

    Object[] objs = bigr.retrieve("","");
        
    if (objs==null || objs.length==0)
    {	
        return;
    }

    Costbook[] cb =new Costbook[objs.length];

    for (int i=0; i<objs.length; i++)
    {
        cb[i] = (Costbook)objs[i];
    }

    StringBuffer sb=new StringBuffer();
    CostpayMgr cmm=CostpayMgr.getInstance();

    for(int i=0;cb !=null &&i< cb.length;i++)
    {
        
        Object[] objs2 = cmm.retrieve("costpayCostbookId='"+cb[i].getId()+"'","");
            
        int totalCostpay=0;

        if (objs2==null || objs2.length==0)
        {	
            totalCostpay=0;
        }else{
            
            for(int j=0;j<objs2.length;j++)
            {
                Costpay cp=(Costpay)objs2[j];

                if(cb[i].getCostbookOutIn()==0)
                    totalCostpay+=cp.getCostpayIncomeNumber();
                else
                    totalCostpay+=cp.getCostpayCostNumber();
            }
        }

        if(totalCostpay !=cb[i].getCostbookPaiedMoney())
        {
            sb.append("Error: 已付金額與現金帳戶不符 costbookId:"+cb[i].getId()+"<br>");
        }
        sb.append((i+1)+" checked <br>");
    }


%>

<%=sb.toString()%>

done