<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%><%

    try
    {
		String code=request.getParameter("code");
		String ran=request.getParameter("ran");
        String typeS=request.getParameter("type");

        int type=1;
        if(typeS !=null)
            type=Integer.parseInt(typeS);
    
        /*
        for(int i=0;code !=null && i< code.length() ;i++)
        {
            char c=code.charAt(i);
            if('0'<=c  &&  c<='9')
            {
                continue;   
            }else{
                out.println("格式錯誤: 請輸入數字");
                return;
            }
        }
        */

        String bigCode=code;
        JsfAdmin ja=JsfAdmin.getInstance();
        if(code.length() >4)
            bigCode=code.substring(0,4);
        
        BigItem[] bi=ja.getAllActiveBigItemByCode(bigCode,type);
        
        if(bi==null){
            out.println("找不到此編號的會計科目.");
        }else{
            SmallItemMgr sim=SmallItemMgr.getInstance();
            out.println("主科目: <font color=blue>"+bigCode+" - "+bi[0].getBigItemName()+"</font>");
            
            SmallItem[] si=ja.getActiveSmallItemByBID(bi[0].getId());
            
            if(si !=null) out.println("<br>"); 

            boolean runChecked=true;
            int xCode=0;
            if(code.length()>=7)
            {
                xCode=Integer.parseInt(code.substring(4,7));

                runChecked=false;
            }

            StringBuffer sb=new StringBuffer();

            for(int i=0; si !=null && i< si.length ; i++)
            {
                sb.append("<input type=radio name=\"siId\" value=\""+si[i].getId()+"\"");

                if(xCode==Integer.parseInt(si[i].getAcctCode()))
                    sb.append(" checked ");

                sb.append("onClick=goChange('"+si[i].getAcctCode()+"')>"+si[i].getAcctCode()+si[i].getSmallItemName());

                if(i !=0 && (i+1)%3==0)
                    sb.append("<br>");

                if(!runChecked && (xCode==Integer.parseInt(si[i].getAcctCode())))
                    runChecked=true;
           }


            if(!runChecked){
                
                out.println("沒有此次科目");
            }else{
                out.println(sb.toString());
            }
        }        
    }catch(Exception ex){


    }


%>	