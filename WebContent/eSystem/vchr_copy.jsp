<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<% // ######## 以下這一堆 is for 傳票編輯 都要 include ###### %>
<link rel="stylesheet" href="css/auto_complete.css" type="text/css">
<script type="text/javascript" src="js/dateformat.js"></script>
<script type="text/javascript" src="js/formcheck.js"></script>
<script type="text/javascript" src="acode_data.jsp"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/auto_complete.js"></script>
<script type="text/javascript" src="js/string.js"></script>
<script type="text/javascript" src="js/vchr_item.js?<%=new Date().getTime()%>"></script>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<% // ####################################################### %>

<script>
var items = new Array;
var bunitIds = new Array;
var bunitNames = new Array;

var ui = null;
function after_add()
{
    parent.do_reload = true;
    document.getElementById("next").innerHTML = '<a href="javascript:parent.location.reload();">關閉</a>';
}

<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    VchrHolder v = VchrHolderMgr.getInstance().find("id=" + request.getParameter("id"));
    ArrayList<VchrItem> items = VchrItemMgr.getInstance().retrieveList("vchrId=" + v.getId(), "");
    VchrInfo _vinfo_ = new VchrInfo(items, 0);
    for (int i=0; i<items.size(); i++) {
        VchrItem vi = items.get(i);
      %>items[items.length] = new vitem(
                    <%=vi.getId()%>, 
                    <%=vi.getBunitId()%>, 
                    <%=vi.getFlag()%>, 
                    <%=vi.getDebit()%>, 
                    <%=vi.getCredit()%>, 
                    '<%=_vinfo_.getMain(vi)%>',
                    '<%=_vinfo_.getSub(vi)%>',
                    <%=vi.getBunitId()%>,
                    '<%=phm.util.TextUtil.escapeJSString(_vinfo_.getAcodeName(vi))%>',
                    '<%=phm.util.TextUtil.escapeJSString(_vinfo_.getNote(vi))%>');
<%
    }
    // 2009/3/26 peter, 以後有部門再說吧
    /*
    ArrayList<Bunit> bunits = BunitMgr.getInstance().retrieveList("status=1 and flag=1", "");
    for (int i=0; i<bunits.size(); i++) {
      %>
        bunitIds[bunitIds.length]=<%=bunits.get(i).getId()%>;
        bunitNames[bunitNames.length]='<%=phm.util.TextUtil.escapeJSString(bunits.get(i).getLabel())%>';
      <%
    }
    */
%>
function init()
{
    var area = document.getElementById('main');
    ui = new vchr_ui(area, items, MODE_EDIT_FREE, false/*not template*/);
    ui.setVchrInfo("", "<%=sdf.format(new Date())%>",
        '<%=phm.util.TextUtil.escapeJSString(EzCountingService.getInstance().getUserName(ud2.getId()))%>',
        "<%=sdf.format(new Date())%>");
    ui.configSave("vchr_add2.jsp", null, after_add);
    ui.setBunitNames(bunitIds, bunitNames);
    ui.edit_status = STATUS_EDITING;
    ui.setRepaint("ui.draw()");
    ui.draw();
    ui.reset_serial();
}

</script>
<body onload="init();">
<div style="position:relative;height:5000px">
<div id="main" style="position:relative;left:15px"></div>
<div id="next" style="position:relative;left:15px"></div>
</div>
</body>

 