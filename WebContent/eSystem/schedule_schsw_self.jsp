<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
    Date month = sdf.parse(request.getParameter("month"));
    MembrMgr mmgr = MembrMgr.getInstance();
    Membr m1 = mmgr.find("id=" + request.getParameter("id1"));
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

<form name="f1" action = "schedule_schsw_self2.jsp" method="post">    
<%@ include file="schedule_schsw_pick_inner.jsp"%>
</form>

<!-- ############# setup the pick_inner.jsp ########### -->
<script src="js/myevent.js"></script>
<script>
document.getElementById('membrcolor_0').bgColor = "green";
document.getElementById('membrcolor_1').bgColor = "red";
document.getElementById('submitbutton').innerHTML = '<input type=button value="新增" onclick="doSubmit()">';
<%
    SchInfo info1 = SchInfo.getSchInfo(m1, d1, d2);
    c = getCalendarOf(month);
    Iterator<SchDef> iter = null;
    Date today = new Date();
    while (c.get(Calendar.MONTH)==thisMonth) {
        iter = schdefs.iterator();
        Date day = c.getTime();
        while (iter.hasNext()) {
            SchDef sd = iter.next();
            int swtch = info1.getSwitchStatus(day, sd.getId());
            String divId = "0_" + sd.getId() + "_" + c.get(Calendar.DAY_OF_MONTH);
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
        c.add(Calendar.DATE, 1);
    }

    SchInfo info2 = SchInfo.getSchInfo(m2, d1, d2);
    c = getCalendarOf(month);
    while (c.get(Calendar.MONTH)==thisMonth) {
        iter = schdefs.iterator();
        Date day = c.getTime();
        while (iter.hasNext()) {
            SchDef sd = iter.next(); 
            int swtch = info2.getSwitchStatus(day, sd.getId());
            String divId = "1_" + sd.getId() + "_" + c.get(Calendar.DAY_OF_MONTH);
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
        c.add(Calendar.DATE, 1);
    }

%>
</script>