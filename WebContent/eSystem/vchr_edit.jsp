<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    VchrHolder v = VchrHolderMgr.getInstance().findX("id=" + request.getParameter("id"), _ws2.getBunitSpace("buId"));

    if (v==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }
%>
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
function after_edit()
{
    parent.do_reload = true;
    setup_command("do_display");
}

<%
    SimpleDateFormat _sdfx = new SimpleDateFormat("yyyy/MM/dd");
    boolean isExport = false;
    try { isExport = request.getParameter("export").equals("true"); } catch (Exception e) {}

    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    String uname = EzCountingService.getInstance().getUserName(v.getUserId());
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

var ui = null;
var note = '<%=phm.util.TextUtil.escapeJSString(vsvc.getVchrNote(v))%>';
function init()
{
    var area = document.getElementById('main');
    ui = new vchr_ui(area, items, MODE_EDIT_SAME, false/*not template*/, note);
    ui.setVchrInfo('<%=phm.util.TextUtil.escapeJSString(v.getSerial())%>', "<%=_sdfx.format(v.getRegisterDate())%>",
        '<%=phm.util.TextUtil.escapeJSString(EzCountingService.getInstance().getUserName(v.getUserId()))%>',
        "<%=_sdfx.format(new Date())%>");
    ui.setRepaint("ui.draw()");
    ui.printable = true;
    ui.edit_status = STATUS_DISPLAY;
    if (<%=isExport%>) {
        ui.no_auto_complete = true;
        ui.edit_mode = MODE_EDIT_RESTRICT_NOTE;
    }
    ui.configSave("vchr_edit2.jsp", "id=<%=v.getId()%>", after_edit);
    ui.setBunitNames(bunitIds, bunitNames);
    ui.draw();
    setup_command("do_display");
}

function edit()
{
    ui.edit_status = STATUS_EDITING;
    ui.draw();
    setup_command("do_edit");
}

function go_read()
{
    ui.edit_status = STATUS_DISPLAY;
    ui.draw();
    setup_command("do_display");
}

function setup_command(cmd) {
    var c = document.getElementById("customize");
    var d = document.getElementById("doprint");
    if (cmd=="do_display") {
        c.innerHTML = '<a href="javascript:edit()">編輯</a>';
        d.innerHTML = '<br><a target=_blank href="vchr_print.jsp?s='+encodeURI(ui.serial)+'"><img src="pic/print.png" border=0>&nbsp;列印</a>';
    }
    else if (cmd=="do_edit") {
        c.innerHTML = "";
        d.innerHTML = '<br><a href="javascript:go_read()">取消編輯</a>';
    }
    else {
        d.innerHTML = '';
    }
}

</script>
<body onload="init();">
<div style="position:relative;height:5000px">
<div id="main" style="position:relative;left:15px"></div>
<div id="customize" class=es02 style="position:relative;left:15px">
</div>
<div id="next" style="position:relative;left:15px">
</div>
<div id="doprint" class=es02 style="position:relative;left:15px">    
</div>
</body>

 



