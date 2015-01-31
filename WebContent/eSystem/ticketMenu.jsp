<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    String frameWidth=request.getParameter("frameWidth");
%>

<%@ include file="jumpTopExpress.jsp"%>
<%!
    public String makeNameLink(String name, int membrId, int studentId)
    {
        if (name==null || name.trim().length()==0) {
            name = "##";
        }
        StringBuffer sb = new StringBuffer();
        sb.append("<a href=\"modifyStudent.jsp?studentId="+studentId+"\" target=\"mainFrame\">");
        sb.append(name);
        sb.append("</a>");
        return sb.toString();
    }

    public String getMembrIds(ArrayList<TagMembrStudent> students)
    {
        StringBuffer sb = new StringBuffer();
        Iterator<TagMembrStudent> i = students.iterator();
        while (i.hasNext()) {
            if (sb.length()>0) sb.append(",");
            sb.append(i.next().getMembrId());
        }
        return sb.toString();
    }

    public ArrayList<TagMembrStudent> getBillStudents(ArrayList<BillRecordInfo> bb)
        throws Exception
    {
        ArrayList<TagMembrStudent> students = new ArrayList<TagMembrStudent>();
        String brIds = new RangeMaker().makeRange(bb, "getId");
        ArrayList<MembrInfoBillRecord> tmp = MembrInfoBillRecordMgr.getInstance().
            retrieveList("billRecordId in (" + brIds + ")", "order by membr.name asc");
        Map<Integer/*membrId*/, Vector<MembrInfoBillRecord>> billMap = new SortingMap(tmp).doSort("getMembrId");
        Iterator<Integer> iter = billMap.keySet().iterator();
        while (iter.hasNext()) {
            MembrInfoBillRecord sinfo = billMap.get(iter.next()).get(0);
            TagMembrStudent t = new TagMembrStudent();
            t.setMembrId(sinfo.getMembrId());
            t.setMembrName(sinfo.getMembrName());
            t.setStudentId(sinfo.getMembrSurrogateId());
            students.add(t);
        }
        return students;
    }

    public void fixInactiveStudents(ArrayList<TagMembrStudent> students, ArrayList<BillRecordInfo>bb)
        throws Exception
    {
        ArrayList<TagMembrStudent> bill_students = getBillStudents(bb);
        Map<Integer/*membrId*/, Vector<TagMembrStudent>> studentMap = new SortingMap(students).doSort("getMembrId");
        Iterator<TagMembrStudent> iter = bill_students.iterator();
        while (iter.hasNext()) {
            TagMembrStudent s = iter.next();
            if (studentMap.get(new Integer(s.getMembrId()))==null) {
                s.setStudentStatus(-1);
                students.add(s);
            }
        }
    }
%>

<link rel="stylesheet" href="css/ajax-tooltip-billsearch.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
<script type="text/javascript" src="js/check.js"></script>
<script>
function check(f)
{
    var m = f.month;
    if (m.options[m.selectedIndex].value.length==0) {
        alert("請選擇月份");
        m.focus();
        return false;
    }
    return true;
}

function preview(i, t) {
    var fname = "p" + i;
    var f = eval("document." + fname);
    f.t.value = t;
    f.submit();
}

function export_excel() {

    var urlString="export_bill_menu.jsp?o="+document.fexport.o.value+"&t="+document.fexport.t.value;

    openwindow_phm(urlString,'匯出帳單Excel報表',450,300,true);

}
</script>
<%@ include file="tag_selection.jsp"%>
<br>

<%
    //##v2
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    
    // 1. get months that has records
    BillRecordInfoMgr bmgr = BillRecordInfoMgr.getInstance();
    ArrayList<BillRecordInfo> brs = bmgr.retrieveListX("billType="+Bill.TYPE_BILLING, 
        "order by month desc", _ws2.getBunitSpace("bunitId"));
    Iterator<BillRecordInfo> iter = brs.iterator();
    LinkedHashMap<Date, String> m = new LinkedHashMap();
    while (iter.hasNext()) {
        BillRecord br = iter.next();
        Date d = br.getMonth();
        m.put(d, "");        
    }

    // 2. get specified tags
    ArrayList<Tag> tags = TagMgr.getInstance().retrieveListX("","", _ws2.getStudentBunitSpace("bunitId"));
    Iterator<Tag> iter3 = tags.iterator();

    int brId = -1;
    try { brId = Integer.parseInt(request.getParameter("brId")); } catch (Exception e) {}

    int pstat = -1;
    try { pstat = Integer.parseInt(request.getParameter("pstat")); } catch (Exception e) {}
    boolean displayFullAmountMode = (pstat==-1) || (pstat==2);

    // 2. get specified month, and get BillRecord of that month if any
    String mon = request.getParameter("month");
    String monstr = "";
    if (mon!=null && mon.length()>0) {
        mon += "-01"; // db store something like 2008-06-01
        monstr = sdf.format(sdf1.parse(mon));
    }

    Set<Date> keys = m.keySet();
    Iterator<Date> iter2 = keys.iterator(); // this has months that has billrecords

    String backurl = "searchbillrecord.jsp?" + request.getQueryString();

    // 開始搜尋
    // ===========================
    // 先找指定月份的 billrecords
    ArrayList<BillRecordInfo> bb = null;
    ArrayList<TagMembrStudent> students = new ArrayList<TagMembrStudent>();
    String tagname = null;
    StringBuffer[] bufs = null;
    StringBuffer allbufs = new StringBuffer();
    int[] receivable_subtotals = null;
    int[] received_subtotals = null;
    int[] receivable_nums = null;
    int[] received_nums = null;
    String label = "";
    EzCountingService ezsvc = EzCountingService.getInstance();
    ArrayList<TagType> all_tagtypes = TagTypeMgr.getInstance().retrieveListX("","order by num ", _ws2.getStudentBunitSpace("bunitId"));
    ArrayList<Tag> all_tags = TagMgr.getInstance().retrieveListX("","",_ws2.getStudentBunitSpace("bunitId"));
    Map<Integer/*typeId*/, Vector<Tag>> tagMap = new SortingMap(all_tags).doSort("getTypeId");

    if (brId==-1 && mon!=null) {  // 沒有 specified BillRecord
        bb = bmgr.retrieveListX("month='" + mon + "' and billType="+Bill.TYPE_BILLING, "", _ws2.getBunitSpace("bunitId"));
        tagname = getTagName(tagIds, _taginfos, all_tags);

        // 找出 tag 里所有的學生
        String q = "studentStatus in (3,4)";
        
        // 沒有交集和兩個都沒 specify 是不同
        // 前者 return "", 后者 return null
        // String studentIds = ezsvc.getStudentIds(tagIds); 這行移到 tag_selection.jsp 里了
        // 換句話說如果沒有 tagId 都是 -1, studentIds return "",
        // 如果沒有交集，studentIds return 會是 null
        if (studentIds!=null) {
            if (studentIds.length()>0)
                q += " and student.id in (" + studentIds + ")";
            students = TagMembrStudentMgr.getInstance().retrieveList(q, "group by student.id");
            if (studentIds.length()==0) {
                fixInactiveStudents(students, bb);
            }
        }        
        label = monstr + " " + tagname + " " +" 搜尋結果";
    }
    else if (brId>0) { //  specified BillRecord
        bb = new ArrayList<BillRecordInfo>();        
        BillRecordInfo tmp = bmgr.findX("billrecord.id=" + brId, _ws2.getBunitSpace("bill.bunitId"));
        if (tmp==null) {
            %><script>alert("資料不存在");history.go(-1)</script><%
            return;
        }
        
        bb.add(tmp);
        students = getBillStudents(bb);
        label = bb.get(0).getName();
    }

    HashMap mm = new HashMap(100);
    if (bb!=null && bb.size()>0) {
        bufs = new StringBuffer[bb.size()];
        receivable_subtotals = new int[bb.size()];     
        receivable_nums = new int[bb.size()];
        received_subtotals = new int[bb.size()];     
        received_nums = new int[bb.size()];
        Iterator<BillRecordInfo> iter4 = bb.iterator();
        StringBuffer sb = new StringBuffer();
        for (int i=0; iter4.hasNext(); i++) {
            if (i>0) sb.append(",");
            sb.append(iter4.next().getId());
        }

        if (students.size()>0) {
            // 找出所有的有這些學生的 billrecord 
            String q = "billRecordId in ("+sb.toString()+")";
            q += " and membrId in (" + getMembrIds(students) + ")";

            if (pstat==0) {
                q += " and paidStatus in (0,1)";
            }
            else if (pstat==2)
                q += " and paidStatus=2";

            ArrayList<MembrBillRecord> lists = 
                MembrBillRecordMgr.getInstance().retrieveList(q, "");

            // 先放在個 map 里等下參考
            Iterator<MembrBillRecord> iter5 = lists.iterator();
            int ii = 0;
            while (iter5.hasNext()) {
                MembrBillRecord r = iter5.next();
                mm.put(r.getMembrId() + "#" + r.getBillRecordId(), r);
                ii ++;
            }
        }
    }
%>
    <div class=es02>
            <b>&nbsp;&nbsp;&nbsp;帳單查詢</b> 

    <br><br>
<%
            
            String[] bName=new String[bb.size()];
            for (int i=0; i<bb.size(); i++) {
                bufs[i] = new StringBuffer();
                receivable_subtotals[i] = (int) 0;
                receivable_nums[i] = 0;
                received_subtotals[i] = (int) 0;
                received_nums[i] = 0;
                BillRecord b = bb.get(i);
                String title = (brId==-1)?tagname+" , "+b.getName()+" 搜尋結果":b.getName();

                bName[i]=b.getName();
            }
%>
<%
        DecimalFormat mnf = new DecimalFormat("###,###,##0");
        Iterator<TagMembrStudent> iter6 = students.iterator();
        int xx = 0;
        while (iter6.hasNext()) {
            xx ++;
            TagMembrStudent ts = iter6.next();
            String bgcolor = "";
            if (ts.getStudentStatus()==-1) {
                bgcolor="bgcolor='#F0F0F0'";
            }
            String anchor = "a" + ts.getMembrId();
            String name = phm.util.TextUtil.makePrecise(ts.getMembrName(), 18, true, ' ');
%>
                <br>
                &nbsp;&nbsp;<b><%=xx%></b>&nbsp;<%=makeNameLink(name, ts.getMembrId(), ts.getStudentId())%><br>
<%
            for (int i=0; i<bb.size(); i++) {
                String k = ts.getMembrId() + "#" + bb.get(i).getId();
                MembrBillRecord r = (MembrBillRecord) mm.get(k);
                String color = "#FFFFFF";
                String amt = "";
                if (r==null) {  
                  %>　》<a target="mainFrame" href="mca_addsingle2.jsp?brId=<%=bb.get(i).getId()%>&membrId=<%= ts.getMembrId()%>" onclick="if (confirm('確定新增帳單')) {return true;} else {return false;}">新增帳單</a> <br><%
                } else {
                    if (allbufs.length()>0) allbufs.append(",");
                    allbufs.append(r.getTicketId());
                    int tmp = 0;
                    receivable_subtotals[i] += r.getReceivable();
                    received_subtotals[i] += r.getReceived();
                    receivable_nums[i] ++;
                    if (r.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID) { // already paid
                        color = "F77510";
                        tmp = r.getReceivable();
                        received_nums[i] ++;
                    }
                    else { // not paid
                        color = "4A7DBD";
                        tmp = (displayFullAmountMode)?r.getReceivable():(r.getReceivable() - r.getReceived());
                    }

                    amt = mnf.format(tmp);

                    String pending = (r.getPending_cheque()==1)?"<br>(支票未兌) ":"";
                   
                    %>

　》<a href='bill_detail_express.jsp?rid=<%=r.getBillRecordId()%>&sid=<%=r.getMembrId()%>&backurl=<%=java.net.URLEncoder.encode(backurl+"#" +anchor)%>' target="mainFrame"><%=bName[i]%> </a>
    <br>            
                <%

                    if (bufs[i].length()>0) 
                        bufs[i].append(",");
                    bufs[i].append(k);
                }                
            }
        }

%>
    </div>
<%

// studentId#billReocrdId,....
for (int i=0; bufs!=null && i<bufs.length; i++) { %>
<form name="p<%=i%>" action="billrecord_detail.jsp" method=post target="_blank">
<input type=hidden name="o" value="<%=bufs[i].toString()%>">
<input type=hidden name="t">
</form>
<% }
%>
<form name="fexport" action="export_bill.jsp" method="post">
<input type=hidden name="type" value=0>
<input type=hidden name="o" value="<%=allbufs.toString()%>">
<input type=hidden name="t" value="<%=label%>">
</form>

<script>
    
    function showForm(az1){

        var e=document.getElementById(az1);
        if(!e)return true;

        if(e.style.display=="none"){
            e.style.display="block"
        } else {
            e.style.display="none"
        }
        return true;

    }
</script>