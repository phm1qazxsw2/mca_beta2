<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%!
    McaFee getFee(int brId)
        throws Exception
    {
        McaRecord mr = McaRecordInfoMgr.getInstance().find("billRecordId=" + brId + " and mca_fee.status!=-1");
        return McaFeeMgr.getInstance().find("id=" + mr.getMcaFeeId());
    }
%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    String param = request.getParameter("param");
    String[] tokens = param.split("#");
    int brId = Integer.parseInt(tokens[0]);

    int tagtypeId = -1;
    try { tagtypeId = Integer.parseInt(request.getParameter("tagtype")); } catch (Exception e) {}
    String q = "";
    if (tagtypeId>0)
        q = "typeId=" + tagtypeId;

    ChargeItem ci = ChargeItemMgr.getInstance().find("id=" + Integer.parseInt(request.getParameter("cid")));
    McaFee fee = getFee(brId);

    McaTagHelper thelper = new McaTagHelper();
    ArrayList<Tag> tags = thelper.getFeeTags(fee, _ws2.getStudentBunitSpace("bunitId")); 
    thelper.setup_tags(tags);
    String tagIds = new RangeMaker().makeRange(tags, "getId");
    ArrayList<TagMembrStudent> tagstudents = TagMembrStudentMgr.getInstance().
        retrieveListX("tag.id in (" + tagIds + ")","", _ws2.getStudentBunitSpace("membr.bunitId"));
    Map<Integer,Vector<TagMembrStudent>> m = new SortingMap(tagstudents).doSort("getTagId");
    ArrayList<TagType> types = TagTypeMgr.getInstance().retrieveListX("","",_ws2.getStudentBunitSpace("bunitId"));
    ArrayList<Tag> connectTags = null;
    if (ci!=null)
        connectTags = thelper.getTagsForChargeItem(ci);
%>
<script>
function do_connect()
{
    if (<%=connectTags==null || connectTags.size()==0%>) {
        alert('請先清空收費對象再做連結.\n(否則會造成收費對象和標籤名單無法同步)')
            return false;
    }
    else if (!confirm('確定連結並加入此標籤所有人？'))
        return false;
    return true;
}
</script>

<center>
<form action="chooser.jsp">
<input type=hidden name="param" value="<%=param%>">
<input type=hidden name="cid" value="<%=(ci==null)?0:ci.getId()%>">
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
    	<td width=70%>
            <table width=100% cellpadding=0 cellspacing=0>
                <tr><td>&nbsp;&nbsp;<b><%=(pd2.getCustomerType()==0)?"學生":"客戶"%>標籤名稱</b></td>
                </tr>
            </table>
        </td>
        <td width=30% align=middle>動作</td>
    </tr>
<%
    int startag=0;

    Iterator<Tag> iter = tags.iterator();
    while (iter.hasNext()) {

        startag++;
        if(startag>7)
            startag=1;

        Tag g = iter.next();
        Vector<TagMembrStudent> v = m.get(new Integer(g.getId()));
        int size = (v==null)?0:v.size();
%>
    <tr bgcolor=#ffffff class=es02 valign=center height=30>
		<td>
        <img src="pic/tag<%=startag%>.png" border=0>
        <%=thelper.getTagFullname(g)%>&nbsp;&nbsp; (<%=size%>&nbsp筆)</td>
        <td nowrap>
            <% if (size>0) { %>
                <a href="chooser_detail.jsp?tag=<%=g.getId()%>&param=<%=java.net.URLEncoder.encode(param)%>">從裡面選取名單</a> 
            <% } %>
        </td>
    </tr>
<%
    }
    Vector<TagMembrStudent> v = m.get(new Integer(0));
    int size = (v==null)?0:v.size();
%>
    <tr bgcolor=#ffffff class=es02 valign=center height=30>
        <td> <font color=red><b>未定(沒有在任何標籤)</font> <%=size%> 筆</td>
        <td>
        <% if (size>0) { %>
            <a href="chooser_detail.jsp?tag=0&param=<%=java.net.URLEncoder.encode(param)%>">從裡面選取名單</a>
        <% } %>
        </td>
    </tr>

</table>
</td></tr></table>
</form>
</center>
