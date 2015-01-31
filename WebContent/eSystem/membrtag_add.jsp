<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    request.setCharacterEncoding("UTF-8");
    int tp = -1;
    try { tp = Integer.parseInt(request.getParameter("t")); } catch (Exception e) {}
    ArrayList<TagType> types = TagTypeMgr.getInstance().retrieveListX("","",_ws2.getStudentBunitSpace("bunitId"));
    Map<Integer, Vector<TagType>> typeMap = new SortingMap(types).doSort("getId");

    //####### 加入從收費項目匯出名單至標籤 #####
    int cid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    String encodeBackurl = java.net.URLEncoder.encode("membrtag_add.jsp?" + request.getQueryString());
    //##########################################
%>
<script>
function IsNumeric(sText)
{
    var ValidChars = "0123456789.";
    var IsNumber=true;
    var Char; 
    if (sText.length==0)
        return false;
    var i = 0;
    if (sText.length>0 && sText.charAt(0)=='-')
        i = 1;
    for (; i < sText.length && IsNumber == true; i++) 
    { 
        Char = sText.charAt(i); 
        if (ValidChars.indexOf(Char) == -1) 
        {
            IsNumber = false;
        }
    }
    return IsNumber;
}


function doSubmit(f)
{
    if (f.name.value.length==0) {
        alert("標籤名稱不可空白");
        f.name.focus();
        return false;
    }
    if (f.tagtype.options[f.tagtype.selectedIndex].value<=0) {
        alert('請選擇一類型');
        f.tagtype.focus();
        return false;
    }

    return true;
}
function setValue()
{
    if (typeof top.__name!='undefined') {
        document.f1.name.value = top.__name;
        top.__name = "";
    }
}
</script>

<body onload="setValue();">

<div class=es02 align=left>
&nbsp;&nbsp;&nbsp;<img src="pic/tag1.png" border=0>&nbsp;新增標籤
</div>

    <center>
        <form name="f1" action="membrtag_add2.jsp" method="post" onsubmit="return doSubmit(this);">
        <input type=hidden name="cid" value="<%=cid%>">
        <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    名稱：
                </td>
                <td>
                    <input type=text name="name">
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    類型
                </td>
                <td>
                    <select name=tagtype onchange="check(this);">
                        <option value="-1">---請選擇---</option><%
                        Iterator<TagType> iter = types.iterator();
                        while (iter.hasNext()) {
                            TagType t = iter.next(); 
                      %><option value="<%=t.getId()%>" <%=(tp==t.getId())?"selected":""%>><%=t.getName()%></option>
                      <%}%>
                    </select>
                    <a href="tagtype_add.jsp?backurl=<%=encodeBackurl%>" 
                    onclick="top.__name=document.f1.name.value;">新增類型</a>
                    <br>
                </td>
            </tr>


<% /* if (BunitMgr.getInstance().numOfRows("flag=" + Bunit.FLAG_BIZ + " and status=" + Bunit.STATUS_ACTIVE)>0) { // 有部門的話 %>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    部門
                </td>
                <td>
                    <% 
                        boolean bunit_filter = false; 
                        int buId = 0;
                    %>
                    <%@ include file="bunit_select.jsp"%>
                </td>
            </tr>     
<% } */ %>

            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=submit value="產生標籤">
                </td>
            </tr>
        </table>

    </td>
    </tr>
    </table>
    </center>

    </form>
</body>
