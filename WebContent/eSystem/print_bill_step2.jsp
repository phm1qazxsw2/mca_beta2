<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.*,java.io.*,mca.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }

    //##v2
    String o =  request.getParameter("o");
    String t = request.getParameter("t");
    String str = request.getParameter("freshonly");
    boolean freshonly = (str!=null) && str.equals("true");

    BillRecordMgr bmgr = BillRecordMgr.getInstance();
    ChargeItemMembrMgr cismgr = ChargeItemMembrMgr.getInstance();
    PaySystem2 pSystem= PaySystem2Mgr.getInstance().find("id=1");

    String[] pairs = o.split(",");
    HashMap m1 = new HashMap();
    HashMap m2 = new HashMap();
    StringBuffer sb1 = new StringBuffer();
    StringBuffer sb2 = new StringBuffer();
    for (int i=0; i<pairs.length; i++) {
        String[] tokens = pairs[i].split("#");
        if (m1.get(tokens[0])==null) {
            if (sb1.length()>0) sb1.append(",");
            sb1.append(tokens[0]);
            m1.put(tokens[0], "");
        }
        if (m2.get(tokens[1])==null) {
            if (sb2.length()>0) sb2.append(",");
            sb2.append(tokens[1]);
            m2.put(tokens[1], "");
        }
    }
    MembrInfoBillRecordMgr snbrmgr = MembrInfoBillRecordMgr.getInstance();
    String query = "membrbillrecord.membrId in (" + sb1.toString() + ")" + 
        " and membrbillrecord.billRecordId in (" + sb2.toString() + ") and paidStatus in (0,1)" +
        " and receivable>0";
    if (freshonly) 
        query += " and printDate=0 and billType=" + Bill.TYPE_BILLING;
    ArrayList<MembrInfoBillRecord> records = 
        snbrmgr.retrieveList(query, "order by membr.name asc");

    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.genVoucherForBills(records, ud2.getId(), "發佈");
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("a")) 
            {}
        else 
            throw e;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    } 

    String billRecordIds = new RangeMaker().makeRange(records, "getBillRecordId");
    String ticketIds = new RangeMaker().makeRange(records, "getTicketId");    
    ArrayList<ChargeItemMembr> charges = ChargeItemMembrMgr.getInstance().retrieveList
        ("ticketId in (" + ticketIds + ")", "order by pos asc");
    //charges = new SortingMap(charges).descendingBy("getMyAmount");
    Map<String, ArrayList<ChargeItemMembr>> chargeMap = new SortingMap(charges).doSortA("getTicketId");
    String chargeItemIds = new RangeMaker().makeRange(charges, "getChargeItemId");
    String membrIds = new RangeMaker().makeRange(charges, "getMembrId");
    ArrayList<Discount> discounts = DiscountMgr.getInstance().retrieveList
        ("chargeItemId in (" + chargeItemIds + ") and membrId in (" + membrIds + ")", "");
    Map<String, ArrayList<Discount>> discountMap = new SortingMap(discounts).doSortA("getChargeKey");
    ArrayList<BillComment> comments = BillCommentMgr.getInstance().retrieveList
        ("membrId in (" + membrIds + ") and billRecordId in (" + billRecordIds + ")", "");
    Map<String, ArrayList<BillComment>> commentMap = new SortingMap(comments).doSortA("getBillKey");
    BillRecord br = BillRecordMgr.getInstance().find("id=" + records.get(0).getBillRecordId());
    ArrayList<FeeDetail> fees = FeeDetailMgr.getInstance().retrieveList
        ("chargeItemId in (" + chargeItemIds + ") and membrId in (" + membrIds + ")", "");

    //####### 2009/1/20 by peter
    boolean outsourcing = (pd2.getWorkflow()==2);
    FeeDetailHandler fdh = new FeeDetailHandler(fees, outsourcing);
    fdh.prepareNotes();
    //####### 

    Map<String, ArrayList<FeeDetail>> feeMap = new SortingMap(fees).doSortA("getChargeKey");
    String billIds = new RangeMaker().makeRange(records, "getBillId");
    // ArrayList<MembrInfoBillRecord> all_unpaid = snbrmgr.retrieveList
    //    ("bill.id in (" + billIds + ") and paidStatus in (0,1)", "");

    ArrayList<MembrInfoBillRecord> all_unpaid = snbrmgr.retrieveListX
        ("paidStatus in (0,1)", "", _ws2.getAcrossBillBunitSpace("bill.bunitId"));
        // 要能印 cover 單位的帳單 
                                     // 把所有的 unpaid 都找來，在 printPayment 里會分
                                     // 同 type 的算在 unpaidTotal 里，不同 type 的放在 remark 里
                                     // ** 這是因臺北劍聲註冊費月費問題討論的結果
      
    //Map<String/*membrId#billId*/, ArrayList<MembrInfoBillRecord>> unpaidMap = 
    //    new SortingMap(all_unpaid).doSortA("getMembrBillKey");

    Map<String/*membrId#billId*/, ArrayList<MembrInfoBillRecord>> unpaidMap = 
        new SortingMap(all_unpaid).doSortA("getMembrId"); // 去掉 BillId 在 paymentprinter 內判斷, 和賬單同BillId
                                                   // 會算在 unpaidTotal, 不同的會放在 remark 內

    Iterator<MembrInfoBillRecord> iter = records.iterator();

    PaymentPrinter p = null;

    boolean useEmail = false;
    Map<String, String> pathMap = null;
    try {
        File testsample_atm = new File(request.getRealPath("/") + "/WEB-INF/tmp/testftp.txt");
        File testsample_store = new File(request.getRealPath("/") + "/WEB-INF/tmp/teststore.txt");

        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        SimpleDateFormat sdf2 = new SimpleDateFormat("HHmmss");
        SimpleDateFormat sdf3 = new SimpleDateFormat("yyMM");

        DecimalFormat mnf = new DecimalFormat("##########0");
        PrintWriter atm_pr = new PrintWriter(new OutputStreamWriter(new FileOutputStream(testsample_atm)));
        PrintWriter store_pr = new PrintWriter(new OutputStreamWriter(new FileOutputStream(testsample_store)));
        String atm_line = "000020680100028306tttttttt00000#AmmmmmmATM  ddddddddddd+C95481kkkkkkkkkkk          013                    101937            W";
        String store_line = "eeeeeeeeuuuuuuuuyyyyyyyyyyyyyyyyooooooooopppp7111111 20680100028306";

        // PaymentPrinter p = PaymentPrinter.getPdfPrinter(toolDir,
        //    br, chargeMap, discountMap, commentMap, feeMap, unpaidMap, document, pdfwriter);

        boolean inSeparatePage = false;
        try { inSeparatePage = request.getParameter("way").equals("email"); } catch (Exception e) {}
        if (inSeparatePage) {
            useEmail = true;
            pathMap = new HashMap<String, String>();
        }

        Bunit bunit = _ws2.getSessionBunit();
System.out.println("## bunit=" + bunit + " " + _ws2.getSessionBunitId() + " " + pSystem.getPagetype());
        p = PaymentPrinter.getPdfPrinter(br, chargeMap, discountMap, commentMap, feeMap, unpaidMap, 
            pSystem, bunit, inSeparatePage, request.getRealPath("/"));

        if (pSystem.getPagetype()==7) { // 馬禮遜
            McaRecord mr = McaRecordInfoMgr.getInstance().find("billRecordId=" + 
                records.get(0).getBillRecordId() + " and mca_fee.status!=-1");
            McaFee fee = McaFeeMgr.getInstance().find("id=" + mr.getMcaFeeId());
            p.setupMcaStudent(fee, records);
        }

        int i = 1;
        if(pSystem.getPagetype()==5){
            
            MembrInfoBillRecord[] sinfoA=new MembrInfoBillRecord[3];
            int j=0;
            int totalX=0;
            while (iter.hasNext()) {
                MembrInfoBillRecord sinfo = iter.next();
                /*
                //####### 以下測試
                String amountstr = mnf.format(sinfo.getReceivable()*10);
                String ftp_line = atm_line.replace("tttttttt", sdf.format(new Date()));
                ftp_line = ftp_line.replace("#", i+"");
                ftp_line = ftp_line.replace("mmmmmm", sdf2.format(new Date()));
                ftp_line = ftp_line.replace("ddddddddddd", p.makePrecise(amountstr,11,true,' '));
                String fixacct = "8888" + p.makePrecise(sinfo.getMembrId()+"",4,false,'0');
                String chsum = p.getChecksumTaiXin(pSystem.getPaySystemFirst5() + fixacct);
                String str_11char = p.makePrecise(fixacct+chsum, 11, true, '0');
                ftp_line = ftp_line.replace("kkkkkkkkkkk", str_11char);
                atm_pr.println(ftp_line);    
                
                ftp_line = store_line.replace("eeeeeeee", sdf.format(new Date()));
                ftp_line = ftp_line.replace("uuuuuuuu", sdf.format(new Date()));
                ftp_line = ftp_line.replace("yyyyyyyyyyyyyyyy", "JSM00000" + sinfo.getTicketId());
                amountstr = mnf.format(sinfo.getReceivable());
                ftp_line = ftp_line.replace("ooooooooo", p.makePrecise(amountstr,9,false,'0'));
                Date m = p.convertToTaiwanDate(sinfo.getBillMonth());
                ftp_line = ftp_line.replace("pppp", sdf3.format(m));
                store_pr.println(ftp_line);
                */
                sinfoA[j]=sinfo;
                j++;
                i++;
                totalX++;
                if(j==3){
                    j=0;
                    p.printPaymentType5(sinfoA,i,records.size());                    
                }else{
                    if(totalX==records.size()){
                        if(j==2){
                            sinfoA[2]=null;
                        }if(j==1){
                            sinfoA[1]=null;
                            sinfoA[2]=null;
                        }
                        p.printPaymentType5(sinfoA,i,records.size());
                    }
                }

                
                if (inSeparatePage) {
                    pathMap.put(sinfo.getTicketId(), p.getOutputFileName());
                }
            }
        }else{
            EzCountingService ezsvc = EzCountingService.getInstance();
            while (iter.hasNext()) {
                MembrInfoBillRecord sinfo = iter.next();
                /*
                //####### 以下測試
                String amountstr = mnf.format(sinfo.getReceivable()*10);
                String ftp_line = atm_line.replace("tttttttt", sdf.format(new Date()));
                ftp_line = ftp_line.replace("#", i+"");
                ftp_line = ftp_line.replace("mmmmmm", sdf2.format(new Date()));
                ftp_line = ftp_line.replace("ddddddddddd", p.makePrecise(amountstr,11,true,' '));
                String fixacct = "8888" + p.makePrecise(sinfo.getMembrId()+"",4,false,'0');
                String chsum = p.getChecksumTaiXin(pSystem.getPaySystemFirst5() + fixacct);
                String str_11char = p.makePrecise(fixacct+chsum, 11, true, '0');
                ftp_line = ftp_line.replace("kkkkkkkkkkk", str_11char);
                atm_pr.println(ftp_line);    
                
                ftp_line = store_line.replace("eeeeeeee", sdf.format(new Date()));
                ftp_line = ftp_line.replace("uuuuuuuu", sdf.format(new Date()));
                ftp_line = ftp_line.replace("yyyyyyyyyyyyyyyy", "JSM00000" + sinfo.getTicketId());
                amountstr = mnf.format(sinfo.getReceivable());
                ftp_line = ftp_line.replace("ooooooooo", p.makePrecise(amountstr,9,false,'0'));
                Date m = p.convertToTaiwanDate(sinfo.getBillMonth());
                ftp_line = ftp_line.replace("pppp", sdf3.format(m));
                store_pr.println(ftp_line);
                */
                p.printPayment(sinfo, i++ ,records.size(), ezsvc.getUserName(ud2.getId()));
                if (inSeparatePage) {
                    pathMap.put(sinfo.getTicketId(), p.getOutputFileName());
                }
            }
        }
        atm_pr.close();
        store_pr.close();
    }
    catch (Exception e) {
        e.printStackTrace();
        throw e;
    }
    finally {
        if (p!=null) 
            p.close();
    }
%>
<body>
<% if (useEmail) {  %>

<div class=es02>
&nbsp;&nbsp;&nbsp;<b><img src="pic/email.png" border=0>&nbsp;Email帳單</b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onClick="history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上一頁</a>

</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<%
	PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem eXX=(PaySystem)em.find(1);
%>
<br>
<center>
    <form action="email_Bill.jsp" method="post">
    <input type=submit value="確認發送" onClick="return confirm('確認發送?')">
<br>
<br>
<table border=0 width="95%">
    <tr>
        <td width="50%" align=left class=es02>
            <b>Email 名單</b>
        </td>
        <td align=left class=es02>
            <b>Email 內容</b>
        </td>
    </tr>
    <tr>
        <td width="50%" valign=top class=es02>

<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr class=es02 bgcolor="f0f0f0">
            <td><%=(eXX.getCustomerType()==0)?"學生姓名":"客戶名稱"%></td>
            <td>Email 帳單</tD>
        </tr>
<%
    ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + sb1.toString() + ")", "order by name asc");
    String studentIds = new RangeMaker().makeRange(membrs, "getSurrogateId");
    ArrayList<Student2> students = Student2Mgr.getInstance().retrieveList("id in (" + studentIds + ")", "");
    Map<Integer, Student2> studentMap = new SortingMap(students).doSortSingleton("getId");
    Map<Integer, ArrayList<MembrInfoBillRecord>> billMap = new SortingMap(records).doSortA("getMembrId");

    JsfPay jp=JsfPay.getInstance();
    JsfAdmin ja=JsfAdmin.getInstance();    


    for (int i=0; i<membrs.size(); i++) {
        Membr membr = membrs.get(i);
        Student2 stu = studentMap.get(new Integer(membr.getSurrogateId()));
        ArrayList<MembrInfoBillRecord> billv = billMap.get(new Integer(membr.getId()));
%>
        <tr bgcolor=ffffff class=es02>
            <td>
            <%=membr.getName()%>
            </td>
            <td>
<%
    if(pSystem.getPaySystemNoticeEmailTo()==0){

                String mNumber="";
                String sendname="";
                switch(stu.getStudentEmailDefault())
                {
                    case 0:
                        Contact[] cons=ja.getAllContact(stu.getId());
            
                        if(cons !=null)
                        {
                            int raId=cons[0].getContactReleationId();
                            RelationMgr rm=RelationMgr.getInstance();
                            Relation ra=(Relation)rm.find(raId);
                            sendname=ra.getRelationName()+": "; //+":"+cons[0].getContactName();
                            mNumber=cons[0].getContactPhone2();
                        }
                        break;
                    case 1:

                        if(pSystem.getCustomerType()==0)
                            sendname="父: "; //+stu.getStudentFather();                        				
                        else
                            sendname="負責人: "; //+stu.getStudentFather();                        				
                        mNumber=stu.getStudentFatherEmail();
                        break;
                    case 2:
                        if(pSystem.getCustomerType()==0)
                            sendname="母: ";//+stu.getStudentMother(); 
                        else                       				
                            sendname="聯絡人: ";//+stu.getStudentMother(); 
                        mNumber=stu.getStudentMotherEmail();
                        break;	
                }    
%>
        <%=sendname%><input type=checkbox name="list" value="<%=stu.getId()%>##<%=mNumber%>" <%=(jp.checkEmail(mNumber))?"checked":"disabled"%> ><%=(jp.checkEmail(mNumber))?mNumber:"無效Email"%><br>
<%
    }else{
%>
       <%=(pSystem.getCustomerType()==0)?"父":"負責人"%>:<input type=checkbox name="list" value="<%=stu.getId()%>##<%=stu.getStudentFatherEmail()%>" <%=(jp.checkEmail(stu.getStudentFatherEmail()))?"checked":"disabled"%> ><%=stu.getStudentFather()%>: <%=(jp.checkEmail(stu.getStudentFatherEmail()))?stu.getStudentFatherEmail():"無效Email"%><br>
       <%=(pSystem.getCustomerType()==0)?"母":"聯絡人"%>:<input type=checkbox name="list" value="<%=stu.getId()%>##<%=stu.getStudentMotherEmail()%>" <%=(jp.checkEmail(stu.getStudentMotherEmail()))?"checked":"disabled"%> ><%=stu.getStudentMother()%>:<%=(jp.checkEmail(stu.getStudentMotherEmail()))?stu.getStudentMotherEmail():"無效Email"%>

<%
    }
        if (billv==null)
            continue;
        StringBuffer sbx=new StringBuffer();
        for (int j=0; j<billv.size(); j++) {
            String tid = billv.get(j).getTicketId();
            if(j !=0 || j!=(billv.size()-1))
                sbx.append("##");
            sbx.append(pathMap.get(tid));
        }
%>
            <input type=hidden name="bill<%=stu.getId()%>" value="<%=sbx.toString()%>">
            </td>
        </tr>                        
<%
    }
%>

    </table>
    </td>
 </form>
    </tr>
    </table>

    </td>
    <td valign=top align=left>

        <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
        <tr align=left valign=top>
        <td bgcolor="#e9e3de">
            <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr class=es02 bgcolor="#f0f0f0">
                    <td>標題</td>    
                    <td bgcolor="ffffff"><%=eXX.getPaySystemNoticeEmailTitle()%></td>
                </tr>
                <tr class=es02 bgcolor="#f0f0f0">
                    <td>內容</td>    
                    <td bgcolor="ffffff"><%=eXX.getPaySystemNoticeEmailText().replace("\n","<br>")%></td>
                </tr>
                <tr class=es02 bgcolor="#ffffff">
                    <td colspan=2 align=middle>
                        <a href="#" onClick="openwindow_phm('email_bill_notice.jsp?pagex=1','設定帳單email樣本',750,600,true);"><img src="pic/fix.gif" border=0>修改email樣本</a>
                    </td>
                </tr>
            </table>
        </td>
        </tr>
        </table>    
    </td>
</tr>
</table>

<%
        
} else { 
    String fname = p.getOutputFileName();
%>

<div class=es02>
&nbsp;&nbsp;&nbsp;<b>
<%=(t!=null)?t:""%>-列印(下載PDF檔)</b>
<a href="javascript:history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上一頁 </a> 
</div>

 <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
    <table width=100%>
        <tr>
            <td width=350 align=middle valign=top class=es02>
                <br>
                <br>
                <br>
                <img src="pic/printShow.png" border=0><br><br>
            </td>
            <td valign=top>
                <form action="../pdf_output/<%=fname%>">
                <input type=submit value="3 下載PDF">
                </form>
            
                <br>
                <div class=es02><b>帳單下載資訊:</b></div>
                <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                        <td>狀態</td>
                        <tD bgcolor=ffffff>
                            已產生帳單,<a target="_blank" href="../pdf_output/<%=fname%>"><font color=blue>可下載</font></a>.
                        </tD>
                        </tr>

                        <tr bgcolor=#f0f0f0 class=es02>
                        <td>注意事項</td>
                        <tD bgcolor=ffffff>
                            <br>
                            <b>1.&nbsp;請確認你已安裝 Adobe Reader.</b><br>

                                &nbsp;&nbsp;&nbsp;如尚未安裝,請連至<a href="http://www.adobe.com/tw/products/acrobat/readstep2.html" target="_blank">Adobe 官方網站</a><a href="http://www.adobe.com/tw/products/acrobat/readstep2.html" target="_blank"><img src="pic/reader_icon_special.jpg" border=0 width=50></a>下載Adobe Reader.

                            <br><br><br>
                            <b>2.&nbsp;本批帳單已被鎖定<img src="pic/lockno2.png" border=0>.</b><br><br>
                            
                                &nbsp;&nbsp;&nbsp;為了確保你所發佈的帳單與系統的資料同步,系統已將此批帳單鎖定.
                                <br><br>
                                &nbsp;&nbsp;&nbsp;被鎖定的帳單將無法被編輯,如需修改,可經由帳單的主頁將鎖定解除.
                        </tD>
                        </tr>
                    </table>
                </td>
                </tr>
                </table>
        </td>
        </tr>
    </table>      
<% } %>