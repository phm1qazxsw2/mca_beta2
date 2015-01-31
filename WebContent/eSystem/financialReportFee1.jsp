<%@ page language="java"  import="web.*,jsf.*,jsi.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<%@ include file="jumpTop.jsp"%>

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
<%
	DecimalFormat nf = new DecimalFormat("###,##0.00");
    DecimalFormat nf2 = new DecimalFormat("#####0");
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");
 
	JsfAdmin ja=JsfAdmin.getInstance();
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM");
	Utility u=Utility.getInstance();
	SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM");

	String smonth=request.getParameter("month");
	String syear=request.getParameter("year");
	String status=request.getParameter("status");
	
	String classIdString=request.getParameter("classesId");
	String levelIdString=request.getParameter("level");
	
	int classIdint=999;
	int levelIdint=999;
	
	if(classIdString !=null)
		classIdint=Integer.parseInt(classIdString);
	
	if(levelIdString !=null)
		levelIdint=Integer.parseInt(levelIdString);
	
	
	int intStatus=0;
	if(status !=null)
		intStatus=Integer.parseInt(status); 
	
	
	String seleString="";
	
	if(smonth !=null)
		seleString=smonth;
	
	JsfTool jt=JsfTool.getInstance();	
	String[] newdate=jt.getSelectDate2();
	
	Classes[] cla=ja.getAllClasses();
	Level[] le=ja.getAllLevel();	
	Date runDate=new Date();
	ClassesCharge cc=new ClassesCharge();
	if(syear==null)
	{
		out.println("目前日期資料!!");
		return;
	}
%>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/char.gif" border=0>學費統計 月份:<%=syear%>-<%=smonth%> </b> <br> 

<%	
	int type=0;
	
	String typeS=request.getParameter("type");
	
	if(typeS !=null) 
		 type=Integer.parseInt(typeS);
 
 	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM");
	String parseDate=syear+"-"+smonth;
	runDate=sdf1.parse(parseDate);
	
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();	
	
%> 
<blockquote>

<%=(type!=4)?"<a href=\"financialReportFee1.jsp?year="+syear+"&month="+smonth+"&type=4\">學費會計科目統計</a>":"學費會計科目統計"%> | 
<%=(type!=0)?"<a href=\"financialReportFee1.jsp?year="+syear+"&month="+smonth+"&type=0\">開徵項目統計</a>":"開徵項目統計"%> | 
<%=(type!=1)?"<a href=\"financialReportFee1.jsp?year="+syear+"&month="+smonth+"&type=1\">折扣統計</a>":"折扣統計"%> | 
<%=(type!=2)?"<a href=\"financialReportFee1.jsp?year="+syear+"&month="+smonth+"&type=2\">收費分析</a>":"收費分析"%> | 
<%=(type!=3)?"<a href=\"financialReportFee1.jsp?year="+syear+"&month="+smonth+"&type=3\">班級效益</a>":"班級效益"%> | 
</blockquote>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<% 
	int[] itemNum =null;
	String[] item =null;
	String[] itemUrl=null;
	String titleName="";
	String itemName="";
	String preUnit="";
	String segmentStyle[]=new String[6];
	segmentStyle[0]="155,202,164"; 
	segmentStyle[1]="159,159,255";
	segmentStyle[2]="235,53,8";
	segmentStyle[3]="255,230,155";
	segmentStyle[4]="16,148,70";
	segmentStyle[5]="17,97,158";

	switch(type){  
		
				case 4:	
%>
<font color=blue>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;收費會計科目統計</font>
<%
	ClassesFee[] cf=ja.getAllClassesFee(runDate);
	
	if(cf==null)
 
	{ 
		out.println("沒有資料");
		return; 
	} 

	int allTotalItem=0;
	int shouldTotalItem=0;
	int discountTotalItem=0;
	Hashtable haItem=new Hashtable();
	Hashtable haNum=new Hashtable();
	for(int i=0;i<cf.length;i++)
  	{
  		String cmIdS=String.valueOf(cf[i].getClassesFeeCMId());
  		int totalPay=cf[i].getClassesFeeShouldNumber()-cf[i].getClassesFeeTotalDiscount();
  		
  		shouldTotalItem +=cf[i].getClassesFeeShouldNumber() ;
		discountTotalItem += cf[i].getClassesFeeTotalDiscount();
  		allTotalItem +=totalPay;
  		if(haItem.get(cmIdS)==null)	
  		{
			haItem.put((String)cmIdS,(String)String.valueOf(totalPay));	
            haNum.put((String)cmIdS,(String)String.valueOf(1));		
  		}else{
  		  	String oldPay=(String)haItem.get(cmIdS);
  		  	int nowPay=totalPay +Integer.parseInt(oldPay);
  		  	haItem.put((String)cmIdS,(String)String.valueOf(nowPay));

            String oldNum=(String)haNum.get(cmIdS);
  		  	int newNum=Integer.parseInt(oldNum)+1;
  		  	haNum.put((String)cmIdS,(String)String.valueOf(newNum));		
  		} 
  	}

	Enumeration keysItem=haItem.keys();
	Enumeration elementsItem=haItem.elements();

    Enumeration keysNumxx=haNum.keys();
	Enumeration elementNum2=haNum.elements();


    Hashtable itemNumHa=new Hashtable();
	Hashtable allItemHa=new Hashtable();
  	while(elementsItem.hasMoreElements())
	{
		String key=(String)keysItem.nextElement();
		String income=(String)elementsItem.nextElement();
		
        String keynum=(String)keysNumxx.nextElement();
		String elenum=(String)elementNum2.nextElement();

      
		ClassesMoney cm=(ClassesMoney)cmm.find(Integer.parseInt(key));
		int itemId=cm.getClassesMoneyIncomeItem(); 
		
		String itenIdS=String.valueOf(itemId);
		
		
        if(allItemHa.get(itenIdS)==null) 
		{ 
			allItemHa.put((String)itenIdS,(String)income);
            
            itemNumHa.put((String)itenIdS,(String)elenum);

		}else{
			String oldIncome=(String)allItemHa.get(itenIdS);
			int newIncome=Integer.parseInt(oldIncome)+Integer.parseInt(income);  
			allItemHa.put((String)itenIdS,(String)String.valueOf(newIncome));

            String oldNum3=(String)itemNumHa.get(itenIdS);
            int newNum3=Integer.parseInt(oldNum3)+Integer.parseInt(elenum); 
			itemNumHa.put((String)itenIdS,(String)String.valueOf(newNum3));
		}
	
    }
%>
	<blockquote> 
	
		<table width="88%" height="" border="0" cellpadding="0" cellspacing="0">
		<tr align=left valign=top>
		<td bgcolor="#e9e3de">
	
		<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr>
            
			<td bgcolor=#f0f0f0  class=es02 align=middle>會計科目</td>
            <td bgcolor=#f0f0f0  class=es02 align=middle>開徵項目</td>
            <td bgcolor=#f0f0f0  class=es02 align=middle>應收金額</td>
            <td bgcolor=#f0f0f0  class=es02 align=middle>開單筆數</td>           
			<td bgcolor=#f0f0f0  class=es02 align=middle>學費總比例</td>
            <td bgcolor=#f0f0f0  class=es02 align=middle>單位金額</td>
		</tr>
<% 
		Enumeration keysItem2=allItemHa.keys();
		Enumeration elementsItem2=allItemHa.elements();
	
        Enumeration keysNum2=itemNumHa.keys();
		Enumeration elementsNum2=itemNumHa.elements();
	
		IncomeSmallItemMgr isim=IncomeSmallItemMgr.getInstance();
		
		int totalNumItem=0; 
		int totalNumX2=0;

        while(keysItem2.hasMoreElements())
		{ 
			totalNumItem++;
			
String key=(String)keysItem2.nextElement();
			String income=(String)elementsItem2.nextElement(); 
			    
            String elenum=(String)elementsNum2.nextElement();
            
            int isiId=Integer.parseInt(key);
            
            IncomeSmallItem  isi=(IncomeSmallItem)isim.find(isiId); 

            ClassesMoney[] cms=ja.getClassesMoneyByIsiId(isiId);
%>
		
    <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
			<td class=es02><%=isi.getIncomeSmallItemName()%></td>
            <td class=es02>
                <%
                if(cms!=null)
                {
                    for(int l=0;l<cms.length;l++)
                    {
                        out.println(cms[l].getClassesMoneyName()+"<br>");
                    }
                }

                %>
            </td>
			<td class=es02 align=right><%=mnf.format(Integer.parseInt(income))%></td>
            <td class=es02 align=right><%=elenum%></tD>
			<td class=es02 align=right>
			<%
				int incomeX=Integer.parseInt(income);
				int elenumX=Integer.parseInt(elenum);

                totalNumX2+=elenumX;
				out.println(nf.format(((float)incomeX/(float)allTotalItem)*100)+"%"); 
			%>
			</td>		
            <td class=es02 align=right>
                <%=mnf.format(incomeX/elenumX)%>
            </td>
		</tr>			 
<%	
		}
%>  
		<tr>
			<td>合計</td>
			<tD align=right><b><%=mnf.format(allTotalItem)%></b></tD>
            <td align=right><%=totalNumX2%></td>
			<td></tD>
			
		<tr>

		</table>
		</td>
		</tr>
		</table>
     
    </blockquote>
    <BR>
    <BR>     
<%  
     	int[] mFeeX=new int[totalNumItem];
		String[] mFeeNameX=new String[totalNumItem];
		String[] mFeeUrlX=new String[totalNumItem];

		Enumeration keys=allItemHa.keys();
		Enumeration elements=allItemHa.elements();
  
   		int intVec=0;
		while(elements.hasMoreElements())
		{ 
			String key=(String)keys.nextElement();
			String income=(String)elements.nextElement();
			IncomeSmallItem  isi=(IncomeSmallItem)isim.find(Integer.parseInt(key)); 
		
			mFeeX[intVec]=Integer.parseInt(income);
			mFeeNameX[intVec]=isi.getIncomeSmallItemName();
			mFeeUrlX[intVec]="";
			intVec++;
		}

		Hashtable reHa2=u.get6num(mFeeX,mFeeNameX,mFeeUrlX);

		titleName="學費會計科目統計";
		itemName="開徵項目";
		preUnit="$";
	 
		itemNum =(int[])reHa2.get("a");
	   	item =(String[])reHa2.get("b");
		itemUrl =(String[])reHa2.get("c");
%>
	<% //include file="henrypie.jsp"%>		

<%
	break;	
			
			
		case 0:	
%>
<font color=blue>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;開徵項目統計</font><br>
<%
	cf=ja.getAllClassesFee(runDate);
	
	if(cf==null) 
	{ 
		out.println("沒有資料");
		return; 
	} 

	int allTotal=0; 
	int shouldTotal=0;
	int discountTotal=0;
	
    Hashtable ha=new Hashtable();
	Hashtable ha1should=new Hashtable();
	Hashtable ha1discount=new Hashtable();
    haNum=new Hashtable();
    
	for(int i=0;i<cf.length;i++)
  	{
  		String cmIdS=String.valueOf(cf[i].getClassesFeeCMId());
  		int totalPay=cf[i].getClassesFeeShouldNumber()-cf[i].getClassesFeeTotalDiscount();
  		
  		shouldTotal +=cf[i].getClassesFeeShouldNumber() ;
		discountTotal += cf[i].getClassesFeeTotalDiscount();
  		allTotal +=totalPay;
  		if(ha.get(cmIdS)==null)	
  		{
			ha.put((String)cmIdS,(String)String.valueOf(totalPay));	
			ha1should.put((String)cmIdS,(String)String.valueOf(cf[i].getClassesFeeShouldNumber()));	
			ha1discount.put((String)cmIdS,(String)String.valueOf(cf[i].getClassesFeeTotalDiscount()));	

            haNum.put((String)cmIdS,(String)String.valueOf(1));	
  		}else{
  		  	String oldPay=(String)ha.get(cmIdS);
  		  	int nowPay=totalPay +Integer.parseInt(oldPay);
  		  	ha.put((String)cmIdS,(String)String.valueOf(nowPay));
  		  	
  		  	String oldShould=(String)ha1should.get(cmIdS);
  		  	int newShould=Integer.parseInt(oldShould)+cf[i].getClassesFeeShouldNumber();
  		  	ha1should.put((String)cmIdS,(String)String.valueOf(newShould));	

			String oldDiscount=(String)ha1discount.get(cmIdS);
  		  	int newDiscount=Integer.parseInt(oldDiscount)+cf[i].getClassesFeeTotalDiscount();
  		  	ha1discount.put((String)cmIdS,(String)String.valueOf(newDiscount));	

            String oldNum=(String)haNum.get(cmIdS);
  		  	int newNum=Integer.parseInt(oldNum)+1;
  		  	haNum.put((String)cmIdS,(String)String.valueOf(newNum));	
  		} 
  	}

	keys=ha.keys();
	elements=ha.elements();

	Enumeration keys1should=ha1should.keys(); 
	Enumeration element1should=ha1should.elements();
 	
 	Enumeration keys1discount=ha1discount.keys();
	Enumeration element1discount=ha1discount.elements();		
	

 	Enumeration keysNum=haNum.keys();
	Enumeration elementNum=haNum.elements();
%> 


<blockquote> 
	
		<table width="88%" height="" border="0" cellpadding="0" cellspacing="0">
		<tr align=left valign=top>
		<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr>
		<td bgcolor=#f0f0f0  class=es02 align=middle>合計開單</td>
		<td bgcolor=#f0f0f0  class=es02 align=middle>合計折扣</td>
		<td bgcolor=#f0f0f0  class=es02 align=middle>應收:</td>
		<td bgcolor=#f0f0f0  class=es02 align=middle>折數:</td>
		
	</tr>
	<tr>
		<td bgcolor=#ffffff  class=es02 align=right><%=mnf.format(shouldTotal)%></td>
		<td bgcolor=#ffffff  class=es02 align=right><a href="financialReportFee1.jsp?year=<%=syear%>&month=<%=smonth%>&type=1"><%=mnf.format(discountTotal)%></a></td>
		<td bgcolor=#ffffff  class=es02 align=right><%=mnf.format(allTotal)%></td>
		<td bgcolor=#ffffff  class=es02 align=right><%=nf.format(((float)allTotal/(float)shouldTotal)*100)%>%</td>
	</tr>
	</table>
	</td>
	</tr>
	</table> 
	
	
	<br>
	<br>					
	
    <table width="88%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=#f0f0f0 class=es02>
        <td>開徵對象</tD>        
		<td>開徵項目名稱</tD>
		<td align=right>開單金額</tD>
		<td align=right>折扣金額</tD>
		<td align=right>折數</tD>
		<td align=right>應收金額</tD>
	    <td align=right>筆數</tD>
        <td align=right>應收總比例</td>  
		<td></td>
	</tr>
<% 
	
	int totalNumFee=0;
	
    
    while(elements.hasMoreElements())
	{
		totalNumFee ++;
		String key=(String)keys.nextElement();
		String income=(String)elements.nextElement();

		ClassesMoney cm=(ClassesMoney)cmm.find(Integer.parseInt(key)); 
		
		int incomeInt=Integer.parseInt(income); 

		String keyshould=(String)keys1should.nextElement();
		String eleShould=(String)element1should.nextElement();

		String keydiscount=(String)keys1discount.nextElement();
		String eleDiscount=(String)element1discount.nextElement();

        String keynum=(String)keysNum.nextElement();
		String elenum=(String)elementNum.nextElement();


		int eleShouldInt=Integer.parseInt(eleShould);
		
        int eleDiscountInt=Integer.parseInt(eleDiscount); 
		int notDiscount= eleShouldInt-eleDiscountInt;

    

  
%>
	
   <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td class=es02> 
        <%
            switch(cm.getClassesMoneyCategory())
            {
                case 1:
                    out.println("班級");
                    break;
                case 2:
                    out.println("才藝班");
                    break;
                case 3:
                    out.println("個人");
                    break;
            }
        %>
        </td>    
         <td class=es02><%=cm.getClassesMoneyName()%></tD> 
        <td class=es02 align=right><%=mnf.format(eleShouldInt)%></td> 
        <td class=es02 align=right><%=mnf.format(eleDiscountInt)%></td> 
        <td class=es02 align=right><%=nf.format(((float)notDiscount/(float)eleShouldInt)*100)%>%</tD>
 		 
        <td class=es02 align=right>
            <%=mnf.format(Integer.parseInt(income))%>
        </td>
        <td class=es02 align=right>
            <%=elenum%>筆
        </tD>
        <td class=es02 align=right><%=nf.format((float)incomeInt/(float)allTotal*100)%>%</td>		
        <td class=es02><a href="classFeeReport.jsp?cmId=<%=cm.getId()%>&year=<%=syear%>&month=<%=smonth%>">詳細資料</a>
  	
    </tr>
<% 
	}
%>  
<tr>
	<td colspan=2>收費合計</tD>  
	<td align=right><b><%=mnf.format(shouldTotal)%></b></tD>
	<td align=right><b><%=mnf.format(discountTotal)%></b></tD>
	<td></td>		 
	<td align=right><b><%=mnf.format(allTotal)%></b></tD>
 	<td align=right></tD>
</tr>

	</table>
	</td></tr></table> 
</blockquote>	
	<br>
	<br> 
<%
		int[] mFee=new int[totalNumFee];
		String[] mFeeName=new String[totalNumFee];
		String[] mFeeUrl=new String[totalNumFee];

		keys=ha.keys();
		elements=ha.elements(); 
		
		int mNum=0;
		while(elements.hasMoreElements())
		{ 	   
			 String key=(String)keys.nextElement();
			 ClassesMoney cm=(ClassesMoney)cmm.find(Integer.parseInt(key));
  			
			 mFeeName[mNum]=cm.getClassesMoneyName();
			 mFee[mNum]=Integer.parseInt((String)elements.nextElement()); 
			 mFeeUrl[mNum]=key;	 
			 mNum ++;
		}
 
 			Hashtable reHa=u.get6num(mFee,mFeeName,mFeeUrl);
  			
  			int[] rInt=(int[])reHa.get("a");
  
			titleName="收入統計";
			itemName="項目名稱";
			preUnit="$";
		 
			itemNum =(int[])reHa.get("a");
		   	item =(String[])reHa.get("b");
		   	String[] oUrl=(String[])reHa.get("c");
  			itemUrl =new String[itemNum.length];
		   	for(int io=0;io<itemNum.length;io++)
		   	{  
		   	 	 if(io>=5) 
					itemUrl[io]="classFeeReport.jsp?cmId="+oUrl[io]+"&year="+syear+"&month="+smonth;
				else
					itemUrl[io] ="";
			}
		  %>	
	
	

	
	<%  // include file="henrypie.jsp"%>
	
	
	
<%	

		break; 
	
	case 1: 
		CfDiscount[] cd=ja.getAllCfDiscount(runDate); 
		
		if(cd==null)
		{ 
			out.println("沒有資料");
			return; 
		} 
%>
<font color=blue>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;折扣統計</font><br> 
<blockquote>
	<table width="58%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>折扣項目名稱</tD>
		<td align=right>金額</tD>
		<td align=right>比例</td>
 
 
		<td></td>
	</tr>

<%
		int allTotal2=0;
		Hashtable ha2=new Hashtable();
		for(int i=0;i<cd.length;i++)
	  	{
  			String typeS2=String.valueOf(cd[i].getCfDiscountTypeId());
  			int totalDiscount=cd[i].getCfDiscountNumber();
  		
	  		allTotal2 +=totalDiscount;
	  		if(ha2.get(typeS2)==null)	
	  		{
				ha2.put((String)typeS2,(String)String.valueOf(totalDiscount));	
	  		}else{
	  				
	  			String oldDiscount=(String)ha2.get(typeS2);
	  		  	
	  		  	int nowDiscount=totalDiscount +Integer.parseInt(oldDiscount);
	  		  	ha2.put((String)typeS2,(String)String.valueOf(nowDiscount));
	  		} 
  	}

	Enumeration keys2=ha2.keys();
	Enumeration elements2=ha2.elements();
 
	DiscountTypeMgr dtm=DiscountTypeMgr.getInstance();

	int accountTotal=0;
	while(elements2.hasMoreElements())
	{
		accountTotal++;
		String key=(String)keys2.nextElement();
		String income=(String)elements2.nextElement();

		DiscountType dt=(DiscountType)dtm.find(Integer.parseInt(key));
		int incomeInt=Integer.parseInt(income);
%>
	
	<tr bgcolor=#ffffff class=es02>
		 <td><%=dt.getDiscountTypeName()%></tD>
 		 <td align=right><%=mnf.format(Integer.parseInt(income))%></tD>
		 <td align=right><%=nf.format((float)incomeInt/(float)allTotal2*100)%>%</td>		
		 <td><a href="classFeeReport.jsp?cmId=<% //cm.getId()%>&year=<%=syear%>&month=<%=smonth%>">詳細資料</a>
  	</tr>
<%
	}
%>
   <tr>
	<td>收費合計</tD>
 
	<td align=right><b><%=mnf.format(allTotal2)%></b></tD>
 	<td align=right></tD>
</tr>
</table>

</tD>
</tr>
</table>
<% 

	titleName="折扣統計";
	itemName="折扣名稱";
	preUnit="$"; 
	itemNum =new int[accountTotal];
   	item = new String[accountTotal];
	itemUrl=new String[accountTotal];
			

	Enumeration keys_3=ha2.keys();
	Enumeration elements_3=ha2.elements();
  	int xxItem=0; 
	

	while(elements_3.hasMoreElements())
	{
		String keyX=(String)keys_3.nextElement();
		
		DiscountType dt=(DiscountType)dtm.find(Integer.parseInt(keyX));
		item[xxItem] = dt.getDiscountTypeName(); 
		
		itemNum[xxItem]=Integer.parseInt((String)elements_3.nextElement());
		itemUrl[xxItem]="";
		xxItem ++;
	} 


	reHa=u.get6num(itemNum,item,itemUrl);
	
	itemNum =(int[])reHa.get("a");
   	item =(String[])reHa.get("b");
	itemUrl =(String[])reHa.get("c");

	//out.println("<br><br><b>圖表</b><br>");

%>	
	<% //include file="henrypie.jsp"%>

<% 
		break;
		
	case 2:
%>	
<font color=blue>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;收費分析</font><br> 
<% 
	JsfPay jp=JsfPay.getInstance();
	int[] fee=jp.getFeeticketByDatePlusNum(runDate); 
%>
	
<center> 
    <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr>
 
		<td bgcolor=#f0f0f0  class=es02 align=middle></td>	
		<td bgcolor=#f0f0f0  class=es02 align=middle>應收金額</td>
		<td bgcolor=#f0f0f0  class=es02 align=middle>已收金額:</td>
		<td bgcolor=#f0f0f0  class=es02 align=middle>未收金額:</td>
		<td bgcolor=#f0f0f0  class=es02 align=middle>收款率:</td>
 
		<td bgcolor=#f0f0f0  class=es02 align=middle></td>
	</tr>
	<tr> 
		<td bgcolor=#f0f0f0  class=es02 align=center> 
			<font color=blue>帳單</font>
		</td>
		<td bgcolor=#ffffff  class=es02 align=right>
			<a href=listFeeNumber.jsp?year=<%=syear%>&month=<%=smonth%>&status=0&classesId=999&level=999><%=mnf.format(fee[0])%>(<%=fee[3]%>筆)</a>		
		</td>
		<td bgcolor=#ffffff  class=es02 align=right>
			<%=mnf.format(fee[1])%> (<a href=listFeeNumber.jsp?year=<%=syear%>&month=<%=smonth%>&status=90&classesId=999&level=999><%=fee[4]-fee[6]%>筆已繳清</a>
                <%
                if(fee[6]!=0)
                {
                %>    
                    , <a href=listFeeNumber.jsp?year=<%=syear%>&month=<%=smonth%>&status=2&classesId=999&level=999><%=fee[6]+"筆未繳清"%></a>
                <%
                }
                %>
               )
		</td>
		<td bgcolor=#ffffff  class=es02 align=right>
		<a href=listFeeNumber.jsp?year=<%=syear%>&month=<%=smonth%>&status=1&classesId=999&level=999><%=mnf.format(fee[2])%>(<%=fee[5]%>筆)</a>
		</td>
		<td bgcolor=#ffffff  class=es02 align=right><%=nf.format(((float)fee[1]/(float)fee[0])*100)%>%</td>
		<td bgcolor=#ffffff  class=es02 align=middle> 
		<a href="listFeeNumber.jsp?year=<%=syear%>&month=<%=smonth%>"><img src="pic/list.gif" border=0>詳細名單</a>

		</tD>
	</tr>
	</table>
	</td>
	</tr>
	</table>
    </center>
<%
	PayFee[] pf=jp.getPayFeeByMonth(runDate); 
	
	if(pf==null)
  	{
  		out.println("</blockquote><br><br><font color=red><b>本月尚未有繳款資料</b></font>"); 
  		return;
  	}
	Hashtable ha3=new Hashtable();
	
	int pfTotal=0;
	for(int i=0;i<pf.length;i++)
  	{
  		String sourS=String.valueOf(pf[i].getPayFeeSourceCategory());
  		int thisPay=pf[i].getPayFeeMoneyNumber(); 
  		
  		pfTotal +=thisPay;

  		if(ha3.get(sourS)==null)	
  		{
			ha3.put((String)sourS,(String)String.valueOf(thisPay));	
  		}else{
  		  	String oldPay2=(String)ha3.get(sourS);
  		  	
  		  	int nowPay2=thisPay +Integer.parseInt(oldPay2);
  		  	ha3.put((String)sourS,(String)String.valueOf(nowPay2));
  		} 
  	}

	Enumeration keys3=ha3.keys();
	Enumeration elements3=ha3.elements(); 
	
	String xDateString=sdf2.format(runDate);  
   %> 
    <br>
     <br>
<font color=blue>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;收款方式統計</font><br> 


<center> 
    <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr>
    <td width=50%>

    <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>收款方式</td>
		<tD>金額</td>
		<tD>比例</td>
		<td></td>
	</tr>
 
<%
    String xName="";  
    String xNumber="";
  	int accountTotal3=0;
	while(elements3.hasMoreElements())
	{ 
		 accountTotal3++;
		String key3=(String)keys3.nextElement();
		String income3=(String)elements3.nextElement();
%>
	<tr bgcolor=#ffffff class=es02>
		<td>
		<% 

			int payWayA=Integer.parseInt(key3);

            if(xName.length()>0)
                xName+="|";

            if(xNumber.length()>0)
                xNumber+=",";
			switch(payWayA)
			{ 
				case 1:
                    xName+="ATM";
					out.println("虛擬帳號");	
					break;	
				case 2:
                    xName+="ATM";                    
					out.println("約定帳號");	
					break;				
				case 3:
                    xName+="7-11";     
					out.println("便利商店");	
					break;		
				case 4:
                    xName+="company"; 
					out.println("櫃臺繳款");	
					break;		
			} 

		%></td>
		<tD align=right><%=mnf.format(Integer.parseInt(income3))%></td>
		<td align=right> 
		
	
	<%
            int incomeXX=Integer.parseInt(income3);
            float xpercent=((float)incomeXX/(float)pfTotal)*100;
			out.println(nf.format(xpercent));
            xNumber+=nf2.format(xpercent);
		%> % 
		
		
		</tD>
		<td align=right><a href="listFeePayByMonth.jsp?way=<%=payWayA%>&month=<%=smonth%>&year=<%=syear%>">詳細資料</td>
	</tr>
<%
	}
%> 
<tr>
	<td>合計</tD>
	<td align=right><b><%=mnf.format(pfTotal)%></b></tD> 
	<td></tD>
</tr>
	</table>
	</tD>
	</tr>
	</table> 

    </td>
    <td align=middle>
        <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=xNumber%>&chs=400x100&chl=<%=xName%>">
    </td>
    </tr>
    </table>
    </center>


<% 

	titleName="收費分析";
	itemName="收費方式";
	preUnit="$";
 
	

	Enumeration keys_2=ha3.keys();
	Enumeration elements_2=ha3.elements();
  
   	item = new String[accountTotal3];
	itemNum =new int[accountTotal3];
	itemUrl=new String[accountTotal3];
	int xxItem3=0;

	while(elements_2.hasMoreElements())
	{
		String keyX=(String)keys_2.nextElement();
		
		int payWayAS=Integer.parseInt(keyX);
		switch(payWayAS)
		{ 
			case 1:
				item[xxItem3] ="浮動虛擬帳號";	
				break;	
			case 2:
				item[xxItem3] ="固定虛擬帳號";	
				break;			
			case 3:
				item[xxItem3] ="便利商店";	
				break;	
			case 4:
				item[xxItem3] ="櫃臺繳款";	
				break;		
		} 
	
		itemNum[xxItem3]=Integer.parseInt((String)elements_2.nextElement());
		itemUrl[xxItem3]="";
		xxItem3 ++;
	}
 

	//out.println("<br><br><b>圖表</b><br>");
/*
	if(accountTotal3>6)	
	{
		out.println("沒前不支援超過六項");
	} else{
%>	
	<% //include file="henrypie.jsp"%>

<%
	}

*/
			break; 

		case 3:
%>			
<font color=blue>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;班級效益</font><br> 
<%
	Feeticket[] ticket=ja.getFeeticketByClassLevel(runDate,3,0,999,999);

	if(ticket==null) 
	{ 
		out.println("沒有收款資料");	 
		return;		
	} 

	Hashtable ha4=new Hashtable();
	
	int ftTotal=0;
	for(int i=0;i<ticket.length;i++)
  	{
  		String claS=String.valueOf(ticket[i].getFeeticketStuClassId());
  		int thisPay=ticket[i].getFeeticketTotalMoney(); 
  		
  		ftTotal +=thisPay;

  		if(ha4.get(claS)==null)	
  		{
			ha4.put((String)claS,(String)String.valueOf(thisPay));	
  		}else{
  		  	String oldPay2=(String)ha4.get(claS);
  		  	
  		  	int nowPay2=thisPay +Integer.parseInt(oldPay2);
  		  	ha4.put((String)claS,(String)String.valueOf(nowPay2));
  		} 
  	}

	Enumeration keys4=ha4.keys();
	Enumeration elements4=ha4.elements();
 
%> 
<br>
<br> 
<blockquote>
<table width="75%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>班級</td>
		<tD>學費收入</td>
		<tD>學費比例</td>
		<td>教師薪資明細</td>
		<td>薪資合計</td>
		<td>結餘</td>
		
	</tr>
 <%  
  	SalaryAdmin saAAA=SalaryAdmin.getInstance();
	TeacherMgr tmA=TeacherMgr.getInstance();

  	ClassesMgr cm2=ClassesMgr.getInstance();
  	
  	
  	Vector retFee = new Vector(); 
	Vector retSalary = new Vector(); 
  	Vector retName=new Vector(); 
	
	while(elements4.hasMoreElements())
	{ 
		String key4=(String)keys4.nextElement();
		String income4=(String)elements4.nextElement();

		int totalSalary=0;
%>
	<tr bgcolor=#ffffff class=es02>
		<td>
		<%
			Classes claA=(Classes)cm2.find(Integer.parseInt(key4));
			
			if(claA != null)
			{
				out.println(claA.getClassesName()); 
				retName.add(claA.getClassesName());
			}else{
				out.println("未定");
				retName.add("未定");
			}
					%></td>
		<tD width=100 align=right><%=mnf.format(Integer.parseInt(income4))%></td>
		<tD width=100 align=right> 
		<%
			int income4Int=Integer.parseInt(income4);		
			retFee.add(income4);
			
			out.println(nf.format(((float)income4Int/(float)ftTotal)*100));	
		%> %
		</td> 
		<td align=right>
		<%
			SalaryTicket[] st=saAAA.getSalaryTicketByDatePoCla(runDate,999,claA.getId());
			
			if(st==null) 
			{   
				totalSalary =0;
				out.println("沒有付款資訊");			
			}else{ 
				
				for(int j=0;j<st.length;j++) 
				{
					totalSalary +=st[j].getSalaryTicketTotalMoney();
					  
					Teacher tea=(Teacher)tmA.find(st[j].getSalaryTicketTeacherId()); 
%> 
				 
					<%=tea.getTeacherFirstName()%><%=tea.getTeacherLastName()%>:<%=mnf.format(st[j].getSalaryTicketTotalMoney())%> <br> 
<%									
				} 
			}

		%>
		</tD>
		<td align=right><%=mnf.format(totalSalary)%></td>
		<td align=right><%=mnf.format(income4Int-totalSalary)%></td>
	</tr>
<% 
		retSalary.add(String.valueOf(totalSalary));
	} 

%>
<tr>
	<td>合計</tD>
	<td align=right><b><%=mnf.format(ftTotal)%></b></tD>
 
	<td></tD>
</tr>
	</table>
	</tD>
	</tr>
	</table>
</blockquote>  
<%   
/*
	String feeInt[]=(String[])retFee.toArray(new String[retFee.size()]);         
	String salaryInt[]=(String[])retSalary.toArray(new String[retSalary.size()]);  
	String feeString[]=(String[])retName.toArray(new String[retName.size()]);  	       

*/
%>

<% //include file="henrybar.jsp"%>

<%	
		break;
	}
%>