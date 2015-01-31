<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    String frameWidth=request.getParameter("frameWidth");
%>
<%@ include file="jumpTopExpress.jsp"%>
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

function printslip(i, t) {
    var fname = "slip_" + i;
    var f = eval("document." + fname);
    f.t.value = t;
    f.submit();
}
function do_pay(i, t) {
    var fname = "pay_" + i;
    var f = eval("document." + fname);
    f.t.value = t;
    f.submit();
}

</script>
<br>
<%


    //##v2
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    
    // 1. get months that has records
    BillRecordInfoMgr bmgr = BillRecordInfoMgr.getInstance();
    ArrayList<BillRecordInfo> brs = bmgr.retrieveList("billType="+Bill.TYPE_SALARY +" and privLevel>=" + ud2.getUserRole(), "order by month desc");
    Iterator<BillRecordInfo> iter = brs.iterator();
    LinkedHashMap<Date, String> m = new LinkedHashMap();
    while (iter.hasNext()) {
        BillRecord br = iter.next();
        Date d = br.getMonth();
        m.put(d, "");        
    }

    // 2. get specified tags
    ArrayList<Tag> tags = TagMgr.getInstance().retrieveList("","");
    Iterator<Tag> iter3 = tags.iterator();
    int tid = -1;
    try { tid = Integer.parseInt(request.getParameter("tid")); } catch (Exception e) {}

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

    String backurl = "searchsalaryrecord.jsp?" + request.getQueryString();

    // 開始搜尋
    // ===========================
    // 先找指定月份的 billrecords
    ArrayList<BillRecordInfo> bb = null;
    ArrayList<TagMembrTeacher> teachers = null;
    String tagname = null;
    StringBuffer[] bufs = null;
    int[] subtotals = null;
    int[] nums = null;
    String label = "";

    if (brId==-1 && mon!=null) {  // 沒有 specified BillRecord
        bb = bmgr.retrieveList("month='" + mon + "' and billType="+Bill.TYPE_SALARY + 
            " and privLevel>=" + ud2.getUserRole(), "");
        tagname = (tid==-1)?"全部":TagMgr.getInstance().find("id=" + tid).getName();

        // 找出 tag 里所有的學生
        String q = "teacherStatus in (1,2)"; // 1:在職 2:試用
        if (tid>0)
            q += " and tagId=" + tid;
        teachers = TagMembrTeacherMgr.getInstance().retrieveList(q, "group by teacher.id");
        label = tagname + " " + monstr + " 搜尋結果";
    }
    else if (brId>0) { //  specified BillRecord
        bb = new ArrayList<BillRecordInfo>();        
        bb.add(bmgr.find("billrecord.id=" + brId));
        teachers = new ArrayList<TagMembrTeacher>();
        ArrayList<MembrInfoBillRecord> tmp = MembrInfoBillRecordMgr.getInstance().
            retrieveList("billRecordId=" + brId, "");
        Iterator<MembrInfoBillRecord> iter8 = tmp.iterator();
        while (iter8.hasNext()) {
            MembrInfoBillRecord sinfo = iter8.next();
            TagMembrTeacher t = new TagMembrTeacher();
            t.setMembrId(sinfo.getMembrId());
            t.setMembrName(sinfo.getMembrName());
            teachers.add(t);
        }
        label = bb.get(0).getName();
    }

    HashMap mm = new HashMap(100);
    if (bb!=null && bb.size()>0) {
        bufs = new StringBuffer[bb.size()];
        subtotals = new int[bb.size()];     
        nums = new int[bb.size()];
        Iterator<BillRecordInfo> iter4 = bb.iterator();
        StringBuffer sb = new StringBuffer();
        for (int i=0; iter4.hasNext(); i++) {
            if (i>0) sb.append(",");
            sb.append(iter4.next().getId());
        }

        // 找出所有的有這些人的 billrecord 
        String q = "billRecordId in ("+sb.toString()+")";
        
        if (tid>0) {
            q += " and tag.id="+tid;
        }
        if (pstat>=0) {
            q += " and paidStatus=" + pstat;
        }

        q += " and privLevel>=" + ud2.getUserRole();

        ArrayList<TagMembrBillRecordShort> lists = 
            TagMembrBillRecordShortMgr.getInstance().retrieveList(q, "");
       
        // 先放在個 map 里等下參考
        Iterator<TagMembrBillRecordShort> iter5 = lists.iterator();
        int ii = 0;
        while (iter5.hasNext()) {
            MembrBillRecord r = iter5.next();
            mm.put(r.getMembrId() + "#" + r.getBillRecordId(), r);
            ii ++;
        }
    }
%>
<div class=es02>
<b>&nbsp;&nbsp;查詢薪資 -<br> &nbsp;&nbsp;<%=label%></b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<div class=es02>
<%
        String[] billName=new String[bb.size()];
    
        for (int i=0; i<bb.size(); i++) {
            bufs[i] = new StringBuffer();
            subtotals[i] = (int) 0;
            nums[i] = 0;
            BillRecord b = bb.get(i);
            String title = b.getName();

            billName[i]=title;
        }

        DecimalFormat mnf = new DecimalFormat("###,###,##0");
        Iterator<TagMembrTeacher> iter6 = teachers.iterator();
        int xx = 0;

        while (iter6.hasNext()) {
            xx ++;
            TagMembrTeacher ts = iter6.next();
            String anchor = "a" + ts.getMembrId();
%>			
            <br>
            &nbsp;<b><%=xx%>&nbsp;<%=ts.getMembrName()%></b>
            <br>
<%
            for (int i=0; i<bb.size(); i++) {
                String k = ts.getMembrId() + "#" + bb.get(i).getId();
                MembrBillRecord r = (MembrBillRecord) mm.get(k);
                String color = "#FFFFFF";
                String amt = "";
                if (r!=null) {  
                    int tmp = 0;
                    if (r.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID) { // already paid
                        color = "F77510";
                        tmp = r.getReceivable();
                    }
                    else { // not paid
                        color = "4A7DBD";
                        tmp = (displayFullAmountMode)?r.getReceivable():(r.getReceivable() - r.getReceived());
                    }

                    amt = (tmp>=0)?mnf.format(tmp):"("+mnf.format(Math.abs(tmp))+")";
                    subtotals[i] += (tmp);
                    nums[i] ++;

                    %>
&nbsp;&nbsp;&nbsp;<%=billName[i]%> <br>
&nbsp;&nbsp;&nbsp;金額: <%=amt%> 元 &nbsp;
<a href='salary_detail_express.jsp?rid=<%=r.getBillRecordId()%>&sid=<%=r.getMembrId()%>&backurl=<%=java.net.URLEncoder.encode(backurl+"#" +anchor)%>' target="mainFrame"><img src="pic/fix.gif" border=0 width=10>&nbsp;編輯</a>
            <br>                       
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
<form name="slip_<%=i%>" target="_blank" action="salaryrecord_detail.jsp" method=post>
<input type=hidden name="o" value="<%=bufs[i].toString()%>">
<input type=hidden name="t">
<input type=hidden name="backurl" value="<%=backurl%>">
</form>
<form name="pay_<%=i%>" action="salary_batchpay.jsp" method=post>
<input type=hidden name="o" value="<%=bufs[i].toString()%>">
<input type=hidden name="t">
<input type=hidden name="backurl" value="<%=backurl%>">
</form>
<% } %>

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