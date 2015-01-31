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
<%
    int bid = Integer.parseInt(request.getParameter("bid"));
    boolean isSalary = false;
    try { isSalary = request.getParameter("t").equals("1"); } catch (Exception e) {}
    BillItem bi = BillItemMgr.getInstance().find("id=" + bid);

    boolean use_default = false;
    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    VchrHolder v = vsvc.getBillItemVoucher(bi);
    if (v==null) {
        use_default = true;
        if (!isSalary)
            v = vsvc.getBillItemVoucher(VchrHolder.BILLITEM_DEFAULT);
        else
            v = vsvc.getBillItemVoucher(VchrHolder.SALARY_BILLITEM_DEFAULT);
    }
    
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
                    '<%=phm.util.TextUtil.escapeJSString(vinfo.getAcodeName(vi))%>');
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
    String backurl = request.getParameter("backurl");
%>
var ui = null;
function init()
{
    var area = document.getElementById('main');
    ui = new vchr_ui(area, items, MODE_READ_ONLY, true);
    ui.setBunitNames(bunitIds, bunitNames);
    ui.draw();
}
function edit()
{
    ui.edit_status = STATUS_EDITING;
    ui.configSave("save_billitem_template.jsp","bid=<%=bid%>", null);
    ui.draw();
    document.getElementById("which").innerHTML = "";
}

function set_default(bid)
{
    var url = "billitem_template_setdefault.jsp?bid=" + bid;
    var req = new XMLHttpRequest();
    req.ui = this;
    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                var t = req.responseText.indexOf("@@");
                if (t>0)
                    alert(req.responseText.substring(t+2));
                else {
                    alert("設定成功!");
                    location.href = '<%=phm.util.TextUtil.escapeJSString(backurl)%>';
                }                        
            }
            else if (req.readyState == 4 && (req.status == 404 || req.status == 500)) {
                alert("設定發生錯誤 資料沒有寫入");
                return;
            }
        }
    };
    req.open('GET', url);
    req.send(null);

}

</script>
<body onload="init();">
<div style="position:relative;height:5000px">
<div id="main" style="position:relative;left:15px"></div>
<div id="customize" style="position:relative;left:15px">
       <span id="which">
           <% if (use_default) { %> 目前使用預設傳票樣本 <% } else { %> 目前使用自定傳票樣本 
           <a href="" onclick="set_default(<%=bid%>); return false;">(設回預設樣本)</a><% } %>
       </span>
    <br>
    <a href="" onclick="edit();return false;">編輯</a>
</div>
<div id="customize" style="position:relative;left:15px"><a href="<%=backurl%>">回收費項目設定</a></div>
</div>
</body>

