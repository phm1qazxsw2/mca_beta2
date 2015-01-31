<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<script>
function doSelect(id, name) {
    parent.setCostTradeId(id, name);
    parent.costtradewin.hide();
}

function doCancel() {
    parent.costtradewin.hide();
}
</script>
<%!
    public String getLink(Costtrade c) {
        if (c==null)
            return "";
        String ret = "<a href=\"javascript:doSelect("+c.getId()+",'"+phm.util.TextUtil.escapeJSString(c.getCosttradeName())+"')\">" + c.getCosttradeName() + "</a><br>";
        return ret;
    }
%>
<div class=es02>
&nbsp;&nbsp;<b>選擇廠商:</b>


<%
    if(checkAuth(ud2,authHa,203))
    {
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='addCosttrade.jsp'><img src="pic/add.gif" width=12 border=0>&nbsp;新增廠商</a>
<%
    }
%>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>

<form name="f1">
<%
    String code = request.getParameter("bicode");
    boolean doneDrawing = false;

    if (code!=null && code.length()>=4) {
        code = code.substring(0,4);
        BigItem bi = (BigItem) ObjectService.find("jsf.BigItem", "acctCode='" + code + "'");
        if (bi!=null) {
            CostbigitemMgr cbmgr = CostbigitemMgr.getInstance();
            Object[] objs = cbmgr.retrieve("bigitemId=" + bi.getId(), "");
            if (objs!=null) {
                out.println("<h4>廠商 for 科目&lt;"+bi.getBigItemName()+"&gt; 　　<a href='find_costtrade.jsp'>顯示全部廠商</a></h4>");
                // prepare costtrade map ######
                Object[] objs2 = CosttradeMgr.getInstance().retrieve("","");
                Map<Integer, Vector<Costtrade>> costtradeMap = 
                    new SortingMap().doSort(objs2, new ArrayList<Costtrade>(), "getId");
                // ############################
                for (int i=0; i<objs.length; i++) {
                    Costbigitem cb = (Costbigitem) objs[i];
                    Vector<Costtrade> vc = costtradeMap.get(new Integer(cb.getCosttradeId()));
                    if (vc!=null) {
                        Costtrade c = vc.get(0);
                        out.println("<div class=es02>"+getLink(c)+"</div>");
                    }
                }
                doneDrawing = true;
            }
        }
    }

    if (!doneDrawing) {
        JsfAdmin ja=JsfAdmin.getInstance();
        Costtrade[] ct=ja.getActiveCosttrade(); 
        if (ct==null)
            out.println("尚未設定交易對象");
        else {
            for (int i=0; i<ct.length; i++) {
                Costtrade c = ct[i];
                out.println(getLink(c));
            }
        }
    }
%>

<br>
</form>
<br>

<br>
</blockquote>

