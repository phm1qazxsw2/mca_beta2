<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,com.lowagie.text.*,com.lowagie.text.pdf.*,java.io.*,java.awt.Color" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    class MyDoc {
        File outdir = null;
        private Document document = null;
        private String fname = null;

        MyDoc(File outdir) throws Exception
        {
            this.outdir = outdir;
            if (!outdir.exists()) {
                throw new Exception(outdir.getAbsolutePath() + " does not exists!");
            }
        }

        String getFilename()
        {
            return fname;
        }

        Document getDocument(boolean inSeparatePage, String prefix)
            throws Exception
        {
            if (document==null) {
                document = new Document(PageSize.A4,15,15,10,10);
                fname = prefix + new Date().getTime() + ".pdf";

                File testout = new File(outdir, fname);
                PdfWriter pdfwriter = PdfWriter.getInstance(document, new FileOutputStream(testout));
                pdfwriter.setViewerPreferences(PdfWriter.PageModeUseOutlines);
                document.open();
                return document;
            }
            if (inSeparatePage) {
                document.close();
                document = null;
                return getDocument(inSeparatePage, prefix);
            }
            else 
                return document;
        }
    }
%>
<%
    //##v2

    String o =  request.getParameter("o");
    String t = request.getParameter("t");
    String str = request.getParameter("freshonly");
    boolean freshonly = (str!=null) && str.equals("true");

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
        " and membrbillrecord.billRecordId in (" + sb2.toString() + ")" +
        " and billType=" + Bill.TYPE_SALARY +
        " and privLevel>=" + ud2.getUserRole();
    if (freshonly) 
        query += " and printDate=0";
    ArrayList<MembrInfoBillRecord> records = 
        snbrmgr.retrieveList(query, "");

    String ticketIds = new RangeMaker().makeRange(records, "getTicketId");    
    ArrayList<ChargeItemMembr> charges = ChargeItemMembrMgr.getInstance().retrieveList
        ("ticketId in (" + ticketIds + ")", "");
    Map<String, Vector<ChargeItemMembr>> chargeMap = new SortingMap(charges).doSort("getTicketId");
    String chargeItemIds = new RangeMaker().makeRange(charges, "getChargeItemId");
    String membrIds = new RangeMaker().makeRange(charges, "getMembrId");
    ArrayList<FeeDetail> fees = FeeDetailMgr.getInstance().retrieveList
        ("chargeItemId in (" + chargeItemIds + ") and membrId in (" + membrIds + ")", "");
    Map<String, Vector<FeeDetail>> feeMap = new SortingMap(fees).doSort("getChargeKey");

    int pWay=0;
    String pwayS=request.getParameter("pWay");

    if(pwayS !=null)
        pWay=Integer.parseInt(pwayS);


    boolean inSeparatePage = false;
    if(pWay ==1)
        inSeparatePage=true;
        

    Document document = null;
    String fname = "";
    Map<String, String> pathMap = null;
    if (inSeparatePage) {
        pathMap = new HashMap<String, String>();
    }

    try {
        File toolDir = new File(request.getRealPath("/") + "/eSystem/pdf_example");
        SalarySlipPrinter p = SalarySlipPrinter.getPdfPrinter(toolDir, chargeMap, feeMap);

        File outdir = new File(request.getRealPath("/"), "pdf_output");
        MyDoc mydoc = new MyDoc(outdir);

        Iterator<MembrInfoBillRecord> iter = records.iterator();
        int i=1;
        while (iter.hasNext()) {
            MembrInfoBillRecord sinfo = iter.next();    
            String remark = null;
            BillComment bc = BillCommentMgr.getInstance().find
                ("membrId=" + sinfo.getMembrId() + " and billRecordId=" + sinfo.getBillRecordId());
            if (bc!=null)
                remark = bc.getComment();
            // p.printSalarySlip(sinfo, document, pdfwriter, i++, chargeMap, feeMap, remark);

            //######### per 戴所長 省紙的 request ##############
            PdfPTable rootTable = new PdfPTable(1);
            PdfPTable ptable = p.printSalarySlipAsPdfTable(sinfo, remark);
            PdfPCell cell = new PdfPCell(ptable);
            cell.setBorderColor(new Color(255, 255, 255));
            rootTable.addCell(cell);

            document = mydoc.getDocument(inSeparatePage, sinfo.getTicketId());
            document.add(new Paragraph("\n"));
            document.add(rootTable);
            //##################################################
            if (inSeparatePage) {
                pathMap.put(sinfo.getTicketId(), mydoc.getFilename());
            }
        }
        fname = mydoc.getFilename();
    }
    catch (Exception e) {
        e.printStackTrace();
        throw e;
    }
    finally {
        if (document!=null)
            document.close();
    }
%>
<body>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;<b>&nbsp;<%=(inSeparatePage)?"<img src=\"pic/email.png\" border=0>&nbsp;Email帳單":"列印薪資條"%></b>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onClick="history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上一頁</a>
</div>
<%
    if(inSeparatePage){
%>

<div class=es02 align=right> 
<a href="modifyEmailSalary.jsp" target="_blank">編輯Email內容</a>
&nbsp;&nbsp;&nbsp;
</div>

<%  }   %>
 <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<%
    if(!inSeparatePage){
%>
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
                <input type=submit value="下載PDF">
                </form>
            
                <br>
                <div class=es02><b>薪資條下載資訊:</b></div>
                <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                        <td>狀態</td>
                        <tD bgcolor=ffffff>
                            已產生薪資條,<a href="../pdf_output/<%=fname%>"><font color=blue>可下載</font></a>.
                        </tD>
                        </tr>

                        <tr bgcolor=#f0f0f0 class=es02>
                        <td>注意事項</td>
                        <tD bgcolor=ffffff>
                            <br>
                            <b>1.&nbsp;請確認你已安裝 Adobe Reader.</b><br>

                                &nbsp;&nbsp;&nbsp;如尚未安裝,請連至<a href="http://www.adobe.com/tw/products/acrobat/readstep2.html" target="_blank">Adobe 官方網站</a><a href="http://www.adobe.com/tw/products/acrobat/readstep2.html" target="_blank"><img src="pic/reader_icon_special.jpg" border=0 width=50></a>下載Adobe Reader.
                            <br><br><br> 
                        </tD>
                        </tr>
                    </table>
                </td>
                </tr>
                </table>
        </td>
        </tr>
    </table>      
<br>
<br>
<%
    }else{  
%>
<br>
<center>

    <form action="email_Salary.jsp" method="post">
    <input type=submit value="確認發送">
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>

<%
    ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + sb1.toString() + ")", "");
    String studentIds = new RangeMaker().makeRange(membrs, "getSurrogateId");
    ArrayList<Teacher2> teachers = Teacher2Mgr.getInstance().retrieveList("id in (" + studentIds + ")", "");
    Map<Integer, Teacher2> teaMap = new SortingMap(teachers).doSortSingleton("getId");
    Map<Integer, Vector<MembrInfoBillRecord>> billMap = new SortingMap(records).doSort("getMembrId");

    JsfPay jp=JsfPay.getInstance();
    JsfAdmin ja=JsfAdmin.getInstance();    


    for (int i=0; i<membrs.size(); i++) {
        Membr membr = membrs.get(i);
        Teacher2 tea = teaMap.get(new Integer(membr.getSurrogateId()));
        Vector<MembrInfoBillRecord> billv = billMap.get(new Integer(membr.getId()));
%>
        <tr bgcolor=ffffff class=es02>
            <td>
            <a href="javascript:openwindow_phm('modifyTeacher.jsp?teacherId=<%=tea.getId()%>','教職員基本資料',800,550,true);"><%=membr.getName()%></a>
            </td>
            <td>
            <%
            String mName=tea.getTeacherFirstName()+tea.getTeacherLastName();
            String mNumber=tea.getTeacherEmail();
            %>
            <%=mName%><input type=checkbox name="list" value="<%=tea.getId()%>##<%=mNumber%>"           
            <%=(jp.checkEmail(mNumber))?"checked":"disabled"%> ><%=(jp.checkEmail(mNumber))?mNumber:"無效Email"%><br>
<%
        StringBuffer sbx=new StringBuffer();
        for (int j=0; j<billv.size(); j++) {
            String tid = billv.get(j).getTicketId();
            if(j !=0 || j!=(billv.size()-1))
                sbx.append("##");
            sbx.append(pathMap.get(tid));
        }
%>
            <input type=hidden name="bill<%=tea.getId()%>" value="<%=sbx.toString()%>">
            </td>
        </tr>                        
<%
    }
%>
    </table>
    </td>
    </tr>
    </table>
    </form>


<%  }   %>

</body>
