<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
    int swId = Integer.parseInt(request.getParameter("swId"));
    ArrayList<SchswRecordx> xrecords = SchswRecordxMgr.getInstance().retrieveList("schswId=" + swId, "order by schswrecord.id asc");
    Date month = xrecords.get(0).getMonth();
    int membrId1 = xrecords.get(0).getMembrId();

    MembrMgr mmgr = MembrMgr.getInstance();
    Membr m1 = mmgr.find("id=" + membrId1);
    Membr m2 = m1;
    ArrayList<Membr> membrs = new ArrayList<Membr>();
    membrs.add(m1);
    membrs.add(m2);
    
    // 找出所有該月的 schdefs
    Calendar c = Calendar.getInstance();
    c.setTime(month);
    Date d1 = c.getTime();
    c.add(Calendar.MONTH, 1);
    Date nextEndDay = c.getTime();
    c.add(Calendar.DATE,-1);
    Date d2 = c.getTime();
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    ArrayList<SchDef> schdefs = SchDefMgr.getInstance().retrieveList(
        "startDate<'" + sdf1.format(nextEndDay) + "' and endDate>='" + sdf1.format(d1) + "'", "");

    c = getCalendarOf(month);
    int thisMonth = c.get(Calendar.MONTH);
%> 

<form name="f1" action = "schedule_schsw_detailself2.jsp" method="post">    
<input type=hidden name="swId" value="<%=swId%>">
<%@ include file="schedule_schsw_pick_inner.jsp"%>
</form>


<!-- ############# setup the pick_inner.jsp ########### -->
<script src="js/myevent.js"></script>
<script>
document.getElementById('membrcolor_0').bgColor = "green";
document.getElementById('membrcolor_1').bgColor = "red";
document.getElementById('submitbutton').innerHTML = '<input type=button value="修改" onclick="doSubmit()">';
<%
    SchInfo info1 = SchInfo.getSchInfo(m1, d1, d2);
    c = getCalendarOf(month);
    while (c.get(Calendar.MONTH)==thisMonth) {
        iter = schdefs.iterator();
        Date day = c.getTime();
        while (iter.hasNext()) {
            SchDef sd = iter.next();
            boolean thisModify = info1.changedBy(day, sd.getId(), swId);
            int swtch = info1.getSwitchStatus(day, sd.getId());
            String divId = "0_" + sd.getId() + "_" + c.get(Calendar.DAY_OF_MONTH);
            if (!thisModify) {
                if (info1.isOriginal(day, sd.getId()) && swtch!=SchswRecord.TYPE_OFF) {
                 %>
                    a['<%=divId%>'] = 0;
                    var d = document.getElementById('<%=divId%>');
                    d.orgColor = "green";
                    d.targetColor = "red";
                    d.style.background = d.orgColor;
                    addevent('<%=divId%>', 'inColor', 'mouseover');
                    addevent('<%=divId%>', 'outColor', 'mouseout');
                    addevent('<%=divId%>', 'doSelect', 'click');
                 <%
                } else if (swtch==SchswRecord.TYPE_OFF) {
                 %>
                    var d = document.getElementById('<%=divId%>');
                    d.style.background = "#f0f0f0";
                 <%
                }
                else if (swtch==SchswRecord.TYPE_ON) {
                 %>
                    var d = document.getElementById('<%=divId%>');
                    d.style.background = "lightgreen";
                 <%
                }
            }
            else {
                if (swtch==SchswRecord.TYPE_OFF) { // 如果 switch off 就代表原來是我的現在是別人的 要畫成別人顏色
                 %>
                    a['<%=divId%>'] = 1;
                    var d = document.getElementById('<%=divId%>');
                    d.orgColor = "green";
                    d.targetColor = "red";
                    d.style.background = d.targetColor;
                    addevent('<%=divId%>', 'inColor', 'mouseover');
                    addevent('<%=divId%>', 'outColor', 'mouseout');
                    addevent('<%=divId%>', 'doSelect', 'click');
                 <%
                }
            }
        }
        c.add(Calendar.DATE, 1);
    }

    SchInfo info2 = SchInfo.getSchInfo(m2, d1, d2);
    c = getCalendarOf(month);
    while (c.get(Calendar.MONTH)==thisMonth) {
        iter = schdefs.iterator();
        Date day = c.getTime();
        while (iter.hasNext()) {
            SchDef sd = iter.next(); 
            boolean thisModify = info2.changedBy(day, sd.getId(), swId);
            int swtch = info2.getSwitchStatus(day, sd.getId());
            String divId = "1_" + sd.getId() + "_" + c.get(Calendar.DAY_OF_MONTH);
            if (!thisModify) {
                if (!info2.isOriginal(day, sd.getId()) && !(swtch==SchswRecord.TYPE_ON) && sd.hasDay(day)!=null) {
                 %>
                    a['<%=divId%>'] = 0;
                    var d = document.getElementById('<%=divId%>');
                    d.orgColor = "white";
                    d.targetColor = "green";
                    d.style.background = d.orgColor;
                    addevent('<%=divId%>', 'inColor', 'mouseover');
                    addevent('<%=divId%>', 'outColor', 'mouseout');
                    addevent('<%=divId%>', 'doSelect', 'click');
                 <%
                } 
                else {
                 %>
                    var d = document.getElementById('<%=divId%>');
                    d.style.background = "#f0f0f0";
                 <%
                }
            }
            else {
                if (swtch==SchswRecord.TYPE_ON) {
                 %>
                    a['<%=divId%>'] = 1;
                    var d = document.getElementById('<%=divId%>');
                    d.orgColor = "white";
                    d.targetColor = "green";
                    d.style.background = d.targetColor;
                    addevent('<%=divId%>', 'inColor', 'mouseover');
                    addevent('<%=divId%>', 'outColor', 'mouseout');
                    addevent('<%=divId%>', 'doSelect', 'click');
                 <%
                }
            }
        }
        c.add(Calendar.DATE, 1);
    }

%>
</script>