<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=4;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>
<%
    //##v2

    int tid = Integer.parseInt(request.getParameter("tid"));
    String tagName = "";
    String q = null;
    if (tid==0) {
        tagName = "未定";
        q = "tag.id is NULL";
    }
    else {
        Tag tag = TagMgr.getInstance().find("id=" + tid);
        tagName = tag.getName();
        q = " tagId=" + tid;
    }
    ArrayList<TagMembrStudent> tagstudents = TagMembrStudentMgr.getInstance().
        retrieveListX("studentStatus in (3,4) and " + q,"", _ws.getStudentBunitSpace("student.bunitId"));
    String backurl = "membr_student_detail.jsp?" + request.getQueryString();
%>
<script>
function check_all(c) {
    var target = document.f2.target;
    if (typeof target!='undefined') {
        if (typeof target.length=='undefined')
            target.checked = c.checked;
        else {
            for (var i=0; i<target.length; i++)
                target[i].checked = c.checked;
        }
    }
}

function doSubmit()
{
    var target = document.f2.target;
    var something_selected = false;
    if (typeof target!='undefined') {
        if (typeof target.length=='undefined') {
            if (target.checked)
                something_selected = true;
        }
        else {
            for (var i=0; i<target.length; i++) {
                if (target[i].checked) {
                    something_selected = true;
                    break;
                }
            }
        }
    }
    if (!something_selected) {
        alert("沒有選任何對象");
        return false;
    }

    var act = document.f2.act;
    if (act.options[act.selectedIndex].value==0) {
        alert("請選擇一個動作");
        act.focus();
        return false;
    }
    return true;
}
</script>
<br>
&nbsp;&nbsp;&nbsp;
<div class=es02>
&nbsp; <b><%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>標籤 - <%=tagName%> (<%=tagstudents.size()%>人) </b>
<a href="javascript:history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上一頁</a>

</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>



<%
    if (tagstudents.size()==0) {
        out.println("<br><blockquote>沒有任何人在內</blockquote>");
        return;
    }
%>
<br>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>現有名單:</b>&nbsp;&nbsp;&nbsp;<input type=checkbox name="checkall" onclick="check_all(this)"> 全選</div>
<form name="f2" action="membr_batchmove.jsp" method="post" onsubmit="return doSubmit();">
<input type="hidden" name="fromtag" value="<%=tid%>">
<input type="hidden" name="backurl" value="<%=backurl%>">

<center>
<table width=90% height="" width="1" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

    <table width=100% border=0 cellpadding=4 cellspacing=1>

<%
    Iterator<TagMembrStudent> iter = tagstudents.iterator();
    int i=0;
    String bgword="bgcolor=#f0f0f0";
    int j=0;
    while (iter.hasNext())
    {
        TagMembrStudent ts = iter.next();
        if ((i%6)==0)
        {
            out.println("<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>");
            if(j%2==0){
                bgword="bgcolor=#f0f0f0";
            }else{
                bgword="bgcolor=#ffffff";
            }
            j++;
        }

        out.println("<td width='16%' "+bgword+"><input type=checkbox name='target' value='"+ts.getMembrId()+"'>" + 

        "<a href=\"#\" onClick=\"javascript:openwindow15('"+ts.getStudentId()+"');return false\">"+ts.getMembrName() +"</a></td>");

        if ((i%6)==5)
            out.println("</tr>");
        i++;
    }
%>
</table>
</td>
</tr>
</table>
<br>
<select name="act" onchange="actchange()">
   <option value="0"> --- 請選一個動作 --- </option>
   <option value="1"> 移至 </option>
   <option value="2"> 複製至 </option>
</select>

<span id="tagdiv">
<select name="totag">
<option value="0">-- 請選擇一標籤 -- </option>
<%
    TagHelper th = TagHelper.getInstance(pd2, 0, _ws.getSessionBunitId());
    ArrayList<Tag> tags = th.getTags(false, "", _ws.getStudentBunitSpace("bunitId"));
    Iterator<Tag> iter2 = tags.iterator();
    while (iter2.hasNext()) { 
        Tag tag = iter2.next();
        %>
    <option value="<%=tag.getId()%>"><%=tag.getName()%></option>
<%  }
%>
    <option value="0"> --自本標籤移除-- </option>
</select>
</span>

<input type=submit value="執行">
</form>
</center>
<!--- end 主內容 --->
<%@ include file="bottom.jsp"%>	