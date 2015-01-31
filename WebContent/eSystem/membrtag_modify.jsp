<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

    request.setCharacterEncoding("UTF-8");
    int tagId = Integer.parseInt(request.getParameter("tid"));
    Tag tag = TagMgr.getInstance().findX("id=" + tagId, _ws2.getStudentBunitSpace("bunitId"));
    ArrayList<TagType> types = TagTypeMgr.getInstance().retrieveListX("","",_ws2.getStudentBunitSpace("bunitId"));

    if (tag==null) {
        %><script>alert("資料不存在");</script><%
        return;
    }
    if (tag.getProgId()>0) {
        %><script>alert("系統產生不可改");</script><%
        return;
    }
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
</script>

<body>
<div class=es02 align=left>
&nbsp;&nbsp;&nbsp;<img src="pic/tag1.png" border=0>&nbsp;修改標籤
</div>
<center>
        <form name="f1" action="membrtag_modify2.jsp" method="post" onsubmit="return doSubmit(this);">
        <input type=hidden name="tid" value="<%=tagId%>">
        <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0 nowrap>
                    名稱：
                </td>
                <td>
                    <input type=text name="name" value="<%=tag.getName()%>">
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
                      %><option value="<%=t.getId()%>" <%=(tag.getTypeId()==t.getId())?"selected":""%>><%=t.getName()%></option>
                      <%}%>
                    </select>
                    <a href="tagtype_add.jsp?backurl=membrtag_modify.jsp?<%=request.getQueryString()%>">新增類型</a>
                    <br>
                </td>
            </tr>


            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=submit value="修改標籤">
                </td>
            </tr>
        </table>
        </td>
        </tr>
        </table>
        </form>
    </center>
   
</body>
