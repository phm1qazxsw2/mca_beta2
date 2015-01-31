<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu5.jsp"%>

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
    ArrayList<BillRecordInfo> brs = bmgr.retrieveListX("billType="+Bill.TYPE_SALARY +
        " and privLevel>=" + ud2.getUserRole(), "order by month desc", _ws.getBunitSpace("bunitId"));
    Iterator<BillRecordInfo> iter = brs.iterator();
    LinkedHashMap<Date, String> m = new LinkedHashMap();
    while (iter.hasNext()) {
        BillRecord br = iter.next();
        Date d = br.getMonth();
        m.put(d, "");        
    }

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
        bb = bmgr.retrieveListX("month='" + mon + "' and billType="+Bill.TYPE_SALARY + 
            " and privLevel>=" + ud2.getUserRole(), "", _ws.getBunitSpace("bill.bunitId"));
        tagname = (tid==-1)?"全部":TagMgr.getInstance().find("id=" + tid).getName();

        // 找出 tag 里所有的學生
        String q = "teacherStatus in (1,2)"; // 1:在職 2:試用
        if (tid>0)
            q += " and tagId=" + tid;
        teachers = TagMembrTeacherMgr.getInstance().retrieveListX(q, "group by teacher.id", _ws.getBunitSpace("membr.bunitId") );
        label = tagname + " " + monstr + " 搜尋結果";
    }
    else if (brId>0) { //  specified BillRecord
        bb = new ArrayList<BillRecordInfo>();  
        BillRecordInfo tmp2 = bmgr.findX("billrecord.id=" + brId, _ws.getBunitSpace("bill.bunitId"));
        if (tmp2==null) {
            %><script>alert("資料不存在");history.go(-1)</script><%
            return;
        }

        bb.add(tmp2);
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
    if (label.length()>0)
        _ws.setBookmark(ud2, "薪資查詢-" + label);

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
            TagMembrBillRecordShortMgr.getInstance().retrieveListX(q, "", _ws.getBunitSpace("bill.bunitId"));
       
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
<table border=0>
    <tr>
        <tD class=es02>
            <b>&nbsp;&nbsp;&nbsp;查詢薪資 - <%=label%></b>
        </td>
        <td>
   
    <%
        if(brId!=-1)
        {
    %>
    <div id=showSearch class=es02><a href="salaryoverview.jsp"><img src="pic/last.gif" border=0>&nbsp;回薪資總覽 </a> | <a href="#" onClick="showForm('searchform')">進階查詢</a></div>
    <%
        }
    %>
        </td>
    </tr>
</table>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<table width=600>
<tr>
    <td width=30></td>
    <td align=left>
    <br>
    <div id=searchform style="<%=(brId==-1)?"":"display:none"%>" class=es02>
        <form action="searchsalaryrecord.jsp" onsubmit="return check(this);">
        <% 
            if (brs.size()==0) {
                out.println("尚無薪資記錄，");
                return;
            }
        %>
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
         &nbsp;付款狀態
        <select name="pstat">
        <option value="-1">全部
        <option value="0" <%=(pstat==0)?"selected":""%>>未付
        <option value="1" <%=(pstat==1)?"selected":""%>>部分付
        <option value="2" <%=(pstat==2)?"selected":""%>>已付清
        </select>

        &nbsp;&nbsp;
        <input type=submit value="查詢" onchange="this.form.submit();">
        </form>
    </div>
    </td>
</tr>
    
<%
    if (brId==-1 && tid==-1 && monstr.length()==0)
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
        <form action="search_single_salary.jsp">
        輸入薪資流水號:
        <input type=text name="ticketId" size=13>
        <input type=submit value="查詢">
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
        <form action="search_membr_salary.jsp">
        輸入員工姓名:
        <input type=text name="name" size=13>
        <input type=submit value="查詢">
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

    String exlString="&nbsp;&nbsp;<img src=\"images/excel2.gif\" border=0 width=18>&nbsp;<a href=\"salary_excel_billrecord.jsp?month="+mon+"\">產生Excel薪資報表</a> | ";


    if (displayFullAmountMode){
        out.println("<table border=0><tr class=es02><td>** 以下顯示的金額為應付的薪資金額。</td><td><img src='img/showstatus2.gif' border=0>&nbsp付款狀態為尚未付清</td><td><img src='img/showstatus1.gif' border=0>&nbsp繳費狀態為已付清</td>");

        if(mon !=null)
            out.println("<td>"+exlString+"</td>");
%>
        <td>
            <a href="salaryrecordFrame.jsp?<%=request.getQueryString()%>" target="_blank"><img src="pic/littleE.png" border=0>&nbsp;快速編輯</a>
        </td>
<%
        out.println("</tr></table>");
    }else{
        out.println("** 以下顯示的金額為尚未付款的薪資金額。<br>");

    }
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
                subtotals[i] = (int) 0;
                nums[i] = 0;
                BillRecord b = bb.get(i);
                String title = (brId==-1)?tagname+" , "+b.getName():b.getName();
          %>
            <td width=5% nowrap align=center><b><%=b.getName()%></b><br><br>
<%
    if(checkAuth(ud2,authHa,302)){
%>
                <input type=button value="支付薪資" onClick="do_pay(<%=i%>,'<%=title%>')">
<%  }

    if(checkAuth(ud2,authHa,301)){
%>
                <br>    
                <input type=button value="預覽薪資條" onClick="printslip(<%=i%>,'<%=title%>')"><br>
<%  }   %>  
            </td>
        <%
            }
%>
		</tr>
<%
        DecimalFormat mnf = new DecimalFormat("###,###,##0");
        Iterator<TagMembrTeacher> iter6 = teachers.iterator();
        int xx = 0;
        while (iter6.hasNext()) {
            xx ++;
            TagMembrTeacher ts = iter6.next();
            String anchor = "a" + ts.getMembrId();
%>
		<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
			
            <td class=es02 valign=top nowrap><%=xx%> <a name=<%=anchor%>><%=ts.getMembrName()%></a> </tD>
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

                    %><td width=150 bgcolor='<%=color%>' align=right><a href='salary_detail.jsp?rid=<%=r.getBillRecordId()%>&sid=<%=r.getMembrId()%>&backurl=<%=java.net.URLEncoder.encode(backurl+"#" +anchor)%>' onmouseover="ajax_showTooltip('peek_salary.jsp?rid=<%=r.getBillRecordId()%>&sid=<%=r.getMembrId()%>',this);return false"
                    onmouseout="ajax_hideTooltip()"><font color=white><%=amt%></font></a>
            </td><%

                    if (bufs[i].length()>0) 
                        bufs[i].append(",");
                    bufs[i].append(k);
                }
                else if (pstat==-1) {
                    %><td width=150 class=es02><a href="salarybillrecord_add.jsp?brid=<%=bb.get(i).getId()%>&mid=<%=ts.getMembrId()%>&backurl=<%=java.net.URLEncoder.encode(backurl+"#"+anchor)%>"><img src="pic/add.gif" border=0 width=8><font color=gray> 新增薪資</font></a></td><%
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
            <td class=es02 valign=top nowrap>小計</td>
<%      for (int i=0; i<bb.size(); i++) { %>
            <td align=right nowrap class=es02><b><%=(subtotals[i]>0)?mnf.format(subtotals[i])+"":""%>元</b><br><%=(nums[i]>0)?(nums[i]+"筆 "):""%></td>
<%      } %>
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

<%@ include file="bottom.jsp"%>