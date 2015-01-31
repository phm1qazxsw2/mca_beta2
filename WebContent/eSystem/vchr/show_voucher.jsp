<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="../justHeader.jsp"%>
<link href="../ft02.css" rel=stylesheet type=text/css>

<% // ######## 以下這一堆 is for 傳票編輯 都要 include ###### %>
<script type="text/javascript" src="../js/vchr_item.js?<%=new Date().getTime()%>"></script>
<% // ####################################################### %>

<script>
var items = new Array;
var bunitIds = new Array;
var bunitNames = new Array;
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    VchrHolder v = VchrHolderMgr.getInstance().find("id=" + request.getParameter("id"));
    String uname = EzCountingService.getInstance().getUserName(v.getUserId());
    ArrayList<VchrItem> items = VchrItemMgr.getInstance().retrieveList("vchrId=" + v.getId(), "");
    VchrInfo vinfo = new VchrInfo(items, 0);
    for (int i=0; i<items.size(); i++) {
        VchrItem vi = items.get(i);
      %>items[items.length] = new vitem(
                    <%=vi.getId()%>, 
                    <%=vi.getBunitId()%>, 
                    <%=vi.getFlag()%>, 
                    <%=vi.getDebit()%>, 
                    <%=vi.getCredit()%>, 
                    '<%=vinfo.getMain(vi)%>',
                    '<%=vinfo.getSub(vi)%>',
                    <%=vi.getBunitId()%>,
                    '<%=phm.util.TextUtil.escapeJSString(vinfo.getAcodeName(vi))%>',
                    '<%=phm.util.TextUtil.escapeJSString(vinfo.getNote(vi))%>');
<%
    }

    ArrayList<Bunit> bunits = BunitMgr.getInstance().retrieveList("status=1 and flag=1", "");
    for (int i=0; i<bunits.size(); i++) {
      %>
        bunitIds[bunitIds.length]=<%=bunits.get(i).getId()%>;
        bunitNames[bunitNames.length]='<%=phm.util.TextUtil.escapeJSString(bunits.get(i).getLabel())%>';
      <%
    }
%>
var ui = null;
var note = '<%=phm.util.TextUtil.escapeJSString(vsvc.getVchrNote(v))%>';
function init()
{
    var area = document.getElementById('main');
    ui = new vchr_ui(area, items, MODE_READ_ONLY, false, note);
    ui.setVchrInfo('<%=phm.util.TextUtil.escapeJSString(v.getSerial())%>', 
        "<%=sdf.format(v.getRegisterDate())%>", '<%=phm.util.TextUtil.escapeJSString(uname)%>', "<%=sdf.format(v.getCreated())%>");
    ui.setBunitNames(bunitIds, bunitNames);
    ui.draw();
}


</script>
<body onload="init();">
<div id="main" style="position:relative;left:15px"></div>
<div id="next" style="position:relative;left:15px"></div>
</body>

 