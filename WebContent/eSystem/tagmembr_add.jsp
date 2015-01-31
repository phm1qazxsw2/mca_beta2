<%@ page language="java" buffer="32kb" import="web.*,jsf.*,phm.ezcounting.*,phm.util.*" contentType="text/html;charset=UTF-8"%>
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
%>
<%
    int tagtypeId = -1;
    try { tagtypeId = Integer.parseInt(request.getParameter("tagtype")); } catch (Exception e) {}

    String q = "";
    if (tagtypeId>0)
        q = "typeId=" + tagtypeId;

    TagHelper th = TagHelper.getInstance(pd2, 0, _ws2.getSessionStudentBunitId());
    ArrayList<Tag> tags = th.getTags(false, q, _ws2.getStudentBunitSpace("bunitId")); 
    ArrayList<TagType> types = TagTypeMgr.getInstance().retrieveListX("","", _ws2.getStudentBunitSpace("bunitId"));

    int tid = -1;
    q = "";
    try { tid = Integer.parseInt(request.getParameter("tid")); } catch (Exception e) {}
    if (tid>0)
        q = "tagId=" + tid;
    else if (tagtypeId>0) {
        q = "typeId=" + tagtypeId;
    }
    else {
        String tagIds = new RangeMaker().makeRange(tags, "getId");
        q = "tagId in (" + tagIds + ")";
    }

    int toTagId = Integer.parseInt(request.getParameter("to"));
    Map<Integer, TagMembr> membrMap = new SortingMap(TagMembrMgr.getInstance().retrieveList("tagId=" + toTagId, "")).doSortSingleton("getMembrId");
    //ArrayList<TagMembrStudent> tms = TagMembrStudentMgr.getInstance().retrieveList(q, "order by student.modified desc");
    ArrayList<TagMembrStudent> tms = TagMembrStudentMgr.getInstance().retrieveListX
        (q, "order by studentName asc", _ws2.getStudentBunitSpace("membr.bunitId"));
    Map<Integer, ArrayList<TagMembrStudent>> tagmembrMap = new SortingMap(tms).doSortA("getMembrId");

    // 如果被選擇要加的對象在目標tag對應的收費有帳單且不能加，就不能選
    Tag toTag = TagMgr.getInstance().find("id=" + toTagId);
    PArrayList<Tag> tmp = new PArrayList<Tag>(tags);
    tmp.add(toTag);
    th.setup_tags(tmp);

    boolean hasLocked = false;
    boolean hasPaid = false;
    boolean hasCharge = false;
%>

<link rel="stylesheet" href="css/ajax-tooltip-student.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
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

function do_submit()
{
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
        alert("請先選取要加入的對象");
    }
    else {
        var tid = <%=toTagId%>;
        if (confirm("確定加入？")) {
            var url = "tagmembr_add2.jsp?tid=" + tid + "&mid=" + ids + "&r="+(new Date()).getTime();
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
                            // parent.parent.do_reload = true;
                            //parent.location.href = 'tag_editor.jsp?tid=<%=toTagId%>';
                            opener.parent.do_reload = true;
                            opener.location.href = 'tag_editor.jsp?tid=<%=toTagId%>';
                            window.close();
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
</script>

<blockquote>

<form name="f2" action="tagmembr_add.jsp" method=get>
<input type=button value="加入[<%=th.getTagFullname(toTag)%>]" onclick="do_submit()">  
<input type=hidden name="to" value="<%=toTagId%>">
<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr>
    <td bgcolor="#e9e3de" nowrap height=25 valign=center align=left>
        &nbsp;&nbsp;類型: 
        <select name=tagtype onchange="this.form.tid.selectedIndex=0;this.form.submit()">
            <option value="-1">全部
            <%
            for (int i=0; i<types.size(); i++) { int curtype = types.get(i).getId(); %>
            <option value="<%=curtype%>" <%=(tagtypeId==curtype)?"selected":""%>><%=types.get(i).getName()%>
            <% } %>
        </select>　
        標籤:
        <select name=tid onchange="this.form.submit()">
            <option value="-1">全部
            <%
            for (int i=0; i<tags.size(); i++) { int curtag = tags.get(i).getId(); %>
            <option value="<%=curtag%>" <%=(tid==curtag)?"selected":""%>><%=th.getTagFullname(tags.get(i))%>
            <% } %>
        </select>&nbsp;&nbsp;
    </td>
    </tr>

    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

    <table width="100%" border=0 cellpadding=4 cellspacing=1>
<%

    int i=0, j=0;
    int mo=4;
    long hour6 = 360 * 60* 1000;
    long now = new Date().getTime();
    Iterator<Integer> iter = tagmembrMap.keySet().iterator();
    while (iter.hasNext()) {
        Integer mid = iter.next();
        ArrayList<TagMembrStudent> mytags = tagmembrMap.get(mid);
        TagMembrStudent student = mytags.get(0);
        if ((i%mo)==0)
        {        
            j++;
            out.println("<tr class=es02 bgcolor=#ffffff>");
        }
        out.println("<td nowrap >");
        if (membrMap.get(mid)!=null) {
            out.println("<img src='pic/no.png' align=top width=15 height=15 alt='已存在'>"); hasCharge = true;
        }
        else {
            switch (th.findChargeStatusForTag(student.getMembrId(), toTag)) {
                case TagHelper.LOCKED: 
                    out.println("<img src='pic/lockno2.png' align=top width=15 height=15 alt='已鎖'>"); hasLocked = true;
                    break;
                case TagHelper.PAID:
                    out.println("<img src='pic/lockfinish2.png' align=top width=15 height=15 alt='已付'>"); hasPaid = true;
                    break;
                case TagHelper.EXISTED:
                    out.println("<img src='pic/no.png' align=top width=15 height=15 alt='已收費'>"); hasCharge = true;
                    break;
                default: 
                    out.println("<input type=checkbox name='target' value='"+student.getMembrId()+"'>");
            }
        }
        out.println(makeNameLink(student.getMembrName(), student.getMembrId(), student.getStudentId()));
        out.println("</td>");
        if ((i%mo)==(mo-1))
            out.println("</tr>");
        i ++;
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
&nbsp;<input type=checkbox name="checkall" onclick="check_all(this)"> 全選

<br>
<input type=button value="加入[<%=th.getTagFullname(toTag)%>]" onclick="do_submit()">  

<br>
<% if (hasLocked) { %>
<br>
　　<img src='pic/lockno2.png' align=top width=15 height=15 alt='已鎖'> 無法加入: 因目的標籤所連結的收費帳單已鎖住
<% } %>
<% if (hasPaid) { %>
<br>
　　<img src='pic/lockfinish2.png' align=top width=15 height=15 alt='已付'> 無法加入: 因目的標籤所連結的收費帳單已付款
<% } %>
<% if (hasCharge) { %>
<br>
　　<img src='pic/no.png' align=top width=15 height=15 alt='已收費'> 無法加入: 因對象已存在(也包括連接的收費)
<% } %>

</form>
</blockquote>