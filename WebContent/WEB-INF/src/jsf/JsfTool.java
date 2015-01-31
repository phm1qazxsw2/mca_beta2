package jsf;

import java.util.*;
import java.text.*;
import java.io.*;
import com.axiom.mgr.*;
import phm.ezcounting.*;


public class JsfTool
{
    private static JsfTool instance;
    
    JsfTool() {}
    
    public synchronized static JsfTool getInstance()
    {
    	try{
	    		JsfAuth jax=JsfAuth.getInstance();
	    		if(!jax.getCouldWork())
					return null;

		}catch(Exception e){}

        if (instance==null)
        {
            instance = new JsfTool();
        }
        return instance;
    }
    
    public int[] getLaborLevel(int moeny){

        int[][] ll={{1,17280},{2,17400},{3,18300},{4,19200},{5,19200},{6,20100},{7,21000},{8,22800},{9,24000},{10,25200},{11,26400},
                    {12,27600},{13,28800},{14,30300},{15,31800},{16,33300},{17,34800},{18,36300},{19,38200},{20,40100},{21,42000}};

        int runRow=-1;
        for(int i=0;i<ll.length;i++)
        {
            if(ll[i][1]==moeny){
                runRow=i; 
                break;
            }else if(ll[i][1]>moeny){
                runRow=i; 
                if(i>0)
                    runRow=runRow-1;
                break;
            }
        }


        if(runRow==-1){
            int[] level={22,43900};
           return level;
        }
        return ll[runRow];

    }

    public int getLaborMonthFee(int[] ll){

        Hashtable ha=new Hashtable();
        ha.put((Integer)1,(Integer)225);
        ha.put((Integer)2,(Integer)226);
        ha.put((Integer)3,(Integer)238);
        ha.put((Integer)4,(Integer)249);
        ha.put((Integer)5,(Integer)261);
        ha.put((Integer)6,(Integer)273);
        ha.put((Integer)7,(Integer)285);
        ha.put((Integer)8,(Integer)297);
        ha.put((Integer)9,(Integer)312);
        ha.put((Integer)10,(Integer)327);
        ha.put((Integer)11,(Integer)343);
        ha.put((Integer)12,(Integer)359);
        ha.put((Integer)13,(Integer)375);
        ha.put((Integer)14,(Integer)394);
        ha.put((Integer)15,(Integer)414);
        ha.put((Integer)16,(Integer)433);
        ha.put((Integer)17,(Integer)453);
        ha.put((Integer)18,(Integer)472);
        ha.put((Integer)19,(Integer)496);
        ha.put((Integer)20,(Integer)521);
        ha.put((Integer)21,(Integer)546);
        ha.put((Integer)22,(Integer)571);

        Integer nowFee=(Integer)ha.get((Integer)ll[0]);
        if(nowFee==null)
            return 0;
        
        return (int)nowFee;

    }

    
    public int calculateHealthFee(int type,int money,int allPeople)
    {
        int fee=0;

        if(type==1){
    
            int[][] feeMap={{1,17280,236,472,708,944,468,468},
                            {2,17400,238,476,714,952,471,471},
                            {3,18300,250,500,750,1000,495,495},
                            {4,19200,262,524,786,1048,520,520},
                            {5,20100,274,548,822,1096,544,544},
                            {6,21000,287,574,861,1148,569,569},
                            {7,21900,299,598,897,1196,593,593},
                            {8,22800,311,622,933,1244,617,617},
                            {9,24000,328,656,984,1312,650,650},
                            {10,25200,344,688,1032,1376,682,682},
                            {11,26400,360,720,1080,1440,715,715},
                            {12,27600,377,754,1131,1508,747,747},
                            {13,28800,393,786,1179,1572,780,780},
                            {14,30300,414,828,1242,1656,820,820},
                            {15,31800,434,868,1302,1736,861,861},
                            {16,33300,455,910,1365,1820,902,902},
                            {17,34800,475,950,1425,1900,942,942},
                            {18,36300,495,990,1485,1980,983,983},
                            {19,38200,521,1042,1563,2084,1034,1034},
                            {20,40100,547,1094,1641,2188,1086,1086},
                            {21,42000,573,1146,1719,2292,1137,1137},
                            {22,43900,599,1198,1797,2396,1188,1188},
                            {23,45800,625,1250,1875,2500,1240,1240},
                            {24,48200,658,1316,1974,2632,1305,1305},
                            {25,50600,691,1382,2073,2764,1370,1370},
                            {26,53000,723,1446,2169,2892,1435,1435},
                            {27,55400,756,1512,2268,3024,1500,1500},
                            {28,57800,789,1578,2367,3156,1565,1565},
                            {29,60800,830,1660,2490,3320,1646,1646},
                            {30,63800,871,1742,2613,3484,1727,1727},
                            {31,66800,912,1824,2736,3648,1808,1808},
                            {32,69800,953,1906,2859,3812,1890,1890},
                            {33,72800,994,1988,2982,3976,1971,1971},
                            {34,76500,1044,2088,3132,4176,2071,2071},
                            {35,80200,1095,2190,3285,4380,2171,2171},
                            {36,83900,1145,2290,3435,4580,2271,2271},
                            {37,87600,1196,2392,3588,4784,2372,2372},
                            {38,92100,1257,2514,3771,5028,2493,2493},
                            {39,96600,1319,2638,3957,5276,2615,2615},
                            {40,101100,1380,2760,4140,5520,2737,2737},
                            {41,105600,1441,2882,4323,5764,2859,2859},
                            {42,110100,1503,3006,4509,6012,2981,2981},
                            {43,115500,1577,3154,4731,6308,3127,3127},
                            {44,120900,1650,3300,4950,6600,3273,3273},
                            {45,126300,1724,3448,5172,6896,3419,3419},
                            {46,131700,1798,3596,5394,7192,3565,3565}
                        };

                int runRow=-1;
                for(int i=0;i<feeMap.length;i++)
                {
                    int nowMoeny=feeMap[i][1];

                    if(nowMoeny==money)
                    {
                        runRow=i;
                        break;
                    }else if(nowMoeny>money){
                        runRow=i;
                        if(i !=0)
                            runRow=runRow-1;
                        break;
                    }
                }

                if(runRow==-1)
                    runRow=feeMap.length-1;

                if(allPeople==1)
                    return feeMap[runRow][2];
                else if(allPeople==2)    
                    return feeMap[runRow][3];
                else if(allPeople==3)
                    return feeMap[runRow][4];
                else if(allPeople==4)
                    return feeMap[runRow][5];

        }
        return fee;
    }

    public Student checkStudentId(String stuID)
    {
    	if(stuID.length()==0)
    		return null;
    		
    	StudentMgr bigr = StudentMgr.getInstance();
    	
    	String query="studentIDNumber='"+stuID+"'";
    	Object[] objs = bigr.retrieve(query, "");
        
        if (objs==null || objs.length==0)
            return null;
        
        Student u =(Student)objs[0];
        
        return u;	
    }

    public static String getUserService(User ud2,Userlog[] uls, String space)
    {
        StringBuffer sb=new StringBuffer("");
        SimpleDateFormat sdf=new SimpleDateFormat("MM/dd");
        SimpleDateFormat sdf2=new SimpleDateFormat("HH:mm");    	

        JsfAdmin ja=JsfAdmin.getInstance();
		//Userlog[] uls=ja.getUserlogById(ud2.getId());

		if(uls==null || uls.length<2)
		{ 

            return "<li>使用上如有任何疑問,歡迎來電洽詢本公司客服人員.";
			//sb.append("歡迎你使用本系統.<br><BR>我是你的小秘書,在系統有資料更新時,都會提醒你喔.");		
        
        }else{

            InsidetradeMgr im=InsidetradeMgr.getInstance();
            Message[] me = null;
            if (ja!=null) 
                me = ja.getAllMessage(ud2,999,999,0,999,999,0, space);
            
            if(me !=null)
            {
                sb.append("<li><img src=\"pic/message2.gif\" border=0 width=20>&nbsp;<a href=\"listMessage.jsp\">有&nbsp;<font color=blue>"+me.length+"</font> 則新訊息</a><br>");
            }	
        
            String query="insidetradeCheckLog <'90'";

            Object[] objs = im.retrieveX(query,"", space);
            int allTrade=0;	        
            if (objs!=null && objs.length>0)
            {	        
                JsfPay jp=JsfPay.getInstance();
                Insidetrade in=null;
                for (int i=0; i<objs.length; i++)
                {
                    in= (Insidetrade)objs[i];
                    
                    if(jp.isAuthorAccount(ud2,in.getInsidetradeToType(),in.getInsidetradeToId()))
                    {
                        allTrade++;
                    } 
                }   	
            }

            if(allTrade !=0)
                sb.append("<li><img src=\"pic/insidetradex.png\" border=0>&nbsp;<a href=\"listInsidetrade.jsp?vstatus=0\">有&nbsp;<font color=blue>"+allTrade+"</font> 則尚未確認的內部轉帳.</a><br>");

            int runCheck=0;

            try{

                 ArrayList<Cheque> cheques = ChequeMgr.getInstance().retrieveListX("cashed is NULL or cashed<'0000-00-01'", 
                     "order by cashDate asc", space);
                    Map<Integer/*type*/, Vector<Cheque>> chequeMap = new SortingMap(cheques).doSort("getType");

                //##1
                Map<Integer/*chequeId*/, Vector<BillPaidInfo>> paidMap = null;
                if (cheques.size()>0) {
                    String chequeIds = new RangeMaker().makeRange(cheques, "getId");
                    ArrayList<BillPaidInfo> paids = BillPaidInfoMgr.getInstance().
                        retrieveList("billpay.chequeId in (" + chequeIds + ")", "");
                    paidMap = new SortingMap(paids).doSort("getChequeId");
                }
                //###

                Vector<Cheque> checks = chequeMap.get(new Integer(Cheque.TYPE_INCOME_TUITION));

                long nowtime=new Date().getTime();

                boolean haveshow=false;
                for (int i=0; checks!=null && i<checks.size(); i++) {
                    Cheque ch = checks.get(i);
                    long casttime=ch.getCashDate().getTime();  

                    if(casttime<nowtime){
                        runCheck++;
                    }
                }

                if(runCheck !=0)
                    sb.append("<li><img src=\"pic/cheque.png\" border=0 width=18>&nbsp;<a href=\"query_cheque.jsp\">有&nbsp;<font color=blue>"+runCheck+"</font> 張到期,需要兌現的支票.</a><br>");
            }catch(Exception ex){}

            int notenoughQuantity=0;

            try{
                ArrayList<PItem> items = PItemMgr.getInstance().retrieveListX("status=1", "", space);
                ArrayList<InvInfo> inv_infos = InvInfoMgr.getInstance().retrieveListX("", "group by pitemId", space);
                Map<Integer, Vector<InvInfo>> invMap = new SortingMap(inv_infos).doSort("getPitemId");

                ArrayList<PitemOut> pitemouts = PitemOutMgr.getInstance().retrieveListX("", "group by pitemId", space);
                Map<Integer, Vector<PitemOut>> pitemoutMap = new SortingMap(pitemouts).doSort("getPitemId");

                Iterator<PItem> iter = items.iterator();
                while (iter.hasNext()) {
                    PItem pi = iter.next();
                    Vector<InvInfo> vi = invMap.get(new Integer(pi.getId()));
                    int quantity = 0;
                    int cost = 0;
                    if (vi!=null) {
                        quantity = vi.get(0).getQuantity();
                        cost = vi.get(0).getCost();
                    }

                    int o = 0;
                    Vector<PitemOut> vpo = pitemoutMap.get(new Integer(pi.getId()));
                    if (vpo!=null) o = vpo.get(0).getQuantity();

                    int nowQuantity=quantity-o;
                    if(pi.getSafetyLevel()!=0 && pi.getSafetyLevel() >nowQuantity){
                        notenoughQuantity++;
                    }
                }
            }catch(Exception ex2){}
            if(notenoughQuantity !=0)
                sb.append("<li><img src=\"pic/littlebag.png\" border=0 width=18>&nbsp;<a href=\"inventory_list.jsp\">有&nbsp;<font color=blue>"+notenoughQuantity+"</font> 項學用品庫存不足.</a><br>");

            /*
            if(runCheck !=0)
            {
               sb.append("<script>alert('有"+runCheck+"張到期但未兌現的支票.');</script>");
            }
            */                
        }

        return sb.toString();
	}
    
    public static String getUserIcon(User ud2, String space)
    {
    	InsidetradeMgr im=InsidetradeMgr.getInstance();
	
		JsfAdmin ja=JsfAdmin.getInstance();
		
        Message[] me = null;
        if (ja!=null) 
		    me = ja.getAllMessage(ud2,999,999,0,999,999,0, space);
		
		if(me !=null)
		{
			return "<a href=\"listMessage.jsp\"><b><img src=\"pic/userEmail.gif\" border=0><font class=es02 color=blue>"+ud2.getUserFullname()+"</font></b></a> 你有新訊息";	
		}	
	
		String query="insidetradeCheckLog <'90'";

		Object[] objs = im.retrieveX(query,"", space);
	        
		if (objs==null || objs.length==0)
		{	
			return "<a href=\"userIndex.jsp\"><b><img src=\"pic/user.gif\" border=0><font class=es02 color=blue>"+ud2.getUserFullname()+"</font></b></a> 你好";	
		}else{
        
        	JsfPay jp=JsfPay.getInstance();
    		Insidetrade in=null;
	        for (int i=0; i<objs.length; i++)
	        {
	            in= (Insidetrade)objs[i];
	            
	            if(jp.isAuthorAccount(ud2,in.getInsidetradeToType(),in.getInsidetradeToId()))
	       		{
	       			return "<a href=\"listInsidetrade.jsp\"><b><img src=\"pic/userInside.gif\" border=0><font class=es02 color=blue>"+ud2.getUserFullname()+"</font></b></a> 你有內部轉帳尚未確認";	
	       		}
	        }    	
    	}
    	return "<a href=\"userIndex.jsp\"><b><img src=\"pic/user.gif\" border=0><font class=es02 color=blue>"+ud2.getUserFullname()+"</font></b></a> 你好";	
	}

	public String getChineseMonth(Date xDate)
	{
		String syear=String.valueOf(xDate.getYear()+1900-1911);
		
		int xMonth=xDate.getMonth();
		
		String smonth="";
		if(xMonth<=8)
			smonth="0"+String.valueOf(xMonth+1);
		else
			smonth=String.valueOf(xMonth+1);	
				
		return syear+smonth;
	}

    public Date getContinuedDate(Date lastDate2,int continueType){
    		long lastlong=lastDate2.getTime();
    		Date lastDate=new Date(lastlong);
    	
		int lastMonth=lastDate.getMonth();
		int lastYear=lastDate.getYear();
		
		if(continueType==1)
		{
			if(lastMonth==11)
			{
				lastDate.setMonth(0);
				lastDate.setYear(lastYear+1);
			}else{
				lastDate.setMonth(lastMonth+1);
			}
		}else if(continueType==2){
			
			if(lastMonth==10)
			{
				lastDate.setMonth(0);
				lastDate.setYear(lastYear+1);
			}else if(lastMonth==11){
				lastDate.setMonth(1);
				lastDate.setYear(lastYear+1);
			}else{
				
				lastDate.setMonth(lastMonth+2);
			}
		}else if(continueType==3){
			
			if(lastMonth==9)
			{
				lastDate.setMonth(0);
				lastDate.setYear(lastYear+1);
			}else if(lastMonth==10){
				lastDate.setMonth(1);
				lastDate.setYear(lastYear+1);
			}else if(lastMonth==11){
				lastDate.setMonth(2);
				lastDate.setYear(lastYear+1);
			}else{
				
				lastDate.setMonth(lastMonth+3);
			}
		}else if(continueType==4){

			if(lastMonth<=5)
			{
				lastDate.setMonth(lastMonth+6);	
			}else{
				lastDate.setYear(lastYear+1);
				lastMonth=lastMonth+6-11;
				lastDate.setMonth(lastMonth);
			
			}	
		}else if(continueType==5)		
		{
				lastDate.setYear(lastYear+1);
			return lastDate;
		}else if(continueType==0)
		{
			lastDate.setYear(2000);	
		}
		return lastDate;
    }
    public Date getBackContinueDate(int continueType,Date runDate){
    		
    		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
		
		long runLong=runDate.getTime();
		Date lastDate=new Date(runLong);
		int lastMonth=lastDate.getMonth();
		int lastYear=lastDate.getYear();
		
		if(continueType==1)
		{
			if(lastMonth==0)
			{
				lastDate.setMonth(11);
				lastDate.setYear(lastYear-1);
			}else{
				lastDate.setMonth(lastMonth-1);
			}
		}else if(continueType==2){
			
			if(lastMonth==1)
			{
				lastDate.setMonth(11);
				lastDate.setYear(lastYear-1);
			}else if(lastMonth==0){
				lastDate.setMonth(10);
				lastDate.setYear(lastYear-1);
			}else{
				
				lastDate.setMonth(lastMonth-2);
			}
		}else if(continueType==3){
			
			if(lastMonth==2)
			{
				lastDate.setMonth(11);
				lastDate.setYear(lastYear-1);
			}else if(lastMonth==1){
				lastDate.setMonth(10);
				lastDate.setYear(lastYear-1);
			}else if(lastMonth==0){
				lastDate.setMonth(9);
				lastDate.setYear(lastYear-1);
			}else{
				
				lastDate.setMonth(lastMonth-3);
			}
		}else if(continueType==4){

			if(lastMonth>=6)
			{
				lastDate.setMonth(lastMonth-6);	
			}else{
				lastDate.setYear(lastYear-1);
				lastMonth=lastMonth-6+12;
				lastDate.setMonth(lastMonth);
			
			}	
		}else if(continueType==5)		
		{
				lastDate.setYear(lastYear-1);
			return lastDate;
		}else if(continueType==0)
		{
			lastDate.setYear(2000);	
		}
		return lastDate;
    }
    public String[] getSelectDate(){
    	
    	String[] newdate=new String[2];
    	
    	Date newDate=new Date();
  		newdate[0]=String.valueOf(newDate.getYear()+1900);
  	
	  	int newMonth=newDate.getMonth()+2;
	  	String nextmonth="";
		
		if(newMonth==13)
		{
			newdate[1]="01";
			newdate[0]=String.valueOf(newDate.getYear()+1901);
		}else{
		
		 	if(newMonth<=9)
				newdate[1]="0"+String.valueOf(newMonth);
			else
				newdate[1]=String.valueOf(newMonth);
	    	}
	    	
	    	return newdate;
    } 	 
 	
 	public String[] getSalaryDate(){
    	
    	String[] newdate=new String[2];

    	Date newDate=new Date();
	
		int someday=newDate.getDate();

		if(someday>=15)
		{
			newdate[0]=String.valueOf(newDate.getYear()+1900);
		
			if((newDate.getMonth()+1)<=9)
				newdate[1]="0"+String.valueOf(newDate.getMonth()+1);	
			else
				newdate[1]=String.valueOf(newDate.getMonth()+1);	
		}else{
			int somemonth=newDate.getMonth();
			int someyear=newDate.getYear();
			
			if(somemonth==0)
			{
				someyear=someyear-1;
				somemonth=12;
			}
			
			newdate[0]=String.valueOf(someyear+1900);
			
			if(somemonth<=9)
				newdate[1]="0"+String.valueOf(somemonth);		
			else
				newdate[1]=String.valueOf(somemonth);	
		}
			  		
	    return newdate;
    } 	 
 
 	public String[] getLastmonthDate(){
    	
    	String[] newdate=new String[2];

    	Date newDate=new Date();
	
		int somemonth=newDate.getMonth();
		int someyear=newDate.getYear();
		
		if(somemonth==0)
		{
			someyear=someyear-1;
			somemonth=12;
		}
		
		newdate[0]=String.valueOf(someyear+1900);
		
		if(somemonth<=9)
			newdate[1]="0"+String.valueOf(somemonth);		
		else
			newdate[1]=String.valueOf(somemonth);	

	    return newdate;
    } 	 
 
 	public String changeCloseString(int status)
 	{
 		String outword="";
 		
 		switch(status){
 			case 0:
 				outword="尚未開始";
 				break;
 			case 1:
 				outword="結帳中";
 				break;
 			case 90:
 				outword="完成";
 				break;
 		}
 		
 		return outword;
 	}
 
 	public String[] getSelectDate2(){
    	
    	String[] newdate=new String[2];
    	
    	Date newDate=new Date();
  		newdate[0]=String.valueOf(newDate.getYear()+1900);
  	
	  	int newMonth=newDate.getMonth()+1;
	  	String nextmonth="";
		
		if(newMonth==13)
		{
			newdate[1]="01";
			newdate[0]=String.valueOf(newDate.getYear()+1901);
		}else{
		
		 	if(newMonth<=9)
				newdate[1]="0"+String.valueOf(newMonth);
			else
				newdate[1]=String.valueOf(newMonth);
	    	}
	    	
	    	return newdate;
    } 	 
 
    private static java.text.SimpleDateFormat _sdf = 
            new java.text.SimpleDateFormat("yyyy/MM/dd");
    public Date ChangeToDate(String cDate)
    {
        return ChangeToDate(cDate, new Date());
    }

    public Date ChangeToDate(String cDatea, Date orgDate)
    {
        try{	
            SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");		
            String[] cDate=cDatea.split("/");
            int cx=Integer.parseInt(cDate[0]);
            if (cx<1000) // this is a taiwan year
                cx += 1911;
            String cYear=String.valueOf(cx);
            
            if(cDate[1].length()<2)
            {
                cDate[1]="0"+cDate[1];                
            }
            
            if(cDate[2].length()<2)
            {
                cDate[2]="0"+cDate[2];
            }
            String parseDate=cYear+"-"+cDate[1]+"-"+cDate[2];
            return sdf1.parse(parseDate);
        }
        catch(Exception e)
        {
            return orgDate;	
        }
    }	

  public String ChangeDateToStringXX(Date cDate)
  {
        if(cDate ==null)
        {
            return "";		
        }
        
        int iYear=cDate.getYear()+1900-1911;
        int iMonth=cDate.getMonth()+1;
        int iDate=cDate.getDate();
            
        String sYear="";
        String sMonth="";
        String sDate="";
        if(iYear<=99)
            sYear="0"+String.valueOf(iYear);	
        else
            sYear=String.valueOf(iYear);		

        if(iMonth<=9)
            sMonth="0"+String.valueOf(iMonth);
        else
            sMonth=String.valueOf(iMonth);
        
        if(iDate<=9)
            sDate="0"+String.valueOf(iDate);
        else
            sDate=String.valueOf(iDate);

        return sYear+"/"+sMonth+"/"+sDate;

    }	
    
    public static String showDate(Date xdate){

        if(xdate==null)
            return "";
        
        String birthdate="";
        EsystemMgr em=EsystemMgr.getInstance();
        Esystem e=(Esystem)em.find(1);
        SimpleDateFormat sdf=new SimpleDateFormat("MM/dd");
        if(e.getEsystemDateType()==0)
        {
            String xYear=String.valueOf(xdate.getYear()+1900-1911);
            birthdate="0"+xYear+"/"+sdf.format(xdate);
        }else{
            String xYear=String.valueOf(xdate.getYear()+1900);
            birthdate=xYear+"/"+sdf.format(xdate);
        }
        return birthdate;
    }

    public static String showDate(Date xdate,Esystem e){

        if(xdate==null)
            return "";
        
        String birthdate="";

        SimpleDateFormat sdf=new SimpleDateFormat("MM/dd");
        if(e.getEsystemDateType()==0)
        {
            String xYear=String.valueOf(xdate.getYear()+1900-1911);
            birthdate="0"+xYear+"/"+sdf.format(xdate);
        }else{
            String xYear=String.valueOf(xdate.getYear()+1900);
            birthdate=xYear+"/"+sdf.format(xdate);
        }
        return birthdate;
    }

    public static Date saveDate(String xdate){

        if(xdate==null || xdate.length()<=0)
            return null;
        
        try{
            String birthdate="";
            EsystemMgr em=EsystemMgr.getInstance();
            Esystem e=(Esystem)em.find(1);
         
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");

            Date studentBirth2=null;
            if(e.getEsystemDateType()==0)
            {
                String[] xString=xdate.split("/");
                int yearx=Integer.parseInt(xString[0])+1911;

                studentBirth2=sdf.parse(String.valueOf(yearx)+"/"+xString[1]+"/"+xString[2]);   

            }else{
                studentBirth2=sdf.parse(xdate);   
            }
            return studentBirth2;
        }catch(Exception e){

            return null;
        }
    }


    public String ChangeDateToString(Date cDate)
    {
        if (cDate==null)
            return "";
        return _sdf.format(cDate);
    /*
	if(cDate ==null)
	{
		return "no data";
		
	}
	
	int iYear=cDate.getYear()+1900-1911;
	int iMonth=cDate.getMonth()+1;
	int iDate=cDate.getDate();
		
	String sYear="";
	String sMonth="";
	String sDate="";
	if(iYear<=99)
		sYear="0"+String.valueOf(iYear);	
	else
		sYear=String.valueOf(iYear);		

	if(iMonth<=9)
		sMonth="0"+String.valueOf(iMonth);
	else
		sMonth=String.valueOf(iMonth);
	
	if(iDate<=9)
		sDate="0"+String.valueOf(iDate);
	else
		sDate=String.valueOf(iDate);
	return sYear+"/"+sMonth+"/"+sDate;
    */
    }	

    private static java.text.SimpleDateFormat _sdf2 = 
            new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm");
    public String ChangeDateToString2(Date cDate)
    {
        if (cDate==null)
            return "";
        return _sdf2.format(cDate);
    /*
	if(cDate ==null)
	{
		return "no data";
		
	}
	
	int iYear=cDate.getYear()+1900-1911;
	int iMonth=cDate.getMonth()+1;
	int iDate=cDate.getDate();
	
	
	String sYear="";
	String sMonth="";
	String sDate="";
	if(iYear<=99)
		sYear="0"+String.valueOf(iYear);	
	else
		sYear=String.valueOf(iYear);		

	if(iMonth<=9)
		sMonth="0"+String.valueOf(iMonth);
	else
		sMonth=String.valueOf(iMonth);
	
	if(iDate<=9)
		sDate="0"+String.valueOf(iDate);
	else
		sDate=String.valueOf(iDate);
	return sYear+"/"+sMonth+"/"+sDate+" "+cDate.getHours()+":"+cDate.getMinutes();
    */
    }	

    private static java.text.SimpleDateFormat _sdf3 = 
            new java.text.SimpleDateFormat("HH:mm");
    public String ChangeDateToString3(Date cDate)
    {
        if (cDate==null)
            return "";
        return _sdf3.format(cDate);
    /*
    if(cDate ==null)
    {
    return "no data";

    }
    String ax="";
    if(cDate.getMinutes()<10)
    ax="0"+String.valueOf(cDate.getMinutes());	
    else
    ax=String.valueOf(cDate.getMinutes());	

    return cDate.getHours()+":"+ax;
    */
    }	
	

    public String formatString(String original)
    {
    	if(original.length() >=30)	
		return original.substring(0,10)+".....";    			
    	
	return original;
    }	

    public String numberPercent(int small,int big)
    {
    	float ax=(float)small/big;
    	ax=ax*(float)100;
    	DecimalFormat df=new DecimalFormat("0.00");
    	
    	return df.format(ax)+" %";
    
    }		

    public String generateFeenumber(Date addDate)
    {
    	try{
		FeenumberMgr fng = FeenumberMgr.getInstance();
	        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	    	String query=" feenumberDate ='"+df.format(addDate)+"/01'";
	       
	       int addDateYear=addDate.getYear()+1900;
	       int addDateMonth=addDate.getMonth()+1;
	       
	       
	       
	         Object[] objs = fng.retrieve(query, "");
	        
	     if (objs==null || objs.length==0)
		 {	
			Feenumber fb=new Feenumber();
			fb.setFeenumberTotal(1);
			fb.setFeenumberDate(df.parse(addDateYear+"/"+addDateMonth));
			fng.createWithIdReturned(fb);	 
			  
			
	        return gFeeNumber(fb.getFeenumberDate(),1);
        }
	         
		 Feenumber fb=(Feenumber)objs[0];
		 int nowNumber=fb.getFeenumberTotal();
		 fb.setFeenumberTotal(nowNumber+1);
		 fng.save(fb);	 
		 
		 nowNumber=fb.getFeenumberTotal();
		 return gFeeNumber(fb.getFeenumberDate(),nowNumber);
	}
	catch(Exception e)
	{
		return e.getMessage();	
	}
	
	
    }		

	 public String generateCostcheck(Date addDate)
    {
    	try{
			CostcheckMgr fng = CostcheckMgr.getInstance();
	        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
	    	String query=" CostcheckDate ='"+df.format(addDate)+"/01'";
	       
			int addDateYear=addDate.getYear()+1900;
			int addDateMonth=addDate.getMonth()+1;

         	Object[] objs = fng.retrieve(query, "");
        
	        if (objs==null || objs.length==0)
		 	{	
				Costcheck fb=new Costcheck();
				fb.setCostcheckTotal(1);
				fb.setCostcheckDate(df.parse(addDateYear+"/"+addDateMonth));
				fng.createWithIdReturned(fb);	 
				  
	          	return gFeeNumber(fb.getCostcheckDate(),1);
	         }
		         
			 Costcheck fb=(Costcheck)objs[0];
			 int nowNumber=fb.getCostcheckTotal();
			 fb.setCostcheckTotal(nowNumber+1);
			 fng.save(fb);	 
			 
			 nowNumber=fb.getCostcheckTotal();
			 return gFeeNumber(fb.getCostcheckDate(),nowNumber);
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
			//int runTimex=5-originalNumber.length();
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
  	
    public Feeticket[] getFeeticketByType(Date oMonth,int classId,int type,int cmId,int status)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
		
		String query=" feeticketMonth ='"+df.format(oMonth)+"/01'";
		
		if(classId !=999)
		{
		    query +=" and feeticketStuClassId='"+classId+"'";
		}
		
	
		if(type !=99)
			query +=" and feeticketNewFeenumber="+type;
			
		if(cmId !=999)
			query +=" and feeticketNewFeenumberCmId="+cmId;
	
		if(status!=999)
		{
			if(status==0)	
				query +=" and feeticketStatus < 90";
			else
				query +=" and feeticketStatus >= 90";
		}		  
		     
		Object[] objs = bigr.retrieve(query," order by feeticketStuId");
		        
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
	
     public Feeticket[] getFeeticketByPrintUpdate(Date oMonth,int classId,int printUpdate)
    {
    	
    	FeeticketMgr bigr = FeeticketMgr.getInstance();
        
        java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM");	
        
		String query=" feeticketMonth ='"+df.format(oMonth)+"/01' and feeticketPrintUpdate="+printUpdate;
	
		if(classId !=0)
		{
			if(classId==999)
				classId=0;
				
			query +=" and feeticketStuClassId="+classId;
		}
	     
		Object[] objs = bigr.retrieve(query," order by feeticketStuId");
	        
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
	
	
	
    public void setFeeticketStatusAfterChange(Feeticket ft)
    {
    	FeeticketMgr fmx=FeeticketMgr.getInstance();
	
	int printU=ft.getFeeticketPrintUpdate();
	
	if(printU==1)
		ft.setFeeticketPrintUpdate(2);	
	  
	fmx.save(ft);
    	
    }	

public AdditionalFee getAdditionalFt(int additionalFtId)
{
	AdditionalFeeMgr afm=AdditionalFeeMgr.getInstance();
	
	String query=" additionalFeeAddition ="+additionalFtId;
			
	Object[] objs = afm.retrieve(query,"");
			        
	if (objs==null || objs.length==0)
	{
		return null;
	}		

	AdditionalFee af=(AdditionalFee)objs[0];
	
	return af;
}

	
public void setNotPayFeeticket(Date runDate,int stuId,int originalFtId)
{
	FeeAdmin fa=FeeAdmin.getInstance();
	Feeticket[] noPayFee=fa.getNotPayFeeticket(runDate,stuId);

	AdditionalFeeMgr afm=AdditionalFeeMgr.getInstance();
	
	
    if(noPayFee !=null)
	{
		for(int i=0;i<noPayFee.length;i++)	
		{
			//String query=" additionalFeeAddition ="+noPayFee[i].getFeeticketFeenumberId();
			
			//Object[] objs = afm.retrieve(query,"");
			        
		     //if (objs==null || objs.length==0)
			 //{
            AdditionalFee af=new AdditionalFee();
            af.setAdditionalFeeOriginal(originalFtId);
            af.setAdditionalFeeAddition(noPayFee[i].getFeeticketFeenumberId());
            af.setAdditionalFeeActive(1);
            
            afm.createWithIdReturned(af);
			//}
		}	
	}
}
	
    // return 
    //        >0 : Feeticket id
    //         0 : some error
    //        -1 : feeticket locked
  	synchronized public int addStudentFee(Date runDate,int classesChargeId,Student stu,int moneyNumber,int cmId,User ud2)
  	{
        boolean commit = false;
        int tran_id = 0;
        JsfFee jf=JsfFee.getInstance();
  		JsfAdmin ja=JsfAdmin.getInstance();
  		
  		if(moneyNumber==0)
  			return 0;
  	
  		if(!JsfPay.FEEStatus(runDate))
			return 0;	
  		
  		try
  		{
            tran_id = Manager.startTransaction();            
            FeeticketMgr feetm=new FeeticketMgr(tran_id);

  			ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
  			ClassesMoney cm=(ClassesMoney)cmm.find(cmId);
  			

  			Feeticket ticket=new Feeticket();
			String numberId="";

            //獨立帳單
  			if(cm.getClassesMoneyNewFeenumber()==1)
  			{
				numberId=generateFeenumber(runDate);
				//setNotPayFeeticket(runDate,stu.getId(),Integer.parseInt(numberId));
				
				Feeticket ft=new Feeticket();
				ft.setFeeticketMonth   	(runDate);
				ft.setFeeticketFeenumberId   	(Integer.parseInt(numberId));
				ft.setFeeticketStuId   	(stu.getId());
				ft.setFeeticketStuClassId(stu.getStudentClassId());
				ft.setFeeticketStuGroupId(stu.getStudentGroupId());
				ft.setFeeticketStuLevelId(stu.getStudentLevel());
				ft.setFeeticketSholdMoney   	(moneyNumber);
				ft.setFeeticketDiscountMoney   	(0);
				ft.setFeeticketTotalMoney   	(moneyNumber);
				ft.setFeeticketPayMoney   	(0);
				ft.setFeeticketStatus   	(1);
				ft.setFeeticketEndPayDate(getLimitDate(runDate));
				ft.setFeeticketNewFeenumber(1);
				ft.setFeeticketNewFeenumberCmId(cmId);
				ft.setFeeticketLock(0);
				ft.setFeeticketPrintUpdate(0);
				int newTicketId=feetm.createWithIdReturned(ft);
				ticket=(Feeticket)feetm.find(newTicketId);
  				
  	            //附屬帳單
  			}else if(cm.getClassesMoneyNewFeenumber()==2){

  				int newFeenumberCMId=cm.getClassesMoneyNewFeenumberCMId();

  				ClassesFee cfx=ja.getClassesFeeX(runDate,stu,newFeenumberCMId);

  				if(cfx!=null)
  				{	
  					ticket=ja.getFeeticketByNumberId(cfx.getClassesFeeFeenumberId());
  					
  					if(ticket.getFeeticketLock()!=0)
						return -1;
  					
  					int smoney=ticket.getFeeticketSholdMoney();
					int tmoney=ticket.getFeeticketTotalMoney();
					smoney+=moneyNumber;
					tmoney+=moneyNumber;
					ticket.setFeeticketSholdMoney(smoney);
					ticket.setFeeticketTotalMoney(tmoney);
					feetm.save(ticket);
  				
  				}else{
  					return 0;  					
  				}
  			}else{	
                //月帳單
                
	  			ticket=ja.getFeeticketByDateAndStuId2(runDate,stu.getId());

				if(ticket==null)
				{
					numberId=generateFeenumber(runDate);
                
					setNotPayFeeticket(runDate,stu.getId(),Integer.parseInt(numberId));
					
					Feeticket ft=new Feeticket();
					ft.setFeeticketMonth   	(runDate);
					ft.setFeeticketFeenumberId   	(Integer.parseInt(numberId));
					ft.setFeeticketStuId   	(stu.getId());
					ft.setFeeticketStuClassId(stu.getStudentClassId());
       				ft.setFeeticketStuGroupId(stu.getStudentGroupId());
					ft.setFeeticketStuLevelId(stu.getStudentLevel());
					ft.setFeeticketSholdMoney   	(moneyNumber);
					ft.setFeeticketDiscountMoney   	(0);
					ft.setFeeticketTotalMoney   	(moneyNumber);
					ft.setFeeticketPayMoney   	(0);
					ft.setFeeticketStatus   	(1);
					ft.setFeeticketEndPayDate(getLimitDate(runDate));
					ft.setFeeticketNewFeenumber(0);
					ft.setFeeticketNewFeenumberCmId(0);
					ft.setFeeticketLock(0);
					int newTicketId=feetm.createWithIdReturned(ft);

					ticket=(Feeticket)feetm.find(newTicketId);
				}else{
					if(ticket.getFeeticketLock()!=0)
						return -1;
				
					int smoney=ticket.getFeeticketSholdMoney();
					int tmoney=ticket.getFeeticketTotalMoney();
					smoney+=moneyNumber;
					tmoney+=moneyNumber;
					ticket.setFeeticketSholdMoney(smoney);
					ticket.setFeeticketTotalMoney(tmoney);
					feetm.save(ticket);
				}
			}
	
			ClassesFee cf=new ClassesFee();
			cf.setClassesFeeCMId   	(cmId);
			cf.setClassesFeeStudentId   	(stu.getId());
			cf.setClassesFeeStuClassId(stu.getStudentClassId());
			cf.setClassesFeeStuGroupId(stu.getStudentGroupId());
			cf.setClassesFeeStuLevelId(stu.getStudentLevel());
			cf.setClassesFeeMonth   	(runDate);
			cf.setClassesFeeFeenumberId   	(ticket.getFeeticketFeenumberId());
			cf.setClassesFeeTotalDiscount(0);
			cf.setClassesFeeShouldNumber   	(moneyNumber);
			//cf.setClassesFeeLogPs   	(String classesFeeLogPs);
			cf.setClassesFeeLogId(ud2.getId());
			cf.setClassesFeeStatus   	(1);
			cf.setClassesFeeVNeed(0);
			cf.setClassesFeeChargeId(classesChargeId);
			
			ClassesFeeMgr cfm=new ClassesFeeMgr(tran_id);
			int cfid=cfm.createWithIdReturned(cf);	

            Manager.commit(tran_id);			
            commit = true;
			return cfid;  		
	  	}
	  	catch(Exception e)
	  	{            
            e.printStackTrace();
	  		return 0;
	  	}
        finally {
            if (!commit)
                try { Manager.rollback(tran_id); } catch (Exception e2) {}
        }
        
	}

	synchronized public int addStudentFeeAndCfDiscount(Date runDate,int classesChargeId,Student stu,int moneyNumber,int cmId,Date cfDiscountDate,User ud2)
  	{
  			int cfId=addStudentFee(runDate,classesChargeId,stu,moneyNumber,cmId,ud2);
		
			if(cfId<=0)
				return cfId;

			ClassesFeeMgr cfm=ClassesFeeMgr.getInstance();
			ClassesFee cf=(ClassesFee)cfm.find(cfId);
			
			FeeAdmin fa=FeeAdmin.getInstance();
			
			CfDiscount[] cfd=fa.getCfDiscountBy(stu.getId(),cfDiscountDate,cmId);
			
			if(cfd==null)
				return 0;				
			
			CfDiscountMgr cfdm=CfDiscountMgr.getInstance();
			for(int x2=0;x2<cfd.length;x2++)
			{
				CfDiscount cf3=new CfDiscount();
				cf3.setCfDiscountClassesFeeId   (cfId);
			    cf3.setCfDiscountNumber   	(cfd[x2].getCfDiscountNumber());
				cf3.setCfDiscountStudentId   	(stu.getId());
				cf3.setCfDiscountClassId   	(stu.getStudentClassId());
				cf3.setCfDiscountGroupId   	(stu.getStudentGroupId());
				cf3.setCfDiscountLevelId   	(stu.getStudentLevel());
				cf3.setCfDiscountCmId   	(cmId);
				cf3.setCfDiscountMonth   	(runDate);
				cf3.setCfDiscountFeenumberId   	(cf.getClassesFeeFeenumberId());
				cf3.setCfDiscountLogId   	(ud2.getId());
				//cf3.setCfDiscountLogPs(discountPs);
				cf3.setCfDiscountStuatus(99); 
				cf3.setCfDiscountTypeId(cfd[x2].getCfDiscountTypeId());   
				
				addCfDiscount(cf3,cf);
			}	
			return cfId;
	}



	public Date getLimitDate(Date runDate)
	{
		
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
		String endDate="";
		Date limitDate=new Date();
		try{
			PaySystemMgr psm=PaySystemMgr.getInstance();
	  		PaySystem pSystem=(PaySystem)psm.find(1); 
	  		int runYear=runDate.getYear()+1900;
	  		int runMonth=runDate.getMonth()+1;
	  		int endDay=pSystem.getPaySystemLimitDate();
	  		String sEndMonth="";
	  		if(runMonth <10)
	  			sEndMonth="0"+String.valueOf(runMonth);
	  		else
	  			sEndMonth=String.valueOf(runMonth);
	  		
	  		String sEndDate="";
	  		if(endDay <10)
	  			sEndDate="0"+String.valueOf(endDay);
	  		else
	  			sEndDate=String.valueOf(endDay);	
	  		
	  		endDate=String.valueOf(runYear)+sEndMonth+sEndDate;
	  		limitDate=sdf.parse(endDate);
		}catch(Exception e)
		{}
			
		return limitDate;
	} 
	
	public boolean balanceFeeticketStudentAccount(PayFee pf,Feeticket ft,StudentAccount rootSA)
	{
		balanceFeeticketNotCostpay(pf,ft); 

		StudentAccountMgr sam=StudentAccountMgr.getInstance(); 
		StudentAccount sa=new StudentAccount();	
		sa.setStudentAccountStuId   	(ft.getFeeticketStuId());
	    sa.setStudentAccountIncomeType   	(1);  //0=income  1=cost
	    sa.setStudentAccountMoney   	(pf.getPayFeeMoneyNumber());
	    sa.setStudentAccountSourceType(2);  
 	    sa.setStudentAccountSourceId(pf.getId());
	    sa.setStudentAccountLogId   	(pf.getPayFeeLogId());
	    sa.setStudentAccountLogDate(new Date());
		sa.setStudentAccountPayFeeId(pf.getId());
		sa.setStudentAccountRootSAId(rootSA.getId());
		
		int saId=sam.createWithIdReturned(sa);

		return true;
	}	
	public boolean balanceFeeticketNotCostpay(PayFee pf,Feeticket ft)
	{
		FeeticketMgr fm=FeeticketMgr.getInstance();
		JsfAdmin js=JsfAdmin.getInstance();
  		try
  		{
			int payNumber=ft.getFeeticketPayMoney()+pf.getPayFeeMoneyNumber();

			if(payNumber==0)
				ft.setFeeticketStatus(1);
			else if(payNumber==ft.getFeeticketTotalMoney())
				ft.setFeeticketStatus(91);
			else if(payNumber>ft.getFeeticketTotalMoney())
				ft.setFeeticketStatus(92);
			else if(payNumber<ft.getFeeticketTotalMoney())
				ft.setFeeticketStatus(2);
			
			ft.setFeeticketPayDate(pf.getPayFeeLogPayDate());
			ft.setFeeticketPayMoney(payNumber);	
			ft.setFeeticketLock(2);
			ft.setFeeticketPrintUpdate(2);
			  	
  		}catch(Exception e){
  			return false;
  		}
  		
  		fm.save(ft);	
  		
  		if(ft.getFeeticketStatus()>=90)
  		{
  			ClassesFeeMgr cfm=ClassesFeeMgr.getInstance();
  			ClassesFee[] cf=js.getClassesFeeByNumber(ft.getFeeticketFeenumberId());
  			
  			for(int i=0;i<cf.length;i++)
  			{
  				cf[i].setClassesFeeStatus   	(91);
  				cfm.save(cf[i]);
  				
  			}
  			
  			AdditionalFeeMgr afm=AdditionalFeeMgr.getInstance();
  			AdditionalFee af=getAdditionalFt(ft.getFeeticketFeenumberId());
		
			if(af !=null)
			{
	  			af.setAdditionalFeeActive(0);
	  			afm.save(af);
	
				int originalFtid=af.getAdditionalFeeOriginal();
				Feeticket ftNotPay=js.getFeeticketByNumberId(originalFtid);
	  			ftNotPay.setFeeticketPrintUpdate(2);
	  			fm.save(ftNotPay);
	  		}
  		}
		
		return true;	
	}	

	public boolean balanceFeeticket(PayFee pf,Feeticket ft,int bankType,int paywayX,int tradeAccount)
  	{	
  			
  		balanceFeeticketNotCostpay(pf,ft);
  			

  		Costpay cost=new Costpay();
        if (1==1)
            throw new RuntimeException("obsolete!");
	  	cost.setCostpayDate   	(pf.getPayFeeLogPayDate());
	    cost.setCostpaySide   	(1);
	    cost.setCostpaySideID   	(0);
	    cost.setCostpayFeeticketID   	(ft.getId());
	    cost.setCostpayFeePayFeeID   	(pf.getId());
	    cost.setCostpayNumberInOut   	(0);
	    
	    String sum="";
	 	if(bankType==1)
		{
		    cost.setCostpayPayway   	(paywayX);
	    	cost.setCostpayAccountType   	(1);
	    	cost.setCostpayAccountId   	(tradeAccount);
			cost.setCostpayLogWay   	(1);
			sum="學費-人工登入-帳單編號"+String.valueOf(ft.getFeeticketFeenumberId());
			
		}else if(bankType==2){
			
			int bankId=tradeAccount;
			
			if(tradeAccount==0)
			{
				PaySystemMgr pma=PaySystemMgr.getInstance();
				PaySystem ps=(PaySystem)pma.find(1);
				bankId=ps.getPaySystemBankAccountId();
			}
			
			cost.setCostpayPayway   	(3);
	    	cost.setCostpayAccountType   	(2);
	    	cost.setCostpayAccountId   	(bankId);
			cost.setCostpayLogWay   	(2);
			
			sum="學費-電腦入帳<br>"+String.valueOf(ft.getFeeticketFeenumberId());
		}
		
		cost.setCostpayLogPs   	(sum);
	    cost.setCostpayCostNumber   	(0);
	    cost.setCostpayIncomeNumber   	(pf.getPayFeeMoneyNumber());
	    cost.setCostpayLogDate   	(new Date());
	    cost.setCostpayLogId   	(pf.getPayFeeVId());
	    cost.setCostpayCostbookId   	(0);
	    cost.setCostpayCostCheckId   	(0);
  		
		CostpayMgr cpm=CostpayMgr.getInstance();
		cpm.createWithIdReturned(cost);
		
		return true;
  	}
  	
  	public boolean deleteClassesFee(ClassesFee cf)
  	{
		boolean commit = false;
  	    int tran_id = 0;	
        FeeAdmin fa=FeeAdmin.getInstance();	
  		try{	
            tran_id = Manager.startTransaction();            
			ClassesFeeMgr cfm=new ClassesFeeMgr(tran_id);
            CfDiscountMgr cdsm=new CfDiscountMgr(tran_id);			
            FeeticketMgr feem=new FeeticketMgr(tran_id);			
            
            JsfAdmin ja=JsfAdmin.getInstance();
            if(!ja.deleteCfDiscountByCfidWithTranId(cf.getId(),tran_id))
			{
                return false;
            }
			
			
			
			//cdsm.createWithIdReturned(cds);
			
			int backMoney=cf.getClassesFeeShouldNumber()-cf.getClassesFeeTotalDiscount();
			
			
			int feenumberId=cf.getClassesFeeFeenumberId();

			Feeticket fee=ja.getFeeticketByNumberId(feenumberId);
			int feeShould=fee.getFeeticketSholdMoney();
			int feeTotalDiscount=fee.getFeeticketDiscountMoney();
			int feeTotalMoney=fee.getFeeticketTotalMoney();
			
			feeShould=feeShould-cf.getClassesFeeShouldNumber();
			feeTotalDiscount=feeTotalDiscount-cf.getClassesFeeTotalDiscount();
			feeTotalMoney=feeShould-feeTotalDiscount;
			
            //刪整張feeticket
			if(feeTotalMoney==0)
			{
				feem.remove(fee.getId());
				
				if(!fa.deleteAdditionalFeeByFeenumberWithTran_Id(feenumberId,tran_id))
                    return false;

			}else{	
				int payNumber=fee.getFeeticketPayMoney();
				
				int nowMoney=payNumber-feeTotalMoney;
				if(payNumber==feeTotalMoney)
					fee.setFeeticketStatus(91);
				else if(nowMoney>0)
					fee.setFeeticketStatus(92);
				else if(nowMoney <0 && payNumber!=0)
					fee.setFeeticketStatus(2);
				else if(nowMoney <0 && payNumber==0)
					fee.setFeeticketStatus(1);
			
                fee.setFeeticketSholdMoney(feeShould);
                fee.setFeeticketDiscountMoney(feeTotalDiscount);
                fee.setFeeticketTotalMoney(feeTotalMoney);
            
                int printU=fee.getFeeticketPrintUpdate();
                if(printU==1)
                    fee.setFeeticketPrintUpdate(2);	
         
                feem.save(fee);
			}
			
			cfm.remove(cf.getId());
            commit = true;
            Manager.commit(tran_id);
		}
        catch(Exception e) {
            return false;
		}
        finally {
            if (!commit) {
    			try { Manager.rollback(tran_id); } catch (Exception e2) {}
            }
        }
        return true;  		
  	}

/*  	
	public Income getIncomeByFeenumber(int type,int feenumber)
	{
		IncomeMgr tm=IncomeMgr.getInstance();
		
		Object[] o=tm.retrieve("incomeFeenumber="+feenumber+" and incomePayWay="+type,null);	
		
		if(o==null || o.length==0)
			return null;
		
		return (Income)o[0];
	
	}
*/	
  	public boolean deletePayFee(PayFee pf)
  	{
  		try{	

			JsfAdmin ja=JsfAdmin.getInstance();
			
			FeeticketMgr fm=FeeticketMgr.getInstance(); 
			Feeticket ft=ja.getFeeticketByNumberId(pf.getPayFeeFeenumberId());

			int payNumber=ft.getFeeticketPayMoney();
			
			payNumber=payNumber-pf.getPayFeeMoneyNumber();
			
			int feeTotalMoney=ft.getFeeticketTotalMoney();
			
			if(payNumber==feeTotalMoney)
				ft.setFeeticketStatus(91);
			else if(payNumber>feeTotalMoney)
				ft.setFeeticketStatus(92);
			else if(payNumber<feeTotalMoney)
				ft.setFeeticketStatus(2);
			
			ft.setFeeticketPayMoney(payNumber);
			fm.save(ft);			
			
			int pw=0;
		
			switch(pf.getPayFeeSourceCategory())
			{
					case 3:pw=4;
						break;
					case 2:pw=2;
						break;
					case 1:pw=2;
						break;
					case 4:pw=1;
						break;
			}
			
		/*	
			Income in=getIncomeByFeenumber(pw,pf.getPayFeeFeenumberId());
			IncomeMgr im=IncomeMgr.getInstance();
			if(in !=null)
				im.remove(in.getId());
		*/	
			Costpay[] cps=getCostpayByPatfee(pf);
			CostpayMgr bigr = CostpayMgr.getInstance();
			
			if(cps !=null)
			{
				for(int i=0;i<cps.length;i++)
				{
					bigr.remove(cps[i].getId());	
				}
			}
			PayFeeMgr pfm=PayFeeMgr.getInstance();
			pfm.remove(pf.getId());

		  }catch(Exception e){
		    	return false;
		  }
    	
    		return true;
  		
  	}
  	
  	public Costpay[] getCostpayByPatfee(PayFee pf)
  	{	
  		CostpayMgr bigr = CostpayMgr.getInstance();
        Object[] objs = bigr.retrieve("costpayFeePayFeeID='"+pf.getId()+"'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
        
        return u;
  	}

    public Costpay[] getCostpayByStudentAccount(int saId)
  	{	
  		CostpayMgr bigr = CostpayMgr.getInstance();
        Object[] objs = bigr.retrieve("costpayStudentAccountId='"+saId+"'"," order by created desc");
        
        if (objs==null || objs.length==0)
            return null;
	
		Costpay[] u =new Costpay[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Costpay)objs[i];
        }
        
        return u;
  	}
  	  	

  	public boolean deleteDiscount(CfDiscount cds)
  	{
        int tran_id = 0;
  		try{	
            tran_id = Manager.startTransaction();            

			ClassesFeeMgr cfm=new ClassesFeeMgr(tran_id);
            CfDiscountMgr cdsm=new CfDiscountMgr(tran_id);
            FeeticketMgr feem=new FeeticketMgr(tran_id);
						
			int discountNumber=cds.getCfDiscountNumber();
			int cfid=cds.getCfDiscountClassesFeeId();
			ClassesFee cf=(ClassesFee)cfm.find(cfid);
			
			JsfAdmin ja=JsfAdmin.getInstance();
			
			int shouldNumber=cf.getClassesFeeShouldNumber();
			int totalDiscount=cf.getClassesFeeTotalDiscount();
			
			cf.setClassesFeeTotalDiscount(totalDiscount-discountNumber);
			cfm.save(cf);
			
			int feenumberId=cf.getClassesFeeFeenumberId();

			Feeticket fee=ja.getFeeticketByNumberId(feenumberId);
			
			int feeShould=fee.getFeeticketSholdMoney();
			int feeTotalDiscount=fee.getFeeticketDiscountMoney();
			int feeTotalMoney=fee.getFeeticketTotalMoney();
			
			feeTotalDiscount=feeTotalDiscount-discountNumber;
			feeTotalMoney=feeShould-feeTotalDiscount;
			
			fee.setFeeticketDiscountMoney(feeTotalDiscount);
			fee.setFeeticketTotalMoney(feeTotalMoney);
			
            int printU=fee.getFeeticketPrintUpdate();
	
	        if(printU==1)
		        fee.setFeeticketPrintUpdate(2);	

			feem.save(fee);
			cdsm.remove(cds.getId());
            
            Manager.commit(tran_id);
		    return true;      
        }catch(Exception e){
		    try { Manager.rollback(tran_id); } catch (Exception e2) {}  
          	return false;
		}
  	}
  	public boolean addCfDiscount(CfDiscount cds,ClassesFee cf)
  	{
	
        int tran_id = 0;
		try{
			if(!JsfPay.FEEStatus(cf.getClassesFeeMonth()))
				return false;
			
            tran_id = Manager.startTransaction();            

            ClassesFeeMgr cfm=new ClassesFeeMgr(tran_id);
            FeeticketMgr feem=new FeeticketMgr(tran_id);
			CfDiscountMgr cdsm=new CfDiscountMgr(tran_id);

            cdsm.createWithIdReturned(cds);

            int discountNumber=cds.getCfDiscountNumber();		
			JsfAdmin ja=JsfAdmin.getInstance();			
			
			int shouldNumber=cf.getClassesFeeShouldNumber();
			int totalDiscount=cf.getClassesFeeTotalDiscount();
			
			cf.setClassesFeeTotalDiscount(totalDiscount+discountNumber);
			cfm.save(cf);
			
			int feenumberId=cf.getClassesFeeFeenumberId();
			
			Feeticket fee=ja.getFeeticketByNumberId(feenumberId);
			
			int feeShould=fee.getFeeticketSholdMoney();
			int feeTotalDiscount=fee.getFeeticketDiscountMoney();
			int feeTotalMoney=fee.getFeeticketTotalMoney();
			
			
			feeTotalDiscount=feeTotalDiscount+discountNumber;
			feeTotalMoney=feeShould-feeTotalDiscount;
			fee.setFeeticketDiscountMoney(feeTotalDiscount);
			fee.setFeeticketTotalMoney(feeTotalMoney);
	    	
            int printU=fee.getFeeticketPrintUpdate();
	
	        if(printU==1)
		        fee.setFeeticketPrintUpdate(2);	
	  
            feem.save(fee);

            Manager.commit(tran_id);

        }catch(Exception e){
            try { Manager.rollback(tran_id); } catch (Exception e2) {}
            return false;
        }
            
   		return true;
  	}
  	
  	public PayStore insertArtificialStore(String line,User ud2,PaySystem pSystem) 
  	{ 
  	 	String[] token = new String[7];
  		token[0]=line.substring(0,8).trim();
  		token[1]=line.substring(8,16).trim();
		token[2]=line.substring(23,32).trim();//ftId
		token[3]=line.substring(32,41).trim();//moneyNumber
		token[4]=line.substring(41,45).trim();//endDate
		token[5]=line.substring(45,53).trim();//storeId
		token[6]=line.substring(53).trim();//storeId
		int tokenLength=token.length;
		
		SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat sdf2=new SimpleDateFormat("yyyyMM");
		PayStoreMgr psm=PayStoreMgr.getInstance();
		PayStore ps=new PayStore();
		
		try{
			//1		
			String UpdateDate=token[0];
	        String PayDate=token[1];
	        String sFeeticketId=token[2];
			Date UpdateDate2=sdf.parse(UpdateDate);
	        Date PayDate2=sdf.parse(PayDate);
			int feeticketId=Integer.parseInt(sFeeticketId.trim());

			//7
        	String sMonth=token[4];
        	int payYear=Integer.parseInt(sMonth.substring(0,2))+1911;
        	String payMonthFormat=String.valueOf(payYear)+sMonth.substring(2);
        	Date payMonth=sdf2.parse(payMonthFormat);		
        	
        	String sMoney=token[3];
        	int payMoney=Integer.parseInt(sMoney);
        	
        	String sStoreId=token[5].trim();

			//8
			String payStoreAccountId=token[6]; 
			
ps.setPayStoreUpdateDate   	(UpdateDate2);
			ps.setPayStorePayDate   	(PayDate2);
			ps.setPayStoreFeeticketId   	(feeticketId);
			ps.setPayStorePayMoney   	(payMoney);
			ps.setPayStoreMonth   	(payMonth);
			ps.setPayStoreId   	(sStoreId);
			ps.setPayStoreAccountId   	(payStoreAccountId);
			ps.setPayStoreSource   	(line);


			PayStore psZ=getPayStoreByLine(line.trim());
			if(psZ !=null)
			{
				ps.setPayStoreStatus(6);
				ps.setPayStoreException("重複消單");
				
				return ps;		
			}
  

            //run Unique Key  
            int psId=0;
            try
            {
                psId=psm.createWithIdReturned(ps);                    
            }catch (Exception e){
                ps.setPayStoreStatus(6);
                ps.setPayStoreException("系統錯誤:"+e.getMessage());
                return ps;
            }
            ps.setId(psId);
			ps=balanceStore(ps,ud2,pSystem);

			
			return ps;
		}
		catch(Exception e)
		{
			ps.setPayStoreSource(line);
			ps.setPayStoreStatus(3);
			ps.setPayStoreException("系統錯誤:"+e.getMessage());
			return ps;	
	    } 
  	} 
  	
  	public PayStore balanceStore(PayStore ps,User ud2,PaySystem pSystem)
  	{	
	    
	    JsfAdmin ja=JsfAdmin.getInstance();
		PayStoreMgr psm=PayStoreMgr.getInstance(); 
		
        Feeticket ft=ja.getFeeticketByNumberId(ps.getPayStoreFeeticketId());
        if(ft==null)
        {
    		ps.setPayStoreStatus   	(4);
    		ps.setPayStoreException("無此繳款單編號");
			psm.remove(ps.getId());
			
			return ps;	
        }
  
    	FeeAdmin fa=FeeAdmin.getInstance();
    	
		int notPay=fa.getAllNotPayNumber(ft);
		int nowShould=ft.getFeeticketTotalMoney()-ft.getFeeticketPayMoney();
		int allMoney=notPay+nowShould;
		
		if(notPay==0 || allMoney>ps.getPayStorePayMoney())
		{    
			int nowPay=0;
			
			int xMoney=ps.getPayStorePayMoney()-nowShould;
			
			if(xMoney>0) 
			{ 
				nowPay=nowShould;

				StudentMgr stumm=StudentMgr.getInstance();
				Student stuXX=(Student)stumm.find(ft.getFeeticketStuId()); 
				String sum="Error:"+stuXX.getStudentName()+"便利商店逾繳 帳單編號:"+ft.getFeeticketFeenumberId(); 

				
				StudentAccountMgr sam=StudentAccountMgr.getInstance(); 
				StudentAccount sa=new StudentAccount();	
				sa.setStudentAccountStuId   	(ft.getFeeticketStuId());
			    sa.setStudentAccountIncomeType   	(0);  /*  0=income  1=cost  */
			    sa.setStudentAccountMoney   	(xMoney);
			    sa.setStudentAccountSourceType   	(4);  // type 1= pay ATM   type 4=store pay
			    sa.setStudentAccountSourceId   	(0);
			    sa.setStudentAccountLogId   	(ud2.getId());
			    sa.setStudentAccountLogDate(new Date());   
				sa.setStudentAccountPs(sum); 
                sa.setStudentAccountNumber(String.valueOf(ft.getFeeticketFeenumberId()));
				int saId=sam.createWithIdReturned(sa);
		
				sa=(StudentAccount)sam.find(saId);
				
				CostpayMgr cpMgr=CostpayMgr.getInstance();
				Costpay cost=new Costpay();
                if (1==1)
                    throw new RuntimeException("obsolete!");
				cost.setCostpayDate   	(ps.getPayStorePayDate());
				cost.setCostpaySide   	(1);
				cost.setCostpaySideID   	(0);
				cost.setCostpayFeeticketID   	(0);
				cost.setCostpayFeePayFeeID   	(0);
				cost.setCostpayNumberInOut   	(0);
				
				int bankId=pSystem.getPaySystemBankAccountId();
				
				cost.setCostpayPayway   	(3);
				cost.setCostpayAccountType   	(2);
				cost.setCostpayAccountId   	(bankId);
				cost.setCostpayLogWay   	(2);
				
	
				cost.setCostpayLogPs   	(sum);
				cost.setCostpayCostNumber   	(0);
				cost.setCostpayIncomeNumber   	(xMoney);
				cost.setCostpayLogDate   	(new Date());
				cost.setCostpayLogId   	(ud2.getId());
				cost.setCostpayCostbookId   	(0);
				cost.setCostpayCostCheckId   	(0);
				cost.setCostpayStudentAccountId (saId);
				int cpXid=cpMgr.createWithIdReturned(cost);
				
				sa.setStudentAccountCostpayID(cpXid);
				sam.save(sa);
			} else{
				
				nowPay=ps.getPayStorePayMoney();
			}
				 
			
			PayFee pf=new PayFee();
			pf.setPayFeeFeenumberId   	(ps.getPayStoreFeeticketId());
			pf.setPayFeeMoneyNumber   	(nowPay);
			pf.setPayFeeLogDate   	(new Date());
			pf.setPayFeeLogPayDate   	(ps.getPayStorePayDate());
			pf.setPayFeeManPCType   	(2);
			pf.setPayFeeStatus   	(1);
			pf.setPayFeeLogId(ud2.getId());
			PayFeeMgr pfm=PayFeeMgr.getInstance();
			int pfId=pfm.createWithIdReturned(pf);
			pf=(PayFee)pfm.find(pfId);
	 		
	 		if(!balanceFeeticket(pf,ft,2,0,0))
	 		{
	 			ps.setPayStoreStatus   	(5);
	        	ps.setPayStoreException("銷單發生錯誤");

			    psm.remove(ps.getId());	
				pfm.remove(pfId);
				
				return ps;
	 		}
		        	       
			ps.setPayStoreStatus   	(90);
			psm.save(ps); 
			
pf.setPayFeeSourceCategory(3);
			pf.setPayFeeSourceId(ps.getId());

			pf.setPayFeeAccountType(2);
			pf.setPayFeeAccountId(pSystem.getPaySystemBankAccountId());   	

			pfm.save(pf);
			return ps;	
	
		}else{
				fa.balanceNotPayTicket(ft,notPay,2,3,ud2,2,0,0);
				
				int leftMoney=ps.getPayStorePayMoney()-notPay;
				
				int xMoney=leftMoney-nowShould;
				
				int nowPay=0;
			
				if(xMoney>0)
				{ 
					nowPay=nowShould;
				
					StudentMgr stumm=StudentMgr.getInstance();
					Student stuXX=(Student)stumm.find(ft.getFeeticketStuId()); 
					String sum="Error:"+stuXX.getStudentName()+"便利商店逾繳 帳單編號:"+ft.getFeeticketFeenumberId(); 
	
					
					StudentAccountMgr sam=StudentAccountMgr.getInstance(); 
					StudentAccount sa=new StudentAccount();	
					sa.setStudentAccountStuId   	(ft.getFeeticketStuId());
				    sa.setStudentAccountIncomeType   	(0);  /*  0=income  1=cost  */
				    sa.setStudentAccountMoney   	(xMoney);
				    sa.setStudentAccountSourceType   	(4);  // type 1= pay ATM   type 4=store pay
				    sa.setStudentAccountSourceId   	(0);
				    sa.setStudentAccountLogId   	(ud2.getId());
				    sa.setStudentAccountLogDate(new Date());   
					sa.setStudentAccountPs(sum);
	 
					
				    sa.setStudentAccountNumber(String.valueOf(ft.getFeeticketFeenumberId()));
					int saId=sam.createWithIdReturned(sa);
			
					sa=(StudentAccount)sam.find(saId);
					
					CostpayMgr cpMgr=CostpayMgr.getInstance();
					Costpay cost=new Costpay();
                    if (1==1)
                        throw new RuntimeException("obsolete!");
					cost.setCostpayDate   	(ps.getPayStorePayDate());
					cost.setCostpaySide   	(1);
					cost.setCostpaySideID   	(0);
					cost.setCostpayFeeticketID   	(0);
					cost.setCostpayFeePayFeeID   	(0);
					cost.setCostpayNumberInOut   	(0);
					
					int bankId=pSystem.getPaySystemBankAccountId();
					
					cost.setCostpayPayway   	(3);
					cost.setCostpayAccountType   	(2);
					cost.setCostpayAccountId   	(bankId);
					cost.setCostpayLogWay   	(2);
					
		
					cost.setCostpayLogPs   	(sum);
					cost.setCostpayCostNumber   	(0);
					cost.setCostpayIncomeNumber   	(xMoney);
					cost.setCostpayLogDate   	(new Date());
					cost.setCostpayLogId   	(ud2.getId());
					cost.setCostpayCostbookId   	(0);
					cost.setCostpayCostCheckId   	(0);
					cost.setCostpayStudentAccountId (saId);
					int cpXid=cpMgr.createWithIdReturned(cost);
					
					sa.setStudentAccountCostpayID(cpXid);
					sam.save(sa); 
				
				}else{
				
					nowPay=leftMoney;
				}
				
				PayFee pf=new PayFee();
				pf.setPayFeeFeenumberId   	(ps.getPayStoreFeeticketId());
				pf.setPayFeeMoneyNumber   	(nowPay);
				pf.setPayFeeLogDate   	(new Date());
				pf.setPayFeeLogPayDate   	(ps.getPayStorePayDate());
				pf.setPayFeeManPCType   	(2);
				pf.setPayFeeStatus   	(1);
				pf.setPayFeeLogId(ud2.getId());
				PayFeeMgr pfm=PayFeeMgr.getInstance();
				int pfId=pfm.createWithIdReturned(pf);
				pf=(PayFee)pfm.find(pfId);
		 		
		 		if(!balanceFeeticket(pf,ft,2,0,0))
		 		{
		 			ps.setPayStoreStatus   	(5);
		        	ps.setPayStoreException("銷單發生錯誤");
        
        			psm.remove(ps.getId());
					
pfm.remove(pfId);
					return ps;
		 		}
			        	       
				ps.setPayStoreStatus   	(90);
				psm.save(ps);
				
				pf.setPayFeeSourceCategory(3);
				pf.setPayFeeSourceId(ps.getId());
				
				pf.setPayFeeAccountType(2);
    			pf.setPayFeeAccountId(pSystem.getPaySystemBankAccountId());   	
				
				pfm.save(pf);
				return ps;	
		}
}
	
	public PayStore getPayStoreByLine(String line)
	{
		PayStoreMgr psm=PayStoreMgr.getInstance();
		String query="payStoreSource ='"+line+"' and PayStoreStatus='90'";	
		
	        Object[] objs = psm.retrieve(query, null);
	        
	        if (objs==null || objs.length==0)
	            return null;
	        
	        return (PayStore)objs[0];		
		
	}
	
	public PayAtm getPayAtmRepeat(int payAtmNumber,Date payDate)
	{
		PayAtmMgr bigr = PayAtmMgr.getInstance();
	
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
		
		String query="payAtmNumber ='"+payAtmNumber+"' and payAtmPayDate ='"+df.format(payDate)+"'";
        	
	        Object[] objs = bigr.retrieve(query, null);
	        
	        if (objs==null || objs.length==0)
	            return null;
	        
	        return (PayAtm)objs[0];		
	}
	
	public PayAtm insertArtificialATM(String line,User ud2,PaySystem ps) 
	{   
		PayAtmMgr pam=PayAtmMgr.getInstance();
		PayAtm pa=new PayAtm(); 
		
		try{ 

			String[] token = line.split("\t");
			int tokenLength=token.length;		
			
			if(tokenLength !=6)
			{
				pa.setPayAtmSource(line);
				pa.setPayAtmStatus(2);
				pa.setPayAtmException("字串間隔長度有誤(6tab)");
				
				return pa;
			} 
			
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
				
			int payAtmNumber=Integer.parseInt(token[0].trim()); 
	    	String spayDate=token[1].trim();
	    	Date payDate=sdf.parse(spayDate);

	    	int payMoney=Integer.parseInt(token[2].trim());
	    	
	    	String x4=token[3].trim();
			String accountFirst5=x4.substring(0,5); 
			int feeticketId=Integer.parseInt(x4.substring(5).trim());

        	String payWay=token[4].trim();
        	String bankId=token[5].trim();
		
			pa.setPayAtmNumber   	(payAtmNumber);
            pa.setPayAtmNumberUnique   	(payAtmNumber);
			pa.setPayAtmPayDate   	(payDate);
			pa.setPayAtmPayMoney   	(payMoney);
			
			pa.setPayAtmAccountFirst5   	(accountFirst5.trim());
			pa.setPayAtmFeeticketId   	(feeticketId);
			pa.setPayAtmWay   	(payWay);
			pa.setPayAtmBankId   	(bankId);
			pa.setPayAtmSource   	(line);

			PayAtm paS=getPayAtmRepeat(payAtmNumber,payDate);

	        if(paS !=null)
	        {
	        	pa.setPayAtmSource(line);
				pa.setPayAtmStatus(6);
				pa.setPayAtmException("重複登入虛擬帳號匯款資料,已登入PayAtm為"+paS.getId());

				return pa;
	        } 

            int psId=0;

            try{
            	    psId=pam.createWithIdReturned(pa);	
	      	}catch(Exception ex){
           
                pa.setPayAtmStatus(6);
				pa.setPayAtmException(ex.getMessage());
				return pa;
            }



	      	pa.setId(psId);
	      	
	    	pa=balanceAtm(pa,ud2,ps);    
	         
	       	return pa;
    
        }catch(Exception e){
		
        	pa.setPayAtmSource(line);
			pa.setPayAtmStatus(3);
			pa.setPayAtmException(e.getMessage());
			
			return pa;	
		}  
	}
	
	public PayAtm balanceAtm(PayAtm pa,User ud2,PaySystem ps)
  	{	
		
		PayAtmMgr pam=PayAtmMgr.getInstance(); 
		
		String originalAccount=pa.getPayAtmAccountFirst5()+String.valueOf(pa.getPayAtmFeeticketId());
		
		String fixATMAccount=ps.getPaySystemFirst5().trim()+ps.getPaySystemFixATMAccount().trim();
		
		String accountFirstX=originalAccount.substring(0,fixATMAccount.length()); 
		String accountLastX=originalAccount.substring(fixATMAccount.length());		


		//check fix atm or not!	
		if(fixATMAccount.equals(accountFirstX))
		{   
			int stuId=Integer.parseInt(accountLastX);
	
			StudentAccountMgr sam=StudentAccountMgr.getInstance(); 
			StudentAccount sa=new StudentAccount();	
			sa.setStudentAccountStuId   	(stuId);
		    sa.setStudentAccountIncomeType   	(0);  //0=income  1=cost
		    sa.setStudentAccountMoney   	(pa.getPayAtmPayMoney());
		    sa.setStudentAccountSourceType   	(1);  // type 1= pay ATM 
		    sa.setStudentAccountSourceId   	(pa.getId());
		    sa.setStudentAccountLogId   	(ud2.getId());
		    sa.setStudentAccountLogDate(new Date());    
		    sa.setStudentAccountNumber(accountFirstX+accountLastX);
			
			int saId=sam.createWithIdReturned(sa);
	
			sa.setId(saId);
		
			CostpayMgr cpMgr=CostpayMgr.getInstance();
			Costpay cost=new Costpay();
            if (1==1)
                throw new RuntimeException("obsolete!");
			cost.setCostpayDate   	(pa.getPayAtmPayDate());
			cost.setCostpaySide   	(1);
			cost.setCostpaySideID   	(0);
			cost.setCostpayFeeticketID   	(0);
			cost.setCostpayFeePayFeeID   	(0);
			cost.setCostpayNumberInOut   	(0);
			
			int bankId=ps.getPaySystemBankAccountId();
			
			cost.setCostpayPayway   	(3);
			cost.setCostpayAccountType   	(2);
			cost.setCostpayAccountId   	(bankId);
			cost.setCostpayLogWay   	(2);
			
	
			StudentMgr stumm=StudentMgr.getInstance();
			Student stuA=(Student)stumm.find(stuId);
			
			String sum="";
			if(stuA ==null)
			{  
				sum="Error: 固定虛擬帳號:"+accountFirstX+accountLastX+" 沒有此學生"; 
			}else{
				
                sum="固定虛擬帳號:"+accountFirstX+accountLastX+" 金額:"+pa.getPayAtmPayMoney();	
			}
			
			cost.setCostpayLogPs   	(sum);
			cost.setCostpayCostNumber   	(0);
			cost.setCostpayIncomeNumber   	(pa.getPayAtmPayMoney());
			cost.setCostpayLogDate   	(new Date());
			cost.setCostpayLogId   	(ud2.getId());
			cost.setCostpayCostbookId   	(0);
			cost.setCostpayCostCheckId   	(0);
			cost.setCostpayStudentAccountId (saId);
			int cpXid=cpMgr.createWithIdReturned(cost);
			
			sa.setStudentAccountCostpayID(cpXid);
			sam.save(sa);
	
			if(stuA ==null)
			{ 
				pa.setPayAtmStatus   	(10);
				pa.setPayAtmException("固定虛擬帳號:"+accountFirstX+accountLastX+" 沒有此學生");
				
                pam.save(pa);
				
				return pa;
			}
			
			int allMoney=countStudentAccount(stuId);
			Feeticket[] ft=allNotpayFeeticket(stuId);
			
			if(ft==null) 
			{ 	        	
				pa.setPayAtmStatus(7);
				pa.setPayAtmException("沒有未銷帳的帳單");
				pam.save(pa);			
				return pa;	
			}		
					
			Hashtable haNum=getPossiblePay(ft); 
			
			String ftList=(String)haNum.get(String.valueOf(allMoney));		
		
			//follow list money
			if(ftList !=null) 
			{ 
				String[] ftLists=ftList.split("###");	
				
				FeeticketMgr ftim=FeeticketMgr.getInstance();
				for(int i=0;i<ftLists.length;i++) 
				{	
					int feeId=Integer.parseInt(ftLists[i]);
					Feeticket ftXX=(Feeticket)ftim.find(feeId);			
	
					int shouldpay= ftXX.getFeeticketTotalMoney()-ftXX.getFeeticketPayMoney(); 
					  
					if(allMoney<shouldpay)
						shouldpay=allMoney;
						 
		        	PayFee pf=new PayFee();
					pf.setPayFeeFeenumberId   	(ftXX.getFeeticketFeenumberId());
					pf.setPayFeeMoneyNumber   	(shouldpay);
					pf.setPayFeeLogDate   	(new Date());
					pf.setPayFeeLogPayDate   	(pa.getPayAtmPayDate());
					pf.setPayFeeManPCType   	(2);
					pf.setPayFeeStatus   	(1);
					pf.setPayFeeLogId(ud2.getId()); 
	
					pf.setPayFeeSourceCategory(2);     /*  2 =fix atm  */ 
	    			pf.setPayFeeSourceId(pa.getId());
	    			
					PayFeeMgr pfm=PayFeeMgr.getInstance();
				 	int pfId=pfm.createWithIdReturned(pf);
			       	pf=(PayFee)pfm.find(pfId);
	
			 		if(!balanceFeeticketStudentAccount(pf,ftXX,sa))
			 		{
						pa.setPayAtmStatus   	(5);
						pa.setPayAtmException("銷單發生錯誤");
						pam.save(pa);
						
						pfm.remove(pfId);
						return pa;	
					
                    }
					
					allMoney-=shouldpay;	
					
					pf.setPayFeeSourceCategory(2);
					pf.setPayFeeSourceId(pa.getId()); 
					pfm.save(pf);
				}  
			
				pa.setPayAtmStatus(90);
				pa.setPayAtmException("固定帳號	預期金額銷帳");
				pam.save(pa); 
	
				return pa;
			
            }else{
				
				for(int i=0;i<ft.length;i++)	
				{ 
					if(allMoney<=0)
						break;
						
					int shouldpay= ft[i].getFeeticketTotalMoney()-ft[i].getFeeticketPayMoney(); 		
					if(shouldpay>allMoney) 
						shouldpay=allMoney;
				
			        PayFee pf=new PayFee();
					pf.setPayFeeFeenumberId   	(ft[i].getFeeticketFeenumberId());
					pf.setPayFeeMoneyNumber   	(shouldpay);
					pf.setPayFeeLogDate   	(new Date());
					pf.setPayFeeLogPayDate   	(pa.getPayAtmPayDate());
					pf.setPayFeeManPCType   	(2);
					pf.setPayFeeStatus   	(1);
					pf.setPayFeeLogId(ud2.getId());
	 
	
					pf.setPayFeeSourceCategory(2);   /*  2 =fix atm  */ 
	    			pf.setPayFeeSourceId(pa.getId());
	    			
					PayFeeMgr pfm=PayFeeMgr.getInstance();
				 	int pfId=pfm.createWithIdReturned(pf);
			       	pf=(PayFee)pfm.find(pfId); 
			       	

                    if(!balanceFeeticketStudentAccount(pf,ft[i],sa))
			 		{
						pa.setPayAtmStatus   	(5);
						pa.setPayAtmException("銷單發生錯誤");
						pam.save(pa);
						
						pfm.remove(pfId);
						return pa;	
					
                    }
					
					allMoney-=shouldpay;	
					
					pf.setPayFeeSourceCategory(2);
					pf.setPayFeeSourceId(pa.getId()); 
					pfm.save(pf);
				}	
			
            	pa.setPayAtmStatus(90);
				pa.setPayAtmException("固定帳號	非預期金額銷帳");
				pam.save(pa); 
	
				return pa;
			
            } 
			
		}else{		
	        JsfAdmin ja=JsfAdmin.getInstance();
	        Feeticket ft=ja.getFeeticketByNumberId(pa.getPayAtmFeeticketId());
	        
	        if(ft==null)
	        {
				pa.setPayAtmStatus (4);
				pa.setPayAtmException("無此帳單編號");
				pam.save(pa);	
				
				
				StudentAccountMgr sam=StudentAccountMgr.getInstance(); 
				StudentAccount sa=new StudentAccount();	
				sa.setStudentAccountStuId   	(pa.getPayAtmFeeticketId());
			    sa.setStudentAccountIncomeType   	(0);  /*  0=income  1=cost  */
			    sa.setStudentAccountMoney   	(pa.getPayAtmPayMoney());
			    sa.setStudentAccountSourceType   	(1);  // type 1= pay ATM 
			    sa.setStudentAccountSourceId   	(pa.getId());
			    sa.setStudentAccountLogId   	(ud2.getId());
			    sa.setStudentAccountLogDate(new Date());   
	
			    sa.setStudentAccountNumber(String.valueOf(pa.getPayAtmFeeticketId()));
				int saId=sam.createWithIdReturned(sa);
		
				sa=(StudentAccount)sam.find(saId);
				
				CostpayMgr cpMgr=CostpayMgr.getInstance();
				Costpay cost=new Costpay();
                if (1==1)
                    throw new RuntimeException("obsolete!");
				cost.setCostpayDate   	(pa.getPayAtmPayDate());
				cost.setCostpaySide   	(1);
				cost.setCostpaySideID   	(0);
				cost.setCostpayFeeticketID   	(0);
				cost.setCostpayFeePayFeeID   	(0);
				cost.setCostpayNumberInOut   	(0);
				
				int bankId=ps.getPaySystemBankAccountId();
				
				cost.setCostpayPayway   	(3);
				cost.setCostpayAccountType   	(2);
				cost.setCostpayAccountId   	(bankId);
				cost.setCostpayLogWay   	(2);
				
				StudentMgr stumm=StudentMgr.getInstance();
				
				String sum="Error: 浮動虛擬帳號:"+pa.getPayAtmFeeticketId()+" 沒有此帳單"; 
	
				cost.setCostpayLogPs   	(sum);
				cost.setCostpayCostNumber   	(0);
				cost.setCostpayIncomeNumber   	(pa.getPayAtmPayMoney());
				cost.setCostpayLogDate   	(new Date());
				cost.setCostpayLogId   	(ud2.getId());
				cost.setCostpayCostbookId   	(0);
				cost.setCostpayCostCheckId   	(0);
				cost.setCostpayStudentAccountId (saId);
				int cpXid=cpMgr.createWithIdReturned(cost);
				
				sa.setStudentAccountCostpayID(cpXid);
				sam.save(sa);
	
				return pa;
	        }
	        
	        FeeAdmin fa=FeeAdmin.getInstance();
	    	
			int notPay=fa.getAllNotPayNumber(ft);
			int nowShould=ft.getFeeticketTotalMoney()-ft.getFeeticketPayMoney();
			int allMoney=notPay+nowShould;
			
			if(notPay==0 || allMoney>pa.getPayAtmPayMoney())
			{  
				int nowPay=0;
				
				if(pa.getPayAtmPayMoney()<=nowShould) 
				{
					nowPay = pa.getPayAtmPayMoney() ;
				}else{
					nowPay=nowShould;
					int extraMoney=pa.getPayAtmPayMoney()-nowShould;
					
					StudentMgr stumm=StudentMgr.getInstance();
					Student sta=(Student)stumm.find(ft.getFeeticketStuId());
					
					String sum=sta.getStudentName()+"浮動虛擬帳號:"+pa.getPayAtmFeeticketId()+" 多匯金額:"+extraMoney;  
					
					StudentAccountMgr sam=StudentAccountMgr.getInstance(); 
					StudentAccount sa=new StudentAccount();	
					sa.setStudentAccountStuId   	(ft.getFeeticketStuId());
					sa.setStudentAccountIncomeType   	(0);  /*  0=income  1=cost  */
					sa.setStudentAccountMoney   	(extraMoney);
					sa.setStudentAccountSourceType   	(1);  // type 1= pay ATM 
					sa.setStudentAccountSourceId   	(0);
					sa.setStudentAccountLogId   	(ud2.getId());
					sa.setStudentAccountLogDate(new Date());   
					sa.setStudentAccountPs(sum);
					sa.setStudentAccountNumber(String.valueOf(pa.getPayAtmFeeticketId()));
					int saId=sam.createWithIdReturned(sa);
					
					sa=(StudentAccount)sam.find(saId);
					
					CostpayMgr cpMgr=CostpayMgr.getInstance();
					Costpay cost=new Costpay();
                    if (1==1)
                        throw new RuntimeException("obsolete!");
					cost.setCostpayDate   	(pa.getPayAtmPayDate());
					cost.setCostpaySide   	(1);
					cost.setCostpaySideID   	(0);
					cost.setCostpayFeeticketID   	(0);
					cost.setCostpayFeePayFeeID   	(0);
					cost.setCostpayNumberInOut   	(0);
					
					int bankId=ps.getPaySystemBankAccountId();
					
					cost.setCostpayPayway   	(3);
					cost.setCostpayAccountType   	(2);
					cost.setCostpayAccountId   	(bankId);
					cost.setCostpayLogWay   	(2);
					cost.setCostpayLogPs   	(sum);
					cost.setCostpayCostNumber   	(0);
					cost.setCostpayIncomeNumber   	(pa.getPayAtmPayMoney());
					cost.setCostpayLogDate   	(new Date());
					cost.setCostpayLogId   	(ud2.getId());
					cost.setCostpayCostbookId   	(0);
					cost.setCostpayCostCheckId   	(0);
					cost.setCostpayStudentAccountId (saId);
					int cpXid=cpMgr.createWithIdReturned(cost);
					
					sa.setStudentAccountCostpayID(cpXid);
					sam.save(sa);
				}			
	      	 	
	        	PayFee pf=new PayFee();
				pf.setPayFeeFeenumberId   	(pa.getPayAtmFeeticketId());
				pf.setPayFeeMoneyNumber   	(nowPay);
				pf.setPayFeeLogDate   	(new Date());
				pf.setPayFeeLogPayDate   	(pa.getPayAtmPayDate());
				pf.setPayFeeManPCType   	(2);
				pf.setPayFeeStatus   	(1);
				pf.setPayFeeLogId(ud2.getId());
				PayFeeMgr pfm=PayFeeMgr.getInstance();
			 	int pfId=pfm.createWithIdReturned(pf);
		        
		        pf=(PayFee)pfm.find(pfId);
		 		
		 		if(!balanceFeeticket(pf,ft,2,0,0))
		 		{
					pa.setPayAtmStatus   	(5);
					pa.setPayAtmException("銷單發生錯誤");
					pam.save(pa);
					
					pfm.remove(pfId);
					return pa;
		 		
                }
			        	       
				pa.setPayAtmStatus   	(90);
				pam.save(pa);
				
				pf.setPayFeeSourceCategory(1);
				pf.setPayFeeSourceId(pa.getId());
				pf.setPayFeeAccountType(2);
				pf.setPayFeeAccountId(ps.getPaySystemBankAccountId());   	
				pfm.save(pf);

				return pa;	
			
			}else{
					
					fa.balanceNotPayTicket(ft,notPay,2,1,ud2,2,0,0);
										
					int leftMoney=pa.getPayAtmPayMoney()-notPay;
					
					int nowPay=0;
					
					if(leftMoney<=nowShould) 
					{
						nowPay=leftMoney;
					}else{
						nowPay=nowShould;
						int extraMoney=leftMoney-nowShould; 
						
						StudentMgr stumm=StudentMgr.getInstance();
						Student sta=(Student)stumm.find(ft.getFeeticketStuId());
						
						String sum=sta.getStudentName()+"浮動虛擬帳號:"+pa.getPayAtmFeeticketId()+" 多匯金額:"+extraMoney;  
						
						StudentAccountMgr sam=StudentAccountMgr.getInstance(); 
						StudentAccount sa=new StudentAccount();	
						sa.setStudentAccountStuId   	(ft.getFeeticketStuId());
						sa.setStudentAccountIncomeType   	(0);  /*  0=income  1=cost  */
						sa.setStudentAccountMoney   	(extraMoney);
						sa.setStudentAccountSourceType   	(1);  // type 1= pay ATM 
						sa.setStudentAccountSourceId   	(0);
						sa.setStudentAccountLogId   	(ud2.getId());
						sa.setStudentAccountLogDate(new Date());   
						sa.setStudentAccountPs(sum);
						sa.setStudentAccountNumber(String.valueOf(pa.getPayAtmFeeticketId()));
						int saId=sam.createWithIdReturned(sa);
						
						sa=(StudentAccount)sam.find(saId);
						
						CostpayMgr cpMgr=CostpayMgr.getInstance();
						Costpay cost=new Costpay();
                        if (1==1)
                            throw new RuntimeException("obsolete!");
						cost.setCostpayDate   	(pa.getPayAtmPayDate());
						cost.setCostpaySide   	(1);
						cost.setCostpaySideID   	(0);
						cost.setCostpayFeeticketID   	(0);
						cost.setCostpayFeePayFeeID   	(0);
						cost.setCostpayNumberInOut   	(0);
						
						int bankId=ps.getPaySystemBankAccountId();
						
						cost.setCostpayPayway   	(3);
						cost.setCostpayAccountType   	(2);
						cost.setCostpayAccountId   	(bankId);
						cost.setCostpayLogWay   	(2);
						cost.setCostpayLogPs   	(sum);
						cost.setCostpayCostNumber   	(0);
						cost.setCostpayIncomeNumber   	(pa.getPayAtmPayMoney());
						cost.setCostpayLogDate   	(new Date());
						cost.setCostpayLogId   	(ud2.getId());
						cost.setCostpayCostbookId   	(0);
						cost.setCostpayCostCheckId   	(0);
						cost.setCostpayStudentAccountId (saId);
						int cpXid=cpMgr.createWithIdReturned(cost);
						
						sa.setStudentAccountCostpayID(cpXid);
						sam.save(sa);
					}
					
					PayFee pf=new PayFee();
					pf.setPayFeeFeenumberId   	(pa.getPayAtmFeeticketId());
					pf.setPayFeeMoneyNumber   	(nowPay);
					pf.setPayFeeLogDate   	(new Date());
					pf.setPayFeeLogPayDate   	(pa.getPayAtmPayDate());
					pf.setPayFeeManPCType   	(2);
					pf.setPayFeeStatus   	(1);
					pf.setPayFeeLogId(ud2.getId());
					PayFeeMgr pfm=PayFeeMgr.getInstance();
					int pfId=pfm.createWithIdReturned(pf);
					pf=(PayFee)pfm.find(pfId);
			 		
			 		if(!balanceFeeticket(pf,ft,2,0,0))
			 		{
						pa.setPayAtmStatus   	(5);
						pa.setPayAtmException("銷單發生錯誤");
						pam.save(pa);
						
						pfm.remove(pfId);
						return pa;	
			 		
                    }
				        	       
					pa.setPayAtmStatus   	(90);
					pam.save(pa);
					
					pf.setPayFeeSourceCategory(1);
					pf.setPayFeeSourceId(pa.getId());
			
					pf.setPayFeeAccountType(2);
					pf.setPayFeeAccountId(ps.getPaySystemBankAccountId());   
					pfm.save(pf); 
					
					return pa;	
				}	
			}
	}
	 
	public boolean balanceCostpaybyStudentAccount(StudentAccount sa,int payWay,int type,int accountId)
  	
    {
        int tran_id = 0;

        try{

            tran_id = Manager.startTransaction(); 

            CostpayMgr cm=new CostpayMgr(tran_id);
            Costpay cp=new Costpay();	
            if (1==1)
                throw new RuntimeException("obsolete!");
            
            cp.setCostpayDate   	(sa.getStudentAccountLogDate());
            cp.setCostpaySide   	(1);
            cp.setCostpaySideID   	(0);
            cp.setCostpayFeeticketID   	(0);
            cp.setCostpayFeePayFeeID   	(0);
            cp.setCostpayOwnertradeStatus   	(0);
            cp.setCostpayOwnertradeId   	(0);
            cp.setCostpaySalaryBankId(0);
            cp.setCostpayNumberInOut   	(1);
            cp.setCostpayPayway   	(payWay);
            cp.setCostpayAccountType   	(type);
            cp.setCostpayAccountId   	(accountId);
            cp.setCostpayCostNumber   	(sa.getStudentAccountMoney());
            cp.setCostpayIncomeNumber   	(0);
            cp.setCostpayLogWay   	(1);
            cp.setCostpayLogDate   	(new Date());
            cp.setCostpayLogId   	(sa.getStudentAccountLogId());
            cp.setCostpayLogPs   	(sa.getStudentAccountPs());
            
            cp.setCostpayStudentAccountId(sa.getId());
           

            int cpId=cm.createWithIdReturned(cp);
            
            StudentAccountMgr sam=new StudentAccountMgr(tran_id);
            sa.setStudentAccountCostpayID(cpId);			
            sam.save(sa);
            
            Manager.commit(tran_id);

            return true;
        }catch(Exception ex){
            ex.printStackTrace();        
            try { Manager.rollback(tran_id); } catch (Exception e2) {}
            
            return false;
        }
  	}
 	
	
	public Hashtable getPossiblePay(Feeticket[] ft) 
	{   
		
		Hashtable haNum=new Hashtable();
		
		int[] notpayNum=new int[ft.length];

		for(int j=0;j<ft.length;j++)	
		{ 
			notpayNum[j]=ft[j].getFeeticketTotalMoney()-ft[j].getFeeticketPayMoney();
	
			String xNumS=String.valueOf(notpayNum[j]);
  			
  			if(haNum.get(xNumS)==null)	
  			{		
				haNum.put((String)xNumS,(String)String.valueOf(ft[j].getId()));
			}
		}	
		
		if(ft.length==2)
		{   
			int xNum=notpayNum[0]+notpayNum[1];
			haNum.put((String)String.valueOf(xNum),(String)String.valueOf(ft[0].getId())+"###"+String.valueOf(ft[1].getId()));	
		}	
		
		if(ft.length>2)
		{ 			
			for(int j=0;j<ft.length;j++)	
			{ 
				for(int k=1;k<ft.length;k++)	
				{	
					if(k!=j)
					{ 
						int xNum=notpayNum[j]+notpayNum[k];  
						String xNumS=String.valueOf(xNum); 
					
						if(haNum.get(xNumS)==null)	
						{
							haNum.put((String)xNumS,(String)String.valueOf(ft[j].getId())+"###"+String.valueOf(ft[k].getId()));	
						}
					}
				}				
			}
		} 
		
		if(ft.length==3)
		{   
			int xNum=notpayNum[0]+notpayNum[1]+notpayNum[2]; 	
			haNum.put((String)String.valueOf(xNum),(String)String.valueOf(ft[0].getId())+"###"+String.valueOf(ft[1].getId())+"###"+String.valueOf(ft[2].getId()));	
		
		}				
		
		if(ft.length>3)
		{ 
			for(int j=0;j<ft.length;j++)	
			{ 
				for(int k=2;k<ft.length;k++)	
				{	
					if(k!=j)
					
                    { 
						int xNum=notpayNum[j]+notpayNum[j+1]+notpayNum[k];
						haNum.put((String)String.valueOf(xNum),(String)String.valueOf(ft[j].getId())+"###"+String.valueOf(ft[j+1].getId())+"###"+String.valueOf(ft[k].getId()));	
					}
				}				
			}
		}
		
		if(ft.length==4)
		{   
			int xNum=notpayNum[0]+notpayNum[1]+notpayNum[2]+notpayNum[3]; 	
			haNum.put((String)String.valueOf(xNum),(String)String.valueOf(ft[0].getId())+"###"+String.valueOf(ft[1].getId())+"###"+String.valueOf(ft[2].getId())+"###"+String.valueOf(ft[3].getId()));	
		}				
		
		if(ft.length>4)
		{ 
			for(int j=0;j<ft.length;j++)	
			{ 
				for(int k=3;k<ft.length;k++)	
				{	
					if(k!=j)
					{ 

					int xNum=notpayNum[j]+notpayNum[j+1]+notpayNum[j+2]+notpayNum[k];
					haNum.put((String)String.valueOf(xNum),(String)String.valueOf(ft[j].getId())+"###"+String.valueOf(ft[j+1].getId())+"###"+String.valueOf(ft[j+2].getId())+"###"+String.valueOf(ft[k].getId()));	
					
					}
				}				
			}
		}
		
		return haNum;
	
    } 

	public Feeticket[] allNotpayFeeticket(int stuId)
  	{
		FeeticketMgr bigr = FeeticketMgr.getInstance();
         
       	String query="feeticketStuId="+stuId+" and feeticketStatus<90";
          
        Object[] objs = bigr.retrieve(query," order by created asc");
        
        if (objs==null || objs.length==0)
            return null;
        
   		Feeticket[] u =new Feeticket[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (Feeticket)objs[i];
        }
		return u;  		
  	}


	public int countStudentAccount(int stuId)
  	{
		StudentAccountMgr bigr = StudentAccountMgr.getInstance();
         
       	String query="studentAccountStuId="+stuId;
          
        Object[] objs = bigr.retrieve(query,"");
        
        if (objs==null || objs.length==0)
            return 0;
         
        int total=0; 
        
for (int i=0; i<objs.length; i++)
        {
            StudentAccount sa=(StudentAccount)objs[i];
         
          	if(sa.getStudentAccountIncomeType()==0) 
           	{
           		total=total+sa.getStudentAccountMoney();
           		
           	}else if(sa.getStudentAccountIncomeType()==1){
           		
           		total=total-sa.getStudentAccountMoney();
           	}
         }
		
		return total;  		
  	}
  	
    public int countStudentAccountByDate(int stuId,Date rundate)
  	{
		StudentAccountMgr bigr = StudentAccountMgr.getInstance();
         
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
       	
        String query="studentAccountStuId="+stuId+" and studentAccountLogDate <'"+sdf.format(rundate)+"'";
          
        Object[] objs = bigr.retrieve(query,"");
        
        if (objs==null || objs.length==0)
            return 0;
        
 
        int total=0; 
        
        for (int i=0; i<objs.length; i++)
        {
            StudentAccount sa=(StudentAccount)objs[i];
         
          	if(sa.getStudentAccountIncomeType()==0)
 
           	{
           		total=total+sa.getStudentAccountMoney();
           		
           	}else if(sa.getStudentAccountIncomeType()==1){
           		
           		total=total-sa.getStudentAccountMoney();
           	}
         }
		
		return total;  		
  	}

  	public StudentAccount[] getStudentAccountByStuId(int stuId)
  	{
		StudentAccountMgr bigr = StudentAccountMgr.getInstance();
         
       	String query="studentAccountStuId="+stuId;
          
        Object[] objs = bigr.retrieve(query," order by created asc");
        
        if (objs==null || objs.length==0)
            return null;
 		
 		StudentAccount[] u =new StudentAccount[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (StudentAccount)objs[i];
        }
        
        return u;
  	}

	public PayFee[] getPayFeeByDate(int payFeeSourceCategory,int payFeeLogId,Date startDate,Date endDate)
    {	   
    	
		PayFeeMgr cm=PayFeeMgr.getInstance();
    	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	long endDateL=endDate.getTime()+(long)1000*60*60*24;
    	
    	Date newEndDate=new Date(endDateL);
    	
    	System.out.println(newEndDate);
    	String 	query="";
    	
    	
		query=" payFeeLogPayDate >='"+df.format(startDate)+"'"+
		      " and payFeeLogPayDate <'"+df.format(newEndDate)+"'";
			      
    
    	if(payFeeLogId !=0)
    		query+=" and payFeeLogId='"+payFeeLogId+"'";
    		
    	if(payFeeSourceCategory!=999)
    		query+=" and payFeeSourceCategory='"+payFeeSourceCategory+"'";		
    
    	Object[] o=cm.retrieve(query," order by created asc");
    	
    	if(o==null || o.length ==0)
            return null;
            
        PayFee[] co=new PayFee[o.length];
        
        for(int i=0; i< o.length ;i++)
        {
            co[i]=(PayFee)o[i];   
        }
        return co;
	}	


	public PayAtm[] getPayAtmBySdateEdate(int type,Date startDate,Date endDate,int status)
    {	   
    	
		PayAtmMgr cm=PayAtmMgr.getInstance();
    	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
    	
    	long endDateL=endDate.getTime()+(long)1000*60*60*24;
    	
    	Date newEndDate=new Date(endDateL);
    	
    	System.out.println(newEndDate);
    	String 	query="";
    	
    	if(type==1)
    	{
    		query=" payAtmPayDate >='"+df.format(startDate)+"'"+
    		      " and payAtmPayDate <='"+df.format(newEndDate)+"'";
    	}else if(type==0){
    		query=" created >='"+df.format(startDate)+"'"+
    		      " and created <='"+df.format(newEndDate)+"'";
    	}		      
    	
    	if(status ==1)
    		query +=" and payAtmStatus >=90";	
		else if(status==0)
			query +=" and payAtmStatus <90";	
    
    	Object[] o=cm.retrieve(query,"");
    	
    	if(o==null || o.length ==0)
            return null;
            
        PayAtm[] co=new PayAtm[o.length];
        
        for(int i=0; i< o.length ;i++)
        {
            co[i]=(PayAtm)o[i];   
        }
        return co;

	}	

	public PayStore[] getPayStoreBySdateEdate(int type,Date startDate,Date endDate,int status)
    {	   
    	
		PayStoreMgr cm=PayStoreMgr.getInstance();
	    	java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd");	
	    	
	    	long endDateL=endDate.getTime()+(long)1000*60*60*24;
	    	
	    	Date newEndDate=new Date(endDateL);
	    	
	    	String 	query="";
	    	
	    	if(type==1)
	    	{
	    		query=" payStorePayDate >='"+df.format(startDate)+"'"+
	    		      " and payStorePayDate <='"+df.format(newEndDate)+"'";
	    	}else if(type==0){
	    		query=" created >='"+df.format(startDate)+"'"+
	    		      " and created <='"+df.format(newEndDate)+"'";
	    	}		      
	    	if(status ==1)
	    		query +=" and payStoreStatus >=90";	
		else if(status==0)
			query +=" and payStoreStatus <90";	
	    
	    	Object[] o=cm.retrieve(query,"");
	    	
	    	if(o==null || o.length ==0)
	            return null;
	            
	        PayStore[] co=new PayStore[o.length];
	        
	        for(int i=0; i< o.length ;i++)
	        {
	            co[i]=(PayStore)o[i];   
	        }
	        return co;
    }	

	
	public PayFee getPayFeeByCategoryAndId(int category,int xid)
	{
		PayFeeMgr tm=PayFeeMgr.getInstance();
		
		Object[] o=tm.retrieve("payFeeSourceCategory="+category+" and payFeeSourceId="+xid,null);	
		
		if(o==null || o.length==0)
		return null;
		
		return (PayFee)o[0];
	
	}

    public PayFee[] getPayFeeByCategoryAndIdes(int category,int xid)
	{
		PayFeeMgr tm=PayFeeMgr.getInstance();
		
		Object[] objs=tm.retrieve("payFeeSourceCategory="+category+" and payFeeSourceId="+xid,"");	
		
		if(objs==null || objs.length==0)
		    return null;
		
        PayFee[] u =new PayFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (PayFee)objs[i];
        }
            
        return u;
	
	}
    
    public PayFee[] getPayFeeByCategoryOnlyATM(int xid)
	{
		PayFeeMgr tm=PayFeeMgr.getInstance();
		
		Object[] objs=tm.retrieve("(payFeeSourceCategory='1' or payFeeSourceCategory='2') and payFeeSourceId="+xid,"");	
		
		if(objs==null || objs.length==0)
		    return null;
		
        PayFee[] u =new PayFee[objs.length];
        
        for (int i=0; i<objs.length; i++)
        {
            u[i] = (PayFee)objs[i];
        }
            
        return u;
	
	}

	public int[] checkCode(String textCode1)
  	{	
  		textCode1=textCode1.toUpperCase();
		int[] codeSum=new int[2];
		for(int j=0;j<textCode1.length();j++)
		{	
			int parseValue=0;
			String sourceValue="";
			try{
				sourceValue=String.valueOf(textCode1.charAt(j));
				parseValue=Integer.parseInt(sourceValue);
			}
			catch(Exception e)
			{
				if(sourceValue.equals("A"))
					parseValue=1;
				else if(sourceValue.equals("B"))	
					parseValue=2;
				else if(sourceValue.equals("C"))	
					parseValue=3;
				else if(sourceValue.equals("D"))	
					parseValue=4;
				else if(sourceValue.equals("E"))	
					parseValue=5;
				else if(sourceValue.equals("F"))	
					parseValue=6;
				else if(sourceValue.equals("G"))	
					parseValue=7;
				else if(sourceValue.equals("H"))	
					parseValue=8;
				else if(sourceValue.equals("I"))	
					parseValue=9;
				else if(sourceValue.equals("J"))	
					parseValue=1;
				else if(sourceValue.equals("K"))	
					parseValue=2;
				else if(sourceValue.equals("L"))	
					parseValue=3;
				else if(sourceValue.equals("M"))	
					parseValue=4;
				else if(sourceValue.equals("N"))	
					parseValue=5;
				else if(sourceValue.equals("O"))	
					parseValue=6;
				else if(sourceValue.equals("P"))	
					parseValue=7;
				else if(sourceValue.equals("Q"))	
					parseValue=8;
				else if(sourceValue.equals("R"))	
					parseValue=9;
				else if(sourceValue.equals("S"))	
					parseValue=2;
				else if(sourceValue.equals("T"))	
					parseValue=3;
				else if(sourceValue.equals("U"))	
					parseValue=4;
				else if(sourceValue.equals("V"))	
					parseValue=5;
				else if(sourceValue.equals("W"))	
					parseValue=6;
				else if(sourceValue.equals("X"))	
					parseValue=7;
				else if(sourceValue.equals("Y"))	
					parseValue=8;
				else if(sourceValue.equals("Z"))	
					parseValue=9;
			
			}
			
			if(j==0)
			{
				codeSum[0]+=parseValue;
			}
			else if(j==1)
			{
				codeSum[1]+=parseValue;	
			}
			else
			{
				int xs=j%2;
				if(xs==0)
					codeSum[0]+=parseValue;
				else
					codeSum[1]+=parseValue;
			}
		}

		return codeSum;
  		
  	}
  	
  	
}