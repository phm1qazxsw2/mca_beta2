<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=4;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,602))
    {
        response.sendRedirect("authIndex.jsp?code=602");
    }
%>
<%@ include file="leftMenu4.jsp"%>
<%
    //##v2
    String mm=request.getParameter("m");
    if(mm !=null)
    {
%>
    <script>
        alert('修改成功!');
        window.location="studentoverview.jsp";
    </script>

<%
    }
    TagHelper thelper = TagHelper.getInstance(pZ2, 0, _ws.getSessionBunitId());
    boolean show_all = request.getParameter("show_all")!=null && request.getParameter("show_all").equals("1");

    ArrayList<TagType> types = TagTypeMgr.getInstance().retrieveListX("","",_ws.getStudentBunitSpace("bunitId"));
    Map<Integer, Vector<TagType>> typeMap = new SortingMap(types).doSort("getId");    
    ArrayList<Tag> tags = thelper.getTags(show_all, "", _ws.getStudentBunitSpace("bunitId"));

    boolean can_mca_upgrade = false;
    if (pZ2.getPagetype()==7) { // 馬禮遜
        McaFee fee = McaFeeMgr.getInstance().find("id=" + request.getParameter("feeId"));
        if (fee!=null) {
            tags = ((McaTagHelper)thelper).getFeeTags(fee, _ws.getStudentBunitSpace("bunitId"));
        }
        String str = new RangeMaker().makeRange(tags, "getStatus");
        can_mca_upgrade = str.equals("0"); // only current can upgrade
        can_mca_upgrade = can_mca_upgrade && (ud2.getUserRole()<=3); // 一般行政不行
    }

    String tagIds = new RangeMaker().makeRange(tags, "getId");
    tagIds += ",0"; // helper 回報的 tags + 包括沒有 tag 的
    ArrayList<TagMembrStudent> tagstudents = TagMembrStudentMgr.getInstance().
        retrieveList("tagId in (" + tagIds + ")","");
        // retrieveListX("tagId in (" + tagIds + ")","", _ws.getBunitSpace("membr.bunitId")); // 這里用 filter space 不行 因為有可能看舊的
    Map<Integer,Vector<TagMembrStudent>> m = new SortingMap(tagstudents).doSort("getTagId");

    thelper.setup_tags(tags);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy/MM/dd");
%>
<br>
<script>
function addtag()
{
    while (true) {
        var name = prompt("請輸入新的標籤名稱");
        if (name==null) {
            return;
        }
        else if (name.length>0) {
            location.href = "add_membr_tag.jsp?n=" + encodeURI(name);
            break;
        }
        else if (name.length==0) {
            alert("您沒有輸入名稱!");
        }
    }
}

function do_graduate(tid)
{
    if (!confirm('本標籤的學生狀態將全部設為畢業並從標籤移除?'))
        return;
    openwindow_phm2('tag_graduate.jsp?tid='+tid,'畢業',300,200,true);
}

/*
function show_content(tid) {
    openwindow_phm2('tag_content.jsp?tid='+tid,'標籤名單',400,450,'tagcontentwin');
}
*/

function open_editor(tid) {
    openwindow_phm2('tag_editor.jsp?tid='+tid+"&from=1",'標籤名單編輯',800,600,'tageditorwin');
}

</script>
&nbsp;&nbsp;&nbsp;
<img src="pic/tagtype.png" border=0>&nbsp; 
<b><%=(pZ2.getCustomerType()==0)?"學生":"客戶"%>標籤列表 </b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>
<div class=es02 align=left>
<form name=f1 action="studentoverview.jsp">
<input type=checkbox name="show_all" value=1 <%=(show_all)?"checked":""%> onclick="this.form.submit()"> 顯示全部(包括停用及前期)
<!--　　　　<font color=red><b>注意!!</b></font> 連結收費項目的標籤請由帳單處編輯名單 -->
<% if (pZ2.getPagetype()==7 && can_mca_upgrade) { %>
<script>
    function do_mca_upgrade() {
        if (!confirm('Upgrade will do : \nGraduate 12th grade, moving others 1 up with Kaohsiung/Taipei 9th grade switching ' +
                ' to Taichung campus' +
                '\n\n This will affect this fee and new created fees (if this fee is the newest)')) return;
        openwindow_phm2('mca_feetag_upgrade.jsp?feeId=<%=request.getParameter("feeId")%>', "Upgrading whole school", 300, 300, "upgradewin");
    }
</script>
<input type=hidden name=feeId value="<%=request.getParameter("feeId")%>">
　<input type=button name="upgrade" value="&nbsp; Upgrade Tags &nbsp;" onclick="do_mca_upgrade();">
<% } %>
</form>

<a target=_blank href="export_fee_tag.jsp?feeId=<%=request.getParameter("feeId")%>">Export Tag Students (Excel)</a>

<!--
<a href="javascript:openwindow_phm('membrtag_add.jsp','建立新的標籤',300,300,true);">
<img src="pic/add.gif" border=0 width=10>&nbsp;建立新的標籤</a> |
<a href="modify_student_tag.jsp"><img src="pic/redfix.png"  width=6 border=0>&nbsp;進階標籤設定</a>&nbsp;&nbsp;&nbsp;　　　 -->　　　
</div>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
    	<td width=40%>&nbsp;&nbsp;&nbsp;名稱</td>
    	<td nowrap align=center>版本</td>
        <td nowrap width=40% align=middle>收費連結</td>
        <td nowrap width=10% align=middle>在校</td>
        <!-- <td align=middle width=150>移動所有名單至</td> // 不要移動,直接改標簽名 -->
        <td nowrap align=middle>離校</td>
    </tr>
<%
    int tagname=1;

    Iterator<Tag> iter = tags.iterator();
    while (iter.hasNext()) {
        Tag tag = iter.next();
        Vector<TagMembrStudent> v = m.get(new Integer(tag.getId()));
        int size1 = 0, size2 = 0;
        for (int i=0; v!=null&&i<v.size(); i++) {
            int st = v.get(i).getStudentStatus();
            if (st==3 || st==4) 
                size1 ++;
            else
                size2 ++;            
        }
        Vector<TagType> ttpv = typeMap.get(new Integer(tag.getTypeId()));
        String typeName="";
        boolean isMain = false;
        if (ttpv!=null) {
            typeName=ttpv.get(0).getName();
            isMain = (ttpv.get(0).getMain()==1);
        }

        tagname++;

        if(tagname>7)
            tagname=tagname%7;

        boolean active = tag.getStatus()==Tag.STATUS_CURRENT;
        // 有三種可能的狀態
        // 1. active  2. 不active, 但同源的有 active, 3. 不active, 同源的也沒有 active
        String connectingHTML = thelper.getConnectingHTML(tag);
        String deletedHTML = thelper.getDeletectedConnectingHTML(tag);
%>
    <tr bgcolor=<%=(active)?"#ffffff":"#f0f0f0"%> class=es02 valign=center height=30>
        <td nowrap> 
           <table width="100%" border=0 cellpadding=0 cellspacing=0 class=es02>
             <tr>
             <td align=left nowrap>
                <%=(isMain)?"<img src='img/flag2.png'> ":"&nbsp;&nbsp;&nbsp;"%><img src="pic/tag<%=tagname%>.png" border=0>
                <%=typeName%>-<%=tag.getName()%>
             &nbsp;&nbsp;
             </td>
             <td align=right nowrap>
         <% if (tag.getProgId()==0) { %>
             <% if (active) { %>
                <a href="javascript:openwindow_phm('membrtag_modify.jsp?tid=<%=tag.getId()%>','修改標籤',300,300,true);">修改</a>
                | <a href="tag_disable.jsp?tid=<%=tag.getId()%>" onclick="if (confirm('停用後連結的收費項目將不再複製。\n\n確定停用？')) return true; else return false;">停用</a>
             <% } else if (tag.getBranchTag()==0) { %>
                &nbsp;<a href="javascript:openwindow_phm('tag_enable.jsp?tid=<%=tag.getId()%>','標籤重啟',200,150,true);">重啟</a>
             <% } %>                              
         <% } %>
             </td>
             </tr>
           </table>
        </td>

        <td nowrap align=right>
           <a href="javascript:openwindow_phm2('tag_version.jsp?tid=<%=tag.getId()%>','標籤版本',800,400,'tagverwin')">v<%=tag.getBranchVer()%></a>&nbsp;&nbsp;
        </td>

        <td nowrap width=30% align=left>
           <table width="100%" border=0 cellpadding=0 cellspacing=0 class=es02>
             <tr>
             <td align=left nowrap>
                &nbsp;<%=connectingHTML%><%=deletedHTML%>&nbsp;
             </td>
             <td align=right nowrap valign=top>
             <% /* if (active) { %>
                &nbsp;<a href="javascript:openwindow_phm('tag_branch.jsp?tid=<%=tag.getId()%>','產生下一期標籤',400,300,true);">產生下一期</a>
             <% } */ %>
             </td>
             </tr>
           </table>
        </td>
        <td nowrap align=right> 
           <a href="javascript:open_editor(<%=tag.getId()%>)"><%=(size1+size2)%>筆</a> &nbsp;
        </td>
        <td nowrap align=right> 
           <%=(size2>0)?(size2+"筆"):""%>&nbsp;
        </td>


<!--
        <form action="move_all_tag.jsp" method="post">
        <tD nowrap>
<%  /*
    Iterator<Tag> iter2 = tags.iterator();
    if(size >0){
%>
        <select name="totag">
<%
            while (iter2.hasNext()) { 
            Tag tag2 = iter2.next();
        %>
                <option value="<%=tag2.getId()%>" <%=(tag2.getId()==tag.getId())?"selected":""%>><%=tag2.getName()%></option>
        <%  }   %>
        </select>
        <input type="hidden" name="fromtag" value="<%=tag.getId()%>">
        <input type=submit value="執行" onClick="return(confirm('請確認不會與移動的標籤名單混淆?'))">
<%
    } */
%>
    </td>
        </form> 
        <td align=middle>
<%
        if(size1 >0){
%>
            <a href="modify_student_tag.jsp?tag=<%=tag.getId()%>&ttId=<%=tag.getTypeId()%>">進階設定</a>
<%      }else{   %>
            <a href="modify_student_tag.jsp">進階設定</a>
<%      }   %>  
        </td>
-->
    </tr>
<%
    }

    Vector<TagMembrStudent> v = m.get(0);
    int size1 = (v!=null)?v.size():0;

%>
    <tr bgcolor=#ffffff class=es02 valign=center height=30>

        <td colspan=3> <font color=blue>未定(沒有在任何標籤)</font> </td>
        <td nowrap align=right> <a href="membr_student_detail.jsp?tid=0"><%=size1%> 筆&nbsp;&nbsp;</a></td>
        <td></td>
    </tr>

</table>
</td></tr></table>
 

</blockquote>

<!--- end 主內容 --->
<%@ include file="bottom.jsp"%>	