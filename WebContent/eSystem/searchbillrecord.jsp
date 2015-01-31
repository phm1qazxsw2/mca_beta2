<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,mca.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%!
    public String makeNameLink(String name, int membrId, int studentId)
    {
        if (name==null || name.trim().length()==0) {
            name = "##";
        }
        StringBuffer sb = new StringBuffer();
        sb.append("<a href=\"javascript:openwindow_phm('modifyStudent.jsp?studentId="+studentId+"','基本資料',700,700,false);\" onmouseover=\"ajax_showTooltip('peek_membr.jsp?id="+membrId+"',this);return false;\" onmouseout=\"ajax_hideTooltip()\">");
        sb.append(name);
        sb.append("</a>");
        return sb.toString();
    }

    public String makeMcaNameLink(String name, int membrId, int studentId, int feeId)
    {
        if (name==null || name.trim().length()==0) {
            name = "##";
        }
        StringBuffer sb = new StringBuffer();
        sb.append("<a href=\"javascript:openwindow_phm('modify_mca_student.jsp?studentId="+studentId+"','基本資料',700,700,false);\" onmouseover=\"ajax_showTooltip('peek_mcafee_membr.jsp?feeId="+feeId +"&id="+membrId+"',this);return false;\" onmouseout=\"ajax_hideTooltip()\">");
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
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(!checkAuth(ud2,authHa,101))
    {
        response.sendRedirect("authIndex.jsp?code=101");
    }
%>
<%@ include file="leftMenu1.jsp"%>
<link rel="stylesheet" href="css/ajax-tooltip-billsearch.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
<script type="text/javascript" src="js/check.js"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/bill.js"></script>
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

function export_excel(v) {

    //var urlString="export_bill_menu.jsp?o="+document.fexport.o.value+"&t="+document.fexport.t.value;

    //openwindow_phm(urlString,'匯出帳單Excel報表',450,300,true);
    document.fexport.type.value = v;
    document.fexport.submit();

}

function show_bill_voucher() {
    /*
    document.fexport.action = "vchr/show_bill_vchrsearch.jsp";
    document.fexport.target = "_blank";
    document.fexport.submit();
    */
    show_bill_acodes(document.fexport.o.value, "帳單搜尋結果:"+document.fexport.t.value);
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
    ArrayList<BillRecordInfo> brs = bmgr.retrieveListX("billType="+Bill.TYPE_BILLING, "order by month desc", 
         _ws.getBunitSpace("bill.bunitId"));
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

    int feeId = -1;
    McaFee fee = null;
    ArrayList<Tag> feetags = null;

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

    ArrayList<TagType> all_tagtypes = TagTypeMgr.getInstance().retrieveListX("","order by num ",_ws.getStudentBunitSpace("bunitId"));
    TagHelper thelper = TagHelper.getInstance(pZ2, 0, _ws.getSessionStudentBunitId());
    ArrayList<Tag> all_tags = thelper.getTags(false, "", _ws.getStudentBunitSpace("bunitId"));

    Map<Integer/*typeId*/, Vector<Tag>> tagMap = new SortingMap(all_tags).doSort("getTypeId");

    if (brId==-1 && mon!=null) {  // 沒有 specified BillRecord
        bb = bmgr.retrieveListX("month='" + mon + "' and billType="+Bill.TYPE_BILLING, "",  _ws.getBunitSpace("bill.bunitId"));
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
            students = TagMembrStudentMgr.getInstance().retrieveListX(q, "group by student.id order by studentName asc", _ws.getStudentBunitSpace("student.bunitId"));
            if (studentIds.length()==0) {
                fixInactiveStudents(students, bb);
            }
        }        
        label = monstr + " " + tagname + " " +" 搜尋結果";
    }
    else if (brId>0) { //  specified BillRecord
        bb = new ArrayList<BillRecordInfo>();     
        BillRecordInfo tmp = bmgr.findX("billrecord.id=" + brId, _ws.getBunitSpace("bill.bunitId"));
        if (tmp==null) {
            %><script>alert("資料不存在");history.go(-1)</script><%
            return;
        }

        bb.add(tmp);
        students = getBillStudents(bb);
        label = bb.get(0).getName();
    }
    if (label.length()>0)
        _ws.setBookmark(ud2, "帳單查詢-" + label);

    Map<String, MembrBillRecord> mm = new HashMap<String, MembrBillRecord>(100);
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

            if (pd2.getPagetype()==7 && lists.size()>0) {
                int _brid = lists.get(0).getBillRecordId();
                mca.McaRecord mr = mca.McaRecordInfoMgr.getInstance().find("billRecordId=" + _brid + 
                    " and mca_fee.status!=-1");
                feeId = mr.getMcaFeeId();
                fee = McaFeeMgr.getInstance().find("id=" + feeId);
                McaTagHelper th = new McaTagHelper();
                feetags = th.getFeeTags(fee);
                tagMap = new SortingMap(feetags).doSort("getTypeId");
            }
        }
    }
%>
<table border=0>
    <tr>
        <tD class=es02>
            <b>&nbsp;&nbsp;&nbsp;帳單查詢</b> - <%=label%>
        </td>
        <td>
    <%
        if(brId!=-1)
        {
    %>
    <div id=showSearch class=es02>&nbsp;&nbsp;&nbsp;&nbsp;<a href="billoverview.jsp"><img src="pic/last2.png" border=0>&nbsp;回帳單總覽 </a> | <a href="#" onClick="showForm('searchform')">進階查詢</a> 
</div>
    <%
        }else{
    %>
        <div class=es02>
            <%  if(mon !=null){     %>
            <a href="billrecord_chart.jsp?month=<%=mon%>"><img src="pic/re1.png" border=0>&nbsp;報表中心</a> | 
            <%  }   %>
        </div>
    <%  }   %>
        </td>
    </tr>
</table>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<table width=600>
<tr>
    <td width=30></td>
    <td align=left nowrap>
    <br>
    <div id=searchform style="<%=(brId==-1)?"":"display:none"%>" class=es02>
        <form name="f1" action="searchbillrecord.jsp" onsubmit="return check(this);">
        <% 
            if (brs.size()==0) {
                out.println("尚無開單記錄，");
                return;
            }
        %>
        <% // ############# 搜尋選單 ############### %>
        <table border=0 cellpadding=0 cellspacing=0><tr><td nowrap>
            查詢月份
            <select name="month">
            <option value="">--- 請選擇查詢月份 ---
            <%
                while (iter2.hasNext()) {
                    Date d = iter2.next();
                    out.println("<option value='"+sdf.format(d)+"' "+((monstr.equals(sdf.format(d)))?"selected":"")+">" + sdf.format(d) + "</option>");
                }
            %>
            </select>
            <br>
            繳費狀態
            <select name="pstat">
            <option value="-1">全部
            <option value="0" <%=(pstat==0)?"selected":""%>>未繳清
            <option value="2" <%=(pstat==2)?"selected":""%>>已繳清
            </select>
            &nbsp;&nbsp;
            <input type=submit value="查詢">
        </td>
        <td><img src="images/spacer.gif" width=20></td>
        <td valign=top nowrap>
            <%@ include file="tag_selection_body.jsp"%>
        </td></tr></table>
        <% // ###################################### %>
        
       </form>
    </div>
    </td>
</tr>
    
<%
    if (brId==-1 && tagIds==null && monstr.length()==0)
    {%>   
<tr>
    <td width=30></td>
    <td class=es02>

         <b> 或</b>
    </td>
</tr>
<tr>   
    <td></td>
    <td align=left class=es02> 
        <form action="search_single_bill.jsp">
        依帳單流水號:
        <input type=text name="ticketId" size=13>
        <input type=submit value="查詢單張帳單">
        </form>
    </td>
</tr>
<tr>
    <td width=30></td>
    <td class=es02>
         <b> 或</b>
    </td>
</tr>
<tr>   
    <td></td>
    <td align=left class=es02> 
        <form action="listStudent.jsp">
            <input type=hidden name="status" value="-1">
            <input type=hidden name="tag" value="-1">
            依繳款者名稱:
            <input type="text" name="searchWord" size=20> 
            <input type=submit value="查詢名單">
        </form>
    </td>
</tr>
<table>

</td>
</tr>
</table>
<%@ include file="bottom.jsp"%>
<%  
        return;
    }
    else {
        out.println("</table>");
    }

    String exlString="&nbsp;&nbsp;&nbsp;<a href=\"javascript:export_excel(2)\"><img src=\"pic/excel2.png\" border=0>&nbsp;收費報表</a> ";
    if (VoucherService.initialized>=0) {
        exlString += " |&nbsp;<a href=\"javascript:show_bill_voucher()\"><img src=pic/costtype3.png border=0>&nbsp;傳票試算</a>";
    }

    if (displayFullAmountMode)
        out.println("<table border=0><tr class=es02><td class=es02 nowrap>** 以下顯示的金額為帳單上的應繳金額。</td><td nowrap><img src='img/showstatus2.gif' border=0>&nbsp繳費狀態為尚未繳清</td><td nowrap><img src='img/showstatus1.gif' border=0>&nbsp繳費狀態為已繳清</td><td nowrap>"+exlString+"</td></tr></table>");
    else
        out.println("<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;** 以下顯示的金額為尚未付款的金額, 可能小於帳單面額。"+ exlString + "</div><br>");
%>


<table border="0" cellpadding="0" cellspacing="0">
<td width=20></td>
<td>

<table height="" width="1" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

    <table border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
			<td nowrap width=100>姓名</td> 
<%
            for (int i=0; i<bb.size(); i++) {
                bufs[i] = new StringBuffer();
                receivable_subtotals[i] = (int) 0;
                receivable_nums[i] = 0;
                received_subtotals[i] = (int) 0;
                received_nums[i] = 0;
                BillRecord b = bb.get(i);
                String title = (brId==-1)?tagname+" , "+b.getName()+" 搜尋結果":b.getName();
              %><td width=5% nowrap align=center>
              <b><%=(b.getName().length()>25)?(b.getName().substring(0,24)+".."):b.getName()%></b><br>
    <input type=button value="預覽帳單" onClick="javascript:preview(<%=i%>,'<%=title%>')">    
</td><%
            }
%>
		</tr>
<%
        /*
        String membrIds = new RangeMaker().makeRange(students, "getMembrId");
        ArrayList<MainTagStudent> sortedstudents = null;
        if (pd2.getPagetype()!=7) {
            sortedstudents = MainTagStudentMgr.getInstance().retrieveList("membr.id in (" + membrIds + 
                ") and tag.status=" + Tag.STATUS_CURRENT,"group by membr.id order by tag.id asc, membr.id asc");
        }
        else {
            String _tagids = new RangeMaker().makeRange(feetags, "getId");
            sortedstudents = MainTagStudentMgr.getInstance().retrieveList("membr.id in (" + membrIds + 
                ") and tag.id in (" + _tagids + ")","group by membr.id order by membr.name asc");
        }
        */


        DecimalFormat mnf = new DecimalFormat("###,###,##0");
        String mbrIds = new RangeMaker().makeRange(students, "getMembrId");
        MainTagHelper mh = new MainTagHelper(mbrIds, _ws.getSessionBunitId());

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
            String namelink = (pd2.getPagetype()!=7)?makeNameLink(ts.getMembrName(), ts.getMembrId(), ts.getStudentId()):makeMcaNameLink(ts.getMembrName(), ts.getMembrId(),  ts.getStudentId(), feeId);

%>
		<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
			
            <td class=es02 valign=top nowrap <%=bgcolor%>><%=xx%> <a name=<%=anchor%>><%=namelink%></a> 
                <%=mh.getMainTagName(ts.getMembrId())%>
            </tD>
<%
            for (int i=0; i<bb.size(); i++) {
                String k = ts.getMembrId() + "#" + bb.get(i).getId();
                MembrBillRecord r = (MembrBillRecord) mm.get(k);
                String color = "#FFFFFF";
                String amt = "";
                if (r!=null) {  
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
                   
                    %><td width=150 bgcolor='<%=color%>' align=right><a  href='bill_detail.jsp?rid=<%=r.getBillRecordId()%>&sid=<%=r.getMembrId()%>&backurl=<%=java.net.URLEncoder.encode(backurl+"#" +anchor)%>' onmouseover="ajax_showTooltip('peek_bill.jsp?rid=<%=r.getBillRecordId()%>&sid=<%=r.getMembrId()%>',this);return false"
                    onmouseout="ajax_hideTooltip()"><font color=white><%=amt%><%=pending%></font></a>
</td><%

                    if (bufs[i].length()>0) 
                        bufs[i].append(",");
                    bufs[i].append(k);
                }
                else if (pstat==-1) {
                    %><td width=150 class=es02>

                    </td><%
                }
                else {
                    %><td width=150>&nbsp;</td><%
                }
                
            }
%>
        </tr>
<%
        }
%>		
		<tr bgcolor="#f0f0f0" align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>			
            <td class=es02 align=left valign=middle nowrap>小計</td>
<%      for (int i=0; i<bb.size(); i++) { %>
            <td align=left nowrap class=es02>
                應收:<%=(receivable_subtotals[i]>0)?mnf.format(receivable_subtotals[i])+"":"0 "%>元   /<%=(receivable_nums[i]>0)?(receivable_nums[i]+"筆 "):"0 筆"%>
                <br>
                已收:<%=(received_subtotals[i]>0)?mnf.format(received_subtotals[i])+"":"0 "%>元   /<%=(received_nums[i]>0)?(received_nums[i]+"筆 "):"0 筆"%>

                <br>
                未收:<%=mnf.format(receivable_subtotals[i]-received_subtotals[i])%> 元   /<%=receivable_nums[i]-received_nums[i]%> 筆 

            </td>
<%      } %>
        </tr>    
    </table>
</td>
</tr>
</table>
<br>

</td>
</tr>
</table>
<div class=es02>
<%=exlString%>
</div>


<br>  
<br>


<%
// studentId#billReocrdId,....
for (int i=0; bufs!=null && i<bufs.length; i++) { %>
<form name="p<%=i%>" action="billrecord_detail.jsp" method=post target="_blank">
<input type=hidden name="o" value="<%=bufs[i].toString()%>">
<input type=hidden name="t">
</form>
<% }
%>
<!-- <form name="fexport" target=_blank action="export_bill.jsp" method="post"> -->
<form name="fexport" target=_blank action="export_bill.jsp" method="post">
<input type=hidden name="type" value=2>
<input type=hidden name="o" value="<%=allbufs.toString()%>">
<input type=hidden name="t" value="<%=label%>">
<input type=hidden name="feeId" value="<%=feeId%>">
<input type=hidden name="month" value="<%=monstr%>">
</form>

<form name="acodeform" action="vchr/show_acode_billsearch.jsp" method="post" target="_blank">
<input type=hidden name="o" value="<%=allbufs.toString()%>">
<input type=hidden name="a" value="">
<input type=hidden name="m" value="false">
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

<%@ include file="bottom.jsp"%>