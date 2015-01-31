<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<script>
function doSelect() {
    var c = document.f1.tagId;
    var r = '';
    if (typeof c!='undefined') {        
        if (typeof c.length=='undefined') {
            if (c.checked)
                r = c.value;
        }
        else {
            for (var i=0; i<c.length; i++) {
                if (c[i].checked) {
                    if (r.length>0) r += ",";
                    r += c[i].value;
                }
            }
        }
    }
    var isAnd = document.f1.isAnd;
    parent.tagwin.hide();
    parent.doSelect(r, isAnd[0].checked);
}

function doCancel() {
    parent.tagwin.hide();
}

</script>
<%!
    public String getCheckboxes(Vector<Tag> tv) {

        String ret = "<table><tr class=es02>";

        if (tv==null)
            return "";
        for (int i=0; i<tv.size(); i++) {
            
            if(i>0 && i%2==0)
                ret+="<tr class=es02>";
            ret += "<td class=es02>";    
            ret += "<input type=checkbox name='tagId' value='"+tv.get(i).getId()+phm.util.TextUtil.encodeHtml("#"+tv.get(i).getName())+"'>" + tv.get(i).getName() + "<br>\n";

            ret += "</td>";
            if(i>0 && i%2==1)
                ret+="</tr>";
        }
        ret += "</table>";        
        return ret;
    }
%>
<link href=ft02.css rel=stylesheet type=text/css> 
<link rel="stylesheet" href="style.css" type="text/css">

<form name="f1">
<div class=es02>
<b><img src="pic/tagtype2.png" border=0>&nbsp;選擇搜尋範圍:</b>
<input type=button value="取回" onclick="doSelect()">　
<input type=radio name="isAnd" value=1> 交集 <input type=radio name="isAnd" value=0 checked> 聯集
</div>

        <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
<%
    ArrayList<TagType> all_tagtypes = TagTypeMgr.getInstance().retrieveListX("","order by num ", _ws2.getStudentBunitSpace("bunitId"));
    ArrayList<Tag> all_tags = TagMgr.getInstance().retrieveListX("", "order by id asc", _ws2.getStudentBunitSpace("bunitId"));
    Map<Integer/*typeId*/, Vector<Tag>> tagMap = new SortingMap(all_tags).doSort("getTypeId");
    Iterator<TagType> iter = all_tagtypes.iterator();
    while (iter.hasNext()) {
        TagType tt = iter.next(); %>
            <tr bgcolor=#ffffff align=left valign=middle>
            <td  bgcolor=#f0f0f0  class=es02 width=30%><%=tt.getName()%></td>
            <td class=es02>    
            <%
                Vector<Tag> tv = tagMap.get(new Integer(tt.getId()));
                out.println(getCheckboxes(tv));
            %>
            </td>
            </tr>    
 <% } %>
    </table>
    </td>
    </tr>
    </table>
<br>
<center>
<input type=button value="取回" onclick="doSelect()">　<input type=button value="取消" onclick="doCancel()">
</center>
</form>