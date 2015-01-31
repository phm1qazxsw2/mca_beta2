<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,mca.*,java.io.*" contentType="text/html;charset=Big5"%><%!
    String convertFull20(String asciiStr, Map<Character, Character> charMap) {
        StringBuffer sb = new StringBuffer();
        int count = 0;
        for (int i=0; i<asciiStr.length() && count<10; i++) {
            char c = asciiStr.charAt(i);
            Character cc = charMap.get(c);
            if (cc!=null) {
                sb.append(cc.charValue());
                count ++;
            }
        }
        for (int i=count; i<10; i++) {
            sb.append(charMap.get(' '));
        }
        return sb.toString();
    }
%><%
    response.setCharacterEncoding("Big5");
    BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream("ascii2big5.txt"), "Big5"));
    String line = br.readLine();
    Map<Character, Character> charMap = new HashMap<Character, Character>();
    for (int i=0; i<line.length(); i+=2) {
        charMap.put(line.charAt(i), line.charAt(i+1));
    }
    WebSecurity _ws2 = WebSecurity.getInstance(pageContext);
    /*
    int brId = Integer.parseInt(request.getParameter("brId"));
    ArrayList<MembrInfoBillRecord> bills = MembrInfoBillRecordMgr.getInstance().
        retrieveListX("billRecordId=" + brId + " and (receivable-received)>0",
            "", _ws2.getBunitSpace("bill.bunitId"));
    ArrayList<McaFeeRecord> mrs = McaFeeRecordMgr.getInstance().retrieveList
        ("billRecordId=" + brId, "order by mca_fee.id desc");
    McaFee fee = McaFeeMgr.getInstance().find("id=" + mrs.get(0).getFeeId());
    */
    McaFee fee = McaFeeMgr.getInstance().find("id=" + Integer.parseInt(request.getParameter("feeId")));
    ArrayList<McaFeeRecord> mrs = McaFeeRecordMgr.getInstance().retrieveList
        ("mca_fee.id=" + fee.getId(), "order by mca_fee.id desc");
    String brIds = "";
    for (int i=0; i<mrs.size(); i++) {
        if (brIds.length()>0)
            brIds += ",";
        brIds += mrs.get(i).getId();
    }
    ArrayList<MembrInfoBillRecord> bills = MembrInfoBillRecordMgr.getInstance().
        retrieveListX("billRecordId in (" + brIds + ") and (receivable-received)>0","", _ws2.getBunitSpace("bill.bunitId"));
    Map<Integer, McaStudent> mcastudentMap = new SortingMap(McaStudentMgr.getInstance().
        retrieveList("", "")).doSortSingleton("getMembrId");
   
//合庫企業識別碼	    Χ(６)	合庫企業識別碼，左靠右補空白
//繳款帳號(銷帳編號)	Χ(１６)	左靠右補空白
//學生姓名	            Χ(２０)	左靠右補空白
//繳款起日	            Χ(８)	ＹＹＹＹＭＭＤＤ：西元年
//繳款迄日	            Χ(８)	ＹＹＹＹＭＭＤＤ：西元年
//繳費金額	           ９(７)	右靠左補零
// sample 1853021853021103104

    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    Date today = new Date();
    StringBuffer sb = new StringBuffer();
    for (int i=0; i<bills.size(); i++) {
        MembrInfoBillRecord bill = bills.get(i);
        sb.append(bill.getRegInfo()); // 6
        // sb.append(PaymentPrinter.makePrecise(bill.getTicketId(), 9, false, '0'));  // 9
        sb.append(bill.getRegInfo());
        sb.append('1');  // 1
        sb.append(fee.getFeeType()); // 1
        McaStudent ms = mcastudentMap.get(bill.getMembrId());
        sb.append(PaymentPrinter.makePrecise(ms.getStudentID()+"", 5, false, '0'));  // 5
        sb.append("   "); // 补三个空白
        String student_name = ms.getStudentSurname() + "," + ms.getStudentFirstName();
        sb.append(convertFull20(student_name, charMap));
        // sb.append(PaymentPrinter.makePrecise(student_name, 20, true, '　'));  // 20
        //if (bill.getMyBillDate().compareTo(today)<0) {
        //    out.println("<script>alert('帳單["+bill.getTicketId()+"]缴费期限已過，無法輸出');</script>");
        //    return;
        //}
        sb.append(sdf.format(today));  // 8
        sb.append(sdf.format(bill.getMyBillDate()));  // 8
        int amt = bill.getReceivable() - bill.getReceived();
        sb.append(PaymentPrinter.makePrecise(amt+"", 7, false, '0'));   // 7
        sb.append("\r\n");
    }
    response.setHeader("Content-disposition","inline; filename=TCBstu.txt");
	response.setHeader("Content-disposition","attachment; filename=TCBstu.txt");     
%><%=sb.toString()%>