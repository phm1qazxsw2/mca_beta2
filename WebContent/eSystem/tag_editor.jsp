<%@ page language="java" buffer="32kb" import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%!
    public String makeNameLink(String name, int membrId, int studentId)
    {
        if (name==null || name.trim().length()==0) {
            name = "##";
        }
        StringBuffer sb = new StringBuffer();
        sb.append("<a href=\"javascript:;\" onmouseover=\"ajax_showTooltip('peek_membr.jsp?id="+membrId+"',this);return false;\" onmouseout=\"ajax_hideTooltip()\">");
        sb.append(name);
        sb.append("</a>");
        return sb.toString();
    }

    Map<Integer, ArrayList<ChargeItemMembr>> getChargeItemMap(ArrayList<BillChargeItem> bcitems)
        throws Exception
    {
        String chargeItemIds = new RangeMaker().makeRange(bcitems, "getId");
        ArrayList<ChargeItemMembr> citems = ChargeItemMembrMgr.getInstance().retrieveList("chargeitem.id in (" + chargeItemIds + ")", "");
        return new SortingMap(citems).doSortA("getMembrId");
    }

    private final static int CLEAN    = 0;
    private final static int LOCKED   = 1;
    private final static int PAID     = 2;
    int findStatus(int membrId, Map<Integer, ArrayList<ChargeItemMembr>> chargeitemMap)
    {
        ArrayList<ChargeItemMembr> citems = chargeitemMap.get(membrId);
        for (int i=0; citems!=null&&i<citems.size(); i++) {
            ChargeItemMembr ci = citems.get(i);
            if (ci.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID)
                return PAID;
            else if (ci.getPrintDate()!=(long)0)
                return LOCKED;
        }
        return CLEAN;
    }
%>
<%
    int tagId = Integer.parseInt(request.getParameter("tid"));
    String buId = request.getParameter("bid");
    TagMgr tmgr = TagMgr.getInstance();
    Tag tag = tmgr.find("id=" + tagId);

    TagHelper th = TagHelper.getInstance(pd2, 0, _ws2.getSessionStudentBunitId());
    th.setup(tag);
    ArrayList<BillChargeItem> bcitmes = th.getBillChargeItem(tag);
    ArrayList<TagMembrStudent> tms = TagMembrStudentMgr.getInstance().retrieveList("tagId=" + tag.getId(), 
          "order by studentName asc");   //    "order by bindTime desc");
    Map<Integer, ArrayList<ChargeItemMembr>> chargeitemMap = getChargeItemMap(bcitmes);
%>

<link rel="stylesheet" href="css/ajax-tooltip-student.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script>

function check_all(c) {
    var target = document.f2.target;
    if (typeof target!='undefined') {
        if (typeof target.length=='undefined')
            target.checked = c.checked;
        else {
            for (var i=0; i<target.length; i++) {
                target[i].checked = c.checked;
            }
        }
    }
}

function do_add()
{
    if (!check_alert())
        return;
    //openwindow_phm2('tagmembr_add.jsp?to=<%=tag.getId()%>&bid=<%=buId%>', '加對象至標籤[<%=th.getTagFullname(tag)%>]', 600,400,'tagaddwin');
    tagaddwin = window.open('tagmembr_add.jsp?to=<%=tag.getId()%>&bid=<%=buId%>');
}

function do_remove() {
    if (!check_alert())
        return;
    var target = document.f2.target;
    var ids = '';
    if (typeof target!='undefined') {
        if (typeof target.length=='undefined') {
            if (target.checked) {
                ids = target.value;
            }
        }
        else {
            for (var i=0; i<target.length; i++) {
                if (target[i].checked) {
                    if (ids.length>0) ids += ",";
                    ids += target[i].value;
                }
            }
        }
    }
    if (ids.length==0) {
        alert("請先選取要刪除的對象");
    }
    else {
        var tid = document.f2.tid.value;
        if (confirm("確定刪除？")) {
            var url = "tagmembr_remove.jsp?tid=" + tid + "&mid=" + ids + "&r="+(new Date()).getTime();
            var req = new XMLHttpRequest();

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
                            parent.do_reload = true;
                            location.href = 'tag_editor.jsp?tid=<%=tagId%>';
                        }                        
                    }
                    else if (req.readyState == 4 && req.status == 500) {
                        alert("發生錯誤,資料沒有寫入");
                        return;
                    }
                    else if (req.readyState == 4 && req.status == 404) {
                        alert("找不到執行頁");
                        return;
                    }
                }
            };
            req.open('GET', url);
            req.send(null);    
        }
    }
}

<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM");
    ArrayList<BillChargeItem> bcitems = th.getBillChargeItem(tag);
    String tmp = "";
    for (int i=0; bcitems!=null && i<bcitems.size(); i++) {
        Date billDate = bcitems.get(i).getBillDate();
        if (billDate.compareTo(new Date())<0) { // 如果今天已經過了繳費期限
            if (tmp.length()>0) tmp += ",";
            tmp += "[" + sdf.format(bcitems.get(i).getMonth()) + " " + bcitems.get(i).getName() + "]";
        }
    }
%>

function check_alert()
{
    var from = <%=request.getParameter("from")%>;
    if (from==1) {
        var str = '<%=phm.util.TextUtil.escapeJSString(th.getBillChargeItemString(tag, true))%>';
        if (str.length>0 && !confirm("編輯標籤名單會同步修改收費項目 " + str + "\n確定?")) {
            parent.tageditorwin.hide();
            return false;
        }
    }
    else if (from==0) {
<%
        int cid = -1;
        try { cid=Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<bcitems.size(); i++) {
            if (bcitems.get(i).getId()!=cid) {
                sb.append(" [" + bcitems.get(i).getName() + "]");
            }
        }
%>
        var str = '<%=phm.util.TextUtil.escapeJSString(sb.toString())%>';
        var tagname = '<%=phm.util.TextUtil.escapeJSString(tag.getName())%>';
        if (str.length>0 && !confirm("修改收費名單亦會修改到連結同標籤 [" + tagname + "]\n的收費 "+ str +"\n確定?")) {
            parent.tageditorwin.hide();
            return false;
        }
    }

    var w = '<%=phm.util.TextUtil.escapeJSString(tmp)%>';
    if (w.length>0) {
        if (!confirm('收費項目 ' + w + ' 已超過繳費期限, 確定要進行修改?')) {
            parent.tageditorwin.hide();
            return false;
        }
    }
    return true;
}

</script>

<body>

&nbsp;&nbsp;&nbsp;<b><%=th.getTagFullname(tag)%>(v<%=tag.getBranchVer()%>)</b> (<%=tms.size()%>筆)
<blockquote>
<% if (bcitems.size()>0) { %>
<span class=es02><font color="red">**注意**  </font>修改名單會影響 <%=th.getBillChargeItemString(tag, true) %></font></span>
<% } %>
<form name="f2" method=post>
<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

    <table width="100%" border=0 cellpadding=4 cellspacing=1>
<%

    int i=0, j=0;
    int mo=4;
    long now = new Date().getTime();
    long onemin = 60*1000;

    for (i=0; i<tms.size(); i++) {
        TagMembrStudent student = tms.get(i);
        boolean recent = (student.getBindTime()!=null)?((now - student.getBindTime().getTime()) < onemin):false;
        if ((i%mo)==0)
        {        
            j++;
            out.println("<tr class=es02 bgcolor=#ffffff>");
        }
        out.println("<td nowrap "+((recent)?"style=\"border:1px solid blue\"":"")+">");
        switch (findStatus(student.getMembrId(), chargeitemMap)) {
            case LOCKED: 
                out.println("<img src='pic/lockno2.png' align=top width=15 height=15 alt='已鎖'>");
                break;
            case PAID:
                out.println("<img src='pic/lockfinish2.png' align=top width=15 height=15 alt='已付'>");
                break;
            default: 
                out.println("<input type=checkbox name='target' value='"+student.getMembrId()+"'>");
        }
        out.println(makeNameLink(student.getMembrName(), student.getMembrId(), student.getStudentId()));
        out.println("</td>");
        if ((i%mo)==(mo-1))
            out.println("</tr>");
    }
    if (i%mo!=0) {
        while ((i%mo)!=0) {
            out.println("<td></td>");
            i++;
        }
        out.println("</tr>");
    }
%>
    </table>

    </td>
    </tr>
</table>

<div class=es02>
<br>
<a href="javascript:do_add();"><img src="pic/add.gif" border=0>&nbsp;加入對象</a>
<% if (tms.size()>0) { %>　
<a href="javascript:do_remove();"><img src="pic/minus.gif" border=0>&nbsp;   將選取的對象移除</a>　　　　
<input type=checkbox name="checkall" onclick="check_all(this)"> 全選
<% } %>
<input type=hidden name="tid" value="<%=tag.getId()%>">
</div>
</form>
</blockquote>