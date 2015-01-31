<%@ page language="java" buffer="32kb" import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%
    int tagId = Integer.parseInt(request.getParameter("tid"));
    TagMgr tmgr = TagMgr.getInstance();
    Tag tag = tmgr.find("id=" + tagId);
    TagHelper th = TagHelper.getInstance(pd2, 0, _ws2.getSessionStudentBunitId());
    ArrayList<Tag> taghistory = th.getHistory(tag);
    th.setup_tags(taghistory);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd");
    String tagIds = new RangeMaker().makeRange(taghistory, "getId");
    Map<Tag, ArrayList<TagMembr>> tagmembrMap = new SortingMap(TagMembrMgr.getInstance()
        .retrieveList("tagId in (" + tagIds + ")", "")).doSortA("getTagId");
%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>

<blockquote>
<table width="390" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

    <table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr class=es02 bgcolor=f0f0f0 align=center>
        <td nowrap>
            版本
        </td>
        <td nowrap>
            產生時間
        </td>
        <td nowrap>
            名稱
        </td>
        <td nowrap>
            連結收費項目
        </td>
        <td nowrap>
            筆數
        </td>
        <td>
        </td>
        <% if (taghistory.size()>1) { %>
        <td>
        </td>
        <% } %>
    </tr>

<%
    for (int i=0; i<taghistory.size(); i++) {
        tag = taghistory.get(i);
        String connectingHTML = th.getConnectingHTML(tag);
        String deletedHTML = th.getDeletectedConnectingHTML(tag);
        ArrayList<TagMembr> tms = tagmembrMap.get(tag.getId());
        if (tms==null)
            tms = new ArrayList<TagMembr>();
        boolean active =  (tag.getStatus()==Tag.STATUS_CURRENT);
        String color = (active)?"ffffff":"f0f0f0";
%>    
    <tr class=es02 bgcolor=<%=color%>> 
        <td nowrap>
            v<%=tag.getBranchVer()%>
        </td>
        <td nowrap>
            <%=(tag.getCreated()==null)?"":sdf2.format(tag.getCreated())%>
        </td>
        <td nowrap>
            <a href="javascript:openwindow_phm('membrtag_modify.jsp?tid=<%=tag.getId()%>','修改標籤',300,300,true);""><%=th.getTagFullname(tag)%></a>
        </td>
        <td nowrap>
            <%=connectingHTML%><%=deletedHTML%>
        </td>
        <td align=right nowrap>
            <a href="javascript:parent.open_editor(<%=tag.getId()%>)"><%=tms.size()%>筆</a>&nbsp;
        </td>
        <td align=left nowrap>
            &nbsp;<a href="javascript:parent.open_editor(<%=tag.getId()%>)">編輯名單</a> 
        <% if (connectingHTML.length()==0) { %>
            | <a href="javascript:remove_ver(<%=tag.getId()%>)">刪除</a>
        <% } %>
        </td>
        <% if (taghistory.size()>1) { %>
        <td align=center nowrap>
            <input type=checkbox name="diff" value="<%=tag.getId()%>">
        </td>
        <% } %>
<%
    }
    if (taghistory.size()>1) {
%>
    <tr class=es02 bgcolor=ffffff align=center>
        <td colspan=7 align=right>
            <input type=button name="" value="顯示差異" onclick="alert('功能預告中!')">&nbsp;&nbsp;
        </td>
    </tr>
<%  } %>

    </table>

    </td>
    </tr>
</table>

<style>
.btn { 
	  color:#050; 
	  font: bold 100%'trebuchet ms',helvetica,sans-serif; 
	  background-color: #fed; 
	} 
</style>

<script>
function do_graduate()
{
    if (!confirm("確定執行畢業？"))
        return;

    var url = "tag_graduate.jsp?tid=<%=tagId%>&r="+(new Date()).getTime();
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
                    location.href = 'tag_version.jsp?tid=<%=tagId%>';
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

function do_branch()
{
    if (!confirm("確定執行複製下期？"))
        return;

    var url = "tag_branch2.jsp?tid=<%=tagId%>&r="+(new Date()).getTime();
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
                    location.href = 'tag_version.jsp?tid=<%=tagId%>';
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


function remove_ver(tid)
{
    if (!confirm("確定刪除？"))
        return;

    var url = "tag_remove_ver.jsp?tid=" + tid + "&r="+(new Date()).getTime();
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
                    location.href = 'tag_version.jsp?tid=<%=tagId%>';
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
</script>

<% if (pd2.getPagetype()!=7) { %>
<br>
<form>
<input type=button class=btn value="畢業" onclick="do_graduate()">　
<br>
<span class=es02>畢業會將標籤里的人設為離校並產生空的新一期標籤</span>
<br>
<br>
<input type=button class=btn value="複製並產生下一期" onclick="do_branch()">
<br>
<span class=es02>產生後的標籤包含所有舊標籤的名單, 帳單複製時會自動套用到新產生的對應收費。</span>
<input type=hidden name="tid" value="<%=taghistory.get(0).getId()%>">
<input type=hidden name="backurl" value="tag_detail.jsp?tid=<%=tagId%>">
</form>
<% } %>

</blockquote>