<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int pid = Integer.parseInt(request.getParameter("pid"));
    String payDate=request.getParameter("payDate").trim();
    String nowTotalString=request.getParameter("nowTotal").trim();
    String totalNum=request.getParameter("nowRun").trim();

    BillPayInfo bpay = BillPayInfoMgr.getInstance().find("billpay.id=" + pid);
    ArrayList<BillPaidInfo> paid_entries = 
        BillPaidInfoMgr.getInstance().retrieveList("billpay.id=" + pid, "");

    String ticketIds = new RangeMaker().makeRange(paid_entries, "getTicketId");

    ArrayList<MembrInfoBillRecord> salaries = 
        MembrInfoBillRecordMgr.getInstance().retrieveList("ticketId in (" + ticketIds + ")", "");

    Map<String, Vector<MembrInfoBillRecord>> salaryMap = 
        new SortingMap(salaries).doSort("getTicketId");

    String membrIds = new RangeMaker().makeRange(salaries, "getMembrId");

    ArrayList<MembrTeacher> teachers = MembrTeacherMgr.getInstance().retrieveList("membr.id in (" + membrIds + ")", "");
    Map<Integer/*membrId*/, Vector<MembrTeacher>> teacherMap = new SortingMap(teachers).doSort("getMembrId");

    Iterator<BillPaidInfo> iter = paid_entries.iterator();

    BankAccount ba=null;
    String acctName = "";
    Costpay2 cp = Costpay2Mgr.getInstance().find("costpayFeePayFeeID=" + Costpay2.COSPAY_TYPE_SALARY + 
        " and costpayStudentAccountId=" + bpay.getId());
    if (bpay.getVia()==BillPay.SALARY_CASH) {
        Tradeaccount ta = (Tradeaccount) ObjectService.find("jsf.Tradeaccount", "id=" + cp.getCostpayAccountId());
        acctName = ta.getTradeaccountName();
    }
    else if (bpay.getVia()==BillPay.SALARY_WIRE) {
        ba= (BankAccount) ObjectService.find("jsf.BankAccount", "id=" + cp.getCostpayAccountId());
        acctName = ba.getBankAccountName();
    }

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    int total = (int)0;
    
    StringBuffer sbuffer=new StringBuffer();

    if(ba.getBankAccount2client().length() !=4)
    { 
        //out.println("台新企業代碼應為4碼");
        //out.println("<br><br>目前企業代碼為:"+ba.getBankAccount2client()); 
        return; // "1xxx台新企業代碼應為4碼<br><br>目前企業代碼為:"+ba.getBankAccount2client();		 
    }

    sbuffer.append(ba.getBankAccount2client());
       //4 bytes 企業編號
    String account=String.valueOf(ba.getBankAccountAccount());	 
     
    
    if(account.length()!=14)
    { 
        //out.println("台新銀行帳戶應為14碼"); 
        //out.println("<br><br>目前台新銀行帳戶為:"+ba.getBankAccountAccount()); 
        return; // "1xxx台新銀行帳戶應為14碼<br><br>目前台新銀行帳戶為:"+ba.getBankAccountAccount();		 
    } 
    sbuffer.append(ba.getBankAccountAccount());  //14 bytes 台新銀行帳戶 
    
    String[] paydateS=payDate.split("-");
    String outpaydate="";

    if(paydateS[0].length()==2)
        outpaydate="00";
    outpaydate+=paydateS[0];

    if(paydateS[1].length()<=1)
        outpaydate="0";
    
    outpaydate+=paydateS[1];
    
    if(paydateS[2].length()<=1)
        outpaydate="0";
    outpaydate+=paydateS[2];

    if(outpaydate.length()!=8)
    {
        out.println("<div class=es02><font color=red>Error:</font>匯款日期有誤.");
        return;
    }
        
    sbuffer.append(outpaydate);
    sbuffer.append("900");
    
    String totalX2=nowTotalString+"00";
	int totalLenth=13-totalX2.length();
    for(int k=0;k<totalLenth;k++)
        totalX2="0"+ totalX2;

    sbuffer.append(totalX2);

    int needNum=7-totalNum.length(); 

    for(int l=0;l<needNum;l++)
        totalNum="0"+totalNum;

    sbuffer.append(totalNum);
    String returnSpace="";
    for(int p=0;p<22;p++)     
        returnSpace+=" ";	
        
    returnSpace+="0\n";
    sbuffer.append(returnSpace);		    

    int nowtotal=0;
    int nowRun=0;
    int sub_total=0;
    while(iter.hasNext()) {
        BillPaidInfo b = iter.next(); 

        sub_total -= b.getPaidAmount();

        nowtotal+=b.getPaidAmount();

        MembrInfoBillRecord s = salaryMap.get(b.getTicketId()).get(0);
        
        Vector<MembrTeacher> vt = teacherMap.get(new Integer(s.getMembrId()));
        MembrTeacher t = vt.get(0);

        String salaryReason = null;
        if(t.getTeacherIdNumber() ==null ||t.getTeacherIdNumber().length()<10)    
            salaryReason="身份証字號不完整";
        else if(t.getTeacherBank1() ==null ||t.getTeacherBank1().length()<3)
            salaryReason="匯款銀行代號有誤";
        else if(t.getTeacherAccountNumber1() ==null ||t.getTeacherAccountNumber1().length()<3)
            salaryReason="匯款帳號有誤";
        if (salaryReason!=null) {
            salaryReason = t.getName() + " " + salaryReason + ", 請先至基本資料處填妥再回來輸出";
          %><script>alert('<%=phm.util.TextUtil.escapeJSString(salaryReason)%>');histor.go(-1);</script><%
            return;
        }
        
        // 
        sbuffer.append(ba.getBankAccount2client());
        
        int aDefault=t.getTeacherAccountDefaut();
        String accoutnNum="";

        if(aDefault==1)	
            accoutnNum=t.getTeacherAccountNumber1();
        else
            accoutnNum=t.getTeacherAccountNumber2();		

        int aLen=14-accoutnNum.length();

        String ox="";
        if(aLen!=0)	
        {	
            for(int sz=0;sz<aLen;sz++)
                ox +="0";
        }		
        sbuffer.append(ox);	
        sbuffer.append(accoutnNum);	

        String idNumber=t.getTeacherIdNumber().toUpperCase(); 	
	    sbuffer.append(idNumber);	
        
        String totalPay =String.valueOf(b.getPaidAmount())+"00";
			
        int payLen=13-totalPay.length();
        
        for(int payI=0;payI<payLen;payI++)
        {
                totalPay="0"+totalPay ;
        }	
        sbuffer.append(totalPay);			
        sbuffer.append("900");
			
        String blankString="";
        for(int bI=0;bI<4;bI++)
        {
            blankString+=" ";	
        }
        sbuffer.append(blankString);

        String outPs=sdf2.format(s.getBillMonth());

        if(outPs.length()>23)
            outPs=outPs.substring(0,23);

        int blankStirngLength=23-outPs.length();
        String blankString2="";
        for(int Xb=0;Xb<blankStirngLength;Xb++)
        {
            blankString2+=" ";	
        }					
        sbuffer.append(outPs);	
        sbuffer.append(blankString2);			
        
        sbuffer.append("0");	
        sbuffer.append("\n"); 

    }

    Date rightnow=new Date();
    long xnow=rightnow.getTime();

    String filename=String.valueOf(xnow);

try{
	String filePath = request.getRealPath("/")+"eSystem/salaryOut/"+filename+".txt"; 
	
	File txtFile=new File(filePath);
 
	
	if(!txtFile.exists()) 
	{
		txtFile.createNewFile(); 
	}
	
	BufferedWriter fout=new BufferedWriter(new FileWriter(filePath,false));
						
	fout.write(sbuffer.toString());
 
	fout.close();
	
}catch(Exception e)	{

	out.println(e.getMessage());
} 

%>
 

<br>
<br>

<blockquote>

<div class=es02>    
檔案已產生!<br><br>


<font size=2 color=red>注意:</font>此為機密資訊,下載後請妥善保存.
<br>
<br>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

		<table width="100%" border=0 cellpadding=4 cellspacing=1>
			<tr bgcolor="ffffff" class=es02>
                <td bgcolor="#f0f0f0">下載注意</td>
                <td>1. 請關閉瀏覽器的攔截視窗.<BR>
                    2. 跳出視窗後,在瀏覽器的功能列,使用<font color=blue>網頁</font> -> <font color=blue>另存新檔</font> 下載.    
            </td>
            </tr>
            <tr bgcolor=ffffff>
                <td colspan=2 align=middle>
                    <a href="salaryOut/<%=filename%>.txt" target="_blank">下載檔案</a>
                </td>
            </tr>
        </table>
        </tD>
        </tr>
        </table>
</div>
</blockquote>