<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int mid = Integer.parseInt(request.getParameter("mid"));
    Membr membr = MembrMgr.getInstance().findX("id="+mid, _ws2.getStudentBunitSpace("bunitId"));

    if (membr==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }    

    ArrayList<BillRecordInfo> all_records = 
        BillRecordInfoMgr.getInstance().retrieveListX("billType="  + Bill.TYPE_BILLING,
        "order by billrecord.id desc", _ws2.getBunitSpace("bill.bunitId"));
    ArrayList<MembrInfoBillRecord> all_bills = 
        MembrInfoBillRecordMgr.getInstance().retrieveList("membrId=" + mid + 
        " and billType=" + Bill.TYPE_BILLING, "order by billrecord.id desc");
    Map<Integer/*billrecord.id*/, Vector<BillRecord>> billMap = new SortingMap(all_bills).doSort("getBillRecordId");

    String backurl = request.getParameter("burl");
%>
<script>
function doSubmit(f)
{
    var s = f.brid;
    if (s.options[s.selectedIndex].value==-1) {
        alert("請選擇未開過的帳單");
        s.focus();
        return false;
    }
    return true;
}
</script>
<body>
<br>
<div class=es02><b>&nbsp;&nbsp;&nbsp;&nbsp;<%=membr.getName()%>-新增帳單</b>

<form name=f1 action="membrbillrecord_add.jsp" onsubmit="return doSubmit(this)" <%=(pageType==1)?"target=\"mainFrame\"":"_top"%>> 
<input type=hidden name="mid" value="<%=mid%>">
<input type=hidden name="backurl" value="<%=backurl%>">
<blockquote>

選擇要開的帳單：<br><br>
<select name="brid">
<%
    Iterator<BillRecordInfo> biter = all_records.iterator();
    while (biter.hasNext()) {
        BillRecordInfo br = biter.next();
        boolean done = billMap.get(new Integer(br.getId()))!=null;
%>
    <option value="<%=(done)?-1:br.getId()%>"><%=br.getName()%><%=(done)?"(已開過)":""%>
<%
    }
%>
</select>
<br>
<br>
<input type="submit" value="開單">
</blockquote>
</form>
</body>