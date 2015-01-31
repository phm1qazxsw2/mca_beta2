<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>

<script>
function doSelect(id, name) {
    parent.setPitem(id, name);
    parent.pitemwin.hide();
}

function doCancel() {
    parent.pitemwin.hide();
}
</script>
<%!
    public String getLink(PItem p) {
        if (p==null)
            return "";
        String ret = "<a href=\"javascript:doSelect("+p.getId()+",'"+phm.util.TextUtil.escapeJSString(p.getName())+"')\">" + p.getName() + "</a><br>";
        return ret;
    }
%>
<link rel="stylesheet" href="style.css" type="text/css">
<b class=es01>選擇產品:</b>
<blockquote>

<form name="f1">
<%
    ArrayList<PItem> pitems = PItemMgr.getInstance().retrieveList("status=" + PItem.STATUS_ACTIVE, "");
    if (pitems.size()==0)
        out.println("目前沒有任何產品");
    else {
        Iterator<PItem> iter = pitems.iterator();
        while (iter.hasNext()) {
            PItem pi = iter.next();
            out.println(getLink(pi));
        }
    }
%>

<br>
</form>
</blockquote>
<b><a href='add_product.jsp'>新增產品</a></b>
